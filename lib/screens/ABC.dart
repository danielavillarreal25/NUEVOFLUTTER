import 'package:appdani/screens/Recetas.dart';
import 'package:flutter/material.dart';
import 'package:appdani/screens/ABC_Altas.dart'; // Importa el archivo ABC_Altas.dart

class ABCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABC Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecetasScreen()),
                );
              },
              child: Text('Recetas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ABCAltasScreen()), // Navega a ABC_Altas.dart
                );
              },
              child: Text('AltasRecetas'), // Nuevo botón
            ),
          ],
        ),
      ),
    );
  }
}
