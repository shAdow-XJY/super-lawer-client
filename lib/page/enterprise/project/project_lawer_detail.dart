/**
 * 认证信息页面,包含四个子页面
 * 1.展示
 * 2.展示
 * 3.申请
 * 4.申请
 */
import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_lawer/common/list_item.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/enterpeiseAuth.dart';
import 'package:super_lawer/model/lawerAuth.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/file_service.dart';
import 'package:super_lawer/service/user_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:super_lawer/util/number_util.dart';

class LawerInfoPage extends StatefulWidget {
  LawerInfoPage({Key? key, required this.map}) : super(key: key);
  Map<String, dynamic> map;
  @override
  _LawerInfoPage createState() => _LawerInfoPage();
}

class _LawerInfoPage extends State<LawerInfoPage> {
  TextEditingController mController = TextEditingController();
  late RResponse response;
  @override
  void initState() {
    super.initState();
    response = RResponse(code: 1, message: "", data: widget.map);
    //print(widget.map);
  }

  @override
  Widget build(BuildContext context) {
    return _LawerWidget();
  }

  _LawerWidget() {
    List<Widget> _list = [];
    _list.add(const SizedBox(
      height: 15,
    ));
    _list.add(ListItem(
        message: "承接人类型",
        widget: const Text(
          "律师",
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "认证时间",
        widget: Text(
          transferTimeStamp(response.data['auth_time'].toString()),
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "姓名",
        widget: Text(
          response.data['real_name'],
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "性别",
        widget: Text(
          response.data['sex'] == 0 ? "男" : "女",
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "身份证号",
        widget: Text(
          response.data['id_number'],
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "身份证正面:", widget: const Text("")));
    _list.add(Image.network(
      response.data['idcard_front'],
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    _list.add(ListItem(message: "身份证背面:", widget: const Text("")));
    _list.add(Image.network(
      response.data['idcard_back'],
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    _list.add(ListItem(message: "律师营业资格证:", widget: const Text("")));
    _list.add(Image.network(
      response.data['business_license'],
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('承接人信息'),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }
}
