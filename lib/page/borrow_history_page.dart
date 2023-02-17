// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:date_format/date_format.dart';

import '../widget/return_history_card.dart';

//借用历史页面
class BorrowHistoryPage extends StatefulWidget {
  final BorrowHistory _history;
  const BorrowHistoryPage(this._history, {super.key});

  @override
  _BorrowHistoryPageState createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  late final BorrowHistory _history;
  var _returnHistorys;
  var returnNum = -1;

  @override
  void initState() {
    super.initState();
    _history = widget._history;
    _returnHistorys = _history.returnHistorys;
  }

  @override
  Widget build(BuildContext context) {
    //final String _itemName = ItemDataManager().getItemById(_itemId)!.name;
    return Scaffold(
        appBar: AppBar(
          title: Text("借用历史: ${ItemDataManager().getItemById(_history.itemId)!.name}"),
        ),
        body: getBodyView(context));
  }

  Widget getBodyView(BuildContext context) {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("已归还: ${_history.returnNum}/${_history.borrowNum}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("借用用户: ${_history.username}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("借用时间: ${formatDate(_history.borrowTime, [
                  'yyyy',
                  '-',
                  'mm',
                  '-',
                  'dd',
                  ' ',
                  'HH',
                  ':',
                  'nn',
                  ':',
                  'ss'
                ])}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            SizedBox(
              width: 300,
              child: TextFormField(
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
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonButton(
                  text: "归还",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () {
                    if (returnNum >= 0) {
                      if (_history.returnItem(returnNum)) {
                        Navigator.pop(context);
                      }
                    } else {
                      print("参数错误");
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                CommonButton(
                  text: "归还全部",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () {
                    if (_history.returnAllItem()) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            const Divider(
              height: 1.0,
              color: Colors.blue,
            ),
            const Padding(padding: EdgeInsets.all(8.0)),
            SizedBox(
              height: 400,
              child: _returnHistorys.length > 0
                  ? ListView.builder(
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: ReturnHistoryCard(_returnHistorys[index]),
                        );
                      },
                      itemCount: _returnHistorys.length,
                    )
                  : null,
            ),
          ],
        )
      ],
    );
  }
}
