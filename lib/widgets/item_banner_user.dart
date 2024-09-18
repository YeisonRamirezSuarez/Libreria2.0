import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libreria_app/models/api_response.dart';
import 'package:libreria_app/pages/user_libros_disponibles_page.dart';
import 'package:libreria_app/services/api_services.dart';
import 'package:libreria_app/services/dialog_service.dart';

class ItemBannerUser extends StatefulWidget {
  final bool isPrincipal;
  final bool estadoUsuario; // Estado del usuario
  final bool seaching;
  final bool deleteBook;
  final String titleBaner;
  final String rolUser;
  String nameUser; // Cambiado a mutable
  final List<Option> options; // Lista de opciones
  final String idLibro;
  final Function(String)? searchCallback; // Callback para la búsqueda
  final List<IconData> availableIcons; // Lista de íconos disponibles

  ItemBannerUser({
    super.key,
    this.isPrincipal = false,
    required this.estadoUsuario,
    this.seaching = false,
    this.deleteBook = false,
    this.titleBaner = 'Titulo del Banner',
    this.rolUser = 'Rol de Usuario',
    required this.nameUser, // Requiere un nombre inicial
    this.options = const [],
    this.idLibro = '0',
    this.searchCallback,
    this.availableIcons = const [
      Icons.person,
      Icons.account_circle,
      Icons.face,
      Icons.people,
      Icons.supervised_user_circle,
      Icons.group,
      Icons.business,
      Icons.work,
      Icons.person_add,
      Icons.person_remove,
      Icons.contact_mail,
      Icons.contact_phone,
      Icons.email,
      Icons.phone,
      Icons.card_membership,
      Icons.badge,
      Icons.security,
      Icons.lock,
      Icons.vpn_key,
      Icons.help,
      Icons.info,
    ],
  });

  @override
  _ItemBannerUserState createState() => _ItemBannerUserState();
}

class _ItemBannerUserState extends State<ItemBannerUser> {
  late FocusNode _searchFocusNode;
  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  IconData _selectedIcon = Icons.person; // Estado del ícono seleccionado

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _nameController.text = widget.nameUser;
    _selectedIcon = Icons.person; // Establece un ícono predeterminado

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });

    _searchController.addListener(() {
      if (widget.searchCallback != null) {
        widget.searchCallback!(_searchController.text); // Llama al callback cuando cambia el texto
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _deleteLibro() async {
    try {
      final response = await ApiService.deleteLibro(widget.idLibro.toString());

      if (response.success) {
        DialogService.showSuccessSnackBar(
            context, 'Libro eliminado exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserLibrosDisponiblesPage(isPrincipal: true)),
        );
      } else {
        DialogService.showErrorSnackBar(
            context, response.error ?? 'Error desconocido');
      }
    } catch (error) {
      DialogService.showErrorSnackBar(context, 'Error de red: $error');
    }
  }

  void _showEditDialog() {
    IconData tempSelectedIcon = _selectedIcon;
    TextEditingController tempNameController = TextEditingController(text: _nameController.text);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Editar Usuario'),
              content: SizedBox(
                width: double.maxFinite, // Asegura que el contenido use el máximo ancho posible
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Selector de ícono
                    Text('Selecciona un ícono:'),
                    const SizedBox(height: 10),
                    Container(
                      height: 150.0, // Ajusta la altura según sea necesario
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, // Número de íconos por fila
                          crossAxisSpacing: 10.0, // Espacio horizontal entre íconos
                          mainAxisSpacing: 10.0, // Espacio vertical entre íconos
                        ),
                        itemCount: widget.availableIcons.length,
                        itemBuilder: (BuildContext context, int index) {
                          IconData icon = widget.availableIcons[index];
                          bool isSelected = tempSelectedIcon == icon;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSelectedIcon = icon; // Actualiza el ícono seleccionado temporal
                              });
                            },
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.blue : Colors.white,
                              size: 40.0,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo de texto para nombre
                    TextField(
                      controller: tempNameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIcon = tempSelectedIcon; // Guarda el ícono seleccionado en el estado del widget
                      widget.nameUser = tempNameController.text; // Guarda el nombre en el estado del widget
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: FocusScopeNode(),
      child: Container(
        width: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (widget.isPrincipal) ? _showEditDialog : null,
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        _selectedIcon, // Mostrar ícono seleccionado
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
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
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context); // Cierra el modal
                                      option.onTap(); // Ejecuta la función onTap
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
                        Navigator.pop(context);
                      },
                      tooltip: 'Volver',
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Visibility(
              visible: widget.seaching,
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o autor',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.titleBaner,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (widget.deleteBook)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.redAccent,
                        size: 50,
                      ),
                      onPressed: () {
                        _deleteLibro();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserLibrosDisponiblesPage(isPrincipal: true,)));
                      },
                    ),
                ],
              ),
            ),
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
  final VoidCallback onTap;

  Option({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
