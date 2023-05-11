// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/page/search_item_list_page.dart';
import 'package:management_system_flutter/widget/common_button.dart';
import 'package:management_system_flutter/widget/custom_dropdown_button.dart';

//搜索器材页面
class SearchItemPage extends StatefulWidget {
  const SearchItemPage({super.key});

  @override
  _SearchItemPageState createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  int? _value = 1;
  var itemSearchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("搜索器材"),
        ),
        body: getBodyView());
  }

  Widget getBodyView() {
    return ListView(
      children: <Widget>[
        Column(
          children: [
            const Padding(padding: EdgeInsets.all(10.0)),
            Row(
              children: [
                const Padding(padding: EdgeInsets.all(5.0)),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.elliptical(4, 4),
                        bottom: Radius.elliptical(4, 4),
                      )),
                  child: CustomDropdownButton(
                    value: _value,
                    hint: "请选择搜索类型",
                    items: const [
                      DropdownMenuItem(
                        value: ItemSearchType.ITEMNAME,
                        child: Text("按器材名称"),
                      ),
                      DropdownMenuItem(
                        value: ItemSearchType.ITEMID,
                        child: Text("按器材ID"),
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value as int;
                      });
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: '请输入器材名称/ID',
                      labelText: '器材名称/ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        itemSearchText = value;
                      } else {
                        itemSearchText = "";
                      }
                    },
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5.0)),
              ],
            ),
            const Padding(padding: EdgeInsets.all(10.0)),
            Center(
              child: CommonButton(
                text: "搜索",
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                fontSize: 20,
                onPress: () {
                  if (itemSearchText.isNotEmpty) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                      return SearchItemListPage(searchType: _value as int, itemSearchText: itemSearchText);
                    }));
                  } else {
                    print("添加参数错误");
                  }
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
