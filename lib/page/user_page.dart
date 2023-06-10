// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/edit_user_page.dart';
import 'package:management_system_flutter/page/euipment_modification_page.dart';
import 'package:management_system_flutter/page/user_control_page.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

//用户页面
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<bool?> _selfIsAdmin;

  @override
  void initState() {
    super.initState();

    _selfIsAdmin = ApiService.instance.checkAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_selfIsAdmin],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(body: getBodyView(data[0]));
        });
  }

  Widget getBodyView(bool isAdmin) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              '修改用户信息',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return EditUserPage(
                  username: DataManager().getMyUserName(),
                );
              }));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              '我的操作记录',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return EuipmentModificationPage(
                  searchText: ApiService.instance.username,
                  searchType: EquipmentModificationSearchType.USERNAME,
                );
              })).then((value) {});
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text(
              '总操作记录',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return EuipmentModificationPage(
                  searchText: ApiService.instance.username,
                  searchType: EquipmentModificationSearchType.ALL,
                );
              })).then((value) {});
            },
          ),
          isAdmin
              ? ListTile(
                  leading: const Icon(Icons.build),
                  title: const Text(
                    '管理员设置',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return const UserControlPage();
                    }));
                  },
                )
              : Visibility(
                  visible: false,
                  child: Container(),
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
              ApiService.instance.Logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ).toList(),
    );
  }
}
