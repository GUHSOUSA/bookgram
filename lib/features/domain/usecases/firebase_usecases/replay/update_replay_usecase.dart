import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/repository/firebase_repository.dart';

class UpdateReplayUseCase {
  final FirebaseRepository repository;

  UpdateReplayUseCase({required this.repository});

  Future<void> call(ReplayEntity replay) {
    return repository.updateReplay(replay);
  }
}