import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytask/search/search_task.dart';
import 'package:mytask/view/add_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_drawer.dart';
import 'custom_slidable.dart';
import 'network/task_service.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(159, 255, 158, 190),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String accountName;
  late String accountEmail;

  @override
  void initState() {
    super.initState();
    accountName = prefs.getString('accountName') ?? '원두네';
    accountEmail = prefs.getString('accountEmail') ?? 'wondu@gmail.com';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        // taskService로 부터 taskList 가져오기
        List<Task> taskList = taskService.taskList;
        bool isChecked = false;
        DateTime now = DateTime.now();
        List<Task> todayList = taskList
            .where((e) =>
                DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day) ==
                    DateTime(now.year, now.month, now.day) &&
                e.isDeleted == false)
            .toList();
        List<Task> expired = taskList
            .where((e) =>
                DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day)
                    .isBefore(DateTime(now.year, now.month, now.day)) &&
                e.isDeleted == false)
            .toList();
        for (Task t in expired) {
          taskService.updateDeleteTask(index: taskList.indexOf(t));
        }
        return Scaffold(
          drawer: CustomDrawer(
              accountName: accountName, accountEmail: accountEmail),
          appBar: AppBar(
            title: Image.asset(
              'images/wondu_appbar_image.png',
              width: 150,
            ),
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SearchTask())),
                  icon: Icon(Icons.search)),
            ],
          ),
          body: todayList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.separated(
                  itemCount: todayList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = todayList[index]; // index에 해당하는 task 가져오기
                    isChecked = task.isChecked;
                    return CustomSlidable(
                      taskList: taskList,
                      task: task,
                      isChecked: isChecked,
                      trailingIcon: true,
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPage(
                    index: taskService.taskList.length - 1,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
