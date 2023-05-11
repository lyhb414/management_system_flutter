// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/item_page.dart';
import 'package:management_system_flutter/widget/item_card.dart';
import 'package:management_system_flutter/page/add_page.dart';

///器材列表页面
class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late Future<List<String>> itemIds;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add",
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const AddPage();
              })).then((value) {
                _onRefresh();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget getBody() {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<List<dynamic>>(
          future: itemIds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              return getBodyView(snapshot.data);
            }
          },
        ));
  }

  Widget getBodyView(List<dynamic>? itemIds) {
    return ListView.builder(
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
      itemCount: itemIds!.length,
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    refreshData();
  }

  void refreshData() {
    itemIds = ItemDataManager().getItemIdList();
  }
}
