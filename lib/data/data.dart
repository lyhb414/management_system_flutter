// ignore_for_file: avoid_print, non_constant_identifier_names
import 'package:management_system_flutter/const/const.dart';

class ItemData {
  String name;
  int totalNum;
  int borrowNum;
  String location;
  String? addText = "";

  ItemData({required this.name, required this.totalNum, this.borrowNum = 0, this.addText, required this.location});

  int getRemainNum() {
    return totalNum - borrowNum;
  }
}

class ActionHistory {
  String username;
  String itemId;
  String itemName;
  int actionNum;
  DateTime actionTime;
  int actionType;

  ActionHistory({
    required this.username,
    required this.itemId,
    required this.itemName,
    required this.actionNum,
    required this.actionTime,
    required this.actionType,
  });
}

class BorrowHistory {
  String username;
  String itemId;
  int borrowNum;
  DateTime borrowTime = DateTime.now();
  List<ReturnHistory> returnHistorys = [];
  int returnNum = 0;
  bool isOver = false;

  BorrowHistory({
    required this.username,
    required this.itemId,
    required this.borrowNum,
  });

  bool returnItem(int returnItemNum) {
    if (returnItemNum > borrowNum - returnNum) {
      print("归还数量大于此次借用需归还数量");
      return false;
    } else {
      var time = DateTime.now();
      ReturnHistory history = ReturnHistory(returnNum: returnItemNum, returnTime: time);
      returnHistorys.add(history);
      returnNum += returnItemNum;

      ItemDataManager().getItemById(itemId)!.borrowNum -= returnItemNum;
      ItemDataManager().addActionHistory(itemId, returnItemNum, ActionType.RETURN);
    }
    if (returnNum == borrowNum) {
      isOver = true;
    }
    return true;
  }

  bool returnAllItem() {
    if (isOver) {
      print("本次借用已完毕，无需归还");
      return false;
    } else {
      returnItem(borrowNum - returnNum);
      return true;
    }
  }
}

class ReturnHistory {
  int returnNum;
  DateTime returnTime;

  ReturnHistory({
    required this.returnNum,
    required this.returnTime,
  });
}

class ItemDataManager {
  static final ItemDataManager _itemDataManager = ItemDataManager._internal();

  ///工厂构造函数
  factory ItemDataManager() {
    return _itemDataManager;
  }

  ///构造函数私有化，防止被误创建
  ItemDataManager._internal();

  static String myUsername = "test admin";

  String getMyUserName() {
    return myUsername;
  }

  final Map<String, ItemData> _itemDatas = {
    "1": ItemData(
      name: "器材a",
      totalNum: 10,
      location: "位置a",
    ),
    "2": ItemData(
      name: "器材b",
      totalNum: 20,
      location: "位置b",
    ),
  };

  final List<ActionHistory> actionHistorys = [];

  final List<BorrowHistory> borrowHistorys = [];

  bool registerItem(String itemId, String itemName, int itemTotalNum, String itemLocation) {
    if (_itemDatas.containsKey(itemId)) {
      return false;
    }

    var item = ItemData(name: itemName, totalNum: itemTotalNum, location: itemLocation);
    _itemDatas[itemId] = item;
    return true;
  }

  unregisterItem(String itemId) {
    borrowHistorys.removeWhere((element) {
      return element.itemId == itemId;
    });
    _itemDatas.remove(itemId);
  }

  ItemData? getItemById(String itemId) {
    return _itemDatas[itemId];
  }

  List<String> getItemIdList() {
    return _itemDatas.keys.toList();
  }

  addItemNum(String itemId, int num) {
    _itemDatas[itemId]!.totalNum += num;
    addActionHistory(itemId, num, ActionType.ADD);
  }

  removeItemNum(String itemId, int num) {
    if (_itemDatas[itemId]!.getRemainNum() < num) {
      print("减少数量大于空余数量");
      return false;
    }
    _itemDatas[itemId]!.totalNum -= num;
    addActionHistory(itemId, num, ActionType.REMOVE);
  }

  bool borrowItem(String itemId, int num) {
    if (_itemDatas[itemId]!.getRemainNum() < num) {
      print("减少数量大于空余数量");
      return false;
    } else if (num < 0) {
      print("借用数量需大于0");
      return false;
    } else {
      _itemDatas[itemId]!.borrowNum += num;
      addActionHistory(itemId, num, ActionType.BORROW);
      borrowHistorys.add(BorrowHistory(username: myUsername, itemId: itemId, borrowNum: num));
      return true;
    }
  }

  addActionHistory(String itemId, int actionNum, int actionType) {
    var time = DateTime.now();

    var history = ActionHistory(
      username: myUsername,
      itemId: itemId,
      itemName: getItemById(itemId)!.name,
      actionNum: actionNum,
      actionTime: time,
      actionType: actionType,
    );
    actionHistorys.add(history);
  }

  List<String> SearchItemList(String itemSearchText, int searchType) {
    List<String> result = [];
    if (searchType == ItemSearchType.ITEMNAME) {
      _itemDatas.forEach((key, value) {
        if (value.name.contains(itemSearchText)) {
          result.add(key);
        }
      });
    } else if (searchType == ItemSearchType.ITEMID) {
      _itemDatas.forEach((key, value) {
        if (key.contains(itemSearchText)) {
          result.add(key);
        }
      });
    }
    return result;
  }

  List<ActionHistory> searchActionHistory(String searchId, int searchType) {
    List<ActionHistory> result = [];
    if (searchType == HistorySearchType.USERNAME) {
      for (var element in actionHistorys) {
        if (element.username == searchId) {
          result.add(element);
        }
      }
    } else if (searchType == HistorySearchType.ITEMID) {
      for (var element in actionHistorys) {
        if (element.itemId == searchId) {
          result.add(element);
        }
      }
    }
    result.sort((left, right) {
      return left.actionTime.isBefore(right.actionTime) ? 1 : -1;
    });
    return result;
  }

  List<BorrowHistory> searchBorrowHistory(String searchId, int searchType) {
    List<BorrowHistory> result = [];
    if (searchType == HistorySearchType.USERNAME) {
      for (var element in borrowHistorys) {
        if (element.username == searchId) {
          result.add(element);
        }
      }
    } else if (searchType == HistorySearchType.ITEMID) {
      for (var element in borrowHistorys) {
        if (element.itemId == searchId) {
          result.add(element);
        }
      }
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

  bool editItem(String itemId, String itemName, int itemTotalNum, String itemLocation) {
    var item = getItemById(itemId);
    if (item!.borrowNum >= itemTotalNum) {
      print("修改后的总数小于已借出的数量");
      return false;
    }
    item.name = itemName;
    item.totalNum = itemTotalNum;
    item.location = itemLocation;
    return true;
  }
}
