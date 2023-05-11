// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

//编辑器材页面
class EditPage extends StatefulWidget {
  final String itemId;
  const EditPage({super.key, required this.itemId});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final String _itemId = widget.itemId;
  var itemEquipId = '';
  var defaultItemEquipId = '';
  var itemName = '';
  var defaultItemName = '';
  var itemTotalNum = -1;
  var defaultItemTotalNum = -1;
  var itemLocation = '';
  var defaultItemLocation = '';
  late TextEditingController _equipIdController;
  late TextEditingController _nameController;
  late TextEditingController _numController;
  late TextEditingController _locationController;

  late Future<ItemData?> _itemData;

  @override
  void initState() {
    super.initState();

    _itemData = ItemDataManager().getItemById(_itemId).then((value) {
      setState(() {
        defaultItemEquipId = value!.equipId;
        itemEquipId = defaultItemEquipId;
        _equipIdController = TextEditingController(text: defaultItemEquipId);

        defaultItemName = value!.name;
        itemName = defaultItemName;
        _nameController = TextEditingController(text: defaultItemName);

        defaultItemTotalNum = value.totalNum;
        _numController = TextEditingController(text: defaultItemTotalNum.toString());
        itemTotalNum = defaultItemTotalNum;

        defaultItemLocation = value.location;
        itemLocation = defaultItemLocation;
        _locationController = TextEditingController(text: defaultItemLocation);
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_itemData],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
              appBar: AppBar(
                title: Text("编辑器材: ${data[0].name}"),
              ),
              body: getBodyView());
        });
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(20.0)),
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _equipIdController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入器材id',
                labelText: '器材id',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemEquipId = value;
                } else {
                  itemEquipId = '';
                }
              },
            ),
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
                AwaitButton(
                  text: "修改",
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  fontSize: 20,
                  onPress: () async {
                    if ((itemName.isNotEmpty) && (itemTotalNum >= 0) && (itemLocation.isNotEmpty)) {
                      await ItemDataManager()
                          .editItem(_itemId, itemEquipId, itemName, itemTotalNum, itemLocation, "")
                          .then((value) {
                        if (value.statusCode == 200) {
                          PageUtil.instance.showSingleBtnDialog(context, "通知", "编辑成功", () {});
                        } else {
                          PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                        }
                      });
                    } else {
                      PageUtil.instance.showSingleBtnDialog(context, "错误", "输入参数错误", () {});
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
