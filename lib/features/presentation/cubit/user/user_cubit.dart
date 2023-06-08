import 'dart:io';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/follow_unfollow_user_usecase.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_users_usecase.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/update_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UpdateUserUseCase updateUserUseCase;
  final GetUsersUseCase getUsersUseCase;
  final FollowUnFollowUseCase followUnFollowUseCase;
  final ReadingOrNotUserCase readingOrNotUserCase;
  UserCubit({required this.readingOrNotUserCase, required this.followUnFollowUseCase, required this.updateUserUseCase, required this.getUsersUseCase}) : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch(_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    try {
      await updateUserUseCase.call(user);
    } on SocketException catch(_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> followUnFollowUser({required UserEntity user}) async {
    try {
      await followUnFollowUseCase.call(user);
    } on SocketException catch(_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
  Future<void> readingOrNotUses({required PostEntity post, required UserEntity user }) async {
    try {
      await readingOrNotUserCase.call(post, user);
    } on SocketException catch(_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}


