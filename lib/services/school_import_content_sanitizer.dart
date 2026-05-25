class SchoolImportContentSanitizer {
  const SchoolImportContentSanitizer._();

  static const int maxContentLength = 120000;

  // Tags whose entire block (including inner content) should be removed.
  static final RegExp _blockRemoveRe = RegExp(
    r'<(?:script|style|noscript|svg|canvas|iframe|template|nav|header|footer|aside|form|object|embed|applet)\b[^>]*>[\s\S]*?<\/(?:script|style|noscript|svg|canvas|iframe|template|nav|header|footer|aside|form|object|embed|applet)>',
    caseSensitive: false,
  );

  // Void/empty tags that should be removed entirely.
  static final RegExp _voidTagRe = RegExp(
    r'<(?:img|input|button|select|textarea|link|meta|base|source|embed|object|param|area|col|colgroup|wbr)\b[^>]*\/?\s*>',
    caseSensitive: false,
  );

  // Tags to unwrap: remove the opening/closing tag but keep the text content.
  static final RegExp _unwrapTagOpenRe = RegExp(
    r'<\s*(?:a|span|em|strong|b|i|u|s|small|mark|sub|sup|label|font|abbr|cite|code|tt|var)\b[^>]*>',
    caseSensitive: false,
  );
  static final RegExp _unwrapTagCloseRe = RegExp(
    r'<\s*/\s*(?:a|span|em|strong|b|i|u|s|small|mark|sub|sup|label|font|abbr|cite|code|tt|var)\s*>',
    caseSensitive: false,
  );

  // Tags to unwrap that may wrap larger blocks (keep inner content).
  static final RegExp _listTagOpenRe = RegExp(
    r'<\s*(?:ul|ol|li|dl|dt|dd)\b[^>]*>',
    caseSensitive: false,
  );
  static final RegExp _listTagCloseRe = RegExp(
    r'<\s*/\s*(?:ul|ol|li|dl|dt|dd)\s*>',
    caseSensitive: false,
  );

  // Full list of HTML event handlers and display attributes to strip.
  static final RegExp _attributePattern = RegExp(
    r'''\s(?:style|class|id|tabindex|role|target|rel|href|src|alt|title|type|width|height|align|valign|bgcolor|border|cellpadding|cellspacing|scope|headers|summary|lang|dir|hidden|disabled|readonly|checked|selected|placeholder|formaction|srcdoc|onclick|ondblclick|onchange|oninput|onload|onerror|onfocus|onblur|onmousedown|onmouseup|onmousemove|onmouseenter|onmouseleave|onmouseover|onmouseout|onkeydown|onkeyup|onkeypress|onscroll|onwheel|ontouchstart|ontouchmove|ontouchend|oncontextmenu|onselect|onselectstart|oncut|oncopy|onpaste|ondrag|ondragstart|ondragend|ondrop|onanimationstart|onanimationend|ontransitionend|onpointerdown|onpointerup|onpointermove|onreset|onsubmit|onsearch|ontoggle|onbeforeinput|onformdata|data-[\w:-]+|aria-[\w-]+)\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+)''',
    caseSensitive: false,
  );

  static String sanitize(String source) {
    var cleaned = source;

    // 1. Strip entire blocks that are never timetable content.
    cleaned = _stripAll(cleaned, _blockRemoveRe);

    // 2. Strip HTML comments.
    cleaned = cleaned.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');

    // 3. Convert <br>, <hr>, <p> to space (preserve text separation).
    cleaned = cleaned.replaceAll(
      RegExp(r'<\s*br\s*\/?\s*>', caseSensitive: false),
      ' ',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'<\s*hr\s*\/?\s*>', caseSensitive: false),
      ' ',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'<\s*\/?\s*p\s*>', caseSensitive: false),
      ' ',
    );

    // 4. Remove void/inline replacement tags entirely.
    cleaned = cleaned.replaceAll(_voidTagRe, '');

    // 4. Unwrap inline formatting tags (keep text).
    cleaned = cleaned.replaceAll(_unwrapTagOpenRe, '');
    cleaned = cleaned.replaceAll(_unwrapTagCloseRe, '');

    // 5. Unwrap list tags (keep text inside <li>).
    cleaned = cleaned.replaceAll(_listTagOpenRe, '');
    cleaned = cleaned.replaceAll(_listTagCloseRe, '');

    // 6. Strip remaining attributes from all tags.
    cleaned = cleaned.replaceAll(_attributePattern, '');

    // 7. Collapse whitespace.
    cleaned = cleaned.replaceAll(RegExp(r'[\r\n\t\x0B\f]+'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r' {2,}'), ' ');
    // Collapse repeated angle-bracket tags with nothing between them.
    for (var i = 0; i < 3; i++) {
      final prev = cleaned.length;
      cleaned = cleaned.replaceAll(RegExp(r'>\s+<'), '> <');
      // Remove empty tags: <xxx>  </xxx> or self-closing-like patterns.
      cleaned = cleaned.replaceAll(RegExp(r'<(\w+)\s*>\s*<\s*/\s*\1\s*>'), '');
      if (cleaned.length == prev) break;
    }

    cleaned = cleaned.trim();
    if (cleaned.length <= maxContentLength) {
      return cleaned;
    }
    return cleaned.substring(0, maxContentLength);
  }

  static String _stripAll(String source, RegExp pattern) {
    var result = source;
    // Repeat until no more matches (handles nested cases).
    for (var i = 0; i < 5; i++) {
      final prevLen = result.length;
      result = result.replaceAll(pattern, '');
      if (result.length == prevLen) break;
    }
    return result;
  }
}
