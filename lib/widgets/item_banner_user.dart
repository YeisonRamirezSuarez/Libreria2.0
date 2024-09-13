import 'package:flutter/material.dart';

class ItemBannerUser extends StatelessWidget {
  final bool estadoUsuario; // Estado del usuario
  final bool seaching;
  final String titleBaner;
  final String rolUser;
  final String nameUser;

  const ItemBannerUser({
    super.key,
    required this.estadoUsuario,
    this.seaching = false,
    this.titleBaner = 'Titulo del Banner',
    this.rolUser = 'Rol de Usuario',
    this.nameUser = 'Nombre del Administrador',
  }); // Constructor actualizado

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.black,
            child: Row(
              children: <Widget>[
    
                // User icon
                const CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('assets/user.png'), // Replace with your image
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        rolUser,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        nameUser,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Add the button here
                if (estadoUsuario)
                  IconButton(
                    icon: const Icon(Icons.add),
                    iconSize: 50.0,
                    color: Colors.redAccent,
                    onPressed: () {
                      
                    },
                    tooltip: 'Funciones de usuario',
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {},
                    tooltip: 'Volver',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),

          // Search bar
          Visibility(
            visible: seaching, // Initially hidden
            child: Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.close),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // Banner title
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              titleBaner,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Orange divider
          Container(
            height: 3.0,
            color: Colors.redAccent,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
