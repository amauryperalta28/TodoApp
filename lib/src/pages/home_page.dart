import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import 'package:todo_app/src/models/task_model.dart';
import 'package:todo_app/src/pages/create_task_page.dart';
import 'package:todo_app/src/pages/theme.dart';
import 'package:todo_app/src/providers/task_provider.dart';
import 'package:todo_app/src/widgets/task_tile_widget.dart';

class HomePage extends StatefulWidget {
  static String routeName = '';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDone = false;
  TaskProvider taskProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskProvider = Provider.of<TaskProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Application'),
        elevation: 0.0,
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CreateTaskPage.routeName);
        },
        backgroundColor: TodoAppColors.primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(color: TodoAppColors.primaryColor),
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      DigitalClock(
                        showSecondsDigit: false,
                        digitAnimationStyle: Curves.elasticOut,
                        is24HourTimeFormat: false,
                        areaDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        hourMinuteDigitTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                        ),
                        amPmDigitTextStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(20))),
            child: FutureBuilder(
              future: taskProvider.getTasksFromFireBase(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Hubo un error cargando las tareas',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final tasks = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(left: 25.0, top: 10.0),
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, i) => Dismissible(
                      background: Container(
                        decoration: BoxDecoration(color: Colors.red),
                      ),
                      key: UniqueKey(),
                      onDismissed: (DismissDirection direction) async {
                        var direc = direction.index;

                        await taskProvider.deleteTaskOnFireBase(tasks[i].id);
                      },
                      child: TaskTile(
                          task: tasks[i],
                          onChanged: (value) async {
                            await taskProvider.updateTaskOnFireBase(tasks[i]);
                          }),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer();
  }
}
