class Book {
  final String? id; // El id es opcional
  final String title;
  final String author;
  final String quantity;
  final String bookUrl;
  final String imageUrl;
  final String description;

  Book({
    this.id, // id es opcional
    required this.title,
    required this.author,
    required this.quantity,
    required this.bookUrl,
    required this.imageUrl,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String?, // Asegúrate de que 'id' sea del tipo String?
      title: json['title'] as String,
      author: json['author'] as String,
      quantity: json['quantity'] as String,
      bookUrl: json['book_url'] as String,
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'author': author,
      'quantity': quantity,
      'book_url': bookUrl,
      'image_url': imageUrl,
      'description': description,
    };

    // Solo incluye el id en el JSON si está presente
    if (id != null) {
      data['id'] = id;
    }

    return data;
  }
}
