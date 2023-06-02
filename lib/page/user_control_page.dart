// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

//用户操作页面
class UserControlPage extends StatefulWidget {
  const UserControlPage({super.key});

  @override
  _UserControlPageState createState() => _UserControlPageState();
}

class _UserControlPageState extends State<UserControlPage> {
  var username = '';

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
          return Scaffold(
              appBar: AppBar(
                title: const Text("管理员设置"),
              ),
              body: getBodyView());
        });
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入用户名(id)',
                labelText: '用户名(id)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  username = value;
                } else {
                  username = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                AwaitButton(
                  text: "提升为管理员",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if ((username.isNotEmpty)) {
                      PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认提升为管理员？', () async {
                        await ApiService.instance.promoteToAdmin(username).then((value) {
                          if (value.statusCode == 200) {
                            PageUtil.instance.showSingleBtnDialog(context, "通知", value.body, () {});
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                          }
                        });
                      }, () {});
                    } else {
                      PageUtil.instance.showSingleBtnDialog(context, "错误", "输入参数错误", () {});
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                AwaitButton(
                  text: "取消管理员权限",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if ((username.isNotEmpty)) {
                      PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认取消管理员权限？', () async {
                        await ApiService.instance.demoteFromAdmin(username).then((value) {
                          if (value.statusCode == 200) {
                            PageUtil.instance.showSingleBtnDialog(context, "通知", value.body, () {});
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                          }
                        });
                      }, () {});
                    } else {
                      PageUtil.instance.showSingleBtnDialog(context, "错误", "输入参数错误", () {});
                    }
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
