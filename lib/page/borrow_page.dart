// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

//借用器材页面
class BorrowPage extends StatefulWidget {
  final String itemId;
  const BorrowPage({super.key, required this.itemId});

  @override
  _BorrowPageState createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  late final String _itemId = widget.itemId;
  var borrowNum = -1;
  late Future<ItemData?> _itemData;

  @override
  void initState() {
    super.initState();
    fetchNetData();
  }

  fetchNetData() {
    _itemData = DataManager().getItemById(_itemId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_itemData],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
              appBar: AppBar(
                title: Text("借用:${data[0].name}"),
              ),
              body: getBodyView(context, data[0]));
        });
  }

  Widget getBodyView(BuildContext context, ItemData itemData) {
    var remainNum = itemData.getRemainNum();
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
              child: AwaitButton(
                text: "借用",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () async {
                  if (borrowNum > 0) {
                    PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认借用？', () async {
                      await DataManager().borrowItem(_itemId, borrowNum).then((value) {
                        if (value.statusCode == 200) {
                          PageUtil.instance.showSingleBtnDialog(context, "通知", "借用成功", () {
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
                    PageUtil.instance.showSingleBtnDialog(context, "错误", "参数错误", () {});
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
