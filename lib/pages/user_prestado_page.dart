import 'package:flutter/material.dart';
import 'package:libreria_app/widgets/custom_button.dart';
import 'package:libreria_app/widgets/item_banner_user.dart';

class UserPrestadoPage extends StatelessWidget {
  const UserPrestadoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
        
              ItemBannerUser(estadoUsuario: true, seaching : true), // El botón se mostrará
              // ItemBannerUser(estadoUsuario: false); // El botón no se mostrará

              const SizedBox(height: 10.0),

              // RecyclerView equivalent
              Container(
                width: double.infinity,
                height: 500.0,
                color: Colors.grey[700], // Fondo para el RecyclerView
                child: const Center(
                  child: Text(
                    'RecyclerView Placeholder',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              // Orange divider lines
              Container(
                width: double.infinity,
                height: 3.0,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 10.0),
              Container(
                width: double.infinity,
                height: 3.0,
                margin: const EdgeInsets.only(top: 2.0),
                color: Colors.redAccent,
              ),
              const SizedBox(height: 4.0),
              Container(
                width: double.infinity,
                height: 4.0,
                margin: const EdgeInsets.only(bottom: 10.0),
                color: Colors.redAccent,
              ),
              const SizedBox(height: 15.0),

              // Button
              CustomButton(
                text: 'Prestar',
                onPressed: () {},
                colorFondo: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
