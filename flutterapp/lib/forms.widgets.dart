import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Formulario extends StatefulWidget {
  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Text('Formulario'),
          TextFormField(
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Correo Electrónico'),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Género'),
            items: ['Masculino', 'Femenino', 'Prefiero no decirlo', 'Otro']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              // Actualiza el valor seleccionado
            },
          ),
          CheckboxListTile(
            title: Text('Acepto los términos y condiciones'),
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value!;
              });
            },
          ),
          ElevatedButton(
            onPressed: _isChecked
                ? () {
                    // Mostrar SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        // Contenido del SnackBar
                        content: Text('Formulario enviado con éxito'),
                        // Color del snackbar
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                : null, // Deshabilita el botón si _isChecked es false
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class CampoFormulario extends StatefulWidget {
  @override
  CampoFormularioState createState() => CampoFormularioState();
}

class CampoFormularioState extends State<CampoFormulario> {
  Color _textColor = Colors.black;
  Color _shadowColor = Colors.grey;

  void _selectTextColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un color de texto'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (Color color) {
                setState(() {
                  _textColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _selectShadowColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona un color de sombreado'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _shadowColor,
              onColorChanged: (Color color) {
                setState(() {
                  _shadowColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> estado) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Campo de Formulario',
              style: TextStyle(color: _textColor, shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: _shadowColor,
                ),
              ]),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Campo Personalizado',
                errorText: estado.hasError ? estado.errorText : null,
              ),
              onChanged: (valor) {
                estado.didChange(valor);
              },
            ),
            if (estado.hasError)
              Text(
                estado.errorText ?? '',
                style: TextStyle(color: const Color.fromARGB(255, 67, 54, 244)),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectTextColor,
              child: Text('Selecciona un color de texto'),
            ),
            ElevatedButton(
              onPressed: _selectShadowColor,
              child: Text('Selecciona un color de sombreado'),
            ),
          ],
        );
      },
      validator: (valor) {
        if (valor == null || valor.isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }
}

class MiAutocompletar extends StatefulWidget {
  @override
  MiAutocompletarState createState() => MiAutocompletarState();
}

class MiAutocompletarState extends State<MiAutocompletar> {
  final List<String> _opciones1 = [
    'Flutter',
    'Dart',
    'React',
    'Vue',
    'Angular',
  ];

  final List<String> _opciones2 = [
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C#',
  ];

  final List<String> _opciones3 = [
    'C++',
    'Ruby',
    'Swift',
    'Kotlin',
    'PHP',
  ];

  List<String> _opciones = [];
  List<String> _selectedOptions = [];
  bool _useAutocomplete = true;
  int _selectedSegment = 0;

  @override
  void initState() {
    super.initState();
    _opciones = _opciones1;
  }

  void _addNewOption(String newOption) {
    setState(() {
      _opciones.add(newOption);
    });
  }

  void _showAddOptionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newOption = '';
        return AlertDialog(
          title: Text('Agregar nueva opción'),
          content: TextField(
            onChanged: (value) {
              newOption = value;
            },
            decoration: InputDecoration(hintText: 'Nueva opción'),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Agregar'),
              onPressed: () {
                if (newOption.isNotEmpty) {
                  _addNewOption(newOption);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSegmentChanged(int index) {
    setState(() {
      _selectedSegment = index;
      switch (index) {
        case 0:
          _opciones = _opciones1;
          break;
        case 1:
          _opciones = _opciones2;
          break;
        case 2:
          _opciones = _opciones3;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SingleChildScrollView(
        child:
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<bool>(
                value: true,
                groupValue: _useAutocomplete,
                onChanged: (bool? value) {
                  setState(() {
                    _useAutocomplete = value!;
                  });
                },
              ),
              Text('Usar Autocompletar'),
              Radio<bool>(
                value: false,
                groupValue: _useAutocomplete,
                onChanged: (bool? value) {
                  setState(() {
                    _useAutocomplete = value!;
                  });
                },
              ),
              Text('No usar Autocompletar'),
            ],
          ),
          if (_useAutocomplete)
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue valorTexto) {
                if (valorTexto.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _opciones.where((String opcion) {
                  return opcion.contains(valorTexto.text.toLowerCase());
                });
              },
              onSelected: (String seleccion) {
                setState(() {
                  if (!_selectedOptions.contains(seleccion)) {
                    _selectedOptions.add(seleccion);
                  }
                });
              },
            ),
          SizedBox(height: 20),
          SegmentedButton(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text('Lista 1'),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Lista 2'),
              ),
              ButtonSegment(
                value: 2,
                label: Text('Lista 3'),
              ),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (Set<int> newSelection) { 
              _onSegmentChanged(newSelection.first);
            },
          ),
          SizedBox(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 2.0,
                children: _opciones.map((String opcion) {
                  return Draggable<String>(
                    data: opcion,
                    feedback: Material(
                      child: Chip(
                        label: Text(opcion),
                      ),
                    ),
                    childWhenDragging: Container(),
                    child: FilterChip(
                      label: Text(opcion),
                      selected: _selectedOptions.contains(opcion),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedOptions.add(opcion);
                          } else {
                            _selectedOptions.remove(opcion);
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Seleccionados:'),
          SizedBox(
            height: 300,
            child: SingleChildScrollView(
              child: DragTarget<String>(
                onAcceptWithDetails: (DragTargetDetails<String> details) {
                  setState(() {
                    if (!_selectedOptions.contains(details.data)) {
                      _selectedOptions.add(details.data);
                    }
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Wrap(
                    spacing: 8.0,
                    children: _selectedOptions.map((String opcion) {
                      return Chip(
                        label: Text(opcion),
                        onDeleted: () {
                          setState(() {
                            _selectedOptions.remove(opcion);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptionDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}

class GridViewWidget extends StatefulWidget {
  @override
  GridViewWidgetState createState() => GridViewWidgetState();
}

class GridViewWidgetState extends State<GridViewWidget> {
  double _tamanoTarjeta = 345.0;
  String _layout = 'Grid';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cambiar Layout'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              setState(() {
                _layout = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Grid',
                child: Text('Grid'),
              ),
              const PopupMenuItem<String>(
                value: 'List',
                child: Text('List'),
              ),
              const PopupMenuItem<String>(
                value: 'Staggered',
                child: Text('Staggered'),
              ),
              const PopupMenuItem<String>(
                value: 'Masonry',
                child: Text('Masonry'),
              ),
              const PopupMenuItem<String>(
                value: 'Carousel',
                child: Text('Carousel'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Slider(
            value: _tamanoTarjeta,
            min: 345,
            max: 500,
            divisions: 20,
            label: _tamanoTarjeta.round().toString(),
            onChanged: (double valor) {
              setState(() {
                _tamanoTarjeta = valor;
              });
            },
          ),
          Expanded(
            child: _buildLayout(),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout() {
    switch (_layout) {
      case 'Grid':
        return GridView.count(
          crossAxisCount: 2,
          children: _buildChildren(),
        );
      case 'List':
        return ListView(
          children: _buildChildren(),
        );
      case 'Staggered':
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.75,
          children: _buildChildren(),
        );
      case 'Masonry':
        return GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 1.5,
          children: _buildChildren(),
        );
      case 'Carousel':
        return PageView(
          children: _buildChildren(),
        );
      default:
        return GridView.count(
          crossAxisCount: 2,
          children: _buildChildren(),
        );
    }
  }

  List<Widget> _buildChildren() {
    return [
      Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: SizedBox(
            width: _tamanoTarjeta,
            height: _tamanoTarjeta,
            child: Formulario(),
          ),
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: SizedBox(
            width: _tamanoTarjeta,
            height: _tamanoTarjeta,
            child: CampoFormulario(),
          ),
        ),
      ),
      Material(
        color: const Color.fromARGB(137, 63, 43, 177),
        borderRadius: BorderRadius.circular(8.0),
        child: Center(
          child: SizedBox(
            width: _tamanoTarjeta,
            height: _tamanoTarjeta,
            child: MiAutocompletar(),
          ),
        ),
      ),
    ];
  }
}
