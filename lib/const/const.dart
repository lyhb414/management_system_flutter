// ignore_for_file: constant_identifier_names, file_names

class ActionType {
  static const int NONE = 0;
  static const int BORROW = 1;
  static const int RETURN = 2;
  static const int ADD = 3;
  static const int REMOVE = 4;
}

const Map<int, String> ActionTypeName = {
  ActionType.NONE: "",
  ActionType.BORROW: "借用",
  ActionType.RETURN: "归还",
  ActionType.ADD: "添加",
  ActionType.REMOVE: "移除",
};

class HistorySearchType {
  static const int NONE = 0;
  static const int USERNAME = 1;
  static const int ITEMID = 2;
}
