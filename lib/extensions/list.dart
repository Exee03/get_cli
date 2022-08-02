extension ListExtension<T> on List<T> {
  /// Edit all elements of a list.
  /// ```
  /// List<String> users = ['john', 'william', 'david'];
  /// users.replaceAll( (user) => user.toUpperCase());
  /// print(users); // ['JHON', 'WILLIAM', 'DAVID'];
  /// ```
  ///
  List<T> replaceAll(T Function(T element) function) {
    for (var i = 0; i < length; i++) {
      this[i] = function(this[i]);
    }
    return this;
  }

  List<String> addContent(
    String value, {
    required String after,
    bool replace = false,
  }) {
    bool added = false;
    List<String> contentLines = this as List<String>;

    contentLines = contentLines.map((e) {
      if (added) return e;
      if (!e.contains(after)) return e;

      added = true;
      if (replace) return value;
      return "$e $value";
    }).toList();

    return contentLines;
  }
}
