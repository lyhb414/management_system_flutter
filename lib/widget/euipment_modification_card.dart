import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/const/const.dart';

///操作记录卡片
class EquipmentModificationCard extends StatelessWidget {
  final EquipmentModification _modification;
  const EquipmentModificationCard(this._modification, {super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 2.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Container(
          //height: 180,
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("器材名称: ${_modification.equipmentName}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作用户: ${_modification.userFirstname}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作类型: ${EquipmentModificationTypeName[_modification.modificationType]}"),
              const Padding(padding: EdgeInsets.all(5.0)),
              Text("操作时间: ${formatDate(_modification.modificationTime, [
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
              Text("操作内容: ${_modification.modificationData}"),
            ],
          ),
        ),
      ),
    );
  }
}
