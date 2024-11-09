class DailyMessage {
  final String text;
  final DateTime date;
  String? comment;
  bool isFavorite;

  DailyMessage({
    required this.text,
    required this.date,
    this.comment,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'date': date.toIso8601String(),
      'comment': comment,
      'isFavorite': isFavorite,
    };
  }

  factory DailyMessage.fromJson(Map<String, dynamic> json) {
    return DailyMessage(
      text: json['text'],
      date: DateTime.parse(json['date']),
      comment: json['comment'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
