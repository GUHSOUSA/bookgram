
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class SignOutUseCase {
  final FirebaseRepository repository;

  SignOutUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}