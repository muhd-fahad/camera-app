import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../services/gallery_service.dart';
import 'image_detail.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _galleryService = GalleryService();
  List<AssetEntity> _photos = [];
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    final photos = await _galleryService.getAllPhotos();

    if (!mounted) return;
    setState(() {
      _photos = photos.reversed.toList(); // newest first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All photos (${_photos.length})',
        ),
      ),
      body:  _photos.isEmpty
          ? const Center(
        child: Text(
          'No photos.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        physics: const BouncingScrollPhysics(),
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          final asset = _photos[index];

          return FutureBuilder(
            future: asset.thumbnailDataWithSize(
              const ThumbnailSize(200, 200),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () async {
                    final file = await asset.file;
                    if (file == null) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ImageDetail(imagePath: file.path),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
