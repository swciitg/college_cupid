import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:blurhash_ffi/blurhash_ffi.dart';
import 'package:college_cupid/functions/helpers.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class _ImageHelpers {
  final ImagePicker _imagePicker;

  _ImageHelpers({ImagePicker? imagePicker})
      : _imagePicker = imagePicker ?? ImagePicker();

  Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
  }) async {
    return await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
  }

  Future<Image> xFileToImage({required XFile xFile}) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = generateRandomString(length: 20);
    final file = await File('${tempDir.path}/$fileName.jpg').create();
    await file.writeAsBytes(await xFile.readAsBytes());

    return Image.file(file);
  }

  Future<File> imageToFile({required ui.Image image}) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("Failed to convert image to ByteData");
    }
    final pngBytes = byteData.buffer.asUint8List();

    // Create an image.Image object from raw bytes
    final decodedImage = img.decodePng(pngBytes);
    if (decodedImage == null) {
      throw Exception("Failed to decode PNG image");
    }
    final bytes = img.encodeJpg(decodedImage);

    // final bytes = byteData.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final path = generateRandomString(length: 20);
    final file = await File('${tempDir.path}/$path.jpg').create();
    //
    await file.writeAsBytes(bytes);
    //
    return file;
  }

  // encode blurhash
  Future<String?> encodeBlurHash(
      {required ImageProvider<Object> imageProvider}) async {
    try {
      final blurHash = await BlurhashFFI.encode(imageProvider);
      log("BlurHash: $blurHash");
      return blurHash;
    } catch (e) {
      log("BlurHash error: $e");
      return null;
    }
  }
}

final imageHelpers = _ImageHelpers();
