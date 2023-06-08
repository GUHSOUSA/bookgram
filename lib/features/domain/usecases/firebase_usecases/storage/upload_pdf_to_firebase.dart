
import 'package:bookgram/features/domain/repository/firebase_repository.dart';
import 'package:file_picker/file_picker.dart';

class UploadPdfToFirebase {
  final FirebaseRepository repository;

  UploadPdfToFirebase({required this.repository});

  Future<String> call(PlatformFile platformFile, bool isPost, String childName) {
    return repository.upLoadPdfToFirebase(platformFile, isPost, childName);

  }
}
