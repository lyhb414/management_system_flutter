// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/item_page.dart';
import 'package:management_system_flutter/widget/item_card.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';
import 'package:management_system_flutter/const/const.dart';

///搜索器材列表页面
class SearchItemListPage extends StatefulWidget {
  final int searchType;
  final String itemSearchText;
  const SearchItemListPage({super.key, required this.searchType, required this.itemSearchText});

  @override
  _SearchItemListPageState createState() => _SearchItemListPageState();
}

class _SearchItemListPageState extends State<SearchItemListPage> {
  var _searchType;
  var _itemSearchText;
  late Future<List<String>> _itemIds;

  @override
  void initState() {
    super.initState();
    _searchType = widget.searchType;
    _itemSearchText = widget.itemSearchText;
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    var _title1 = "";
    if (_searchType == ItemSearchType.ITEMNAME) {
      _title1 = "按器材名称搜索:";
    } else if (_searchType == ItemSearchType.ITEMID) {
      _title1 = "按器材ID搜索:";
    } else if (_searchType == ItemSearchType.CREATEUSER) {
      _title1 = "按创建人搜索:";
    }
    final String _title2 = _itemSearchText;
    return MultiFutureBuilder(
        futures: [_itemIds],
        builder: ((context, data) {
          return Scaffold(
            appBar: AppBar(
              title: Text("$_title1 $_title2"),
            ),
            body: getBodyView(data[0]),
          );
        }));
  }

  Widget getBodyView(List<String> itemIds) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return ItemPage(itemId: itemIds[index]);
                })).then((value) {
                  _onRefresh();
                });
              },
              child: ItemCard(itemId: itemIds[index]));
        },
        itemCount: itemIds.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    refreshData();
  }

  refreshData() {
    _itemIds = DataManager().SearchItemList(_itemSearchText, _searchType);
  }
}
