part of 'timetable_provider.dart';

mixin _TimetableProviderLifecycle on _TimetableProviderBase {
  String? _remotePrivacyPolicyVersion;

  String? get activePrivacyPolicyVersion => _remotePrivacyPolicyVersion;

  String? get acceptedPrivacyPolicyVersion =>
      _appData.privacyPolicyAcceptedVersion;

  DateTime? get privacyPolicyAcceptedAt {
    final value = _appData.privacyPolicyAcceptedAtIso;
    return tryParseStrictIsoDateTime(value);
  }

  bool get hasAcceptedCurrentPrivacyPolicy {
    if (_remotePrivacyPolicyVersion == null) return true;
    return _appData.privacyPolicyAcceptedVersion == _remotePrivacyPolicyVersion;
  }

  void injectRemotePrivacyPolicyVersion(String version) {
    _remotePrivacyPolicyVersion = version;
  }

  Future<void> fetchRemotePrivacyPolicyVersion() async {
    final version = await _privacy.fetchCurrentPrivacyPolicyVersion();
    if (version == null || _remotePrivacyPolicyVersion == version) return;
    _remotePrivacyPolicyVersion = version;
    notifyListeners();
  }

  Future<void> load() async {
    if (_isLoaded || _isLoading) {
      return;
    }
    _isLoading = true;
    try {
      final fileData = await _repository.load();
      if (fileData != null) {
        final normalized = _importExportService.normalizeAppData(
          fileData,
          localeCode: fileData.localeCode,
        );
        _appData = normalized;
        if (normalized.encode() != fileData.encode()) {
          try {
            await _repository.save(normalized);
          } catch (e, st) {
            debugPrint(
              'Storage normalization save failed, keeping loaded data: $e\n$st',
            );
          }
        }
      } else {
        _appData = await _buildDefaultAppData();
        if (_repository.lastRecoveryStatus !=
            RecoveryStatus.failedBackupRestore) {
          await _save();
        }
      }
      _storagePath = await _repository.filePath();
    } catch (e, st) {
      debugPrint('Storage load failed, using defaults: $e\n$st');
      _appData = await _buildDefaultAppData();
      try {
        _storagePath = await _repository.filePath();
      } catch (e2, st2) {
        debugPrint('Storage path unavailable: $e2\n$st2');
        _storagePath = null;
      }
    } finally {
      _selectedWeek = _currentWeekForActiveTimetable();
      _isLoaded = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptPrivacyPolicyCurrentVersion() async {
    final active = _remotePrivacyPolicyVersion;
    if (active == null) return;
    if (_appData.privacyPolicyAcceptedVersion == active) return;
    _appData = _appData.copyWith(
      privacyPolicyAcceptedVersion: active,
      privacyPolicyAcceptedAtIso: DateTime.now().toIso8601String(),
    );
    await _saveAndNotify();
  }

  Future<void> ignoreUpdateVersion(String version) async {
    final normalized = version.trim();
    if (normalized.isEmpty || _appData.ignoredUpdateVersion == normalized) {
      return;
    }
    _appData = _appData.copyWith(ignoredUpdateVersion: normalized);
    await _saveAndNotify();
  }

  Future<void> updateAvailableUpdateVersion(String? version) async {
    final normalized = version?.trim();
    final nextValue = normalized == null || normalized.isEmpty
        ? null
        : normalized;
    if (_appData.availableUpdateVersion == nextValue) {
      return;
    }
    _appData = _appData.copyWith(availableUpdateVersion: nextValue);
    await _saveAndNotify();
  }
}
