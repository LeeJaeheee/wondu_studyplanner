import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytask/todo_list.dart';
import 'package:mytask/network/task_service.dart';
import 'package:provider/provider.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({
    super.key,
  });

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  TextEditingController searchController = TextEditingController();
  String search = '';
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        List<Task> taskList = taskService.taskList;
        List<Task> searchList =
            taskList.where((e) => e.isDeleted == false).toList();
        bool isChecked = false;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: searchController
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length)),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.text = '';
                    },
                    icon: Icon(Icons.clear),
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onEditingComplete: () {
                  setState(
                    () {
                      search = searchController.text;
                    },
                  );
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
          // fix: 변경된 레이아웃으로 수정
          body: searchList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.separated(
                  itemCount: searchList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = searchList[index]; // index에 해당하는 task 가져오기
                    isChecked = task.isChecked;
                    if (search != '' && !task.content.contains(search)) {
                      return SizedBox();
                    }
                    return ToDoTile(
                      isChecked: isChecked,
                      task: task,
                      taskList: taskList,
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
