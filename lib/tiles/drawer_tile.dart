import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController controler;
  final int page;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.text,
    required this.controler,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: controler.page?.round() == page
            ? Theme.of(context).primaryColor
            : Colors.grey[700], //
      ),
      title: Text(
        text,
        style: TextStyle(
          color: controler.page?.round() == page
              ? Theme.of(context).primaryColor
              : Colors.grey[700],
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        controler.jumpToPage(page);
      },
    );
  }
}
