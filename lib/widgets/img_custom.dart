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
  ImageStreamListener? _imageStreamListener;

  @override
  void initState() {
    super.initState();
    // Initialize the image with a default image in case of invalid URL
    image = Image.network(widget.imageUrl, errorBuilder: (context, error, stackTrace) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 100.0,
      );
    });
    _loadImage();
  }

  void _loadImage() {
    // Check if the URL is valid
    if (widget.imageUrl.isEmpty || !Uri.parse(widget.imageUrl).isAbsolute) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    _imageStreamListener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      onError: (exception, stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      },
    );
    stream.addListener(_imageStreamListener!);
  }

  @override
  void dispose() {
    final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    if (_imageStreamListener != null) {
      stream.removeListener(_imageStreamListener!);
    }
    super.dispose();
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
