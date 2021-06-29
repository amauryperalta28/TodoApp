import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/models/task_model.dart';
import 'package:todo_app/src/pages/theme.dart';
import 'package:todo_app/src/providers/task_provider.dart';

class CreateTaskPage extends StatefulWidget {
  static String routeName = 'create-task';

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Task task = new Task();
  TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Agregar tarea'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              TextFormField(
                  decoration: InputDecoration(hintText: 'Titulo'),
                  onSaved: (value) {
                    task.title = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) return 'El titulo es requerido';

                    return null;
                  }),
              TextFormField(
                decoration: InputDecoration(hintText: 'Descripción'),
                onSaved: (value) {
                  task.description = value;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Text('Agregar'),
                  color: TodoAppColors.primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _onSubmit();
                  })
            ],
          ),
        ),
      ),
    );
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Guardar tasks en provider
      await taskProvider.saveTaskOnFireBase(task);

      SnackBar snackBar = new SnackBar(content: Text('La tarea fue creada correctamente'));

      _scaffoldKey.currentState.showSnackBar(snackBar);
      
      Navigator.of(context).pop();
    }
  }
}
