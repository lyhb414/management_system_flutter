// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';

//借用器材页面
class BorrowPage extends StatefulWidget {
  final String itemId;
  const BorrowPage({super.key, required this.itemId});

  @override
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  late final String _itemId;
  var borrowNum = -1;

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
          title: Text("借用:$_itemName"),
        ),
        body: getBodyView(context));
  }

  Widget getBodyView(BuildContext context) {
    var remainNum = ItemDataManager().getItemById(_itemId)!.getRemainNum();
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            Text(
              "空闲数量: $remainNum",
              style: TextStyle(
                color: (remainNum > 0) ? Colors.green : Colors.red,
              ),
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入借用数量',
                labelText: '借用数量',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  borrowNum = int.parse(value);
                } else {
                  borrowNum = -1;
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Center(
              child: CommonButton(
                text: "借用",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () {
                  if (borrowNum > 0) {
                    if (ItemDataManager().borrowItem(_itemId, borrowNum)) {
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
