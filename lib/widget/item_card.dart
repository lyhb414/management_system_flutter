import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';

///器材卡片
class ItemCard extends StatelessWidget {
  final String _itemId;
  const ItemCard(this._itemId, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          height: 80,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("器材名称: ${ItemDataManager().getItemById(_itemId)!.name}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("空闲数量: ${ItemDataManager().getItemById(_itemId)!.getRemainNum()}"),
            ],
          ),
        ),
      ),
    );
  }
}
