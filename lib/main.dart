import 'package:flutter/material.dart';

import 'package:management_system_flutter/page/list_page.dart';
import 'package:management_system_flutter/widget/login_input_widget.dart';
import 'package:management_system_flutter/widget/common_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                onChanged: (String value) {
                  //_userName = value;
                },
              ),
              const Padding(padding: EdgeInsets.all(10.0)),
              LoginInputWidget(
                hintText: '请输入密码',
                iconData: Icons.lock,
                obscureText: true,
                onChanged: (String value) {
                  //_userName = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      text: "登陆",
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 16,
                      onPress: (() {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return const ListPage();
                        }));
                      }),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CommonButton(
                      text: "注册",
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      fontSize: 16,
                      onPress: (() {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        //   return const ListPage();
                        // }));
                      }),
                    ),
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
