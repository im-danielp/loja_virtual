import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaceTile({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data() as Map<String, dynamic>? ?? {};

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100,
            child: Image.network(data['image'], fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(8, 16, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'],
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  data['address'],
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('Ver no mapa'),
                onPressed: () {
                  launchUrl(
                    Uri.parse('https://www.google.com/maps/search/${data['lat']},+${data['long']}'),
                  );
                },
              ),
              TextButton(
                child: Text('Ligar'),
                onPressed: () {
                  launchUrl(Uri.parse('tel:${data['phone']}'));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
