// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:management_system_flutter/const/const.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/widget/euipment_modification_card.dart';
import 'package:management_system_flutter/widget/multi_future_builder.dart';

///操作记录页面
class EuipmentModificationPage extends StatefulWidget {
  final String searchText;
  final int searchType;
  const EuipmentModificationPage({super.key, required this.searchText, required this.searchType});

  @override
  _EuipmentModificationPageState createState() => _EuipmentModificationPageState();
}

class _EuipmentModificationPageState extends State<EuipmentModificationPage> {
  var _searchText;
  var _searchType;
  var _modifications;
  late String? _searchName;

  @override
  void initState() {
    super.initState();
    _searchText = widget.searchText;
    _searchType = widget.searchType;
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiFutureBuilder(
        futures: [_modifications],
        builder: (BuildContext context, List<dynamic> data) {
          return Scaffold(
            appBar: AppBar(
              title: Text("操作记录: $_searchName"),
            ),
            body: getBodyView(data[0]),
          );
        });
  }

  Widget getBodyView(List<EquipmentModification> modifications) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemBuilder: (context, index) {
          return InkWell(onTap: () {}, child: EquipmentModificationCard(modifications[index]));
        },
        itemCount: modifications.length,
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {});
    refreshData();
  }

  refreshData() async {
    _modifications = DataManager().SearchEuipmentModificationList(_searchText, _searchType);
    await getSearchName();
  }

  getSearchName() async {
    if (_searchType == EquipmentModificationSearchType.USERNAME) {
      await ApiService.instance.getFirstName(_searchText).then((value) {
        _searchName = value;
      });
    } else if (_searchType == EquipmentModificationSearchType.EQUIPMENTID) {
      await DataManager().getItemById(_searchText).then((value) {
        _searchName = value?.name;
      });
    } else if (_searchType == EquipmentModificationSearchType.ALL) {
      _searchName = '所有';
    } else {
      _searchName = "";
    }
  }
}
