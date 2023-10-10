import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heartdog/src/services/owner_services.dart';
import 'package:heartdog/src/util/app_colors.dart';
import 'package:heartdog/src/models/owner.dart';
import 'package:heartdog/src/util/widget_properties.dart';

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
  bool _acceptTerms = false;

  String? _validateName(String? value) {
    final RegExp nameExp = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'El campo debe contener solo letras y espacios';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final RegExp emailExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
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

        if (registeredOwner == 1) {
          print("Se registro");
          // ignore: use_build_context_synchronously
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

// Método para mostrar los términos y condiciones en una ventana emergente (modal)
void _showTermsAndConditionsDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenido a nuestra solución tecnológica para el monitoreo de perros geriátricos cardiopáticos de razas pequeñas mediante el uso de dispositivos "wearables" y técnicas de machine learning. Antes de utilizar nuestros servicios, te pedimos que leas detenidamente los siguientes términos y condiciones. Al acceder y utilizar nuestra plataforma, aceptas cumplir con estos términos y condiciones. Si no estás de acuerdo con alguno de estos términos, te recomendamos que no utilices nuestros servicios.',
              ),
              SizedBox(height: 16),
              Text(
                '1. Uso de la Plataforma',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '1.1. Nuestra plataforma está diseñada para proporcionar monitoreo y análisis de la frecuencia cardíaca y el pulso de perros geriátricos cardiopáticos de razas pequeñas. Esta solución tiene fines informativos y de monitoreo, y no debe reemplazar el consejo de un veterinario u otro profesional de la salud animal.',
              ),
              SizedBox(height: 8),
              Text(
                '1.2. Tú eres responsable de la configuración y el uso adecuado de los dispositivos "wearables" en tus perros. Asegúrate de seguir las instrucciones proporcionadas por el fabricante y nuestros procedimientos recomendados.',
              ),
              SizedBox(height: 16),
              
              Text(
                '2. Privacidad y Datos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '2.1. Entendemos la importancia de la privacidad de tus datos y la de tus perros. Toda la información que recopilamos se maneja de acuerdo con nuestra Política de Privacidad. Al utilizar nuestra plataforma, aceptas nuestras prácticas de privacidad.'
              ),
              SizedBox(height: 8),
              Text(
                '2.2. Ten en cuenta que, como esta es una primera versión de nuestra solución, es posible que la precisión de los resultados del análisis de electrocardiograma no sea perfecta debido a la falta de datos en el entrenamiento de machine learning. Te recomendamos que consultes a un veterinario para una evaluación más precisa de la salud de tu perro.'
              ),
              SizedBox(height: 16),

              Text(
                '3. Responsabilidades',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '3.1. No somos responsables de ningún daño directo, indirecto, incidental, especial o consecuente que pueda surgir del uso de nuestra plataforma. Es tu responsabilidad garantizar la salud y el bienestar de tus perros y buscar atención veterinaria si es necesario.'
              ),
              SizedBox(height: 16),

              Text(
                '4. Cambios en los Términos y Condiciones',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '4.1. Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. Te notificaremos sobre cualquier cambio significativo y te pediremos que revises y aceptes los nuevos términos antes de continuar utilizando nuestros servicios.'
              ),
              SizedBox(height: 8),
              Text(
                'Estos son los términos y condiciones que rigen el uso de nuestra plataforma. Al utilizar nuestros servicios, aceptas cumplir con estos términos. Si tienes alguna pregunta o inquietud, no dudes en ponerte en contacto con nosotros. Gracias por confiar en nuestra solución tecnológica para el bienestar de tus perros.'
              ),
              SizedBox(height: 16),
              Text(
                'Fecha de entrada en vigor: 10/10/2023'
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
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
                  decoration: WidgetCustomProperties.customInputDecoration(
                      hintText: "Nombres"),
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _lastnameController,
                  decoration: WidgetCustomProperties.customInputDecoration(
                      hintText: "Apellidos"),
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: WidgetCustomProperties.customInputDecoration(
                      hintText: "Correo electrónico"),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  decoration:
                      WidgetCustomProperties.customPasswordInputDecoration(
                          gestureDetector: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  )),
                  obscureText: _obscureText,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: WidgetCustomProperties.customInputDecoration(
                      hintText: "Teléfono"),
                  validator: _validatePhone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 9,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptTerms = value!;
                        });
                      },
                    ),
                    Text('Acepto los'),
                    TextButton(
                      onPressed: _showTermsAndConditionsDialog,
                      child: Text('Términos y Condiciones'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_acceptTerms) {
                      _registerUser();
                    } else {
                      // Mostrar un mensaje de error si los términos no se aceptan
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Debes aceptar los Términos y Condiciones.'),
                        ),
                      );
                    }
                  },
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
