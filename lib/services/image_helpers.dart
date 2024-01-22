import 'package:college_cupid/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelpers {
  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  ImageHelpers({ImagePicker? imagePicker, ImageCropper? imageCropper})
      : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  Future<XFile?> pickImage(
      {ImageSource source = ImageSource.gallery,
      int imageQuality = 100}) async {
    return await _imagePicker.pickImage(
        source: source, imageQuality: imageQuality);
  }

  Future<CroppedFile?> crop(
      {required XFile file, CropStyle cropStyle = CropStyle.rectangle}) async {
    return await _imageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: cropStyle,
      uiSettings: [
        AndroidUiSettings(
          backgroundColor: Colors.black,
          toolbarColor: Colors.black,
          toolbarTitle: 'Edit Image',
          statusBarColor: Colors.black,
          toolbarWidgetColor: CupidColors.offWhiteColor,
          hideBottomControls: false,
          activeControlsWidgetColor: CupidColors.titleColor,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: 'Edit Image',
          cancelButtonTitle: 'Cancel',
          doneButtonTitle: 'Done',
          aspectRatioLockDimensionSwapEnabled: false,
          resetButtonHidden: false,
        )
      ],
    );
  }
}
