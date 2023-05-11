// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button%20copy.dart';
import 'package:management_system_flutter/widget/login_input_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  String username = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册'),
      ),
      body: Padding(padding: const EdgeInsets.all(20.0), child: getBodyView()),
    );
  }

  Widget getBodyView() {
    return Center(
        child: Card(
            elevation: 5.0,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoginInputWidget(
                    hintText: '请输入用户名',
                    iconData: Icons.perm_identity,
                    onChanged: (String value) {
                      if (value.isNotEmpty) {
                        username = value;
                      } else {
                        username = '';
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  LoginInputWidget(
                    controller: _passwordController,
                    hintText: '请输入密码',
                    iconData: Icons.lock,
                    obscureText: true,
                    onChanged: (String value) {
                      if (value.isNotEmpty) {
                        password = value;
                      } else {
                        password = '';
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  LoginInputWidget(
                    controller: _confirmPasswordController,
                    hintText: '请再次输入密码',
                    iconData: Icons.lock,
                    obscureText: true,
                    onChanged: (String value) {
                      if (value.isNotEmpty) {
                        confirmPassword = value;
                      } else {
                        confirmPassword = '';
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  AwaitButton(
                    text: "注册",
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    fontSize: 16,
                    onPress: (() async {
                      if (username.isEmpty || password.isEmpty) {
                        PageUtil.instance.showSingleBtnDialog(context, "错误", "输入不能为空", () {});
                      } else if (password == confirmPassword) {
                        ApiService.instance.register(username, password).then((response) {
                          if (response.statusCode == 201) {
                            PageUtil.instance.showSingleBtnDialog(context, "通知", "注册成功", () {
                              Navigator.of(context).pop();
                            });
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", response.body, () {});
                          }
                        });
                      } else {
                        PageUtil.instance.showSingleBtnDialog(context, "错误", "两次输入的密码不一致。", () {});
                      }
                    }),
                  ),
                ],
              ),
            )));
  }
}
