import 'package:flutter/material.dart';
import 'package:libreria_app/models/user_model.dart';
import 'package:libreria_app/services/api_service.dart'; // Asegúrate de importar tu ApiService
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:libreria_app/widgets/edit_user_dialog.dart';
import 'package:libreria_app/services/snack_bar_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de importar SnackBarService

class PerfilTab extends StatelessWidget {
  final String userName;
  final String rolUser;
  final String emailUser;
  final IconData selectedIcon;
  final void Function(IconData) onIconChanged;
  final ApiService apiService = ApiService(); // Instancia de ApiService

  PerfilTab({
    super.key,
    required this.userName,
    required this.rolUser,
    required this.emailUser,
    required this.selectedIcon,
    required this.onIconChanged,
  });

  @override
  Widget build(BuildContext context) {
    Map<IconData, String> iconMap = {
      Icons.person: 'Icons.person',
      Icons.account_circle: 'Icons.account_circle',
      Icons.face: 'Icons.face',
      Icons.people: 'Icons.people',
      Icons.supervised_user_circle: 'Icons.supervised_user_circle',
      Icons.group: 'Icons.group',
      Icons.business: 'Icons.business',
      Icons.work: 'Icons.work',
      Icons.person_add: 'Icons.person_add',
      Icons.person_remove: 'Icons.person_remove',
      Icons.contact_mail: 'Icons.contact_mail',
      Icons.contact_phone: 'Icons.contact_phone',
      Icons.email: 'Icons.email',
      Icons.phone: 'Icons.phone',
      Icons.card_membership: 'Icons.card_membership',
      Icons.badge: 'Icons.badge',
      Icons.security: 'Icons.security',
      Icons.lock: 'Icons.lock',
      Icons.vpn_key: 'Icons.vpn_key',
      Icons.help: 'Icons.help',
      Icons.info: 'Icons.info',
    };
    IconData getIconFromString(String iconString) {
      switch (iconString) {
        case 'Icons.person':
          return Icons.person;
        case 'Icons.account_circle':
          return Icons.account_circle;
        case 'Icons.face':
          return Icons.face;
        case 'Icons.people':
          return Icons.people;
        case 'Icons.supervised_user_circle':
          return Icons.supervised_user_circle;
        case 'Icons.group':
          return Icons.group;
        case 'Icons.business':
          return Icons.business;
        case 'Icons.work':
          return Icons.work;
        case 'Icons.person_add':
          return Icons.person_add;
        case 'Icons.person_remove':
          return Icons.person_remove;
        case 'Icons.contact_mail':
          return Icons.contact_mail;
        case 'Icons.contact_phone':
          return Icons.contact_phone;
        case 'Icons.email':
          return Icons.email;
        case 'Icons.phone':
          return Icons.phone;
        case 'Icons.card_membership':
          return Icons.card_membership;
        case 'Icons.badge':
          return Icons.badge;
        case 'Icons.security':
          return Icons.security;
        case 'Icons.lock':
          return Icons.lock;
        case 'Icons.vpn_key':
          return Icons.vpn_key;
        case 'Icons.help':
          return Icons.help;
        case 'Icons.info':
          return Icons.info;
        default:
          return Icons.person; // Valor por defecto si no coincide
      }
    }

    List<IconData> availableIcons = const [
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
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                ItemBannerUser(
                  viewAdd: false,
                  seaching: false,
                  nameUser: userName,
                  titleBaner: "Editar Perfil",
                  rolUser: rolUser,
                  selectedIcon: selectedIcon,
                  viewVolver: false,
                  viewLogout: true,
                ),
                Expanded(
                  child: UserEditWidget(
                    availableIcons: availableIcons,
                    initialName: userName,
                    selectedIcon: selectedIcon,
                    onSave: (IconData icon, String name) async {
                      try {
                        User updatedUser = User.update(
                          name: name,
                          icono: iconMap[icon] ?? 'Icons.person',
                          email: emailUser,
                        );

                        final response =
                            await apiService.updateUser(updatedUser);
                        if (response.success) {
                          // Almacenar datos en SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          // Actualizar solo si los valores han cambiado
                          await prefs.setString('name', updatedUser.name);
                          await prefs.setString('icono', updatedUser.icono);
                          onIconChanged(icon); // Actualiza el estado local si es necesario
                          SnackBarService.showSuccessSnackBar(
                              context, 'Usuario actualizado con éxito');
                        } else {
                          SnackBarService.showErrorSnackBar(
                              context, response.error ?? 'Error desconocido');
                        }
                      } catch (e) {
                        SnackBarService.showErrorSnackBar(context,
                            'Se ha producido un error: ${e.toString()}');
                      }
                    },
                    onCancel: () {
                      onIconChanged(
                          selectedIcon); // Restablece el icono si se cancela
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
