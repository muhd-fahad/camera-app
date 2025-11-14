import 'dart:io';

import 'package:flutter/material.dart';

class ImageDetail extends StatelessWidget {
  final String imagePath;
  const ImageDetail({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: 'image',
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.grey.shade700,
                  image: DecorationImage(
                    // image: NetworkImage(
                    //   'https://cdn.naturettl.com/wp-content/uploads/2021/05/14135435/How-to-Photograph-Minimalist-Landscapes_-7.jpg',
                    // ),
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              spacing: 12,
              mainAxisAlignment: .spaceEvenly,
              crossAxisAlignment: .end,
              children: [
                ImageIcons(icon: Icons.share, label: 'Share'),
                ImageIcons(icon: Icons.tune, label: 'Edit'),
                ImageIcons(icon: Icons.archive_outlined, label: 'Save'),
                ImageIcons(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageIcons extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const ImageIcons({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(spacing: 8, children: [Icon(icon), Text(label)]),
    );
  }
}
