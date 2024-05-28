import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appdani/screens/ABC.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      // Consultar la base de datos para obtener el usuario con el nombre de usuario proporcionado
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('Usuario', isEqualTo: username)
          .limit(1)
          .get();

      // Verificar si se encontró un usuario con el nombre de usuario proporcionado
      if (result.docs.isNotEmpty) {
        final user = result.docs.first;

        // Verificar si la contraseña coincide
        if (user['Contraseña'] == password) {
          // Navegar a la pantalla de ABC si el inicio de sesión es exitoso
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ABCScreen()),
          );
        } else {
          // Mostrar mensaje de error si la contraseña no coincide
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contraseña incorrecta. Inténtelo de nuevo.'),
            ),
          );
        }
      } else {
        // Mostrar mensaje de error si no se encontró ningún usuario con el nombre de usuario proporcionado
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El usuario no existe. Por favor, regístrese.'),
          ),
        );
      }
    } catch (e) {
      print('Error de inicio de sesión: $e');
      // Manejar el error, mostrar un mensaje al usuario, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Ingresa tu Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Ingresa tu Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
