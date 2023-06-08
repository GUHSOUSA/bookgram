Container(
    margin: EdgeInsets.symmetric(horizontal: 10,),
    height: 35,
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(7)
    ),
    child: TextFormField(
      
      controller: controller,
      
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: Colors.black.withOpacity(0.5),
        ),hintText: "Pesquisar",
        hintStyle: TextStyle(color: Colors.grey)
      ),
      
    ),
  );

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////Expanded(
            child: GridView.custom(
            
              
              gridDelegate: 
              SliverQuiltedGridDelegate(
                
                crossAxisCount:3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                
                                repeatPattern: QuiltedGridRepeatPattern.inverted,
                pattern: [
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(2, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),

                ] 
            ),childrenDelegate: SliverChildBuilderDelegate(
              childCount: 20,
              (context, index)=> Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true, 
          child:
          Container(
                color: Colors.grey,
              ))
            )),
          )

        ],
      ),
    );
////////////////////////////////////////////////////////////////////////////////////////////////////////////
final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    
    super.initState();

    _searchController.addListener(() {
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget usuarios(){
  return Container(
    height: 60,
    child: Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            width: 40,
            height: 40,
           child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.grey,
            ),
           ), 
            ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,child: Container(height: 8, width: 150, color: Colors.grey[500])),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,child: Container(height: 7, width: 250, color: Colors.grey[300])),
              ),
              Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
                child: Container(
                  margin: EdgeInsets.only(left: 2, right: 2),
                  height: 5, width: 300, color: Colors.grey[100],),
              ),
            ],
          ),
        )
      ],
    ),
  );
}