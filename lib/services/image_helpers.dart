import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:college_cupid/functions/helpers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blurhash_ffi/blurhash_ffi.dart';

class _ImageHelpers {
  final ImagePicker _imagePicker;

  _ImageHelpers({ImagePicker? imagePicker}) : _imagePicker = imagePicker ?? ImagePicker();

  Future<XFile?> pickImage(
      {ImageSource source = ImageSource.gallery, int imageQuality = 100}) async {
    return await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
  }

  Future<Image> xFileToImage({required XFile xFile}) async {
    final tempDir = await getTemporaryDirectory();
    String fileName = generateRandomString(length: 20);
    File file = await File('${tempDir.path}/$fileName.png').create();
    file.writeAsBytesSync(await xFile.readAsBytes());

    return Image.file(file);
  }

  Future<File> imageToFile({required ui.Image image}) async {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = data!.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final String path = generateRandomString(length: 20);
    File file = await File('${tempDir.path}/$path.png').create();

    file.writeAsBytesSync(bytes);

    return file;
  }

  // encode blurhash
  Future<String?> encodeBlurHash({required ImageProvider<Object> imageProvider}) async {
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
