// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/common_button.dart';

//编辑器材页面
class EditPage extends StatefulWidget {
  final String itemId;
  const EditPage({super.key, required this.itemId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final String _itemId;
  var itemName = '';
  var defaultItemName = '';
  var itemTotalNum = -1;
  var defaultItemTotalNum = -1;
  var itemLocation = '';
  var defaultItemLocation = '';
  late TextEditingController _nameController;
  late TextEditingController _numController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _itemId = widget.itemId;

    defaultItemName = ItemDataManager().getItemById(_itemId)!.name;
    itemName = defaultItemName;
    _nameController = TextEditingController(text: defaultItemName);

    defaultItemTotalNum = ItemDataManager().getItemById(_itemId)!.totalNum;
    _numController = TextEditingController(text: defaultItemTotalNum.toString());
    itemTotalNum = defaultItemTotalNum;

    defaultItemLocation = ItemDataManager().getItemById(_itemId)!.location;
    itemLocation = defaultItemLocation;
    _locationController = TextEditingController(text: defaultItemLocation);
  }

  @override
  Widget build(BuildContext context) {
    final String _title = ItemDataManager().getItemById(_itemId)!.name;
    return Scaffold(
        appBar: AppBar(
          title: Text("编辑器材: $_title"),
        ),
        body: getBodyView());
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材名称',
                labelText: '器材名称',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemName = value;
                } else {
                  itemName = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _numController,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材总数',
                labelText: '器材总数',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemTotalNum = int.parse(value);
                } else {
                  itemTotalNum = -1;
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _locationController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材位置',
                labelText: '器材位置',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemLocation = value;
                } else {
                  itemLocation = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.all(10.0)),
                CommonButton(
                  text: "修改",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () {
                    if ((itemName.isNotEmpty) && (itemTotalNum >= 0) && (itemLocation.isNotEmpty)) {
                      ItemDataManager().editItem(_itemId, itemName, itemTotalNum, itemLocation);
                      Navigator.pop(context);
                    } else {
                      print("添加参数错误");
                    }
                  },
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                CommonButton(
                  text: "重置",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () {
                    _nameController.value = TextEditingValue(
                        text: defaultItemName,
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: defaultItemName.length)));
                    _numController.value = TextEditingValue(
                        text: defaultItemTotalNum.toString(),
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream, offset: defaultItemTotalNum.toString().length)));
                    _locationController.value = TextEditingValue(
                        text: defaultItemLocation.toString(),
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream, offset: defaultItemLocation.toString().length)));
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
