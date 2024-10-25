import 'dart:html' as html;

class FilePickerWeb {
  Future<html.File?> pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    return await Future<html.File?>.delayed(
      Duration(seconds: 1),
      () {
        return uploadInput.onChange.first.then((_) {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            return files.first;
          }
          return null;
        });
      },
    );
  }
}
