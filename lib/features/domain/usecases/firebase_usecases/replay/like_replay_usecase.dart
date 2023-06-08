import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class LikeReplayUseCase {
  final FirebaseRepository repository;

  LikeReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.likeReplay(replay);
  }
}