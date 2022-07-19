import 'package:flutter/material.dart';
import 'package:super_lawer/page/admin/admin_index.dart';
import 'package:super_lawer/page/admin/manage/auth_detail.dart';
import 'package:super_lawer/page/admin/manage/auth_manage.dart';
import 'package:super_lawer/page/admin/manage/fee_detail.dart';
import 'package:super_lawer/page/admin/manage/fee_list.dart';
import 'package:super_lawer/page/admin/manage/project_detail.dart';
import 'package:super_lawer/page/admin/manage/project_handle.dart';
import 'package:super_lawer/page/admin/manage/project_lawer_chooose.dart';
import 'package:super_lawer/page/enterprise/create_project.dart';
import 'package:super_lawer/page/enterprise/project_detail.dart';
import 'package:super_lawer/page/lawer/lawer_project_detail.dart';
import 'package:super_lawer/page/public/auth.dart';
import 'package:super_lawer/page/public/chang_pwd.dart';
import 'package:super_lawer/page/public/chat.dart';
import 'package:super_lawer/page/public/forget_pwd.dart';
import 'package:super_lawer/page/public/index.dart';
import 'package:super_lawer/page/public/login.dart';
import 'package:super_lawer/page/public/personal_info.dart';
import 'package:super_lawer/page/public/register.dart';
import 'package:super_lawer/page/public/sys_msg.dart';
//需要引入跳转页面地址

// 配置路由
final routes = {
  // 前面是自己的命名 后面是加载的方法
  '/': (context) => LoginPage(), //不用传参的写法
  '/enterprise/project/create': (context) => CreateProjectPage(),
  '/enterprise/project/detail': (context, {arguments}) => ProjectDetailPage(
        arguments: arguments,
      ),
  '/lawer/project/detail': (context, {arguments}) => LawerProjectDetailPage(
        arguments: arguments,
      ),

  '/regisster': (context) => RegisterPage(),
  '/auth': (context) => AuthPage(),

  '/msg/chat': (context, {arguments}) => OverdueUrgeReplyPage(
        arguments: arguments,
      ),
  '/msg/sys': (context) => SysMsgPage(),

  '/admin/index': (context, {arguments}) => AdminIndexPage(
        arguments: arguments,
      ),
  '/admin/manage/auth': (context) => AuthManagePage(),
  '/admin/manage/auth/detail': (context, {arguments}) => AuthDetailPage(
        arguments: arguments,
      ),
  '/admin/manage/project': (context) => ProjectHandleListPage(),
  '/admin/manage/project/detail': (context, {arguments}) =>
      ProjectDetailHanlePage(arguments: arguments),
  '/admin/manage/project/choose-lawer': (context, {arguments}) =>
      ChooseLawerPage(arguments: arguments),
  '/admin/manage/project/fee-list': (context) => ProjectFeeHandleListPage(),
  '/admin/manage/project/fee-detail': (context, {arguments}) =>
      FeeDetailPage(arguments: arguments),

  '/personal/info': (context) => PersonalInfoPage(),

  '/forget/pwd': (context) => ForgetPwdPage(),
  '/forget/pwd/change': (context, {arguments}) =>
      ChangePwdPage(arguments: arguments),

  '/index': (context, {arguments}) => IndexPage(arguments: arguments), //需要传参的写法
};

// 固定写法，统一处理，无需更改
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  if (name != null) {
    final Function? pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute(
            builder: (context) =>
                pageContentBuilder(context, arguments: settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute(
            builder: (context) => pageContentBuilder(context));
        return route;
      }
    }
  }
};
