// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/const/const.dart';
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
        appBar: AppBar(
          title: const Text("个人主页"),
        ),
        body: getBodyView());
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            Center(
              child: CommonButton(
                text: "操作记录",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return ActionHistoryPage(searchId: userName, searchType: HistorySearchType.USERNAME);
                  }));
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
