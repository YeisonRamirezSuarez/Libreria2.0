class Usuario {
  final String? id; // Hacer id opcional
  final String idBook;
  final String title;
  final String author;
  final String bookUrl;
  final String imageUrl;
  final String description;
  final String date;
  final String emailUser;
  final String nameUser;
  final String phoneUser;

  Usuario({
    this.id,
    required this.idBook,
    required this.title,
    required this.author,
    required this.bookUrl,
    required this.imageUrl,
    required this.description,
    required this.date,
    required this.emailUser,
    required this.nameUser,
    required this.phoneUser,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String?,
      idBook: json['id_book'] as String? ?? '',
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      bookUrl: json['book_url'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      emailUser: json['email_user'] as String? ?? '',
      nameUser: json['name_user'] as String? ?? '',
      phoneUser: json['phone_user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id_book': idBook,
      'title': title,
      'author': author,
      'book_url': bookUrl,
      'image_url': imageUrl,
      'description': description,
      'date': date,
      'email_user': emailUser,
      'name_user': nameUser,
      'phone_user': phoneUser,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
