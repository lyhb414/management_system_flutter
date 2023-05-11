// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:http/http.dart';
import 'package:management_system_flutter/const/const.dart';

import 'api_service.dart';

class ItemData {
  String id;
  String equipId;
  String name;
  int totalNum;
  int borrowNum;
  String location;
  String description = "None";

  ItemData(
      {required this.id,
      required this.equipId,
      required this.name,
      required this.totalNum,
      this.borrowNum = 0,
      required this.description,
      required this.location});

  int getRemainNum() {
    return totalNum - borrowNum;
  }

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'].toString(),
      equipId: json['equipId'].toString(),
      name: json['name'],
      totalNum: json['totalNum'],
      borrowNum: json['borrowNum'],
      location: json['location'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'equipId': equipId,
      'name': name,
      'totalNum': totalNum,
      'borrowNum': borrowNum,
      'location': location,
      'description': description,
    };
  }
}

class BorrowHistory {
  String id;
  String user;
  String itemId;
  int borrowNum;
  DateTime borrowTime;
  List<ReturnHistory> returnHistorys;
  int returnNum;
  bool isOver;

  BorrowHistory({
    required this.id,
    required this.user,
    required this.itemId,
    required this.borrowNum,
    required this.borrowTime,
    required this.returnHistorys,
    required this.returnNum,
    required this.isOver,
  });

  factory BorrowHistory.fromJson(Map<String, dynamic> json) {
    List<dynamic> returnHistorysJson = json['returnHistorys'];
    List<ReturnHistory> returnHistorysList =
        returnHistorysJson.map((returnHistoryJson) => ReturnHistory.fromJson(returnHistoryJson)).toList();

    return BorrowHistory(
      id: json['id'].toString(),
      user: json['user'],
      itemId: json['itemId'].toString(),
      borrowNum: json['borrowNum'],
      borrowTime: DateTime.parse(json['borrowTime']).toLocal(),
      returnHistorys: returnHistorysList,
      returnNum: json['returnNum'],
      isOver: json['isOver'],
    );
  }

  Future<Response> returnItem(int returnItemNum) async {
    return ApiService.instance.returnEquipment(id, returnItemNum);
  }

  Future<Response> returnAllItem() async {
    return ApiService.instance.returnAllEquipment(id);
  }
}

class ReturnHistory {
  int returnNum;
  DateTime returnTime;

  ReturnHistory({
    required this.returnNum,
    required this.returnTime,
  });

  factory ReturnHistory.fromJson(Map<String, dynamic> json) {
    return ReturnHistory(
      returnNum: json['returnNum'],
      returnTime: DateTime.parse(json['returnTime']).toLocal(),
    );
  }
}

class ItemDataManager {
  static final ItemDataManager _itemDataManager = ItemDataManager._internal();

  ///工厂构造函数
  factory ItemDataManager() {
    return _itemDataManager;
  }

  ///构造函数私有化，防止被误创建
  ItemDataManager._internal();

  String getMyUserName() {
    return ApiService.instance.username;
  }

  Future<Response> registerItem(
      String equipId, String itemName, int itemTotalNum, String itemLocation, String itemDescription) {
    Map<String, dynamic> equipmentData = {
      'equipId': equipId,
      'name': itemName,
      'totalNum': itemTotalNum,
      'borrowNum': 0,
      'location': itemLocation,
      'description': itemDescription,
    };
    return ApiService.instance.createEquipment(equipmentData);
  }

  Future<Response> unregisterItem(String itemId) {
    return ApiService.instance.deleteEquipment(itemId);
  }

  Future<ItemData?> getItemById(String itemId) async {
    var item = await ApiService.instance.getEquipment(itemId);
    return item;
  }

  Future<List<String>> getItemIdList() async {
    List<String> equipmentIds = await ApiService.instance.getEquipmentIdList();
    return equipmentIds;
  }

  Future<Response> borrowItem(String itemId, int num) async {
    return ApiService.instance.borrowEquipment(itemId, num);
  }

  Future<BorrowHistory?> getBorrowHistoryById(String borrowHistoryId) async {
    var borrowHistory = await ApiService.instance.getBorrowHistory(borrowHistoryId);
    return borrowHistory;
  }

  Future<List<String>> SearchItemList(String itemSearchText, int searchType) async {
    List<String> result = [];
    List<ItemData> items = [];
    if (searchType == ItemSearchType.ITEMNAME) {
      items = await ApiService.instance.searchEquipment(itemSearchText, 'name');
    } else if (searchType == ItemSearchType.ITEMID) {
      items = await ApiService.instance.searchEquipment(itemSearchText, 'equipId');
    }
    for (var value in items) {
      result.add(value.id);
    }
    return result;
  }

  Future<List<BorrowHistory>> searchBorrowHistory(String searchId, int searchType) async {
    print(searchId);
    List<BorrowHistory> result = [];
    if (searchType == HistorySearchType.USERNAME) {
      result = await ApiService.instance.searchBorrowHistory(searchId, 'user');
    } else if (searchType == HistorySearchType.ITEMID) {
      result = await ApiService.instance.searchBorrowHistory(searchId, 'itemId');
    }

    result.sort((left, right) {
      if (left.isOver ^ right.isOver) {
        return left.isOver ? 1 : -1;
      } else {
        return left.borrowTime.isBefore(right.borrowTime) ? 1 : -1;
      }
    });
    return result;
  }

  Future<Response> editItem(
      String id, String equipId, String itemName, int itemTotalNum, String itemLocation, String itemDescription) async {
    ItemData tmpData = ItemData(
        id: id,
        equipId: equipId,
        name: itemName,
        totalNum: itemTotalNum,
        location: itemLocation,
        description: itemDescription);
    return ApiService.instance.updateEquipment(tmpData);
  }
}
