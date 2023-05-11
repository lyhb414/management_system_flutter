import 'package:flutter/material.dart';

class MultiFutureBuilder extends StatelessWidget {
  final List<Future> futures;
  final Function(BuildContext context, List<dynamic> data) builder;

  const MultiFutureBuilder({super.key, required this.futures, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(futures),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return builder(context, snapshot.data!);
          }
        }
      },
    );
  }
}
