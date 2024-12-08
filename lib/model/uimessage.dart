class UiMessage {
  String title;
  String message;
  bool error;
  UiMessage({
    required this.title,
    required this.message,
    this.error = false,
  });
}
