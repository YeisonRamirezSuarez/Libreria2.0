import 'package:flutter/material.dart';

class ItemBannerUser extends StatefulWidget {
  final bool estadoUsuario; // Estado del usuario
  final bool seaching;
  final String titleBaner;
  final String rolUser;
  final String nameUser;
  final List<Option> options; // Lista de opciones

  const ItemBannerUser({
    super.key,
    required this.estadoUsuario,
    this.seaching = false,
    this.titleBaner = 'Titulo del Banner',
    this.rolUser = 'Rol de Usuario',
    this.nameUser = 'Nombre del Administrador',
    this.options = const [], // Nueva propiedad para opciones
  });

  @override
  _ItemBannerUserState createState() => _ItemBannerUserState();
}

class _ItemBannerUserState extends State<ItemBannerUser> {
  // FocusNode to control the search bar focus
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    // Initialize the FocusNode
    _searchFocusNode = FocusNode();

    // Ensure the TextField does not have focus on page build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    // Dispose the FocusNode to free resources
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: FocusScopeNode(), // Create a new FocusScope
      child: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(10.0),
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
                    backgroundImage: AssetImage(
                        'assets/user.png'), // Replace with your image
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.rolUser,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          widget.nameUser,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Add the button here
                  if (widget.estadoUsuario)
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 50.0,
                      color: Colors.redAccent,
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.redAccent,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: widget.options.map((option) {
                                  return ListTile(
                                    leading: option.icon,
                                    iconColor: Colors.white,
                                    title: Text(
                                      option.title,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              option.destination,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        );
                      },
                      tooltip: 'Funciones de usuario',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 50.0,
                      color: Colors.redAccent,
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cierra el Modal si está abierto

                        Navigator.pop(context);
                      },
                      tooltip: 'Volver',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            // Search bar
            Visibility(
              visible: widget.seaching, // Initially hidden
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: TextField(
                  focusNode: _searchFocusNode, // Attach FocusNode
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _searchFocusNode
                            .unfocus(); // Unfocus when clicking the close icon
                      },
                      child: const Icon(Icons.close),
                    ),
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                widget.titleBaner,
                style: const TextStyle(
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
      ),
    );
  }
}

class Option {
  final Icon icon;
  final String title;
  final Widget destination;

  Option({
    required this.icon,
    required this.title,
    required this.destination,
  });
}
