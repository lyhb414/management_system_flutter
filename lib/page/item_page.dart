// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/euipment_modification_page.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/page/borrow_page.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

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
  late Future<ItemData?> _itemData;
  late Future<bool?> _selfIsAdmin;
  late Future<String?> _itemCreateUserFirstName;

  @override
  void initState() {
    super.initState();
    _itemId = widget.itemId;
    fetchNetData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [
          _itemData,
          _selfIsAdmin,
          _itemCreateUserFirstName,
        ],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
            appBar: AppBar(
              title: Text(data[0].name),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _onRefresh();
                  },
                ),
              ],
            ),
            body: getBodyView(data[0], data[1], data[2]),
          );
        });
  }

  Widget getBodyView(ItemData? itemData, bool isAdmin, String itemCreateUserFirstName) {
    var remainNum = itemData!.getRemainNum();
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材id: ${itemData.equipId}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材名称: ${itemData.name}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材创建人: $itemCreateUserFirstName"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("总数: ${itemData.totalNum}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text(
              "空闲数量: $remainNum",
              style: TextStyle(
                color: (remainNum > 0) ? Colors.green : Colors.red,
              ),
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("器材位置: ${itemData.location}"),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text("备注: ${itemData.description}"),
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
                  text: "操作记录",
                  color: Colors.orange,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: (() {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return EuipmentModificationPage(
                        searchText: _itemId,
                        searchType: EquipmentModificationSearchType.EQUIPMENTID,
                      );
                    })).then((value) {
                      _onRefresh();
                    });
                  }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isAdmin
                    ? AwaitButton(
                        text: "删除器材",
                        color: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 20,
                        onPress: (() async {
                          PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认删除？', () async {
                            await DataManager().unregisterItem(_itemId).then((value) {
                              if (value.statusCode == 204) {
                                PageUtil.instance.showSingleBtnDialog(context, "通知", "删除成功", () {
                                  Navigator.pop(context);
                                });
                              } else {
                                PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                              }
                            });
                          }, () {});
                        }),
                      )
                    : Visibility(
                        visible: false,
                        child: Container(),
                      ),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
          ],
        ),
      ),
    );
  }

  fetchNetData() async {
    _itemData = DataManager().getItemById(_itemId);
    _itemCreateUserFirstName = _itemData.then((value) => ApiService.instance.getFirstName(value!.createUser));
    _selfIsAdmin = ApiService.instance.checkAdmin();
  }

  Future<void> _onRefresh() async {
    await fetchNetData();
    setState(() {});
  }
}
