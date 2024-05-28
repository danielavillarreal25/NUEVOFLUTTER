import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecetasScreen extends StatefulWidget {
  @override
  _RecetasScreenState createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  String _selectedCategoria = '';
  String _selectedNumComensales = '';
  String _selectedTiempo = '';
  String _selectedTipo = ''; // Nuevo campo para el Tipo de receta
  List<String> _categorias = [];
  List<String> _numComensales = [];
  List<String> _tiempos = [];
  List<String> _tipos = []; // Lista para almacenar los valores únicos de Tipo

  late Stream<QuerySnapshot> _filteredRecetas; // Nuevo stream para recetas filtradas

  @override
  void initState() {
    super.initState();
    _getCategorias();
    _getNumComensales();
    _getTiempos();
    _getTipos(); // Llamada a la función para obtener los tipos de receta
    _filteredRecetas = FirebaseFirestore.instance.collection('Recetas').snapshots(); // Inicialización del stream
  }

  void _getCategorias() {
    FirebaseFirestore.instance.collection('Recetas').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String categoria = doc['Categoria'];
        if (!_categorias.contains(categoria)) {
          setState(() {
            _categorias.add(categoria);
          });
        }
      });
    });
  }

  void _getNumComensales() {
    _numComensales.add("Seleccionar");
    FirebaseFirestore.instance.collection('Recetas').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String numComensales = doc['NumComensales'].toString();
        if (!_numComensales.contains(numComensales)) {
          setState(() {
            _numComensales.add(numComensales);
          });
        }
      });
    });
  }

  void _getTiempos() {
    Set<String> uniqueTiempos = {};
    uniqueTiempos.add("Seleccionar");
    FirebaseFirestore.instance.collection('Recetas').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String tiempo = doc['Tiempo'].toString();
        uniqueTiempos.add(tiempo);
      });
      setState(() {
        _tiempos = uniqueTiempos.toList();
      });
    });
  }

  void _getTipos() {
    Set<String> uniqueTipos = {}; // Usamos un conjunto para eliminar duplicados
    uniqueTipos.add("Seleccionar"); // Agregar valor predeterminado
    FirebaseFirestore.instance.collection('Recetas').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        String tipo = doc['Tipo'].toString();
        uniqueTipos.add(tipo);
      });
      setState(() {
        _tipos = uniqueTipos.toList(); // Convertir el conjunto de nuevo a una lista
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField(
              value: _selectedCategoria.isNotEmpty ? _selectedCategoria : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoria = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar'),
                ),
                ..._categorias.map((String categoria) {
                  return DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria),
                  );
                }),
              ],
              decoration: InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: _selectedNumComensales.isNotEmpty ? _selectedNumComensales : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedNumComensales = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar'),
                ),
                ..._numComensales.map((String numComensales) {
                  return DropdownMenuItem(
                    value: numComensales,
                    child: Text(numComensales),
                  );
                }),
              ],
              decoration: InputDecoration(
                labelText: 'Comensales',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: _selectedTiempo.isNotEmpty ? _selectedTiempo : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTiempo = newValue!;
                });
              },
              items: [
                                DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar'),
                ),
                ..._tiempos.map((String tiempo) {
                  return DropdownMenuItem(
                    value: tiempo,
                    child: Text(tiempo),
                  );
                }),
              ],
              decoration: InputDecoration(
                labelText: 'Tiempo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: _selectedTipo.isNotEmpty ? _selectedTipo : null,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTipo = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('Seleccionar'),
                ),
                ..._tipos.map((String tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }),
              ],
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Filtrar las recetas según las selecciones
                Query<Map<String, dynamic>> filteredRecetas = FirebaseFirestore.instance.collection('Recetas');

                if (_selectedCategoria.isNotEmpty) {
                  filteredRecetas = filteredRecetas.where('Categoria', isEqualTo: _selectedCategoria);
                }
                if (_selectedNumComensales.isNotEmpty) {
                  filteredRecetas = filteredRecetas.where('NumComensales', isEqualTo: int.parse(_selectedNumComensales));
                }
                if (_selectedTiempo.isNotEmpty) {
                  filteredRecetas = filteredRecetas.where('Tiempo', isEqualTo: _selectedTiempo);
                }
                if (_selectedTipo.isNotEmpty) { // Agregar filtro por Tipo
                  filteredRecetas = filteredRecetas.where('Tipo', isEqualTo: _selectedTipo);
                }

                // Mostrar solo las recetas filtradas
                setState(() {
                  _filteredRecetas = filteredRecetas.snapshots();
                });
              },
              child: Text('Buscar Recetas'),
            ),
            SizedBox(height: 20), // Espacio entre los botones y la lista
            Expanded(
              child: StreamBuilder(
                stream: _filteredRecetas,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  // Si no hay errores y tenemos datos, mostramos la lista
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final receta = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(receta['NombreReceta']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Categoría: ${receta['Categoria']}'),
                            Text('Ingredientes:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: receta['Ingredientes'].toString().split(',').map((String ingrediente) {
                                return Text('- $ingrediente');
                              }).toList(),
                            ),
                            Text('Número de comensales: ${receta['NumComensales']}'),
                            Text('Tiempo: ${receta['Tiempo']}'),
                            Text('Tipo: ${receta['Tipo']}'),
                            // Añade más campos según sea necesario
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

