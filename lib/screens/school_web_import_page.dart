import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/school_site_models.dart';
import '../screens/school_html_import_page.dart';
import '../services/school_site_service.dart';
import '../services/school_web_import_page_service.dart';

class SchoolWebImportPage extends StatefulWidget {
  const SchoolWebImportPage({super.key, required this.site});

  final SchoolSite site;

  @override
  State<SchoolWebImportPage> createState() => _SchoolWebImportPageState();
}

class _SchoolWebImportPageState extends State<SchoolWebImportPage> {
  static const _pageLoadTimeout = Duration(seconds: 15);

  final SchoolSiteService _siteService = const SchoolSiteService();
  final SchoolWebImportPageService _pageService =
      const SchoolWebImportPageService();

  InAppWebViewController? _controller;
  Timer? _pageLoadWatchdog;
  bool _isLoadingPage = false;
  bool _isParsing = false;
  bool _isLoadingSchools = true;
  bool _canGoBack = false;
  bool _hasStartedInitialLoad = false;
  String _currentUrl = '';
  String _currentTitle = '';
  String _entryUrl = '';
  List<SchoolSite> _sites = const [];
  SchoolSite? _selectedSite;
  String? _schoolLoadError;

  bool get _isConfigured => AppConfig.hasSchoolImportApiBaseUrl;
  bool get _supportsWebView =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.windows);

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  @override
  void dispose() {
    _cancelPageLoadWatchdog();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedSite?.name ?? widget.site.name),
        actions: [
          TextButton(
            onPressed: _canGoBack && !_isParsing ? _goBackInWebView : null,
            child: Text(l10n.schoolWebImportGoBack),
          ),
          IconButton(
            onPressed: _controller == null || _isParsing ? null : _reload,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _controller == null || _isLoadingPage || _isParsing
                ? null
                : _importCurrentPage,
            icon: _isParsing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_download_outlined),
            tooltip: l10n.schoolWebImportImportCurrentPage,
          ),
        ],
      ),
      body: !_isConfigured
          ? _buildMessage(l10n.schoolWebImportConfigMissing)
          : !_supportsWebView
          ? _buildMessage(l10n.schoolWebImportUnsupportedPlatform)
          : _schoolLoadError != null
          ? _buildMessage(_schoolLoadError!)
          : _sites.isEmpty || _selectedSite == null
          ? _buildMessage(l10n.schoolWebImportNoSchools)
          : Column(
              children: [
                Material(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Text(
                      _isLoadingSchools
                          ? l10n.schoolWebImportLoadingPage
                          : _isParsing
                          ? l10n.schoolWebImportParsing
                          : _isLoadingPage
                          ? l10n.schoolWebImportLoadingPage
                          : l10n.schoolWebImportOpenPageHint,
                    ),
                  ),
                ),
                Expanded(
                  child: _isLoadingSchools
                      ? const Center(child: CircularProgressIndicator())
                      : InAppWebView(
                          initialSettings: InAppWebViewSettings(
                            javaScriptEnabled: true,
                            javaScriptCanOpenWindowsAutomatically: true,
                          ),
                          onWebViewCreated: (controller) {
                            _controller = controller;
                            _scheduleInitialSchoolOpen();
                          },
                          onLoadStart: (_, url) {
                            _startPageLoadWatchdog();
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _isLoadingPage = true;
                              _currentUrl = url?.toString() ?? _currentUrl;
                            });
                          },
                          onLoadStop: (_, url) {
                            _cancelPageLoadWatchdog();
                            final nextUrl = url?.toString() ?? _currentUrl;
                            final entryUrl =
                                _entryUrl.isEmpty && nextUrl.isNotEmpty
                                ? nextUrl
                                : _entryUrl;
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _isLoadingPage = false;
                              _currentUrl = nextUrl;
                              _entryUrl = entryUrl;
                              _canGoBack =
                                  entryUrl.isNotEmpty && nextUrl != entryUrl;
                            });
                          },
                          onUpdateVisitedHistory: (_, url, _) {
                            final nextUrl = url?.toString() ?? _currentUrl;
                            final entryUrl =
                                _entryUrl.isEmpty && nextUrl.isNotEmpty
                                ? nextUrl
                                : _entryUrl;
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              _currentUrl = nextUrl;
                              _entryUrl = entryUrl;
                              _canGoBack =
                                  entryUrl.isNotEmpty && nextUrl != entryUrl;
                            });
                          },
                          onTitleChanged: (_, title) {
                            if (!mounted ||
                                title == null ||
                                title == _currentTitle) {
                              return;
                            }
                            setState(() => _currentTitle = title);
                          },
                          onReceivedError: (_, request, error) {
                            if (request.isForMainFrame == false) {
                              return;
                            }
                            _handlePageLoadFailure(
                              AppLocalizations.of(
                                context,
                              ).schoolWebImportLoadFailed,
                            );
                          },
                          onReceivedHttpError: (_, request, _) {
                            if (request.isForMainFrame == false) {
                              return;
                            }
                            _handlePageLoadFailure(
                              AppLocalizations.of(
                                context,
                              ).schoolWebImportLoadFailed,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }

  Future<void> _loadSchools() async {
    final l10n = AppLocalizations.of(context);
    try {
      final sites = await _siteService.loadSites();
      if (!mounted) {
        return;
      }
      final selected = sites
          .where((item) => item.loginUrl == widget.site.loginUrl)
          .firstOrNull;
      setState(() {
        _sites = sites;
        _selectedSite = selected ?? widget.site;
        _isLoadingSchools = false;
      });
      await _ensureController();
      _scheduleInitialSchoolOpen();
    } catch (e, st) {
      debugPrint('Failed to load schools for web import: $e\n$st');
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingSchools = false;
        _schoolLoadError = l10n.schoolWebImportSchoolLoadFailed;
      });
    }
  }

  Future<void> _ensureController() async {
    if (_controller != null || !_supportsWebView) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingPage = true;
      });
    }
  }

  void _scheduleInitialSchoolOpen() {
    if (_hasStartedInitialLoad) {
      return;
    }
    if (_controller == null || _selectedSite == null) {
      return;
    }
    _hasStartedInitialLoad = true;
    unawaited(_openSelectedSchool());
  }

  Future<void> _openSelectedSchool() async {
    final site = _selectedSite;
    final controller = _controller;
    if (site == null || controller == null) {
      _hasStartedInitialLoad = false;
      return;
    }
    final loadFailedMessage = AppLocalizations.of(
      context,
    ).schoolWebImportLoadFailed;
    _startPageLoadWatchdog();
    if (mounted) {
      setState(() {
        _isLoadingPage = true;
        _currentUrl = site.loginUrl;
        _entryUrl = '';
        _canGoBack = false;
      });
    }
    try {
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri(site.loginUrl)),
      );
    } catch (_) {
      _hasStartedInitialLoad = false;
      _handlePageLoadFailure(loadFailedMessage);
    }
  }

  Future<void> _reload() async {
    final controller = _controller;
    if (controller == null) {
      return;
    }
    _startPageLoadWatchdog();
    if (mounted) {
      setState(() => _isLoadingPage = true);
    }
    await controller.reload();
  }

  Future<void> _goBackInWebView() async {
    final controller = _controller;
    if (controller == null || !_canGoBack) {
      return;
    }
    _startPageLoadWatchdog();
    await controller.goBack();
  }

  void _startPageLoadWatchdog() {
    _cancelPageLoadWatchdog();
    _pageLoadWatchdog = Timer(_pageLoadTimeout, () {
      if (!mounted || !_isLoadingPage) {
        return;
      }
      setState(() => _isLoadingPage = false);
      _showMessage(AppLocalizations.of(context).schoolWebImportLoadTimedOut);
    });
  }

  void _cancelPageLoadWatchdog() {
    _pageLoadWatchdog?.cancel();
    _pageLoadWatchdog = null;
  }

  void _handlePageLoadFailure(String message) {
    _cancelPageLoadWatchdog();
    if (!mounted) {
      return;
    }
    if (_isLoadingPage) {
      setState(() => _isLoadingPage = false);
    }
    _showMessage(message);
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _importCurrentPage() async {
    final l10n = AppLocalizations.of(context);
    final controller = _controller;
    final selectedSite = _selectedSite;
    if (_isParsing || controller == null || selectedSite == null) {
      return;
    }
    setState(() => _isParsing = true);
    try {
      final source = await _pageService.extractSource(
        controller,
        fallbackUrl: _currentUrl,
        fallbackTitle: _currentTitle,
      );
      if (!mounted) {
        return;
      }
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => SchoolHtmlImportPage(
            initialContent: source.content,
            initialUrl: source.url,
            initialTitle: source.title,
            showReturnToWebPageButton: true,
          ),
        ),
      );
    } on FormatException catch (error) {
      if (!mounted) {
        return;
      }
      final message = error.message == 'Import content is empty.'
          ? l10n.schoolWebImportEmptyPage
          : error.message;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.importFailedCheckContent)));
    } finally {
      if (mounted) {
        setState(() => _isParsing = false);
      }
    }
  }
}

extension _FirstWhereOrNull<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
