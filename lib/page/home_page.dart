// ignore_for_file: library_private_types_in_public_api

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:management_system_flutter/page/list_page.dart';
import 'package:management_system_flutter/page/search_item_page.dart';
import 'package:management_system_flutter/page/user_page.dart';

import '../const/const.dart';
import '../data/data.dart';
import 'borrow_history_list_page.dart';

///主页页面
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List pageList = [
    const ListPage(),
    BorrowHistoryListPage(
      searchId: ItemDataManager().getMyUserName(),
      searchType: HistorySearchType.USERNAME,
      isShowAppBar: false,
    ),
    const UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('器材管理系统'),
        actions: (currentIndex == 0)
            ? ([
                IconButton(
                  onPressed: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return const SearchItemPage();
                    }));
                  }),
                  icon: const Icon(Icons.search),
                )
              ])
            : null,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Row(
              children: const <Widget>[
                Expanded(
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      '导航',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(
                '设置',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, //配置底部tabs可以有
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "借用历史"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
      ),
    );
  }
}
