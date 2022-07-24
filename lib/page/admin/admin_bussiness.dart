import 'package:flutter/material.dart';

class AdminBussinesspage extends StatefulWidget {
  const AdminBussinesspage({Key? key}) : super(key: key);

  @override
  _AdminBussinesspageState createState() => _AdminBussinesspageState();
}

class _AdminBussinesspageState extends State<AdminBussinesspage> {
  List<Widget> _list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  initData() {
    _list.add(const SizedBox(
      height: 10,
    ));
    _list.add(_ListItem(
      leadingIcon: Icons.people,
      title: "认证申请管理",
      callback: () {
        Navigator.pushNamed(context, '/admin/manage/auth');
      },
    ));
    _list.add(_ListItem(
      leadingIcon: Icons.people,
      title: "项目审核",
      callback: () {
        Navigator.pushNamed(context, '/admin/manage/project');
      },
    ));
    _list.add(_ListItem(
      leadingIcon: Icons.people,
      title: "费用支付审核",
      callback: () {
        Navigator.pushNamed(context, '/admin/manage/project/fee-list');
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _list
            .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
        itemBuilder: (content, index) {
          return _list[index];
        });
  }
}

class _ListItem extends StatelessWidget {
  IconData leadingIcon;
  String title;
  dynamic callback;
  _ListItem(
      {Key? key, this.callback, required this.title, required this.leadingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              leadingIcon,
              size: 30,
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
