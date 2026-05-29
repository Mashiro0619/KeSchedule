part of 'home_screen.dart';

extension _HomeScreenPrivacy on _HomeScreenState {
  void _ensurePrivacyConsentDialog(TimetableProvider provider) {
    if (!mounted ||
        !provider.isLoaded ||
        provider.hasAcceptedCurrentPrivacyPolicy ||
        _isShowingPrivacyConsentDialog) {
      return;
    }
    _isShowingPrivacyConsentDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!mounted ||
            !provider.isLoaded ||
            provider.hasAcceptedCurrentPrivacyPolicy) {
          return;
        }
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            final l10n = AppLocalizations.of(dialogContext);
            var isAccepting = false;
            var popped = false;

            Future<void> acceptPrivacy(StateSetter setDialogState) async {
              if (isAccepting || popped) {
                return;
              }
              setDialogState(() => isAccepting = true);
              try {
                await provider.acceptPrivacyPolicyCurrentVersion();
                if (!dialogContext.mounted || popped) {
                  return;
                }
                popped = true;
                Navigator.of(dialogContext).pop();
              } catch (_) {
                if (dialogContext.mounted) {
                  setDialogState(() => isAccepting = false);
                }
                rethrow;
              }
            }

            return StatefulBuilder(
              builder: (context, setDialogState) {
                return PopScope(
                  canPop: false,
                  child: AlertDialog(
                    title: Text(l10n.privacyGateTitle),
                    content: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.privacyPolicyIntro),
                            const SizedBox(height: 16),
                            _PrivacySummaryRow(
                              text: l10n.privacyGateSummaryStorage,
                            ),
                            const SizedBox(height: 8),
                            _PrivacySummaryRow(
                              text: l10n.privacyGateSummaryImportExport,
                            ),
                            const SizedBox(height: 8),
                            _PrivacySummaryRow(
                              text: l10n.privacyGateSummaryUpdates,
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: isAccepting
                            ? null
                            : () => _openPrivacyPolicyPage(),
                        child: Text(l10n.privacyViewFullPolicy),
                      ),
                      TextButton(
                        onPressed: isAccepting
                            ? null
                            : () => _declinePrivacyPolicy(dialogContext),
                        child: Text(l10n.privacyDecline),
                      ),
                      FilledButton(
                        onPressed: isAccepting
                            ? null
                            : () => acceptPrivacy(setDialogState),
                        child: isAccepting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.privacyAgreeAndContinue),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      } finally {
        _isShowingPrivacyConsentDialog = false;
      }
    });
  }

  Future<void> _openPrivacyPolicyPage() async {
    final uri = Uri.parse('https://mashiro.tech/Sked/privacy.html');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _declinePrivacyPolicy(BuildContext context) async {
    if (kIsWeb) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).privacyDeclineWebHint),
        ),
      );
      return;
    }
    await SystemNavigator.pop();
  }
}

class _PrivacySummaryRow extends StatelessWidget {
  const _PrivacySummaryRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 3),
          child: Icon(Icons.check_circle_outline, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}
