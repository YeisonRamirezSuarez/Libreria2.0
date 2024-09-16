class Usuario {

  final String id;
  final String id_book;
  final String title;
  final String author;
  final String book_url;
  final String image_url;
  final String description;
  final String date;
  final String email_user;
  final String name_user;
  final String phone_user;


  Usuario({
    required this.id,
    required this.id_book,
    required this.title,
    required this.author,
    required this.book_url,
    required this.image_url,
    required this.description,
    required this.date,
    required this.email_user,
    required this.name_user,
    required this.phone_user
  });

  // Define the fromJson method
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      id_book: json['id_book'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      book_url: json['book_url'] as String,
      image_url: json['image_url'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      email_user: json['email_user'] as String,
      name_user: json['name_user'] as String,
      phone_user: json['phone_user'] as String,
    );
  }

  // Optional: Add a toJson method for easy conversion back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_book': id_book,
      'title': title,
      'author': author,
      'book_url': book_url,
      'image_url': image_url,
      'description': description,
      'date': date,
      'email_user': email_user,
      'name_user': name_user,
      'phone_user': phone_user
    };
  }
}
