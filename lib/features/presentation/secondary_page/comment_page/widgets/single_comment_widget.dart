import 'package:bookgram/features/presentation/widgets/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/comment/comment_entity.dart';
import 'package:bookgram/features/domain/entities/replay/replay_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/user/get_current_uid_usecase.dart';
import 'package:bookgram/features/presentation/cubit/replay/replay_cubit.dart';
import 'package:bookgram/features/presentation/secondary_page/comment_page/widgets/single_replay_widget.dart';
import 'package:bookgram/features/presentation/widgets/form_container_widget.dart';
import 'package:bookgram/constants/profile_widget.dart';

import 'package:intl/intl.dart';
import 'package:bookgram/constants/injection_container.dart' as di;
import 'package:uuid/uuid.dart';

class SingleCommentWidget extends StatefulWidget {
  final CommentEntity comment;
  final VoidCallback? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  final UserEntity? currentUser;

  const SingleCommentWidget(
      {Key? key,
      required this.comment,
      this.onLongPressListener,
      this.onLikeClickListener,
      this.currentUser})
      : super(key: key);

  @override
  State<SingleCommentWidget> createState() => _SingleCommentWidgetState();
}

class _SingleCommentWidgetState extends State<SingleCommentWidget> {
  final _replayDescriptionController = TextEditingController();
  String _currentUid = "";

  @override
  void initState() {
    di.sl<GetCurrentUidUseCase>().call().then((value) {
      setState(() {
        _currentUid = value;
      });
    });

    BlocProvider.of<ReplayCubit>(context).getReplays(replay: ReplayEntity(postId: widget.comment.postId, commentId: widget.comment.commentId));

    super.initState();
  }

  bool _isUserReplaying = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.comment.creatorUid == _currentUid? widget.onLongPressListener : null,
      child: Container(


        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: profileWidget(imageUrl: widget.comment.userProfileUrl),
              ),
            ),
            sizeHor(10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.comment.username}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                                onTap: widget.onLikeClickListener,
                                child: Icon(
                                  widget.comment.likes!.contains(_currentUid)
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  size: 20,
                                  color: widget.comment.likes!.contains(_currentUid)
                                      ? Colors.red
                                      : darkGreyColor,
                                )),
                          ],
                        )
                      ],
                    ),
                    sizeVer(4),
                    Text(
                      "${widget.comment.description}",
                      style: const TextStyle(color: primaryColor),
                    ),
                    sizeVer(4),
                    Row(
                      children: [
                        Text(
                          DateFormat("dd/MMM/yyy").format(widget.comment.createAt!.toDate()),
                          style: const TextStyle(color: darkGreyColor),
                        ),
                        sizeHor(15),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _isUserReplaying = !_isUserReplaying;
                              });
                            },
                            child: const Text(
                              "Responder",
                              style: TextStyle(color: darkGreyColor, fontSize: 12),
                            )),
                        sizeHor(15),
                        GestureDetector(
                          onTap: () {
                            widget.comment.totalReplays == 0? toastInfo(msg: "Sem respostas") :
                            BlocProvider.of<ReplayCubit>(context).getReplays(replay: ReplayEntity(postId: widget.comment.postId, commentId: widget.comment.commentId));
                          },
                          child: const Text(
                            "Ver respostas",
                            style: TextStyle(color: darkGreyColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<ReplayCubit, ReplayState>(
                      builder: (context, replayState) {
                        if (replayState is ReplayLoaded) {
                          final replays = replayState.replays.where((element) => element.commentId == widget.comment.commentId).toList();
                          return ListView.builder(shrinkWrap: true, physics: const ScrollPhysics(), itemCount: replays.length, itemBuilder: (context, index) {
                            return SingleReplayWidget(replay: replays[index],
                            onLongPressListener: () {
                              _openBottomModalSheet(context: context, replay: replays[index]);
                            },
                            onLikeClickListener: () {
                              _likeReplay(replay: replays[index]);
                            },
                            );

                          });

                        }
                        return const Center(child: CircularProgressIndicator(),);
                      },
                    ),
                    _isUserReplaying == true ? sizeVer(10) : sizeVer(0),
                    _isUserReplaying == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FormContainerWidget(
                                  hintText: "Escreva sua respostas...",
                                  controller: _replayDescriptionController),
                              sizeVer(10),
                              GestureDetector(
                                onTap: () {
                                  _createReplay();
                                },
                                child: const Text(
                                  "Enviar",
                                  style: TextStyle(color: blueColor),
                                ),
                              )
                            ],
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createReplay() {
    BlocProvider.of<ReplayCubit>(context)
        .createReplay(
            replay: ReplayEntity(
      replayId: const Uuid().v1(),
      createAt: Timestamp.now(),
      likes: const [],
      username: widget.currentUser!.username,
      userProfileUrl: widget.currentUser!.profileUrl,
      creatorUid: widget.currentUser!.uid,
      postId: widget.comment.postId,
      commentId: widget.comment.commentId,
      description: _replayDescriptionController.text,
    ))
        .then((value) {
      setState(() {
        _replayDescriptionController.clear();
        _isUserReplaying = false;
      });
    });
  }

  _openBottomModalSheet({required BuildContext context, required ReplayEntity replay}) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(color: backGroundColor.withOpacity(.8)),
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Opçoes",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          _deleteReplay(replay: replay);
                        },
                        child: const Text(
                          "Deleta",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                    const Divider(
                      thickness: 1,
                      color: secondaryColor,
                    ),
                    sizeVer(7),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, PageConst.updateReplayPage,
                              arguments: replay);

                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePostPage()));
                        },
                        child: const Text(
                          "Modificar",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: primaryColor),
                        ),
                      ),
                    ),
                    sizeVer(7),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deleteReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).deleteReplay(replay: ReplayEntity(
      postId: replay.postId,
      commentId: replay.commentId,
      replayId: replay.replayId
    ));
  }

  _likeReplay({required ReplayEntity replay}) {
    BlocProvider.of<ReplayCubit>(context).likeReplay(replay: ReplayEntity(
        postId: replay.postId,
        commentId: replay.commentId,
        replayId: replay.replayId
    ));
  }

}
