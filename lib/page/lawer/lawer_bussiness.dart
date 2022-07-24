import 'package:flutter/material.dart';
import 'package:super_lawer/page/lawer/lawer_project_list.dart';
import 'package:super_lawer/page/lawer/lawyer_case_list.dart';




class LawerBussinessPage extends StatefulWidget {
  const LawerBussinessPage({Key? key}) : super(key: key);
  @override
  _EnterpriseBussinessPageState createState() =>
      _EnterpriseBussinessPageState();
}

class _EnterpriseBussinessPageState extends State<LawerBussinessPage>
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
        backgroundColor: const Color(0xfffbfbfb),
        title: _TitleTabBar(
          tabController: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabContent,
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
            unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400), //设置未选中时的字体样式，tabs里面的字体样式优先级最高
            labelColor: Colors.black, //设置选中时的字体颜色，tabs里面的字体样式优先级最高
            labelStyle: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600), //设置选中时的字体样式，tabs里面的字体样式优先级最高
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            indicatorColor: Colors.white,
            tabs: _tabs,
            isScrollable: true,
            controller: widget.tabController,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}

List<Tab> _tabs = [
  const Tab(
    text: '法律咨询',
  ),
  const Tab(
    text: '案件管理',
  ),
];

List<Widget> _tabContent = [const LawerProjectListPage(), const LawerCaseListPage()];
