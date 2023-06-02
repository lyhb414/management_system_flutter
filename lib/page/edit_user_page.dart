// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

//编辑器材页面
class EditUserPage extends StatefulWidget {
  final String username;
  const EditUserPage({super.key, required this.username});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final String _username = widget.username;
  var firstname = '';
  var defaultFirstname = '';
  late TextEditingController _firstnameController;

  late Future<String?> _myfirstname;

  @override
  void initState() {
    super.initState();

    _myfirstname = DataManager().getFirstName(_username).then((value) {
      setState(() {
        defaultFirstname = value;
        firstname = defaultFirstname;
        _firstnameController = TextEditingController(text: defaultFirstname);
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_myfirstname],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
              appBar: AppBar(
                title: Text("资料修改: ${data[0]}"),
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
              controller: _firstnameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入用户姓名',
                labelText: '用户姓名',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  firstname = value;
                } else {
                  firstname = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                AwaitButton(
                  text: "确认",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if ((firstname.isNotEmpty)) {
                      await DataManager().updateFirstName(_username, firstname).then((value) {
                        if (value.statusCode == 200) {
                          PageUtil.instance.showSingleBtnDialog(context, "通知", "编辑成功", () {});
                        } else {
                          PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                        }
                      });
                    } else {
                      PageUtil.instance.showSingleBtnDialog(context, "错误", "输入参数错误", () {});
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                CommonButton(
                  text: "重置",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () {
                    firstname = defaultFirstname;
                    _firstnameController.value = TextEditingValue(
                        text: defaultFirstname,
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: defaultFirstname.length)));
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
