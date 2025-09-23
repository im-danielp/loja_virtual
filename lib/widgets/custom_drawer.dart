import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  const CustomDrawer({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16, right: 16),
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
                height: 200,
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      left: 0,
                      child: Text.rich(
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        TextSpan(
                          children: [
                            TextSpan(text: 'Vestiário\n'),
                            TextSpan(
                              text: 'Flutter',
                              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Olá!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          InkWell(
                            child: Text(
                              'Entre ou cadastre-se',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Divider(color: Theme.of(context).textTheme.bodyMedium!.color),
              ),
              DrawerTile(
                icon: Icons.home,
                text: 'Início',
                controler: pageController,
                page: 0,
              ),
              DrawerTile(
                icon: Icons.list,
                text: 'Produtos',
                controler: pageController,
                page: 1,
              ),
              DrawerTile(
                icon: Icons.location_on,
                text: 'Lojas',
                controler: pageController,
                page: 2,
              ),
              DrawerTile(
                icon: Icons.playlist_add_check,
                text: 'Meus Pedidos',
                controler: pageController,
                page: 3,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
