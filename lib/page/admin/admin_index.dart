import 'package:flutter/material.dart';
import 'package:super_lawer/page/admin/admin_bussiness.dart';
import 'package:super_lawer/page/admin/admin_my.dart';
import 'package:super_lawer/page/public/message.dart';

class AdminIndexPage extends StatefulWidget {
  Map arguments;

  AdminIndexPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _AdminIndexState createState() => _AdminIndexState();
}

class _AdminIndexState extends State<AdminIndexPage> {
  final List<BottomNavigationBarItem> _bottomNavBarItemList = [];
  int _currntIndex = 0;
  late final List _pageList = [];
  @override
  void initState() {
    super.initState();
    Map<String, String> bottomNames = {"message": "业务", "my": "我的"};
    bottomNames.forEach((key, value) {
      _bottomNavBarItemList.add(_bottomNavBarItem(key, value));
    });
    print(widget.arguments);
    _pageList.addAll(
        [const AdminBussinesspage(), AdminMyPage(userInfo: widget.arguments)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("超级律师"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: _pageList[_currntIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: _onTabClick,
          currentIndex: _currntIndex,
          type: BottomNavigationBarType.fixed,
          items: _bottomNavBarItemList),
    );
  }

  BottomNavigationBarItem _bottomNavBarItem(String key, String value) {
    return BottomNavigationBarItem(
      activeIcon: Opacity(
        opacity: 0.5,
        child: Image.asset("assets/images/public/index/${key}_active.png",
            width: 32, height: 32, fit: BoxFit.cover),
      ),
      label: value,
      icon: Image.asset("assets/images/public/index/$key.png",
          width: 32, height: 32, fit: BoxFit.cover),
    );
  }

  void _onTabClick(int value) {
    setState(() {
      _currntIndex = value;
    });
  }
}
