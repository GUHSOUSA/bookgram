
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class FollowUnFollowUseCase {
  final FirebaseRepository repository;

  FollowUnFollowUseCase({required this.repository});

  Future<void> call(UserEntity user) {
    return repository.followUnFollowUser(user);
  }
}
class ReadingOrNotUserCase {
  final FirebaseRepository repository;

  ReadingOrNotUserCase({required this.repository});

  Future<void> call(PostEntity post, UserEntity user) {
    return repository.readingOrNot(post, user);
  }
}

