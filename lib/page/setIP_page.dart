// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button.dart';

//用户操作页面
class SetIPPage extends StatefulWidget {
  const SetIPPage({super.key});

  @override
  _SetIPPageState createState() => _SetIPPageState();
}

class _SetIPPageState extends State<SetIPPage> {
  var ip = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("IP设置"),
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
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入IP',
                labelText: 'IP',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  ip = value;
                } else {
                  ip = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                AwaitButton(
                  text: "设置",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if ((ip.isNotEmpty)) {
                      ApiService.instance.IP = ip;
                      PageUtil.instance.showSingleBtnDialog(context, "通知", '设置成功', () {});
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
