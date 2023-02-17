// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';

//添加器材页面
class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var itemId = '';
  var itemName = '';
  var itemTotalNum = -1;
  var itemLocation = "";

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
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材id',
                labelText: '器材id',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemId = value;
                } else {
                  itemId = '';
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
            Center(
              child: CommonButton(
                text: "添加",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () {
                  if ((itemId.isNotEmpty) &&
                      (itemName.isNotEmpty) &&
                      (itemTotalNum >= 0) &&
                      (itemLocation.isNotEmpty)) {
                    if (ItemDataManager().registerItem(itemId, itemName, itemTotalNum, itemLocation)) {
                      Navigator.pop(context);
                    } else {
                      print("此id已使用");
                    }
                  } else {
                    print("添加参数错误");
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
