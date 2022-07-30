/**
 * 认证信息页面,包含四个子页面
 * 1.展示
 * 2.展示
 * 3.申请
 * 4.申请
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_lawer/common/list_item.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/enterpeiseAuth.dart';
import 'package:super_lawer/model/lawerAuth.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/file_service.dart';
import 'package:super_lawer/service/user_service.dart';
import 'package:super_lawer/util/number_util.dart';

import 'apply_enterprise.dart';
import 'apply_lawer.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController mController = TextEditingController();
  int type = -1;
  late RResponse response;

  @override
  void initState() {
    super.initState();
    getAuthInfo();
  }

  getAuthInfo() async {
    RResponse rResponse = await UserService.checkAuthInfo();
    response = rResponse;
    setState(() {
      if (rResponse.data["auth_type"] == "enterprise") {
        type = 1;
      } else if (rResponse.data["auth_type"] == "lawer") {
        type = 2;
      } else {
        type = 0;
      }
    });
  }

  int groupValue = 0;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 0:
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.orange,
            brightness: Brightness.light,
            title: const Text('认证申请'),
          ),
          body: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "认证类型:     ",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    "企业",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 0,
                      groupValue: groupValue,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value as int;
                        });
                      }),
                  const Text(
                    "律师",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 1,
                      groupValue: groupValue,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value as int;
                        });
                      }),
                ],
              ),
              groupValue == 0 ? const ApplyEnterprise() : const ApplyLawer()
            ],
          ),
        );
      case 1:
        return _EnterpeiseWidget();
      case 2:
        return _LawerWidget();
      default:
        return Scaffold(
          body: LoadingDialog(),
        );
    }
  }



  _LawerWidget() {
    List<Widget> _list = [];
    _list.add(const SizedBox(
      height: 15,
    ));
    LawerAuth lawerAuth = response.data["lawer"];
    _list.add(ListItem(
        message: "认证类型",
        widget: const Text(
          "律师",
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "认证状态",
        widget: Text(
          lawerAuth.authStatus!,
          style: const TextStyle(fontSize: 17),
        )));
    if (lawerAuth.authStatus == "认证完成") {
      _list.add(ListItem(
          message: "认证时间",
          widget: Text(
            lawerAuth.authTime!,
            style: const TextStyle(fontSize: 17),
          )));
    } else {
      _list.add(ListItem(
          message: "认证申请时间",
          widget: Text(
            lawerAuth.authTime!,
            style: const TextStyle(fontSize: 17),
          )));
    }
    _list.add(ListItem(
        message: "姓名",
        widget: Text(
          lawerAuth.realName!,
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "性别",
        widget: Text(
          lawerAuth.sex!,
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "身份证号",
        widget: Text(
          lawerAuth.idNumber!,
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "身份证正面:", widget: const Text("")));
    _list.add(Image.network(
      lawerAuth.idcardFrontUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    _list.add(ListItem(message: "身份证背面:", widget: const Text("")));
    _list.add(Image.network(
      lawerAuth.idcardBackUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    _list.add(ListItem(message: "律师营业资格证:", widget: const Text("")));
    _list.add(Image.network(
      lawerAuth.businessLicenseUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('认证信息'),
        ),
        body: ListView.builder(
            itemCount: _list.length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }),

    );
  }

  _EnterpeiseWidget() {
    List<Widget> _list = [];
    _list.add(const SizedBox(
      height: 15,
    ));
    EnterpeiseAuth enterpeiseAuth = response.data["enterpeise"];
    _list.add(ListItem(
        message: "认证类型",
        widget: const Text(
          "企业",
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "认证状态",
        widget: Text(
          enterpeiseAuth.authStatus!,
          style: const TextStyle(fontSize: 17),
        )));
    if (enterpeiseAuth.authStatus == "认证完成") {
      _list.add(ListItem(
          message: "认证时间",
          widget: Text(
            enterpeiseAuth.authTime!,
            style: const TextStyle(fontSize: 15),
          )));
    } else {
      _list.add(ListItem(
          message: "认证申请时间",
          widget: Text(
            enterpeiseAuth.authTime!,
            style: const TextStyle(fontSize: 15),
          )));
    }
    _list.add(ListItem(
        message: "企业名称",
        widget: Text(
          enterpeiseAuth.enterpriseName!,
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业地址",
        widget: Text(
          enterpeiseAuth.enterpriseAdd!,
          style: const TextStyle(fontSize: 15),
        )));
    _list.add(ListItem(
        message: "企业代码",
        widget: Text(
          enterpeiseAuth.institutionCode!,
          style: const TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "企业经营执照:", widget: const Text("")));
    _list.add(Image.network(
      enterpeiseAuth.businessLicenseUrl!,
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('认证信息'),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }
}
