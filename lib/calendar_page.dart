import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytask/custom_slidable.dart';
import 'package:provider/provider.dart';

import 'network/task_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        // taskService로 부터 taskList 가져오기
        List<Task> taskList = taskService.taskList;
        bool isChecked = false;
        DateTime now = DateTime.now();
        List<Task> notTodayList = taskList
            .where((e) =>
                DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day)
                    .isAfter(DateTime(now.year, now.month, now.day)) &&
                e.isDeleted == false)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Calendar'),
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            centerTitle: true,
          ),
          body: notTodayList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.separated(
                  itemCount: notTodayList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = notTodayList[index]; // index에 해당하는 task 가져오기
                    isChecked = task.isChecked;
                    return CustomSlidable(
                      taskList: taskList,
                      task: task,
                      isChecked: isChecked,
                      trailingIcon: false,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                      height: 0,
                      indent: 0,
                      endIndent: 0,
                    );
                  },
                ),
        );
      },
    );
  }
}
