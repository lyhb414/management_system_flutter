// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/page/borrow_page.dart';
import 'package:management_system_flutter/page/action_history_page.dart';
import 'package:management_system_flutter/const/const.dart';

import 'borrow_history_list_page.dart';
import 'edit_page.dart';

///器材详情页面
class ItemPage extends StatefulWidget {
  final String itemId;
  const ItemPage({super.key, required this.itemId});

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late final String _itemId;

  @override
  void initState() {
    super.initState();
    _itemId = widget.itemId;
  }

  @override
  Widget build(BuildContext context) {
    final String _title = ItemDataManager().getItemById(_itemId)!.name;
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: getBodyView(),
    );
  }

  Widget getBodyView() {
    var remainNum = ItemDataManager().getItemById(_itemId)!.getRemainNum();
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材id: $_itemId"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材名称: ${ItemDataManager().getItemById(_itemId)!.name}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("总数: ${ItemDataManager().getItemById(_itemId)!.totalNum}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text(
              "空闲数量: $remainNum",
              style: TextStyle(
                color: (remainNum > 0) ? Colors.green : Colors.red,
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材位置: ${ItemDataManager().getItemById(_itemId)!.location}"),
            const Padding(padding: EdgeInsets.all(10.0)),
            const Divider(
              height: 1.0,
              color: Colors.blue,
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                CommonButton(
                  text: "借用",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return BorrowPage(
                        itemId: _itemId,
                      );
                    })).then((value) {
                      _onRefresh();
                    });
                  }),
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                CommonButton(
                  text: "借用历史",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return BorrowHistoryListPage(
                        searchId: _itemId,
                        searchType: HistorySearchType.ITEMID,
                      );
                    })).then((value) {
                      _onRefresh();
                    });
                  }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            const Divider(
              height: 1.0,
              color: Colors.blue,
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                CommonButton(
                  text: "编辑",
                  color: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return EditPage(
                        itemId: _itemId,
                      );
                    })).then((value) {
                      _onRefresh();
                    });
                  }),
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                CommonButton(
                  text: "操作日志",
                  color: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return ActionHistoryPage(
                        searchId: _itemId,
                        searchType: HistorySearchType.ITEMID,
                      );
                    })).then((value) {
                      _onRefresh();
                    });
                  }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            const Divider(
              height: 1.0,
              color: Colors.blue,
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                CommonButton(
                  text: "删除器材",
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    ItemDataManager().unregisterItem(_itemId);
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
  }
}
