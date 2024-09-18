import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late Image image;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    // Inicializamos la imagen
    _loadImage();
  }

  @override
  void didUpdateWidget(ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si la URL de la imagen cambia, volvemos a cargar la imagen
    if (widget.imageUrl != oldWidget.imageUrl) {
      _isLoading = true;
      _hasError = false;
      _loadImage();
    }
  }

  void _loadImage() {
    // Validamos que la URL sea válida
    if (widget.imageUrl.isEmpty || !Uri.parse(widget.imageUrl).isAbsolute) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    image = Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      width: widget.width * 1.2,
      height: widget.height * 1.1, 
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        // Muestra el ícono de error personalizado en caso de fallo
        return const Icon(
          Icons.error,
          color: Colors.red,
          size: 120.0,
        );
      },
    );

    // Intentamos cargar la imagen
    final ImageStream stream = image.image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = false;
            });
          }
        },
        onError: (dynamic error, StackTrace? stackTrace) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 120.0,
                )
              : image,
    );
  }
}
