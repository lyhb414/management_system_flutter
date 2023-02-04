// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/borrow_history_page.dart';
import 'package:management_system_flutter/widget/borrow_history_card.dart';

///借用历史页面
class BorrowHistoryListPage extends StatefulWidget {
  final String searchId;
  final int searchType;
  const BorrowHistoryListPage({super.key, required this.searchId, required this.searchType});

  @override
  _BorrowHistoryListPageState createState() => _BorrowHistoryListPageState();
}

class _BorrowHistoryListPageState extends State<BorrowHistoryListPage> {
  var _searchId;
  var _searchType;
  var _historys;

  @override
  void initState() {
    super.initState();
    _searchId = widget.searchId;
    _searchType = widget.searchType;
    _historys = ItemDataManager().searchBorrowHistory(widget.searchId, widget.searchType);
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
        title: Text("借用历史列表: $_searchName"),
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
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return BorrowHistoryPage(_historys[index]);
                })).then(
                  (value) {
                    _onRefresh();
                  },
                );
              },
              child: BorrowHistoryCard(_historys[index]));
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
    _historys = ItemDataManager().searchBorrowHistory(_searchId, _searchType);
  }
}
