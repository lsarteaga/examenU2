import 'package:examenu2/models/person_model.dart';
import 'package:examenu2/providers/vulnerability_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<VulnerabilityProvider>(
        create: (_) => VulnerabilityProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContentProvider>(
        create: (BuildContext context) => ContentProvider(),
        child: Consumer<ContentProvider>(builder: (context, provider, __) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: MyHomePage(),
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dateController = TextEditingController();
  PersonModel _person = new PersonModel();
  final formKey = GlobalKey<FormState>();
  bool isSwitched = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column<Widget>[
          Text('Registro',),
          Container(
                        margin: EdgeInsets.all(14.0),
                        child: Form(
                            key: formKey,
                            child: Column(children: [
                              _getFieldCard(),
                              _getFieldSurname(),
                              _getFieldCard(),
                              _getFieldDate(),
                              _getFieldDiscapacity(),
                              _getSubmitButton()
                            ]))),
        ],
      ),
    );
  }
  Widget _getFieldName() {
    return TextFormField(
      initialValue: "",
      decoration: InputDecoration(labelText: "Nombre"),
      maxLength: 50,
      onSaved: (value) {
        //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
        _person.name = value;
      },
      validator: (value) {
        if (value.length < 5) {
          return "Debe ingresar un nombre con al menos 5 caracteres";
        } else {
          return null; //Validación se cumple al retorna null
        }
      },
    );
  }
   Widget _getFieldSurname() {
    return TextFormField(
      initialValue: "",
      decoration: InputDecoration(labelText: "Apellido"),
      maxLength: 50,
      onSaved: (value) {
        //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
        _person.surname = value;
      },
      validator: (value) {
        if (value.length < 5) {
          return "Debe ingresar un apellido con al menos 5 caracteres";
        } else {
          return null; //Validación se cumple al retorna null
        }
      },
    );
  }
   Widget _getFieldCard() {
    return TextFormField(
      initialValue: "",
      decoration: InputDecoration(labelText: "Cedula"),
      maxLength: 10,
      onSaved: (value) {
        //Este evento se ejecuta cuando se cumple la validación y cambia el estado del Form
        _person.cardId = value;
      },
      validator: (value) {
        if (value.length < 10) {
          return "Debe ingresar una cedula";
        } else {
          return null; //Validación se cumple al retorna null
        }
      },
    );
  }
  Widget _getFieldDate() {
    return TextField(
      readOnly: true,
      controller: dateController,
      decoration: InputDecoration(hintText: "Escoja su fecha de nacimiento"),
      onTap: () async {
        var date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2021)
        );
        dateController.text = date.toString().substring(0,10);
        if (dateController.text.isNotEmpty) {
          _person.birthDate = dateController.text;
        }
      },
    );
  }
  Widget _getFieldDiscapacity() {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
                  isSwitched = value;
                  if (isSwitched) {
                    _person.discapacity = 'Si';
                  } else {
                    _person.discapacity = 'No';
                  }
                });
      },
      activeColor: Colors.green,
      activeTrackColor: Colors.lightGreenAccent,
    );
  }
  Widget _getSubmitButton() {
    return Container(
        color: Theme.of(context).buttonColor,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  if (!formKey.currentState.validate()) return;

                  //Vincula el valor de las controles del formulario a los atributos del modelo
                  formKey.currentState.save();

                  //Llamamos al provider para guardar el viaje
                  final vulnerabilityProvider =
                      Provider.of<VulnerabilityProvider>(context, listen: false);
                  _person = await vulnerabilityProvider.addPerson(
                    _person.cardId, 
                    _person.name, _person.surname, 
                    _person.birthDate, _person.discapacity
                  );
                  print(_person);
                })
          ],
        ));
  }
}

 