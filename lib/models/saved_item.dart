class SavedItem {
  final String content;
  final String comment;
  final DateTime savedDate;
  final String type; // 'message' o 'story'

  SavedItem({
    required this.content,
    required this.comment,
    required this.savedDate,
    required this.type,
  });

  // Convertiamo in Map per salvare i dati
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'comment': comment,
      'savedDate': savedDate.toIso8601String(),
      'type': type,
    };
  }

  // Creiamo un oggetto da Map
  factory SavedItem.fromJson(Map<String, dynamic> json) {
    return SavedItem(
      content: json['content'],
      comment: json['comment'],
      savedDate: DateTime.parse(json['savedDate']),
      type: json['type'],
    );
  }
}
