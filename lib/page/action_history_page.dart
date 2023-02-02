// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/action_history_card.dart';

///操作记录页面
class ActionHistoryPage extends StatefulWidget {
  final String searchId;
  final int searchType;
  const ActionHistoryPage({super.key, required this.searchId, required this.searchType});

  @override
  _ActionHistoryPageState createState() => _ActionHistoryPageState();
}

class _ActionHistoryPageState extends State<ActionHistoryPage> {
  late final String _searchId;
  late final int _searchType;
  late final List<ActionHistory> _historys;

  @override
  void initState() {
    super.initState();
    _searchId = widget.searchId;
    _searchType = widget.searchType;
    _historys = ItemDataManager().searchActionHistory(widget.searchId, widget.searchType);
  }

  @override
  Widget build(BuildContext context) {
    final String _searchName;
    if (_searchType == HistorySearchType.USERNAME) {
      _searchName = _searchId;
    } else if (_searchType == HistorySearchType.ITEMID) {
      _searchName = ItemDataManager().getItemById(_searchId)!.name;
    } else {
      _searchName = "";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("操作历史: $_searchName"),
      ),
      body: getBodyView(),
    );
  }

  Widget getBodyView() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                //   return ItemPage(itemId: itemIds[index]);
                // }));
              },
              child: ActionHistoryCard(_historys[index]));
        },
        itemCount: _historys.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    refreshData();
  }

  refreshData() {
    _historys = ItemDataManager().searchActionHistory(widget.searchId, widget.searchType);
  }
}
