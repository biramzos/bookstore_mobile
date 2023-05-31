class File{
  final int? id;
  final String? name;

  File(
      this.id,
      this.name
      );

  factory File.fromJson(Map<String, dynamic> data){
    return File(
        data['id'],
        data['name']
    );
  }
}