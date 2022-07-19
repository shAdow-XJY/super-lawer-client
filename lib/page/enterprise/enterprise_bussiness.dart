import 'package:flutter/material.dart';
import 'package:super_lawer/page/enterprise/project_list.dart';
import 'package:super_lawer/page/public/auth.dart';

class EnterpriseBussinessPage extends StatefulWidget {
  const EnterpriseBussinessPage({Key? key}) : super(key: key);
  @override
  _EnterpriseBussinessPageState createState() =>
      _EnterpriseBussinessPageState();
}

class _EnterpriseBussinessPageState extends State<EnterpriseBussinessPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbfbfb),
        title: _TitleTabBar(
          tabController: this._tabController,
        ),
      ),
      body: TabBarView(
        children: _tabContent,
        controller: _tabController,
      ),
    );
  }
}

class _TitleTabBar extends StatefulWidget {
  final TabController tabController;

  _TitleTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  __TitleTabBarState createState() => __TitleTabBarState();
}

class __TitleTabBarState extends State<_TitleTabBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TabBar(
            unselectedLabelColor: Colors.grey, //设置未选中时的字体颜色，tabs里面的字体样式优先级最高
            unselectedLabelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400), //设置未选中时的字体样式，tabs里面的字体样式优先级最高
            labelColor: Colors.black, //设置选中时的字体颜色，tabs里面的字体样式优先级最高
            labelStyle: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600), //设置选中时的字体样式，tabs里面的字体样式优先级最高
            labelPadding: EdgeInsets.symmetric(horizontal: 16),
            indicatorColor: Colors.white,
            tabs: _tabs,
            isScrollable: true,
            controller: widget.tabController,
          ),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}

List<Tab> _tabs = [
  Tab(
    text: '法律咨询',
  ),
  Tab(
    text: '案件管理',
  ),
];

List<Widget> _tabContent = [ProjectListPage(), AuthPage()];