import 'package:flutter/material.dart';
import 'package:mytask/calendar_page.dart';
import 'package:mytask/settings.dart';
import 'package:mytask/trash_can.dart';

import 'category_list.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
    required this.accountName,
    required this.accountEmail,
  });

  final String accountName;
  final String accountEmail;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/wondu.jpeg'),
            ),
            accountName: Text(accountName),
            accountEmail: Text(accountEmail),
            decoration: BoxDecoration(
              color: Color.fromARGB(159, 242, 170, 255),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: Text('홈'),
            onTap: () {
              Navigator.pop(context);
            },
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: Text('캘린더'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarPage(),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.category),
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: Text('카테고리'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoryTasksScreen()),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.restore_from_trash),
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: Text('휴지통'),
            onTap: () async {
              // 아이템 클릭시
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrashCanPage(),
                ),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            iconColor: Colors.purple,
            focusColor: Colors.purple,
            title: Text('설정'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(
                          accountName: '원두네',
                          accountEmail: 'wondu@gmail.com',
                        )),
              );
            },
            trailing: Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
