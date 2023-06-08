import 'package:bookgram/features/presentation/widgets/common_widget.dart';
import 'package:flutter/material.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({Key? key}) : super(key: key);

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Todos os livros"),
      body: const Center(child: Text("todos os livros"),),
    );
  }
}
