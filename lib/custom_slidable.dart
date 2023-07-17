import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mytask/network/task_service.dart';
import 'package:mytask/todo_list.dart';
import 'package:provider/provider.dart';

class CustomSlidable extends StatelessWidget {
  const CustomSlidable({
    super.key,
    required this.taskList,
    required this.task,
    required this.isChecked,
    required this.trailingIcon,
  });

  final List<Task> taskList;
  final Task task;
  final bool isChecked;
  final bool trailingIcon;

  //get taskService => TaskService();
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(builder: (context, taskService, child) {
      return Slidable(
        key: UniqueKey(), // 트리에서 삭제 문제 해결
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              //onPressed:
              onPressed: (context) {
                taskService.updatePinTask(index: taskList.indexOf(task));
              },
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.push_pin,
            ),
          ],
        ),
        endActionPane: ActionPane(
          // swipe from right to left
          motion: ScrollMotion(),
          children: [
            SlidableAction(
                autoClose: false,
                flex: 2,
                onPressed: (context) {
                  taskService.updateDeleteTask(index: taskList.indexOf(task));
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete'),
          ],
        ),
        child: ToDoTile(
          isChecked: isChecked,
          task: task,
          taskList: taskList,
          trailingIcon: trailingIcon,
        ),
      );
    });
  }
}
