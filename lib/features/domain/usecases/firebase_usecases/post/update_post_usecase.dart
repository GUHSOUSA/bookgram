import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class UpdatePostUseCase {
  final FirebaseRepository repository;

  UpdatePostUseCase({required this.repository});

  Future<void> call(PostEntity post) {
    return repository.updatePost(post);
  }
}