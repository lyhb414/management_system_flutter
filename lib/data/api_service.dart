// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'data.dart';

class ApiService {
  ApiService._privateConstructor();
  static final ApiService instance = ApiService._privateConstructor();

  final String baseApiUrl1 = "http://";
  final String baseApiUrl2 = ":8888/api/";
  String username = '';
  String password = '';
  String IP = '222.20.94.12';
  static const String DefaultIp = '222.20.94.12';
  String get authorization => 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  //用户注册
  Future<Response> register(String username, String password, String name) {
    final url = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}register/');
    final body = jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'first_name': name,
    });

    return http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
  }

  //登录验证用户名密码
  Future<Response> checkCredentials(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}check_credentials/'),
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

  //授予管理员权限
  Future<Response> promoteToAdmin(String username) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}promote_to_admin/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    return response;
  }

  //取消管理员资格
  Future<Response> demoteFromAdmin(String username) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}demote_from_admin/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    return response;
  }

  //判断自己是否为管理员
  Future<bool> checkAdmin() async {
    final response = await http.get(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}check_admin/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['is_admin'];
    } else {
      return false;
    }
  }

  //授予成员权限
  Future<Response> promoteToMember(String username) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}promote_to_member/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    return response;
  }

  //取消用户资格
  Future<Response> demoteFromMember(String username) async {
    final response = await http.post(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}demote_from_member/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    return response;
  }

  //判断自己是否有成员权限
  Future<bool> checkMember() async {
    final response = await http.get(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}check_member/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['is_admin'];
    } else {
      return false;
    }
  }

  //登出
  void Logout() {
    username = '';
    password = '';
  }

  //获取用户姓名
  Future<String> getFirstName(String username) async {
    final response = await http.get(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}get_first_name/$username/'),
      headers: {
        'Content-Type': 'application/json, charset=UTF-8',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['first_name'];
    } else {
      return '';
    }
  }

  //更改用户姓名
  Future<Response> updateFirstName(String username, String firstname) async {
    final body = jsonEncode(<String, dynamic>{
      'firstname': firstname,
    });

    final response = await http.put(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}update_first_name/$username/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authorization,
      },
      body: body,
    );

    return response;
  }

  //获取器材id列表
  Future<List<String>> getEquipmentIdList() async {
    final response = await http.get(
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment_ids/'),
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
      Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment/'),
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
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment/$equipmentId/');
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
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment/$equipmentId/');
    final response = await http.get(
      apiUrl,
      headers: {
        'Content-Type': 'application/json, charset=UTF-8',
        'Authorization': authorization,
      },
    );

    if (response.statusCode == 200) {
      var jsonMap = json.decode(utf8.decode(response.bodyBytes));
      var item = ItemData.fromJson(jsonMap);
      return item;
    } else {
      return null;
    }
  }

  //编辑器材对象
  Future<Response> updateEquipment(Map<String, dynamic> updatedData) async {
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment/${updatedData['id']}/');
    final jsonData = json.encode(updatedData);

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
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment/$equipmentId/borrow/');
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
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment_search/');

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

  //搜索器材修改记录
  Future<List<EquipmentModification>> searchEquipmentModification(String query, String searchBy) async {
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment_modification_search/');

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

    List<EquipmentModification> items = [];
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      items = (decodedResponse as List).map((item) => EquipmentModification.fromJson(item)).toList();
    } else {}
    return items;
  }

  // 获取借用记录对象
  Future<BorrowHistory?> getBorrowHistory(String borrowHistoryId) async {
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}borrow_history/$borrowHistoryId/');
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
    final apiUrl = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}borrow_history_search/');

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
    final url = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment_return/');
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
    final url = Uri.parse('$baseApiUrl1$IP${baseApiUrl2}equipment_return_all/');
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
