class WeeklyStory {
  final String title;
  final String content;
  final DateTime date;
  bool isFavorite;
  String? comment;

  WeeklyStory({
    required this.title,
    required this.content,
    required this.date,
    this.isFavorite = false,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'isFavorite': isFavorite,
      'comment': comment,
    };
  }

  factory WeeklyStory.fromJson(Map<String, dynamic> json) {
    return WeeklyStory(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      isFavorite: json['isFavorite'] ?? false,
      comment: json['comment'],
    );
  }
}
