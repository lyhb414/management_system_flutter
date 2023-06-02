// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';

///器材卡片

class ItemCard extends StatefulWidget {
  final String itemId;
  const ItemCard({super.key, required this.itemId});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  late final String _itemId;
  late Future<ItemData?> _itemData;

  @override
  void initState() {
    super.initState();
    _itemId = widget.itemId;
    _itemData = DataManager().getItemById(_itemId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemData?>(
      future: _itemData,
      builder: (BuildContext context, AsyncSnapshot<ItemData?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CardBuild(const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return CardBuild(Center(child: Text('Error: ${snapshot.error}')));
        } else if (snapshot.hasData) {
          return ItemCardBuild(snapshot.data);
        } else {
          return CardBuild(const Center(child: Text('Item not found')));
        }
      },
    );
  }

  Widget CardBuild(Widget widget) {
    return Card(
      elevation: 2.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: widget,
    );
  }

  Widget ItemCardBuild(ItemData? itemData) {
    return CardBuild(
      Container(
        height: 80,
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("器材名称: ${itemData!.name}"), Text("器材id: ${itemData.equipId}")],
            ),
            const Padding(padding: EdgeInsets.all(5.0)),
            Text(
              "空闲数量: ${itemData.getRemainNum()} / ${itemData.totalNum}",
              style: TextStyle(
                color: (itemData.getRemainNum() > 0) ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
