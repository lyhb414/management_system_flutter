// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/borrow_history_page.dart';
import 'package:management_system_flutter/widget/borrow_history_card.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

///借用历史页面
class BorrowHistoryListPage extends StatefulWidget {
  final String searchId;
  final int searchType;
  final bool isShowAppBar;
  const BorrowHistoryListPage({super.key, required this.searchId, required this.searchType, this.isShowAppBar = true});

  @override
  _BorrowHistoryListPageState createState() => _BorrowHistoryListPageState();
}

class _BorrowHistoryListPageState extends State<BorrowHistoryListPage> {
  var _searchId;
  var _searchType;
  var _isShowAppBar;
  late Future<List<BorrowHistory>> _historys;
  late String? _searchName;

  @override
  void initState() {
    super.initState();
    _searchId = widget.searchId;
    _searchType = widget.searchType;
    _isShowAppBar = widget.isShowAppBar;
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_historys],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
            appBar: _isShowAppBar
                ? AppBar(
                    title: Text("借用历史列表: $_searchName"),
                  )
                : null,
            body: getBodyView(data),
          );
        });
  }

  Widget getBodyView(List<dynamic> data) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return BorrowHistoryPage(data[0][index].id);
                })).then(
                  (value) {
                    _onRefresh();
                  },
                );
              },
              child: BorrowHistoryCard(data[0][index]));
        },
        itemCount: data[0].length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    refreshData();
  }

  refreshData() {
    _historys = DataManager().searchBorrowHistory(_searchId, _searchType);
    getSearchName();
  }

  getSearchName() {
    if (_searchType == HistorySearchType.USERNAME) {
      _searchName = _searchId;
    } else if (_searchType == HistorySearchType.ITEMID) {
      DataManager().getItemById(_searchId).then((value) {
        _searchName = value?.name;
      });
    } else {
      _searchName = "";
    }
  }
}
