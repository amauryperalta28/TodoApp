import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/src/pages/create_task_page.dart';
import 'package:todo_app/src/pages/home_page.dart';
import 'package:todo_app/src/pages/theme.dart';
import 'package:todo_app/src/providers/task_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(),
          CreateTaskPage.routeName: (context) => CreateTaskPage(),
        },
        theme: ThemeData(primaryColor: TodoAppColors.primaryColor),
      ),
    );
  }
}
