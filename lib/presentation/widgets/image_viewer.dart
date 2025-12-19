import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final List<String?>? originalFileNames;
  final int initialIndex;

  const ImageViewer({
    super.key,
    required this.imageUrls,
    this.originalFileNames,
    this.initialIndex = 0,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late PageController _pageController;
  late int _currentIndex;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<Directory?> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      try {
        // Try to get the public Downloads directory
        // Path: /storage/emulated/0/Download
        final downloadsDir = Directory('/storage/emulated/0/Download');
        
        // Check if it exists or try to create it
        if (!await downloadsDir.exists()) {
          try {
            await downloadsDir.create(recursive: true);
          } catch (e) {
            // If we can't create, try alternative path
            final altDownloadsDir = Directory('/sdcard/Download');
            if (await altDownloadsDir.exists()) {
              return altDownloadsDir;
            }
            try {
              await altDownloadsDir.create(recursive: true);
              if (await altDownloadsDir.exists()) {
                return altDownloadsDir;
              }
            } catch (e2) {
              // Continue to fallback
            }
            // Last resort: use external storage directory
            return await getExternalStorageDirectory();
          }
        }
        return downloadsDir;
      } catch (e) {
        // Fallback: use external storage directory
        try {
          return await getExternalStorageDirectory();
        } catch (e2) {
          return null;
        }
      }
    }
    return null;
  }

  Future<void> _downloadImage() async {
    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final imageUrl = widget.imageUrls[_currentIndex];
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;
        
        // Get original file name or use default
        String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}';
        
        if (widget.originalFileNames != null &&
            _currentIndex < widget.originalFileNames!.length &&
            widget.originalFileNames![_currentIndex] != null &&
            widget.originalFileNames![_currentIndex]!.isNotEmpty) {
          fileName = widget.originalFileNames![_currentIndex]!;
        } else {
          // Try to get extension from URL
          final uri = Uri.parse(imageUrl);
          final path = uri.path;
          if (path.contains('.')) {
            final extension = path.split('.').last.split('?').first;
            fileName = '$fileName.$extension';
          } else {
            fileName = '$fileName.jpg'; // Default to jpg
          }
        }

        // Get Downloads directory
        final downloadsDir = await _getDownloadsDirectory();
        
        if (downloadsDir == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot access Downloads folder'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
          return;
        }

        // Save directly to Downloads folder
        final file = File('${downloadsDir.path}/$fileName');
        await file.writeAsBytes(imageBytes);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image saved to Downloads: $fileName'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to download image'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${_currentIndex + 1} / ${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download, color: Colors.white),
            onPressed: _isDownloading ? null : _downloadImage,
            tooltip: 'Download image',
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrls[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

