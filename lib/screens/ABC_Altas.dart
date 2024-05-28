import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ABCAltasScreen extends StatefulWidget {
  @override
  _ABCAltasScreenState createState() => _ABCAltasScreenState();
}

class _ABCAltasScreenState extends State<ABCAltasScreen> {
  String _selectedCategoria = '';
  String _selectedTipo = '';
  String _nombreReceta = '';
  String _ingredientes = '';
  String _numComensales = '';
  String _tiempo = '';

  List<String> _categorias = [];
  List<String> _tipos = [];

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getCategorias();
    _getTipos();
  }

  void _getCategorias() {
    _firestore.collection('Recetas').get().then((querySnapshot) {
      Set<String> categoriasSet = {};
      querySnapshot.docs.forEach((doc) {
        categoriasSet.add(doc['Categoria']);
      });
      setState(() {
        _categorias = categoriasSet.toList();
        _selectedCategoria = _categorias.isNotEmpty ? _categorias[0] : '';
      });
    });
  }

  void _getTipos() {
    _firestore.collection('Recetas').get().then((querySnapshot) {
      Set<String> tiposSet = {};
      querySnapshot.docs.forEach((doc) {
        tiposSet.add(doc['Tipo']);
      });
      setState(() {
        _tipos = tiposSet.toList();
        _selectedTipo = _tipos.isNotEmpty ? _tipos[0] : '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Altas de Recetas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField(
              value: _selectedCategoria,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoria = newValue!;
                });
              },
              items: _categorias.map((String categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: _selectedTipo,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTipo = newValue!;
                });
              },
              items: _tipos.map((String tipo) {
                return DropdownMenuItem(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _nombreReceta = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nombre de la Receta',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _ingredientes = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Ingredientes',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _numComensales = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Número de Comensales',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _tiempo = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tiempo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agregar la receta a Firestore
                _firestore.collection('Recetas').add({
                  'Categoria': _selectedCategoria,
                  'Tipo': _selectedTipo,
                  'NombreReceta': _nombreReceta,
                  'Ingredientes': _ingredientes,
                  'NumComensales': _numComensales,
                  'Tiempo': _tiempo,
                }).then((value) {
                  // Limpiar los campos después de agregar la receta
                  setState(() {
                    _selectedCategoria = _categorias.isNotEmpty ? _categorias[0] : '';
                    _selectedTipo = _tipos.isNotEmpty ? _tipos[0] : '';
                    _nombreReceta = '';
                    _ingredientes = '';
                    _numComensales = '';
                    _tiempo = '';
                  });
                  // Mostrar un mensaje de éxito
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Receta agregada con éxito'),
                  ));
                }).catchError((error) {
                  // Mostrar un mensaje de error si falla la operación
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error al agregar la receta: $error'),
                  ));
                });
              },
              child: Text('Agregar Receta'),
            ),
          ],
        ),
      ),
    );
  }
}
