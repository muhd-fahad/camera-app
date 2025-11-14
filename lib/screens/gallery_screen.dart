import 'dart:io';

import 'package:flutter/material.dart';

import 'image_detail.dart';

class GalleryScreen extends StatelessWidget {
  final List<String> images;

  const GalleryScreen({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All photos (${images.length})')),
      body: images.isEmpty
          ? const Center(
              child: Text('No photos.', style: TextStyle(fontSize: 18, color: Colors.grey)),
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,

                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              padding: EdgeInsets.all(8.0),
              reverse: true,

              itemCount: images.length,
              // scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const .all(4.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImageDetail(imagePath: images[index],)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: .circular(8),
                        image: DecorationImage(
                          image: FileImage(File(images[index])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
