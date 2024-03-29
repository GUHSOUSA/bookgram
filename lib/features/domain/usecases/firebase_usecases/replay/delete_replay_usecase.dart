import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class DeleteReplayUseCase {
  final FirebaseRepository repository;

  DeleteReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.deleteReplay(replay);
  }
}