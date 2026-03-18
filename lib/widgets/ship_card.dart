import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  const ShipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Calcular frete',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        splashColor: Colors.transparent,
        leading: Icon(Icons.location_on),
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              initialValue: '',
              onFieldSubmitted: (text) {},
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hint: Text('Digite seu CEP'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
