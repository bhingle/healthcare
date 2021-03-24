import 'package:flutter/material.dart';

class HospitalInfoView extends StatefulWidget {
  HospitalInfoView({Key key}) : super(key: key);

  @override
  _HospitalInfoViewState createState() => _HospitalInfoViewState();
}

class _HospitalInfoViewState extends State<HospitalInfoView> {
  List<String> entries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            child: Center(child: Text('Entry ${entries[index]}')),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
