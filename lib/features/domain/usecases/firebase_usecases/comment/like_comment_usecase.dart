
import 'package:bookgram/features/domain/entities/comment/comment_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class LikeCommentUseCase {
  final FirebaseRepository repository;

  LikeCommentUseCase({required this.repository});

  Future<void> call(CommentEntity comment) {
    return repository.likeComment(comment);
  }
}