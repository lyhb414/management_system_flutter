// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';

//归还器材页面
class ReturnPage extends StatefulWidget {
  final String itemId;
  const ReturnPage({super.key, required this.itemId});

  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  late final String _itemId;
  var returnNum = -1;

  @override
  void initState() {
    super.initState();
    _itemId = widget.itemId;
  }

  @override
  Widget build(BuildContext context) {
    final String _itemName = ItemDataManager().getItemById(_itemId)!.name;
    return Scaffold(
        appBar: AppBar(
          title: Text("归还:$_itemName"),
        ),
        body: getBodyView(context));
  }

  Widget getBodyView(BuildContext context) {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入归还数量',
                labelText: '归还数量',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  returnNum = int.parse(value);
                } else {
                  returnNum = -1;
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Center(
              child: CommonButton(
                text: "归还",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () {
                  if (returnNum >= 0) {
                    if (ItemDataManager().returnItem(_itemId, returnNum)) {
                      Navigator.pop(context);
                    }
                  } else {
                    print("参数错误");
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
