import 'package:flutter/material.dart';

class BannerHeader extends StatelessWidget {
  final String rolUser;
  final String nameUser;
  final bool viewAdd;
  final bool viewVolver;
  final bool viewLogout;
  final IconData selectedIcon;
  final VoidCallback? onAddTap;
  final VoidCallback? onBackTap;
  final VoidCallback? onLogoutTap;

  const BannerHeader({
    super.key,
    required this.rolUser,
    required this.nameUser,
    this.viewAdd = false,
    this.viewVolver = false,
    this.viewLogout = false,
    this.selectedIcon = Icons.person,
    this.onAddTap,
    this.onBackTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.grey[200],
            child: Icon(
              selectedIcon,
              size: 30,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  rolUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                Text(
                  nameUser,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
          if (viewAdd)
            GestureDetector(
              onTap: onAddTap,
              child: const Icon(
                Icons.add,
                size: 50.0,
                color: Colors.redAccent,
              ),
            )
          else if (viewVolver)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              iconSize: 50.0,
              color: Colors.redAccent,
              onPressed: onBackTap,
              tooltip: 'Volver',
            )
          else if (viewLogout)
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.redAccent, size: 50),
              onPressed: onLogoutTap,
              tooltip: 'Cerrar Sesión',
            )
        ],
      ),
    );
  }
}
