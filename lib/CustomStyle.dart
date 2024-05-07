import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'main.dart';

class ShopThumbnail extends StatefulWidget {
  final Shop shop;

  ShopThumbnail({required this.shop});

  @override
  _ShopThumbnailState createState() => _ShopThumbnailState();
}

class _ShopThumbnailState extends State<ShopThumbnail> {
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final thumbnailBytes = await getMarkerIcon(widget.shop.thumbnail);
    setState(() {
      imageBytes = thumbnailBytes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: imageBytes == null
          ? BoxDecoration()
          : BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(imageBytes!),
          fit: BoxFit.cover,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}