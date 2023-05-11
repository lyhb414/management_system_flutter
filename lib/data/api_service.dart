import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'data.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final String baseApiUrl = "http://127.0.0.1:8000/api/";
  String username = 'test';
  String password = 'admintest';
  String get authorization => 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  //用户注册
  Future<Response> register(String username, String password) {
    final url = Uri.parse('${baseApiUrl}register/');
    final body = jsonEncode(<String, String>{
      'username': username,
      'password': password,
    });

    return http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
      body: body,
    );
  }

  //验证用户名密码
  Future<Response> checkCredentials(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseApiUrl}check_credentials/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      this.username = username;
      this.password = password;
    }
    return response;
  }

  //获取器材列表
  Future<List<dynamic>> getEquipmentList() async {
    final response = await http.get(
      Uri.parse('${baseApiUrl}equipment/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return List.empty();
    }
  }

  //获取id-器材map
  Future<Map<String, ItemData>> getEquipmentMap() async {
    final response = await http.get(
      Uri.parse('${baseApiUrl}equipment/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<ItemData> equipmentList = jsonResponse.map((json) => ItemData.fromJson(json)).toList();

      Map<String, ItemData> itemMap = {for (var equipment in equipmentList) equipment.id: equipment};

      return itemMap;
    } else {
      return {};
    }
  }

  //获取器材id列表
  Future<List<String>> getEquipmentIdList() async {
    final response = await http.get(
      Uri.parse('${baseApiUrl}equipment_ids/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<String> equipmentIds = jsonResponse.map((equipment) => equipment['id'].toString()).toList();
      return equipmentIds;
    } else {
      return [];
    }
  }

  // 创建器材对象
  Future<Response> createEquipment(Map<String, dynamic> equipmentData) async {
    final response = await http.post(
      Uri.parse('${baseApiUrl}equipment/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
      body: jsonEncode(equipmentData),
    );

    return response;
  }

  // 删除器材对象
  Future<Response> deleteEquipment(String equipmentId) async {
    final apiUrl = Uri.parse('${baseApiUrl}equipment/$equipmentId/');
    final response = await http.delete(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    return response;
  }

  // 获取器材对象
  Future<ItemData?> getEquipment(String equipmentId) async {
    final apiUrl = Uri.parse('${baseApiUrl}equipment/$equipmentId/');
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body);
      var item = ItemData.fromJson(jsonMap);
      return item;
    } else {
      return null;
    }
  }

  // 更新器材对象
  Future<Response> updateEquipment(ItemData updatedData) async {
    final apiUrl = Uri.parse('${baseApiUrl}equipment/${updatedData.id}/');
    final jsonData = json.encode(updatedData.toJsonMap());

    // 发起PATCH请求
    final response = await http.patch(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
      body: jsonData,
    );

    return response;
  }

  //借用器材
  Future<Response> borrowEquipment(String equipmentId, int borrowDeltaNum) async {
    final apiUrl = Uri.parse('${baseApiUrl}equipment/$equipmentId/borrow/');
    final response = await http.patch(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
      body: json.encode({'borrowDeltaNum': borrowDeltaNum}),
    );
    return response;
  }

  //搜索器材
  Future<List<ItemData>> searchEquipment(String query, String searchBy) async {
    final apiUrl = Uri.parse('${baseApiUrl}equipment_search/');

    // 构建查询参数
    final Map<String, String> queryParams = {
      'query': query,
      'search_by': searchBy,
    };

    final response = await http.get(
      apiUrl.replace(queryParameters: queryParams),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    List<ItemData> items = [];
    if (response.statusCode == 200) {
      items = (json.decode(response.body) as List).map((item) => ItemData.fromJson(item)).toList();
    } else {}
    return items;
  }

  // 获取借用记录对象
  Future<BorrowHistory?> getBorrowHistory(String borrowHistoryId) async {
    final apiUrl = Uri.parse('${baseApiUrl}borrow_history/$borrowHistoryId/');
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body);
      var borrowHistory = BorrowHistory.fromJson(jsonMap);
      return borrowHistory;
    } else {
      return null;
    }
  }

  //搜索借用记录
  Future<List<BorrowHistory>> searchBorrowHistory(String query, String searchBy) async {
    final apiUrl = Uri.parse('${baseApiUrl}borrow_history_search/');

    // 构建查询参数
    final Map<String, String> queryParams = {
      'query': query,
      'search_by': searchBy,
    };

    final response = await http.get(
      apiUrl.replace(queryParameters: queryParams),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
    );

    List<BorrowHistory> items = [];
    if (response.statusCode == 200) {
      items = (json.decode(response.body) as List).map((item) => BorrowHistory.fromJson(item)).toList();
    } else {}
    return items;
  }

  //归还器材
  Future<Response> returnEquipment(String historyId, int returnNum) async {
    final url = Uri.parse('${baseApiUrl}equipment_return/');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': authorization,
    };
    final body = jsonEncode(<String, dynamic>{
      'historyId': historyId,
      'returnNum': returnNum,
    });

    final response = await http.patch(url, headers: headers, body: body);

    return response;
  }

  //归还全部器材
  Future<Response> returnAllEquipment(String historyId) async {
    final url = Uri.parse('${baseApiUrl}equipment_return_all/');
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': authorization,
    };
    final body = jsonEncode(<String, dynamic>{
      'historyId': historyId,
    });

    final response = await http.patch(url, headers: headers, body: body);

    return response;
  }
}
