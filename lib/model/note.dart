class Note {
  final String id;
  final String title;
  final String content;
  final String author;
  final bool isPublic;
  final DateTime createdAt;
  final String shortId;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.isPublic,
    required this.createdAt,
    required this.shortId,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      isPublic: json['is_public'],
      createdAt: DateTime.parse(json['created_at']),
      shortId: json['short_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'author': author,
      'is_public': isPublic,
      'short_id': shortId,
    };
  }
}