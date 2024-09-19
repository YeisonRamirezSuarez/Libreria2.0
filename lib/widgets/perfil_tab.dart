import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_widgets.dart';
import 'package:libreria_app/widgets/edit_user_dialog.dart';

class PerfilTab extends StatelessWidget {
  final String userName;
  final String rolUser;
  final IconData selectedIcon;
  final void Function(IconData) onIconChanged;

  const PerfilTab({
    Key? key,
    required this.userName,
    required this.rolUser,
    required this.selectedIcon,
    required this.onIconChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    onSave: (IconData icon, String name) {
                      onIconChanged(icon);
                    },
                    onCancel: () {
                      onIconChanged(selectedIcon);
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
