import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytask/network/task_service.dart';
import 'package:provider/provider.dart';

import 'view/detail_page.dart';

class ToDoTile extends StatelessWidget {
  ToDoTile({
    super.key,
    required this.isChecked,
    required this.task,
    required this.taskList,
    required this.trailingIcon,
  });

  bool isChecked;
  final Task task;
  final List<Task> taskList;
  final bool trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(builder: (context, taskService, child) {
      return ListTile(
        tileColor: isChecked ? const Color.fromARGB(255, 198, 198, 198) : null,
        leading: Checkbox(
          value: isChecked,
          onChanged: (value) {
            isChecked = value!;
            taskService.updateCheckTask(index: taskList.indexOf(task));
          },
          activeColor: Colors.grey,
          checkColor: Colors.black,
        ),
        // 메모 내용 (최대 3줄까지만 보여주도록)
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: task.content, style: TextStyle(color: Colors.black)),
              if (task.isPinned) WidgetSpan(child: Text(' ')),
              if (task.isPinned)
                WidgetSpan(
                  child: Icon(CupertinoIcons.pin_fill, size: 14),
                ),
            ],
          ),
        ),

        trailing: trailingIcon
            ? Icon(Icons.navigate_next)
            : Text(
                DateFormat('yy/MM/dd').format(task.dueDate),
              ),

        onTap: () async {
          // 아이템 클릭시
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                index: taskList.indexOf(task),
              ),
            ),
          );
          if (task.content.isEmpty) {
            taskService.deleteTask(index: taskList.indexOf(task));
          }
        },
      );
    });
  }
}
