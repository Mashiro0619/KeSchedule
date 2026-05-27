String sanitizeImportedId(String rawId, {int maxLength = 96}) {
  final source = rawId.trim();
  if (source.isEmpty || maxLength <= 0) {
    return '';
  }
  final safe = source
      .replaceAll(RegExp(r'[^A-Za-z0-9._-]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  if (safe.isEmpty) {
    return '';
  }
  return safe.length > maxLength ? safe.substring(0, maxLength) : safe;
}
