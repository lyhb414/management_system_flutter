import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

///借用历史卡片
class BorrowHistoryCard extends StatelessWidget {
  final BorrowHistory _history;
  const BorrowHistoryCard(this._history, {super.key});
  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [getName(), getFirstName()],
        builder: (BuildContext context, List<dynamic> data) {
          return getCard(data[0], data[1]);
        });
  }

  Future<String?> getName() async {
    var item = await DataManager().getItemById(_history.itemId);
    return item?.name;
  }

  Future<String?> getFirstName() async {
    var firstname = await DataManager().getFirstName(_history.user);
    return firstname;
  }

  Widget getCard(String itemName, String firstname) {
    return Center(
      child: Card(
        color: _history.isOver
            ? Colors.grey
            : (_history.user == DataManager().getMyUserName() ? Colors.redAccent : Colors.yellowAccent),
        elevation: 2.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          height: 150,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("借用器材: $itemName"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("归还数量: ${_history.returnNum} / ${_history.borrowNum}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("借用用户: $firstname"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("借用时间: ${formatDate(_history.borrowTime, [
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
            ],
          ),
        ),
      ),
    );
  }
}
