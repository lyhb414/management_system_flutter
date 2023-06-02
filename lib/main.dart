import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:management_system_flutter/data/api_service.dart';
import 'package:management_system_flutter/data/data.dart';
import 'package:management_system_flutter/page/home_page.dart';
import 'package:management_system_flutter/page/regester_page.dart';
import 'package:management_system_flutter/page/setIP_page.dart';
import 'package:management_system_flutter/utils/page_util.dart';
import 'package:management_system_flutter/widget/await_button.dart';
import 'package:management_system_flutter/widget/login_input_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '实验室器材管理系统'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var username = '';
  var password = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const SetIPPage();
              }));
            },
          ),
        ],
      ),
      body: getBodyView(),
    );
  }

  Widget getBodyView() {
    return Center(
      child: Card(
        elevation: 5.0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: SizedBox(
          height: 200,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoginInputWidget(
                hintText: '请输入用户名',
                iconData: Icons.perm_identity,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))],
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
              Row(
                children: [
                  Expanded(
                    child: AwaitButton(
                      text: "登录",
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 16,
                      onPress: (() async {
                        // username = 'user';
                        // password = '11112222';
                        ApiService.instance.checkCredentials(username, password).then((value) {
                          if (value.statusCode == 200) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                              return const HomePage();
                            }));
                          } else {
                            PageUtil.instance.showSingleBtnDialog(context, "错误", "用户名或密码错误", () {});
                          }
                        });
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AwaitButton(
                        text: "注册",
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        fontSize: 16,
                        onPress: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                            return const RegisterPage();
                          }));
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
