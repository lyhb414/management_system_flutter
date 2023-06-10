// ignore_for_file: library_private_types_in_public_api, avoid_print, no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button.dart';
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
  var itemDescription = '';
  var defaultItemDescription = '';
  var itemCreateUser = '';
  var defaultItemCreateUser = '';
  late TextEditingController _equipIdController;
  late TextEditingController _nameController;
  late TextEditingController _numController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _createUserController;

  late Future<ItemData?> _itemData;

  @override
  void initState() {
    super.initState();

    _itemData = DataManager().getItemById(_itemId).then((value) {
      setState(() {
        defaultItemEquipId = value!.equipId;
        itemEquipId = defaultItemEquipId;
        _equipIdController = TextEditingController(text: defaultItemEquipId);

        defaultItemName = value.name;
        itemName = defaultItemName;
        _nameController = TextEditingController(text: defaultItemName);

        defaultItemTotalNum = value.totalNum;
        itemTotalNum = defaultItemTotalNum;
        _numController = TextEditingController(text: defaultItemTotalNum.toString());

        defaultItemLocation = value.location;
        itemLocation = defaultItemLocation;
        _locationController = TextEditingController(text: defaultItemLocation);

        defaultItemDescription = value.description;
        itemDescription = defaultItemDescription;
        _descriptionController = TextEditingController(text: defaultItemDescription);

        defaultItemCreateUser = value.createUser;
        itemCreateUser = defaultItemCreateUser;
        _createUserController = TextEditingController(text: defaultItemCreateUser);
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
            TextFormField(
              controller: _descriptionController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入备注',
                labelText: '备注',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemDescription = value;
                } else {
                  itemDescription = '';
                }
              },
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            TextFormField(
              controller: _createUserController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: '请输入创建人ID',
                labelText: '创建人ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  itemCreateUser = value;
                } else {
                  itemCreateUser = '';
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
                    if ((itemName.isNotEmpty) && (itemTotalNum >= 0)) {
                      PageUtil.instance.showDoubleBtnDialog(context, '', '是否确认编辑？', () async {
                        await DataManager()
                            .editItem(_itemId, itemEquipId, itemName, itemTotalNum, itemLocation, itemDescription,
                                itemCreateUser)
                            .then((value) {
                          if (value.statusCode == 200) {
                            PageUtil.instance.showSingleBtnDialog(context, "通知", "编辑成功", () {});
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", value.body, () {});
                          }
                        });
                      }, () {});
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
                    itemEquipId = defaultItemEquipId;
                    itemName = defaultItemName;
                    itemTotalNum = defaultItemTotalNum;
                    itemLocation = defaultItemLocation;
                    itemDescription = defaultItemDescription;
                    itemCreateUser = defaultItemCreateUser;

                    _equipIdController.value = TextEditingValue(
                        text: defaultItemEquipId,
                        selection: TextSelection.fromPosition(
                            TextPosition(affinity: TextAffinity.downstream, offset: defaultItemEquipId.length)));
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
                    _descriptionController.value = TextEditingValue(
                        text: defaultItemDescription.toString(),
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream, offset: defaultItemDescription.toString().length)));
                    _createUserController.value = TextEditingValue(
                        text: defaultItemCreateUser.toString(),
                        selection: TextSelection.fromPosition(TextPosition(
                            affinity: TextAffinity.downstream, offset: defaultItemCreateUser.toString().length)));
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
