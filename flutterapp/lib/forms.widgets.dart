import 'package:flutter/material.dart';

class Formulario extends StatelessWidget {
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
          ElevatedButton(
            onPressed: () {
              // Mostrar SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // Contenido del SnackBar
                  content: Text('Formulario enviado con éxito'),
                  // Color del snackbar
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

class CampoFormulario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> estado) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Campo de Formulario'),
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

class MiAutocompletar extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue valorTexto) {
        if (valorTexto.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _opciones.where((String opcion) {
          return opcion.contains(valorTexto.text.toLowerCase());
        });
      },
      onSelected: (String seleccion) {
        print('Seleccionado: $seleccion');
      },
    );
  }
}

class GridViewWidget extends StatefulWidget {
  @override
  _GridViewWidget createState() => _GridViewWidget();
}

class _GridViewWidget extends State<GridViewWidget> {
  double _tamanoTarjeta = 150.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _tamanoTarjeta,
          min: 150,
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
          child: GridView.count(
            crossAxisCount: 2,
            children: [
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
            ],
          ),
        ),
      ],
    );
  }
}