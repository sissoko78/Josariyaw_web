import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';

class FilePickerMobile {
  final ImagePicker _picker = ImagePicker();

  Future<io.File?> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return io.File(pickedFile.path);
    }
    return null;
  }
}
