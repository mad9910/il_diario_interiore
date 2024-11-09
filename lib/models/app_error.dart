class AppError {
  final String message;
  final String? details;
  final ErrorType type;
  final DateTime timestamp;

  AppError({
    required this.message,
    this.details,
    required this.type,
    DateTime? timestamp,
  }) : this.timestamp = timestamp ?? DateTime.now();

  factory AppError.network({String? details}) {
    return AppError(
      message: 'Errore di connessione',
      details: details,
      type: ErrorType.network,
    );
  }

  factory AppError.storage({String? details}) {
    return AppError(
      message: 'Errore di salvataggio',
      details: details,
      type: ErrorType.storage,
    );
  }

  factory AppError.content({String? details}) {
    return AppError(
      message: 'Errore nel caricamento dei contenuti',
      details: details,
      type: ErrorType.content,
    );
  }
}

enum ErrorType {
  network,
  storage,
  content,
  unknown
}
