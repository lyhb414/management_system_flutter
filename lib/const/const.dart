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

const Map<int, String> EquipmentModificationTypeName = {
  EquipmentModificationType.CREATE: "注册",
  EquipmentModificationType.EDIT: "编辑",
  EquipmentModificationType.DELETE: "删除",
};

class HistorySearchType {
  static const int NONE = 0;
  static const int USERNAME = 1;
  static const int ITEMID = 2;
}

class ItemSearchType {
  static const int NONE = 0;
  static const int ITEMNAME = 1;
  static const int ITEMID = 2;
  static const int CREATEUSER = 3;
}

class EquipmentModificationSearchType {
  static const int ALL = 0;
  static const int USERNAME = 1;
  static const int EQUIPMENTID = 2;
}

class EquipmentModificationType {
  static const int CREATE = 0;
  static const int EDIT = 1;
  static const int DELETE = 2;
}
