import 'package:flutter/material.dart';
import 'package:LibreriaApp/models/user_model.dart';
import 'package:LibreriaApp/services/api_service.dart';
import 'package:LibreriaApp/widgets/custom_widgets.dart';
import 'package:LibreriaApp/widgets/edit_user_dialog.dart';
import 'package:LibreriaApp/services/snack_bar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilTab extends StatelessWidget {
  final String userName;
  final String rolUser;
  final String emailUser;
  final IconData selectedIcon;
  final void Function(IconData) onIconChanged;
  final ApiService apiService = ApiService();
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
                          rol: rolUser,
                        );

                        final response =
                            await apiService.updateUser(updatedUser);
                        if (response.success) {
                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString('name', updatedUser.name);
                          await prefs.setString('icono', updatedUser.icono);
                          onIconChanged(icon);
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
