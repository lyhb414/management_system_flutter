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
  String createUser;

  ItemData(
      {required this.id,
      required this.equipId,
      required this.name,
      required this.totalNum,
      this.borrowNum = 0,
      required this.description,
      required this.location,
      required this.createUser});

  int getRemainNum() {
    return totalNum - borrowNum;
  }

  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: (json['id'] ?? 0).toString(),
      equipId: (json['equipId'] ?? 0).toString(),
      name: json['name'] ?? 'null',
      totalNum: json['totalNum'] ?? 0,
      borrowNum: json['borrowNum'] ?? 0,
      location: json['location'] ?? 'null',
      description: json['description'] ?? 'null',
      createUser: (json['createUser'] ?? 0).toString(),
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
      'createUser': createUser,
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
      id: (json['id'] ?? 0).toString(),
      user: (json['user'] ?? 0).toString(),
      itemId: (json['itemId'] ?? 0).toString(),
      borrowNum: json['borrowNum'] ?? 0,
      borrowTime: DateTime.parse(json['borrowTime'] ?? 'null').toLocal(),
      returnHistorys: returnHistorysList,
      returnNum: json['returnNum'] ?? 0,
      isOver: json['isOver'] ?? true,
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
  String returnUser;
  DateTime returnTime;

  ReturnHistory({
    required this.returnNum,
    required this.returnUser,
    required this.returnTime,
  });

  factory ReturnHistory.fromJson(Map<String, dynamic> json) {
    return ReturnHistory(
      returnNum: json['returnNum'] ?? 0,
      returnUser: (json['returnUser'] ?? 0).toString(),
      returnTime: DateTime.parse(json['returnTime'] ?? 'null').toLocal(),
    );
  }
}

class EquipmentModification {
  String equipmentId;
  String equipmentName;
  int modificationType;
  String modificationData;
  String username;
  String userFirstname;
  DateTime modificationTime;

  EquipmentModification({
    required this.equipmentId,
    required this.equipmentName,
    required this.modificationType,
    required this.modificationData,
    required this.username,
    required this.userFirstname,
    required this.modificationTime,
  });

  factory EquipmentModification.fromJson(Map<String, dynamic> json) {
    return EquipmentModification(
      equipmentId: (json['equipment_id'] ?? 0).toString(),
      equipmentName: json['equipment_name'] ?? 'null',
      modificationType: json['modification_type'] ?? 0,
      modificationData: json['modification_data'] ?? 'null',
      username: json['username'] ?? '0',
      userFirstname: json['user_firstname'] ?? 'null',
      modificationTime: DateTime.parse(json['modification_time'] ?? 'null').toLocal(),
    );
  }
}

class DataManager {
  static final DataManager _dataManager = DataManager._internal();

  ///工厂构造函数
  factory DataManager() {
    return _dataManager;
  }

  ///构造函数私有化，防止被误创建
  DataManager._internal();

  String getMyUserName() {
    return ApiService.instance.username;
  }

  Future<String> getFirstName(String? username) async {
    var name = await ApiService.instance.getFirstName(username!);
    return name;
  }

  Future<Response> updateFirstName(String username, String firstname) async {
    return await ApiService.instance.updateFirstName(username, firstname);
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
    } else if (searchType == ItemSearchType.CREATEUSER) {
      items = await ApiService.instance.searchEquipment(itemSearchText, 'createUser');
    }
    for (var value in items) {
      result.add(value.id);
    }
    return result;
  }

  Future<List<BorrowHistory>> searchBorrowHistory(String searchId, int searchType) async {
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
        var leftIsMine = left.user == getMyUserName();
        var rightIsMine = right.user == getMyUserName();
        if (leftIsMine ^ rightIsMine) {
          return rightIsMine ? 1 : -1;
        } else {
          return left.borrowTime.isBefore(right.borrowTime) ? 1 : -1;
        }
      }
    });
    return result;
  }

  Future<List<EquipmentModification>> SearchEuipmentModificationList(String itemSearchText, int searchType) async {
    List<EquipmentModification> result = [];
    List<ItemData> items = [];
    if (searchType == EquipmentModificationSearchType.USERNAME) {
      result = await ApiService.instance.searchEquipmentModification(itemSearchText, 'username');
    } else if (searchType == EquipmentModificationSearchType.EQUIPMENTID) {
      result = await ApiService.instance.searchEquipmentModification(itemSearchText, 'equipment_id');
    } else if (searchType == EquipmentModificationSearchType.ALL) {
      result = await ApiService.instance.searchEquipmentModification(itemSearchText, 'all');
    }

    result.sort((left, right) {
      return left.modificationTime.isBefore(right.modificationTime) ? 1 : -1;
    });
    return result;
  }

  Future<Response> editItem(String id, String equipId, String itemName, int itemTotalNum, String itemLocation,
      String itemDescription, String itemCreateUser) async {
    Map<String, dynamic> tmpData = {
      'id': id,
      'equipId': equipId,
      'name': itemName,
      'totalNum': itemTotalNum,
      'location': itemLocation,
      'description': itemDescription,
      'createUser': itemCreateUser,
    };
    return ApiService.instance.updateEquipment(tmpData);
  }
}
