class UiMessage {
  String title;
  String message;
  bool error;

  // Construtor com parâmetros nomeados
  UiMessage({
    required this.title,
    required this.message,
    this.error = false, // Valor padrão para 'error'
  });
}
