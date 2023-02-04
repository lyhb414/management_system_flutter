// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/page/borrow_history_list_page.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/page/action_history_page.dart';

//用户页面
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var userName = ItemDataManager().getMyUserName();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("个人主页"),
        // ),
        body: getBodyView());
  }

  Widget getBodyView() {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text(
              '借用历史',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return BorrowHistoryListPage(
                  searchId: ItemDataManager().getMyUserName(),
                  searchType: HistorySearchType.USERNAME,
                );
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(
              '操作日志',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return ActionHistoryPage(searchId: userName, searchType: HistorySearchType.USERNAME);
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              '退出登陆',
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
      ).toList(),
    );
  }
}
