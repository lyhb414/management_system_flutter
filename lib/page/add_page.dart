// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';

//添加器材页面
class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var itemEquipId = '';
  var itemName = '';
  var itemTotalNum = -1;
  var itemLocation = "";
  var itemDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("注册新器材"),
        ),
        body: getBodyView());
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材id',
                labelText: '器材id',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemEquipId = value;
                } else {
                  itemEquipId = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材名称',
                labelText: '器材名称',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemName = value;
                } else {
                  itemName = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材总数',
                labelText: '器材总数',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemTotalNum = int.parse(value);
                } else {
                  itemTotalNum = -1;
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材位置',
                labelText: '器材位置',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemLocation = value;
                } else {
                  itemLocation = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材描述',
                labelText: '器材描述',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemDescription = value;
                } else {
                  itemDescription = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Center(
              child: AwaitButton(
                text: "添加",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () async {
                  if ((itemEquipId.isNotEmpty) && (itemName.isNotEmpty) && (itemTotalNum >= 0)) {
                    PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认添加？', () async {
                      await DataManager()
                          .registerItem(itemEquipId, itemName, itemTotalNum, itemLocation, itemDescription)
                          .then((value) {
                        if (value.statusCode == 201) {
                          PageUtil.instance.showSingleBtnDialog(context, "通知", "添加成功", () {
                            Navigator.pop(context);
                          });
                        } else {
                          PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {
                            Navigator.pop(context);
                          });
                        }
                      });
                    }, () {});
                  } else {
                    PageUtil.instance.showSingleBtnDialog(context, "错误", "添加参数错误", () {});
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
