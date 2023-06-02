import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

///归还历史卡片
class ReturnHistoryCard extends StatelessWidget {
  final ReturnHistory _history;
  const ReturnHistoryCard(this._history, {super.key});

  Future<String?> getFirstName() async {
    var firstname = await DataManager().getFirstName(_history.returnUser);
    return firstname;
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [getFirstName()],
        builder: (BuildContext context, List<dynamic> data) {
          return getBody(data[0]);
        });
  }

  Widget getBody(String firstname) {
    return Center(
      child: Card(
        color: Colors.white,
        elevation: 2.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          height: 100,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("归还数量: ${_history.returnNum}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("归还用户: $firstname"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("归还时间: ${formatDate(_history.returnTime, [
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
