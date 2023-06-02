// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';
import 'package:date_format/date_format.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

import '../widget/return_history_card.dart';

//借用历史页面
class BorrowHistoryPage extends StatefulWidget {
  final String _historyId;
  const BorrowHistoryPage(this._historyId, {super.key});

  @override
  _BorrowHistoryPageState createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  late final String _historyId = widget._historyId;
  var returnNum = -1;

  late Future<Map<String, dynamic>> _netData;

  @override
  void initState() {
    super.initState();
    _netData = fetchNetData();
  }

  Future<Map<String, dynamic>> fetchNetData() async {
    var history = await DataManager().getBorrowHistoryById(_historyId);
    var itemId = history?.itemId;
    var returnHistorys = history?.returnHistorys;
    var firstname = await DataManager().getFirstName(history?.user);

    var item = await DataManager().getItemById(itemId!);
    var itemName = item?.name;

    return {'borrowHistory': history, 'returnHistorys': returnHistorys, 'itemName': itemName, 'firstname': firstname};
  }

  Future<void> _onRefresh() async {
    _netData = fetchNetData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_netData],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
              appBar: AppBar(
                title: Text("借用历史: ${data[0]['itemName']}"),
              ),
              body: getBodyView(context, data[0]));
        });
  }

  Widget getBodyView(BuildContext context, Map<String, dynamic> netData) {
    var borrowHistory = netData['borrowHistory'];
    var returnHistorys = netData['returnHistorys'];
    var firstname = netData['firstname'];

    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(10.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("已归还: ${borrowHistory.returnNum}/${borrowHistory.borrowNum}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("借用用户: $firstname"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("借用时间: ${formatDate(borrowHistory.borrowTime, [
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
                AwaitButton(
                  text: "归还",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if (returnNum >= 0) {
                      PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认归还？', () async {
                        await borrowHistory.returnItem(returnNum).then((value) {
                          _onRefresh();
                          if (value.statusCode == 200) {
                            PageUtil.instance.showSingleBtnDialog(context, "通知", "归还成功", () {});
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                          }
                        });
                      }, () {});
                    } else {
                      PageUtil.instance.showSingleBtnDialog(context, "错误", "参数错误", () {});
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                AwaitButton(
                  text: "归还全部",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认归还全部？', () async {
                      await borrowHistory.returnAllItem().then((value) {
                        _onRefresh();
                        if (value.statusCode == 200) {
                          PageUtil.instance.showSingleBtnDialog(context, "通知", "归还成功", () {});
                        } else {
                          PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                        }
                      });
                    }, () {});
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
              child: returnHistorys.length > 0
                  ? ListView.builder(
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (context, index) {
                        return InkWell(
                          child: ReturnHistoryCard(returnHistorys[index]),
                        );
                      },
                      itemCount: returnHistorys.length,
                    )
                  : null,
            ),
          ],
        )
      ],
    );
  }
}
