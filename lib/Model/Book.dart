class Book {
  final int id;
  final String? name;
  final String? author;
  final String? description;
  final double cost;
  Book(
      this.id,
      this.name,
      this.author,
      this.description,
      this.cost
      );

  factory Book.fromJson(Map<String, dynamic> data){
    return Book(
        data['id'],
        data['name'],
        data['author'],
        data['description'],
        data['cost']
    );
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "author": author,
    "description": description,
    "cost": cost
  };
}