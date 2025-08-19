import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final Future<QuerySnapshot> data = FirebaseFirestore.instance
      .collection('home')
      .orderBy('pos')
      .get();

  @override
  Widget build(BuildContext context) {
    Widget buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF519E8A), Color(0xFF476A6F)],
          begin: Alignment.topLeft,
          end: AlignmentGeometry.bottomRight,
        ),
      ),
    );

    return Stack(
      children: [
        buildBodyBack(),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Color(0xFF519E8A),
              elevation: 0.0,
              title: Text('Novidade', style: TextStyle(color: Color(0xFFF4FAFF), fontSize: 20)),
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
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: img.data()['image'],
                                fit: BoxFit.cover,
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
