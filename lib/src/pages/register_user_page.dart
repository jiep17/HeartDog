import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartdog/src/services/owner_services.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:heartdog/src/models/owner.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _obscureText = true;

  String? _validateName(String? value) {
    final RegExp nameExp = RegExp(r'^[a-zA-Z]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'El campo debe contener solo letras';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final RegExp emailExp = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailExp.hasMatch(value!)) {
      return 'El correo electrónico no es válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value!.length != 9 || !value.startsWith('9')) {
      return 'El teléfono debe tener 9 dígitos y comenzar con 9';
    }
    final RegExp phoneExp = RegExp(r'^\d{9}$');
    if (!phoneExp.hasMatch(value)) {
      return 'El teléfono debe contener solo números';
    }
    return null;
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String lastname = _lastnameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String phone = _phoneController.text;

      final Owner newOwner = Owner(
        id: '',
        name: name,
        lastname: lastname,
        email: email,
        password: password,
        phone: phone,
      );

      try {
        final ownerService = OwnerService();
        final registeredOwner = await ownerService.registerOwner(newOwner);

        if(registeredOwner == 1) {
          print("Se registro");
          Navigator.of(context).pushNamed('/');
        } else {
          print("No se registro");
        }
        // Muestra un mensaje de éxito y redirige a otra página
      } catch (e) {
        print(e);
      }
      
      _nameController.clear();
      _lastnameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Usuario'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/barbeat_logo.png', 
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                  ),
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 9,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
