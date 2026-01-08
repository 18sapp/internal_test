import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:internal_test/exercises/screen_a/ui/screen_a.dart';

// Variables globales
List<Map<String, dynamic>> gastosLista = [];
List<Map<String, dynamic>> categoriasLista = [];
List<Map<String, dynamic>> cuentasLista = [];
List<Map<String, dynamic>> presupuestosLista = [];
int contadorId = 1;
int contadorIdCat = 1;
int contadorIdCuenta = 1;
int contadorIdPresu = 1;

void main() {
  // datos de prueba
  categoriasLista.add({
    'id': 1,
    'nombre': 'Comida',
    'color': 0xFF4CAF50,
    'icono': 'restaurant',
    'presupuesto': 5000.0,
  });
  categoriasLista.add({
    'id': 2,
    'nombre': 'Transporte',
    'color': 0xFF2196F3,
    'icono': 'directions_car',
    'presupuesto': 2000.0,
  });
  categoriasLista.add({
    'id': 3,
    'nombre': 'Entretenimiento',
    'color': 0xFF9C27B0,
    'icono': 'movie',
    'presupuesto': 3000.0,
  });
  contadorIdCat = 4;

  cuentasLista.add({
    'id': 1,
    'nombre': 'Efectivo',
    'tipo': 'efectivo',
    'saldo': 10000.0,
  });
  cuentasLista.add({
    'id': 2,
    'nombre': 'Tarjeta Crédito',
    'tipo': 'tarjeta',
    'saldo': 5000.0,
  });
  contadorIdCuenta = 3;

  gastosLista.add({
    'id': 1,
    'descripcion': 'Almuerzo',
    'monto': 1500.0,
    'fecha': DateTime.now().subtract(Duration(days: 2)).toIso8601String(),
    'categoriaId': 1,
    'cuentaId': 1,
    'etiquetas': ['trabajo'],
  });
  gastosLista.add({
    'id': 2,
    'descripcion': 'Uber',
    'monto': 800.0,
    'fecha': DateTime.now().subtract(Duration(days: 1)).toIso8601String(),
    'categoriaId': 2,
    'cuentaId': 2,
    'etiquetas': [],
  });
  contadorId = 3;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Gastos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Pantalla principal - todo mezclado
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Gastos'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categorías',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Cuentas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Presupuestos',
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildBody() {
    if (selectedIndex == 0) {
      return DashboardScreen();
    } else if (selectedIndex == 1) {
      return GastosListScreen();
    } else if (selectedIndex == 2) {
      return CategoriasScreen();
    } else if (selectedIndex == 3) {
      return CuentasScreen();
    } else {
      return PresupuestosScreen();
    }
  }

  Widget? _buildFAB() {
    if (selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditGastoScreen()),
          );
        },
        child: Icon(Icons.add),
      );
    } else if (selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditCategoriaScreen()),
          );
        },
        child: Icon(Icons.add),
      );
    } else if (selectedIndex == 3) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditCuentaScreen()),
          );
        },
        child: Icon(Icons.add),
      );
    } else if (selectedIndex == 4) {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditPresupuestoScreen()),
          );
        },
        child: Icon(Icons.add),
      );
    }
    return null;
  }
}

// Dashboard
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // cálculos
    var ahora = DateTime.now();
    var inicioMes = DateTime(ahora.year, ahora.month, 1);
    var finMes = DateTime(ahora.year, ahora.month + 1, 0);

    // calcular totales - código duplicado y malo
    double totalGastos = 0;
    for (var g in gastosLista) {
      var fechaGasto = DateTime.parse(g['fecha']);
      if (fechaGasto.isAfter(inicioMes.subtract(Duration(days: 1))) &&
          fechaGasto.isBefore(finMes.add(Duration(days: 1)))) {
        totalGastos += g['monto'];
      }
    }

    // calcular por categoría
    Map<int, double> gastosPorCategoria = {};
    for (var g in gastosLista) {
      var fechaGasto = DateTime.parse(g['fecha']);
      if (fechaGasto.isAfter(inicioMes.subtract(Duration(days: 1))) &&
          fechaGasto.isBefore(finMes.add(Duration(days: 1)))) {
        var catId = g['categoriaId'];
        if (gastosPorCategoria.containsKey(catId)) {
          gastosPorCategoria[catId] = gastosPorCategoria[catId]! + g['monto'];
        } else {
          gastosPorCategoria[catId] = g['monto'];
        }
      }
    }

    // verificar presupuestos excedidos
    List<Map<String, dynamic>> alertas = [];
    for (var p in presupuestosLista) {
      var catId = p['categoriaId'];
      var presuMonto = p['monto'];
      var gastoCat = gastosPorCategoria[catId] ?? 0.0;
      if (gastoCat > presuMonto) {
        var cat = categoriasLista.firstWhere(
          (c) => c['id'] == catId,
          orElse: () => {'nombre': 'Desconocida'},
        );
        alertas.add({
          'categoria': cat['nombre'],
          'gasto': gastoCat,
          'presupuesto': presuMonto,
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _exportarDatos(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.ads_click),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExerciseScreenA(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // card de resumen
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gastos del Mes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$$totalGastos',
                      style: TextStyle(fontSize: 32, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // alertas de presupuesto
            if (alertas.isNotEmpty) ...[
              Text(
                '⚠️ Presupuestos Excedidos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...alertas
                  .map(
                    (a) => Card(
                      color: Colors.red.shade50,
                      child: ListTile(
                        title: Text(a['categoria']),
                        subtitle: Text(
                          'Gastado: \$${a['gasto']} / Presupuesto: \$${a['presupuesto']}',
                        ),
                      ),
                    ),
                  )
                  .toList(),
              SizedBox(height: 16),
            ],

            // gráfico de barras simple - código horrible
            Text(
              'Gastos por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: gastosPorCategoria.entries.map((e) {
                  var cat = categoriasLista.firstWhere(
                    (c) => c['id'] == e.key,
                    orElse: () => {'nombre': 'N/A', 'color': 0xFF000000},
                  );
                  var maxGasto = gastosPorCategoria.values.reduce(
                    (a, b) => a > b ? a : b,
                  );
                  var altura = maxGasto > 0 ? (e.value / maxGasto * 180) : 0.0;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 40,
                        height: altura,
                        color: Color(cat['color']),
                        child: Center(
                          child: Text(
                            '\$${e.value.toString()}',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 60,
                        child: Text(
                          cat['nombre'],
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            // gráfico de pastel simple - más código horrible
            Text(
              'Distribución de Gastos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 200,
              child: CustomPaint(
                size: Size(200, 200),
                painter: PieChartPainter(gastosPorCategoria, categoriasLista),
              ),
            ),
            SizedBox(height: 16),

            // lista de categorías con totales
            Text(
              'Detalle por Categoría',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...gastosPorCategoria.entries.map((e) {
              var cat = categoriasLista.firstWhere(
                (c) => c['id'] == e.key,
                orElse: () => {'nombre': 'Desconocida', 'color': 0xFF000000},
              );
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: Color(cat['color'])),
                  title: Text(cat['nombre']),
                  trailing: Text(
                    '\$${e.value.toString()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _exportarDatos(BuildContext context) {
    // exportar a JSON - código inline
    Map<String, dynamic> datos = {
      'gastos': gastosLista,
      'categorias': categoriasLista,
      'cuentas': cuentasLista,
      'presupuestos': presupuestosLista,
    };
    var jsonString = jsonEncode(datos);
    // mostrar diálogo con datos - sin usar servicios
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Datos Exportados'),
        content: SingleChildScrollView(
          child: Text(jsonString, style: TextStyle(fontSize: 10)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// Painter para gráfico de paste
class PieChartPainter extends CustomPainter {
  Map<int, double> datos;
  List<Map<String, dynamic>> categorias;

  PieChartPainter(this.datos, this.categorias);

  @override
  void paint(Canvas canvas, Size size) {
    var total = datos.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var startAngle = -3.14159 / 2;

    datos.forEach((catId, valor) {
      var cat = categorias.firstWhere(
        (c) => c['id'] == catId,
        orElse: () => {'color': 0xFF000000},
      );
      var sweepAngle = (valor / total) * 2 * 3.14159;
      var paint = Paint()
        ..color = Color(cat['color'])
        ..style = PaintingStyle.fill;
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Lista de gastos - filtros y búsqueda mezclados
class GastosListScreen extends StatefulWidget {
  @override
  State<GastosListScreen> createState() => _GastosListScreenState();
}

class _GastosListScreenState extends State<GastosListScreen> {
  String busquedaTexto = '';
  int? filtroCategoria;
  int? filtroCuenta;
  DateTime? fechaInicio;
  DateTime? fechaFin;
  double? montoMin;
  double? montoMax;

  @override
  Widget build(BuildContext context) {
    // filtrar gastos - lógica en build
    List<Map<String, dynamic>> gastosFiltrados = [];
    for (var g in gastosLista) {
      // filtro de búsqueda
      if (busquedaTexto.isNotEmpty &&
          !g['descripcion'].toString().toLowerCase().contains(
            busquedaTexto.toLowerCase(),
          )) {
        continue;
      }
      // filtro de categoría
      if (filtroCategoria != null && g['categoriaId'] != filtroCategoria) {
        continue;
      }
      // filtro de cuenta
      if (filtroCuenta != null && g['cuentaId'] != filtroCuenta) {
        continue;
      }
      // filtro de fecha
      var fechaGasto = DateTime.parse(g['fecha']);
      if (fechaInicio != null && fechaGasto.isBefore(fechaInicio!)) {
        continue;
      }
      if (fechaFin != null &&
          fechaGasto.isAfter(fechaFin!.add(Duration(days: 1)))) {
        continue;
      }
      // filtro de monto
      if (montoMin != null && g['monto'] < montoMin!) {
        continue;
      }
      if (montoMax != null && g['monto'] > montoMax!) {
        continue;
      }
      gastosFiltrados.add(g);
    }

    // ordenar por fecha - código inline
    gastosFiltrados.sort((a, b) {
      var fechaA = DateTime.parse(a['fecha']);
      var fechaB = DateTime.parse(b['fecha']);
      return fechaB.compareTo(fechaA);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Gastos'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _mostrarFiltros(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // barra de búsqueda
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar gastos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  busquedaTexto = value;
                });
              },
            ),
          ),
          // lista
          Expanded(
            child: gastosFiltrados.isEmpty
                ? Center(child: Text('No hay gastos'))
                : ListView.builder(
                    itemCount: gastosFiltrados.length,
                    itemBuilder: (context, index) {
                      var g = gastosFiltrados[index];
                      var cat = categoriasLista.firstWhere(
                        (c) => c['id'] == g['categoriaId'],
                        orElse: () => {'nombre': 'N/A', 'color': 0xFF000000},
                      );
                      var cuenta = cuentasLista.firstWhere(
                        (c) => c['id'] == g['cuentaId'],
                        orElse: () => {'nombre': 'N/A'},
                      );
                      var fecha = DateTime.parse(g['fecha']);
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(cat['color']),
                          ),
                          title: Text(g['descripcion']),
                          subtitle: Text(
                            '${cat['nombre']} • ${cuenta['nombre']} • ${fecha.day}/${fecha.month}/${fecha.year}',
                          ),
                          trailing: Text(
                            '\$${g['monto'].toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditGastoScreen(gasto: g),
                              ),
                            );
                          },
                          onLongPress: () {
                            _eliminarGasto(context, g['id']);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _mostrarFiltros(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Filtros'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // filtro categoría
                DropdownButtonFormField<int?>(
                  value: filtroCategoria,
                  decoration: InputDecoration(labelText: 'Categoría'),
                  items: [
                    DropdownMenuItem<int?>(value: null, child: Text('Todas')),
                    ...categoriasLista.map(
                      (c) => DropdownMenuItem<int?>(
                        value: c['id'] as int,
                        child: Text(c['nombre']),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      filtroCategoria = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                // filtro cuenta
                DropdownButtonFormField<int>(
                  value: filtroCuenta,
                  decoration: InputDecoration(labelText: 'Cuenta'),
                  items: [
                    DropdownMenuItem(value: null, child: Text('Todas')),
                    ...cuentasLista.map(
                      (c) => DropdownMenuItem(
                        value: c['id'],
                        child: Text(c['nombre']),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      filtroCuenta = value;
                    });
                  },
                ),
                SizedBox(height: 8),
                // filtro fecha inicio
                ListTile(
                  title: Text(
                    'Fecha Inicio: ${fechaInicio != null ? "${fechaInicio!.day}/${fechaInicio!.month}/${fechaInicio!.year}" : "Ninguna"}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    var fecha = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (fecha != null) {
                      setDialogState(() {
                        fechaInicio = fecha;
                      });
                    }
                  },
                ),
                // filtro fecha fin
                ListTile(
                  title: Text(
                    'Fecha Fin: ${fechaFin != null ? "${fechaFin!.day}/${fechaFin!.month}/${fechaFin!.year}" : "Ninguna"}',
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    var fecha = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (fecha != null) {
                      setDialogState(() {
                        fechaFin = fecha;
                      });
                    }
                  },
                ),
                SizedBox(height: 8),
                // filtro monto min
                TextField(
                  decoration: InputDecoration(labelText: 'Monto Mínimo'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setDialogState(() {
                        montoMin = double.tryParse(value);
                      });
                    } else {
                      setDialogState(() {
                        montoMin = null;
                      });
                    }
                  },
                ),
                SizedBox(height: 8),
                // filtro monto max
                TextField(
                  decoration: InputDecoration(labelText: 'Monto Máximo'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setDialogState(() {
                        montoMax = double.tryParse(value);
                      });
                    } else {
                      setDialogState(() {
                        montoMax = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  filtroCategoria = null;
                  filtroCuenta = null;
                  fechaInicio = null;
                  fechaFin = null;
                  montoMin = null;
                  montoMax = null;
                });
                setState(() {
                  filtroCategoria = null;
                  filtroCuenta = null;
                  fechaInicio = null;
                  fechaFin = null;
                  montoMin = null;
                  montoMax = null;
                });
                Navigator.pop(context);
              },
              child: Text('Limpiar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: Text('Aplicar'),
            ),
          ],
        ),
      ),
    );
  }

  void _eliminarGasto(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar'),
        content: Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              gastosLista.removeWhere((g) => g['id'] == id);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Agregar/Editar Gasto
class AddEditGastoScreen extends StatefulWidget {
  final Map<String, dynamic>? gasto;

  AddEditGastoScreen({this.gasto});

  @override
  State<AddEditGastoScreen> createState() => _AddEditGastoScreenState();
}

class _AddEditGastoScreenState extends State<AddEditGastoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController descripcionController;
  late TextEditingController montoController;
  late DateTime fechaSeleccionada;
  int? categoriaSeleccionada;
  int? cuentaSeleccionada;
  List<String> etiquetas = [];
  final etiquetaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.gasto != null) {
      descripcionController = TextEditingController(
        text: widget.gasto!['descripcion'],
      );
      montoController = TextEditingController(
        text: widget.gasto!['monto'].toString(),
      );
      fechaSeleccionada = DateTime.parse(widget.gasto!['fecha']);
      categoriaSeleccionada = widget.gasto!['categoriaId'];
      cuentaSeleccionada = widget.gasto!['cuentaId'];
      etiquetas = List<String>.from(widget.gasto!['etiquetas'] ?? []);
    } else {
      descripcionController = TextEditingController();
      montoController = TextEditingController();
      fechaSeleccionada = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null ? 'Nuevo Gasto' : 'Editar Gasto'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            // descripción
            TextFormField(
              controller: descripcionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La descripción es requerida';
                }
                if (value.length < 3) {
                  return 'Mínimo 3 caracteres';
                }
                if (value.length > 100) {
                  return 'Máximo 100 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // monto
            TextFormField(
              controller: montoController,
              decoration: InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El monto es requerido';
                }
                var monto = double.tryParse(value);
                if (monto == null) {
                  return 'Debe ser un número válido';
                }
                if (monto <= 0) {
                  return 'Debe ser mayor a 0';
                }
                if (monto > 1000000) {
                  return 'Monto muy alto';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // fecha
            ListTile(
              title: Text('Fecha'),
              subtitle: Text(
                '${fechaSeleccionada.day}/${fechaSeleccionada.month}/${fechaSeleccionada.year}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                var fecha = await showDatePicker(
                  context: context,
                  initialDate: fechaSeleccionada,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (fecha != null) {
                  setState(() {
                    fechaSeleccionada = fecha;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            // categoría
            DropdownButtonFormField<int>(
              value: categoriaSeleccionada,
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: categoriasLista
                  .map(
                    (c) => DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(c['nombre']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSeleccionada = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una categoría';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // cuenta
            DropdownButtonFormField<int>(
              value: cuentaSeleccionada,
              decoration: InputDecoration(
                labelText: 'Cuenta',
                border: OutlineInputBorder(),
              ),
              items: cuentasLista
                  .map(
                    (c) => DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(c['nombre']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  cuentaSeleccionada = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una cuenta';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            // etiquetas
            Text(
              'Etiquetas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: etiquetas
                  .map(
                    (e) => Chip(
                      label: Text(e),
                      onDeleted: () {
                        setState(() {
                          etiquetas.remove(e);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: etiquetaController,
                    decoration: InputDecoration(
                      labelText: 'Nueva etiqueta',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (etiquetaController.text.isNotEmpty) {
                      setState(() {
                        etiquetas.add(etiquetaController.text);
                        etiquetaController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            // botón guardar
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // validar fecha - código duplicado
                  if (fechaSeleccionada.isAfter(DateTime.now())) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('La fecha no puede ser futura')),
                    );
                    return;
                  }

                  var monto = double.parse(montoController.text);

                  if (widget.gasto == null) {
                    // crear nuevo
                    gastosLista.add({
                      'id': contadorId++,
                      'descripcion': descripcionController.text,
                      'monto': monto,
                      'fecha': fechaSeleccionada.toIso8601String(),
                      'categoriaId': categoriaSeleccionada,
                      'cuentaId': cuentaSeleccionada,
                      'etiquetas': etiquetas,
                    });
                  } else {
                    // actualizar
                    var index = gastosLista.indexWhere(
                      (g) => g['id'] == widget.gasto!['id'],
                    );
                    if (index != -1) {
                      gastosLista[index] = {
                        'id': widget.gasto!['id'],
                        'descripcion': descripcionController.text,
                        'monto': monto,
                        'fecha': fechaSeleccionada.toIso8601String(),
                        'categoriaId': categoriaSeleccionada,
                        'cuentaId': cuentaSeleccionada,
                        'etiquetas': etiquetas,
                      };
                    }
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    descripcionController.dispose();
    montoController.dispose();
    etiquetaController.dispose();
    super.dispose();
  }
}

// Pantalla de Categorías
class CategoriasScreen extends StatefulWidget {
  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categorías')),
      body: categoriasLista.isEmpty
          ? Center(child: Text('No hay categorías'))
          : ListView.builder(
              itemCount: categoriasLista.length,
              itemBuilder: (context, index) {
                var c = categoriasLista[index];
                // calcular gastos de esta categoría
                double totalGastos = 0;
                for (var g in gastosLista) {
                  if (g['categoriaId'] == c['id']) {
                    totalGastos += g['monto'];
                  }
                }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Color(c['color'])),
                    title: Text(c['nombre']),
                    subtitle: Text('Gastos: \$${totalGastos.toString()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditCategoriaScreen(categoria: c),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _eliminarCategoria(context, c['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _eliminarCategoria(BuildContext context, int id) {
    // verificar si hay gastos - validación inline
    var tieneGastos = gastosLista.any((g) => g['categoriaId'] == id);
    if (tieneGastos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se puede eliminar una categoría con gastos'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar'),
        content: Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              categoriasLista.removeWhere((c) => c['id'] == id);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Agregar/Editar Categoría
class AddEditCategoriaScreen extends StatefulWidget {
  final Map<String, dynamic>? categoria;

  AddEditCategoriaScreen({this.categoria});

  @override
  State<AddEditCategoriaScreen> createState() => _AddEditCategoriaScreenState();
}

class _AddEditCategoriaScreenState extends State<AddEditCategoriaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController presupuestoController;
  int colorSeleccionado = 0xFF4CAF50;
  String iconoSeleccionado = 'category';

  final List<int> colores = [
    0xFF4CAF50,
    0xFF2196F3,
    0xFF9C27B0,
    0xFFFF9800,
    0xFFF44336,
    0xFF00BCD4,
    0xFFE91E63,
    0xFF795548,
  ];
  final List<String> iconos = [
    'restaurant',
    'directions_car',
    'movie',
    'shopping_cart',
    'home',
    'fitness_center',
    'local_hospital',
    'school',
    'work',
    'category',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      nombreController = TextEditingController(
        text: widget.categoria!['nombre'],
      );
      presupuestoController = TextEditingController(
        text: widget.categoria!['presupuesto'].toString(),
      );
      colorSeleccionado = widget.categoria!['color'];
      iconoSeleccionado = widget.categoria!['icono'];
    } else {
      nombreController = TextEditingController();
      presupuestoController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoria == null ? 'Nueva Categoría' : 'Editar Categoría',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                if (value.length < 2) {
                  return 'Mínimo 2 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: presupuestoController,
              decoration: InputDecoration(
                labelText: 'Presupuesto Mensual',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El presupuesto es requerido';
                }
                var presu = double.tryParse(value);
                if (presu == null || presu < 0) {
                  return 'Debe ser un número válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text(
              'Color',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: colores
                  .map(
                    (c) => GestureDetector(
                      onTap: () {
                        setState(() {
                          colorSeleccionado = c;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(c),
                          border: Border.all(
                            color: c == colorSeleccionado
                                ? Colors.black
                                : Colors.transparent,
                            width: 3,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Icono',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: iconos
                  .map(
                    (i) => GestureDetector(
                      onTap: () {
                        setState(() {
                          iconoSeleccionado = i;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: i == iconoSeleccionado
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _getIconForName(i),
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var presu = double.parse(presupuestoController.text);

                  if (widget.categoria == null) {
                    categoriasLista.add({
                      'id': contadorIdCat++,
                      'nombre': nombreController.text,
                      'color': colorSeleccionado,
                      'icono': iconoSeleccionado,
                      'presupuesto': presu,
                    });
                  } else {
                    var index = categoriasLista.indexWhere(
                      (c) => c['id'] == widget.categoria!['id'],
                    );
                    if (index != -1) {
                      categoriasLista[index] = {
                        'id': widget.categoria!['id'],
                        'nombre': nombreController.text,
                        'color': colorSeleccionado,
                        'icono': iconoSeleccionado,
                        'presupuesto': presu,
                      };
                    }
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Icon _getIconForName(String name) {
    // función helper
    switch (name) {
      case 'restaurant':
        return Icon(Icons.restaurant);
      case 'directions_car':
        return Icon(Icons.directions_car);
      case 'movie':
        return Icon(Icons.movie);
      case 'shopping_cart':
        return Icon(Icons.shopping_cart);
      case 'home':
        return Icon(Icons.home);
      case 'fitness_center':
        return Icon(Icons.fitness_center);
      case 'local_hospital':
        return Icon(Icons.local_hospital);
      case 'school':
        return Icon(Icons.school);
      case 'work':
        return Icon(Icons.work);
      default:
        return Icon(Icons.category);
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    presupuestoController.dispose();
    super.dispose();
  }
}

// Pantalla de Cuentas
class CuentasScreen extends StatefulWidget {
  @override
  State<CuentasScreen> createState() => _CuentasScreenState();
}

class _CuentasScreenState extends State<CuentasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cuentas')),
      body: cuentasLista.isEmpty
          ? Center(child: Text('No hay cuentas'))
          : ListView.builder(
              itemCount: cuentasLista.length,
              itemBuilder: (context, index) {
                var c = cuentasLista[index];
                // calcular saldo actual - código duplicado
                double saldoActual = c['saldo'];
                for (var g in gastosLista) {
                  if (g['cuentaId'] == c['id']) {
                    saldoActual -= g['monto'];
                  }
                }
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.account_balance_wallet),
                    ),
                    title: Text(c['nombre']),
                    subtitle: Text(
                      '${c['tipo']} • Saldo: \$${saldoActual.toString()}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditCuentaScreen(cuenta: c),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _eliminarCuenta(context, c['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _eliminarCuenta(BuildContext context, int id) {
    var tieneGastos = gastosLista.any((g) => g['cuentaId'] == id);
    if (tieneGastos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se puede eliminar una cuenta con gastos')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar'),
        content: Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              cuentasLista.removeWhere((c) => c['id'] == id);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Agregar/Editar Cuenta
class AddEditCuentaScreen extends StatefulWidget {
  final Map<String, dynamic>? cuenta;

  AddEditCuentaScreen({this.cuenta});

  @override
  State<AddEditCuentaScreen> createState() => _AddEditCuentaScreenState();
}

class _AddEditCuentaScreenState extends State<AddEditCuentaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController saldoController;
  String tipoSeleccionado = 'efectivo';

  @override
  void initState() {
    super.initState();
    if (widget.cuenta != null) {
      nombreController = TextEditingController(text: widget.cuenta!['nombre']);
      saldoController = TextEditingController(
        text: widget.cuenta!['saldo'].toString(),
      );
      tipoSeleccionado = widget.cuenta!['tipo'];
    } else {
      nombreController = TextEditingController();
      saldoController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cuenta == null ? 'Nueva Cuenta' : 'Editar Cuenta'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: tipoSeleccionado,
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              items: ['efectivo', 'tarjeta', 'banco']
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  tipoSeleccionado = value!;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: saldoController,
              decoration: InputDecoration(
                labelText: 'Saldo Inicial',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El saldo es requerido';
                }
                var saldo = double.tryParse(value);
                if (saldo == null) {
                  return 'Debe ser un número válido';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var saldo = double.parse(saldoController.text);

                  if (widget.cuenta == null) {
                    cuentasLista.add({
                      'id': contadorIdCuenta++,
                      'nombre': nombreController.text,
                      'tipo': tipoSeleccionado,
                      'saldo': saldo,
                    });
                  } else {
                    var index = cuentasLista.indexWhere(
                      (c) => c['id'] == widget.cuenta!['id'],
                    );
                    if (index != -1) {
                      cuentasLista[index] = {
                        'id': widget.cuenta!['id'],
                        'nombre': nombreController.text,
                        'tipo': tipoSeleccionado,
                        'saldo': saldo,
                      };
                    }
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    saldoController.dispose();
    super.dispose();
  }
}

// Pantalla de Presupuestos
class PresupuestosScreen extends StatefulWidget {
  @override
  State<PresupuestosScreen> createState() => _PresupuestosScreenState();
}

class _PresupuestosScreenState extends State<PresupuestosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Presupuestos')),
      body: presupuestosLista.isEmpty
          ? Center(child: Text('No hay presupuestos'))
          : ListView.builder(
              itemCount: presupuestosLista.length,
              itemBuilder: (context, index) {
                var p = presupuestosLista[index];
                var cat = categoriasLista.firstWhere(
                  (c) => c['id'] == p['categoriaId'],
                  orElse: () => {'nombre': 'N/A'},
                );
                // calcular gasto actual
                double gastoActual = 0;
                var ahora = DateTime.now();
                var inicioMes = DateTime(ahora.year, ahora.month, 1);
                var finMes = DateTime(ahora.year, ahora.month + 1, 0);
                for (var g in gastosLista) {
                  if (g['categoriaId'] == p['categoriaId']) {
                    var fechaGasto = DateTime.parse(g['fecha']);
                    if (fechaGasto.isAfter(
                          inicioMes.subtract(Duration(days: 1)),
                        ) &&
                        fechaGasto.isBefore(finMes.add(Duration(days: 1)))) {
                      gastoActual += g['monto'];
                    }
                  }
                }
                var porcentaje = p['monto'] > 0
                    ? (gastoActual / p['monto'] * 100)
                    : 0;
                var excedido = gastoActual > p['monto'];
                return Card(
                  color: excedido ? Colors.red.shade50 : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: excedido ? Colors.red : Colors.green,
                    ),
                    title: Text(cat['nombre']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Presupuesto: \$${p['monto'].toString()}'),
                        Text(
                          'Gastado: \$${gastoActual.toString()} (${porcentaje.toString()}%)',
                        ),
                        LinearProgressIndicator(
                          value: porcentaje > 100 ? 1.0 : porcentaje / 100,
                          color: excedido ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditPresupuestoScreen(presupuesto: p),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _eliminarPresupuesto(context, p['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _eliminarPresupuesto(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar'),
        content: Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              presupuestosLista.removeWhere((p) => p['id'] == id);
              setState(() {});
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// Agregar/Editar Presupuesto
class AddEditPresupuestoScreen extends StatefulWidget {
  final Map<String, dynamic>? presupuesto;

  AddEditPresupuestoScreen({this.presupuesto});

  @override
  State<AddEditPresupuestoScreen> createState() =>
      _AddEditPresupuestoScreenState();
}

class _AddEditPresupuestoScreenState extends State<AddEditPresupuestoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController montoController;
  int? categoriaSeleccionada;
  String periodoSeleccionado = 'mensual';

  @override
  void initState() {
    super.initState();
    if (widget.presupuesto != null) {
      montoController = TextEditingController(
        text: widget.presupuesto!['monto'].toString(),
      );
      categoriaSeleccionada = widget.presupuesto!['categoriaId'];
      periodoSeleccionado = widget.presupuesto!['periodo'] ?? 'mensual';
    } else {
      montoController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.presupuesto == null
              ? 'Nuevo Presupuesto'
              : 'Editar Presupuesto',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              value: categoriaSeleccionada,
              decoration: InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
              items: categoriasLista
                  .map(
                    (c) => DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(c['nombre']),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoriaSeleccionada = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecciona una categoría';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: montoController,
              decoration: InputDecoration(
                labelText: 'Monto',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El monto es requerido';
                }
                var monto = double.tryParse(value);
                if (monto == null || monto <= 0) {
                  return 'Debe ser un número mayor a 0';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: periodoSeleccionado,
              decoration: InputDecoration(
                labelText: 'Período',
                border: OutlineInputBorder(),
              ),
              items: ['mensual', 'anual']
                  .map(
                    (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Text(p.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  periodoSeleccionado = value!;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var monto = double.parse(montoController.text);

                  if (widget.presupuesto == null) {
                    presupuestosLista.add({
                      'id': contadorIdPresu++,
                      'categoriaId': categoriaSeleccionada,
                      'monto': monto,
                      'periodo': periodoSeleccionado,
                    });
                  } else {
                    var index = presupuestosLista.indexWhere(
                      (p) => p['id'] == widget.presupuesto!['id'],
                    );
                    if (index != -1) {
                      presupuestosLista[index] = {
                        'id': widget.presupuesto!['id'],
                        'categoriaId': categoriaSeleccionada,
                        'monto': monto,
                        'periodo': periodoSeleccionado,
                      };
                    }
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    montoController.dispose();
    super.dispose();
  }
}
