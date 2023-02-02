import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/const/const.dart';

///操作记录卡片
class ActionHistoryCard extends StatelessWidget {
  final ActionHistory _history;
  const ActionHistoryCard(this._history, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          height: 150,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("器材名称: ${ItemDataManager().getItemById(_history.itemId)!.name}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作类型: ${ActionTypeName[_history.actionType]}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作数量: ${_history.actionNum}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作时间: ${formatDate(_history.actionTime, [
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
              Text("操作用户: ${_history.username}"),
            ],
          ),
        ),
      ),
    );
  }
}
