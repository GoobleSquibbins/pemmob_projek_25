import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../core/config/api_config.dart';

class ImageHelper {
  static const _uuid = Uuid();

  static String constructImageUrl(String filename) {
    return ApiConfig.getImageUrl(filename);
  }

  static String generateFilename(String originalPath) {
    final extension = originalPath.split('.').last.toLowerCase();
    final uuid = _uuid.v4();
    return '$uuid.$extension';
  }

  /// Uploads a single image to Azure Blob Storage
  /// Returns the filename if successful, null otherwise
  static Future<String?> uploadImageToAzure(File imageFile) async {
    try {
      final filename = generateFilename(imageFile.path);
      final uploadUrl = ApiConfig.getAzureUploadUrl(filename);
      final imageBytes = await imageFile.readAsBytes();

      final response = await http.put(
        Uri.parse(uploadUrl),
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return filename;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Uploads multiple images to Azure Blob Storage
  /// Returns list of filenames for successfully uploaded images
  static Future<List<String>> uploadMultipleImages(
    List<File> imageFiles,
  ) async {
    final List<String> uploadedFilenames = [];

    for (final imageFile in imageFiles) {
      final filename = await uploadImageToAzure(imageFile);
      if (filename != null) {
        uploadedFilenames.add(filename);
      }
    }

    return uploadedFilenames;
  }
}

