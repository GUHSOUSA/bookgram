import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constants/consts.dart';
import '../../widgets/common_widget.dart';

class ReadPdf extends StatefulWidget {
  final String pdfUrl;

  const ReadPdf({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  State<ReadPdf> createState() => _ReadPdfState();
}

class _ReadPdfState extends State<ReadPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  int _currentPage = 1;
  late final int _totalPages = 0;




  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.primaryText),
          elevation: 0.2,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: resusableMenuText("BookGram", color: Colors.black.withOpacity(0.7))

        ),
        body: Stack(
            children: [
              SfPdfViewer.network(
                widget.pdfUrl,
                controller: _pdfViewerController,
                enableDoubleTapZooming: false,
                scrollDirection: PdfScrollDirection.horizontal,
                pageLayoutMode: PdfPageLayoutMode.single,
                key: _pdfViewerKey,
                canShowScrollHead: false,
                canShowScrollStatus: false,

                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    _currentPage = details.newPageNumber;
                  });
                },



              ),
              Positioned(
                  right: 15,
                  bottom: 15,
                  left: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text('Página $_currentPage de $_totalPages'),



                      Row(
                        children: [

                          Container(
                            margin: const EdgeInsets.all(20),
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryElement


                            ),
                            child: IconButton(onPressed: (){ _pdfViewerController.previousPage();}, icon: const Icon(Icons.keyboard_arrow_left, color: Colors.white,)),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.primaryElement


                            ),
                            child: IconButton(onPressed: (){ _pdfViewerController.nextPage();}, icon: const Icon(Icons.keyboard_arrow_right, color: Colors.white,)),
                          )



                        ],
                      ),
                    ],
                  )
              )
            ]


        ));
  }
}
