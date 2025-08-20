import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final Future<QuerySnapshot> data = FirebaseFirestore.instance
      .collection('home')
      .orderBy('pos')
      .get();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 0.0,
              backgroundColor: corPrimaria,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Novidade',
                style: TextStyle(
                  color: Color(0xFFF4FAFF),
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            ),
            FutureBuilder<QuerySnapshot>(
              future: data,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                } else {
                  final List images = snapshot.data!.docs;
                  return SliverToBoxAdapter(
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: images
                          .map(
                            (img) => StaggeredGridTile.count(
                              crossAxisCellCount: img.data()['x'],
                              mainAxisCellCount: img.data()['y'],
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Material(
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.antiAlias,
                                  color: const Color.fromARGB(255, 248, 248, 248),
                                  child: CachedNetworkImage(
                                    imageUrl: img.data()['image'],
                                    placeholder: (context, url) => Image.memory(kTransparentImage),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
