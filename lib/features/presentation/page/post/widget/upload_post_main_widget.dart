
import 'dart:io';

import 'package:bookgram/features/domain/usecases/firebase_usecases/storage/upload_pdf_to_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bookgram/constants/consts.dart';
import 'package:bookgram/features/domain/entities/posts/post_entity.dart';
import 'package:bookgram/features/domain/entities/user/user_entity.dart';
import 'package:bookgram/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:bookgram/features/presentation/cubit/post/post_cubit.dart';
import 'package:bookgram/features/presentation/widgets/profile_form_widget.dart';
import 'package:bookgram/constants/profile_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:bookgram/constants/injection_container.dart' as di;

import '../../../widgets/common_widget.dart';

class UploadPostMainWidget extends StatefulWidget {
  final UserEntity currentUser;
  const UploadPostMainWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  bool _isShrimer = false;
  PlatformFile? pickedFile;
  File? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _startLoading() {
    setState(() {
      _isShrimer = pickedFile != null ? false: true;

    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isShrimer = false;
      });
    });
  }
  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }



  Future _openFileExplorer() async {
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;
    _startLoading();

    setState(() {
      pickedFile = result.files.first;


    });
  }

    Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        elevation: 0.2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: resusableMenuText("Adicionar livro"),
         leading: _image == null? Container(): GestureDetector(onTap: () => setState(() => _image = null),child: const Icon(Icons.close, size: 28,) ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(onTap: _submitPost,child: const Icon(Icons.arrow_forward, color: AppColors.primaryElement,)),
          )
        ],
      ),
      body:   Column(

        children: [

          _isShrimer ? _buildProgressBar(): Container(),
          Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          width: double.infinity,
          height: 150.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: selectImage,
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  height: 130.h,
                  width: 83.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),

                  ),
                  child: profileWidget(image: _image),
                ),
              ),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileFormWidget( title: "Titulo", controller: _titleController,),
                  SizedBox(height: 10.h,),

                  ProfileFormWidget( title: "Autor", controller: _authorController,),
                  SizedBox(height: 12.h,),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [ Icon(Icons.favorite, size: 25.w, color: Colors.black.withOpacity(0.5),),
                        resusableMenuText("0", fontSize: 16,),
                        SizedBox(width: 15.w,),
                        Icon(Icons.comment, size: 25,color: Colors.black.withOpacity(0.5),),
                        resusableMenuText("0"),
                        SizedBox(width: 15.w,),
                        const Icon(Icons.star, size: 25, color: Colors.yellowAccent,),
                        resusableMenuText("0")
                      ],
                    ),
                    const Icon(Icons.bookmark_outline)
                    ],
                  )
                ],
              ))
            ],
          ),
          ),
          _upLoadFiles(_openFileExplorer),
          pickedFile  != null ? _fileLoaded() : Container(),


        ],
      ),
    );
  }

  _submitPost() {
    final imageUpload = di.sl<UploadImageToStorageUseCase>().call(_image!, true, "posts");
    final pdfUpload = di.sl<UploadPdfToFirebase>().call(pickedFile!, true, "posts");


    Future.wait([imageUpload, pdfUpload]).then((List<dynamic> results) {
      final imageUrl = results[0];
      final pdfUrl = results[1];
      _createSubmitPost(image: imageUrl, pdf: pdfUrl);
    });
  }
  _createSubmitPost({required String image, required String pdf}) {
    BlocProvider.of<PostCubit>(context).createPost(
        post: PostEntity(
            title: _titleController.text,
            author: _authorController.text,
            createAt: Timestamp.now(),
            creatorUid: widget.currentUser.uid,
            likes: const                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  [],
            postId: const Uuid().v1(),
            postImageUrl: image,
            totalComments: 0,
            totalLikes: 0,
            username: widget.currentUser.username,
            userProfileUrl: widget.currentUser.profileUrl,
            postPdfUrl: pdf,
        )
    ).then((value) => _clear());
  }
  _clear() {
    setState(() {
      _authorController.clear();
      _titleController.clear();
      _image = null;
      pickedFile = null;
    });
  }

  _clearPdf(){
    setState(() {

    pickedFile = null;
  });
  }

  _upLoadFiles(void Function()? func){
    return GestureDetector(
      onTap: func,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.w),
          color: const Color(0xFFE6F2FF)
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: DashedLinePainter(
                  color: AppColors.primaryElement,
                  strokeWidth: 1.0,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Clique aqui para enviar o livro',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
}
  _buildProgressBar() {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      direction: ShimmerDirection.ltr,
      baseColor: AppColors.primaryElement,
      highlightColor: Colors.grey,
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey,
      ),

    );
  }
  _fileLoaded(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      width: double.infinity,
      height: 85.h,
      decoration: BoxDecoration(
          color: const Color(0xfff0f4fd),
          borderRadius: BorderRadius.circular(5.w)
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.w, right: 10.w),
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: const DecorationImage(image: AssetImage("assets/icons/book.png"))
              ),

            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10.h,),
                resusableMenuText("${pickedFile!.name.substring(0,9)}...${pickedFile!.name.substring(pickedFile!.name.length - 3)}", fontWeight: FontWeight.normal, ),
                resusableMenuText("${pickedFile!.size} KB", fontSize: 13, color: AppColors.primaryThreeElementText, ),
                SizedBox(height: 5.h,),
                _isShrimer ? Shimmer.fromColors(
                  period: const Duration(milliseconds: 1500),
                  direction: ShimmerDirection.ltr,
                  baseColor: AppColors.primaryElement,
                  highlightColor: Colors.grey,
                  child: Container(
                    width: 145.w,
                    height: 2,
                    color: Colors.grey,
                  ),

                ): Container(
                  width: 145.w,
                  height: 2,
                  color: Colors.green,
                ),
                SizedBox(height: 15.h,),
              ],
            ),
            resusableMenuText("100%", fontWeight: FontWeight.bold),
            SizedBox(width: 15.h,),

            SizedBox(
                height: 15.h,
                width: 15.w,
                child:  _isShrimer ? const CircularProgressIndicator(color: AppColors.primaryElement,): Icon(Icons.check, color: Colors.green, size: 25.w,)),
              SizedBox(width: 15.h,),
            GestureDetector(
                onTap: _clearPdf,
                child: const Icon(Icons.close))

          ],
        ),
      ),

    );
  }

}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedLinePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

     const dashWidth = 5.0;
     const dashSpace = 5.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0.0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    double endY = size.height;

    while (endY > 0) {
      canvas.drawLine(
        Offset(size.width, endY),
        Offset(size.width, endY - dashWidth),
        paint,
      );
      endY -= dashWidth + dashSpace;
    }

    double endX = size.width;

    while (endX > 0) {
      canvas.drawLine(
        Offset(endX, size.height),
        Offset(endX - dashWidth, size.height),
        paint,
      );
      endX -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}




