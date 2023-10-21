
class TodoItems {
  final int userId;
  final int id;
  final String title;

  TodoItems({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory TodoItems.fromJson(Map<String, dynamic> json) {
    return TodoItems(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
    );
  }
}