import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task_model.dart';
import 'package:todo_app/src/pages/theme.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final ValueChanged<bool> onChanged;

  const TaskTile({@required this.task, this.onChanged});

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        setState(() => widget.task.completed = !widget.task.completed);
        this.widget.onChanged(widget.task.completed);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.5,
            child: ListTile(
              title: Text(
                widget.task.title,
                style: getLineThroughtCompletedTaskStyle(widget.task.completed),
              ),
              subtitle: Text(
                widget.task.description,
                style: getLineThroughtCompletedTaskStyle(widget.task.completed),
              ),
            ),
          ),
          Checkbox(
            activeColor: TodoAppColors.primaryColor,
            value: widget.task.completed,
            onChanged: (value) {
              setState(() => widget.task.completed = value);
              this.widget.onChanged(value);
            },
          )
        ],
      ),
    );
  }

  TextStyle getLineThroughtCompletedTaskStyle(bool completed) {
    return completed
        ? TextStyle(decoration: TextDecoration.lineThrough)
        : TextStyle(decoration: TextDecoration.none);
  }
}
