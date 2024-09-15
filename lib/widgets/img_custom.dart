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
    image = Image.network(widget.imageUrl);
    _loadImage();
  }

  void _loadImage() {
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        setState(() {
          _isLoading = false;
        });
      },
      onError: (exception, stackTrace) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      },
    );
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _hasError
              ? const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100.0,
                  ),
                )
              : Image.network(
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  width: widget.width,
                  height: widget.height,
                ),
    );
  }
}
