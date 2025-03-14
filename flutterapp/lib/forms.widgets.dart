import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
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
  _CampoFormularioState createState() => _CampoFormularioState();
}

class _CampoFormularioState extends State<CampoFormulario> {
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
  _MiAutocompletarState createState() => _MiAutocompletarState();
}

class _MiAutocompletarState extends State<MiAutocompletar> {
  final List<String> _opciones = [
    'Flutter',
    'Dart',
    'React',
    'Vue',
    'Angular',
    'JavaScript',
    'TypeScript',
    'Python',
    'Java',
    'C#',
    'C++',
    'Ruby',
    'Swift',
    'Kotlin',
    'PHP',
    'HTML',
    'CSS',
    'SQL',
    'NoSQL',
    'GraphQL',
    'REST',
    'SOAP',
    'JSON',
    'XML',
    'YAML',
    'Docker',
    'Kubernetes',
    'AWS',
    'Azure',
    'GCP',
    'Firebase',
    'MongoDB',
    'PostgreSQL',
    'MySQL',
    'SQLite',
    'Redis',
    'Elasticsearch',
    'Linux',
    'Windows',
    'MacOS',
    'Android',
    'iOS',
    'Git',
    'GitHub',
    'GitLab',
    'Bitbucket',
    'CI/CD',
    'Jenkins',
    'Travis CI',
    'CircleCI',
    'Ansible',
    'Terraform',
    'Puppet',
    'Chef',
    'Nagios',
    'Prometheus',
    'Grafana',
    'Splunk',
    'New Relic',
    'Sentry',
    'DataDog',
    'Logstash',
    'Kibana',
    'Hadoop',
    'Spark',
    'Kafka',
    'RabbitMQ',
    'ActiveMQ',
    'Zookeeper',
    'Nginx',
    'Apache',
    'Tomcat',
    'Jetty',
    'Spring',
    'Hibernate',
    'JPA',
    'EJB',
    'JSF',
    'PrimeFaces',
    'Thymeleaf',
    'JSP',
    'Servlets',
    'Struts',
    'Grails',
    'Play',
    'Micronaut',
    'Quarkus',
    'Vert.x',
    'Dropwizard',
    'Lagom',
    'Akka',
    'Scala',
    'Groovy',
    'Clojure',
    'Elixir',
    'Erlang',
    'Haskell',
    'F#',
    'OCaml',
    'Rust',
    'Go',
    'Perl',
    'Lua',
    'R',
    'MATLAB',
    'Octave',
    'SAS',
    'SPSS',
    'Stata',
    'Julia',
    'Fortran',
    'COBOL',
    'Pascal',
    'Ada',
    'VHDL',
    'Verilog',
    'Assembly',
    'Shell',
    'Bash'
  ];

  List<String> _selectedOptions = [];
  bool _useAutocomplete = true;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          height: 200, // Limita la altura del contenedor
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
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
        DragTarget<String>(
          onAccept: (data) {
            setState(() {
              if (!_selectedOptions.contains(data)) {
                _selectedOptions.add(data);
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
      ],
    );
  }
}

class GridViewWidget extends StatefulWidget {
  @override
  _GridViewWidget createState() => _GridViewWidget();
}

class _GridViewWidget extends State<GridViewWidget> {
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
          children: _buildChildren(),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.75,
        );
      case 'Masonry':
        return GridView.count(
          crossAxisCount: 2,
          children: _buildChildren(),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 1.5,
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
          child: Container(
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
          child: Container(
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
          child: Container(
            width: _tamanoTarjeta,
            height: _tamanoTarjeta,
            child: MiAutocompletar(),
          ),
        ),
      ),
    ];
  }
}
