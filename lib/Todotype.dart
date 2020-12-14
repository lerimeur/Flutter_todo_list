class Todo {
  final int id;
  final String title;
  final String desc;
  final int done;

  Todo({this.id, this.title, this.desc, this.done});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'done': done,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, title: $title, desc: $desc, fait: $done}';
  }
}
