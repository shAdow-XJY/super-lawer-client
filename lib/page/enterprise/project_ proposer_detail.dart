/**
 * 认证信息页面,包含四个子页面
 * 1.展示
 * 2.展示
 * 3.申请
 * 4.申请
 */

import 'package:flutter/material.dart';
import 'package:super_lawer/common/list_item.dart';
import 'package:super_lawer/model/enterpeiseAuth.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/util/date_util.dart';

import 'package:super_lawer/util/number_util.dart';

class ProposerDetailPage extends StatefulWidget {
  Map<String, dynamic> proposerInfo;
  ProposerDetailPage({Key? key, required this.proposerInfo}) : super(key: key);

  @override
  _ProposerDetailPage createState() => _ProposerDetailPage();
}

class _ProposerDetailPage extends State<ProposerDetailPage> {
  TextEditingController mController = TextEditingController();
  int type = -1;
  late RResponse response;
  @override
  void initState() {
    super.initState();
    print(widget.proposerInfo);
    response = RResponse(code: 1, message: "", data: widget.proposerInfo);
  }

  int groupValue = 0;
  @override
  Widget build(BuildContext context) {
    return _EnterpeiseWidget();
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text('提示'),
          content: new Text(message),
          actions: <Widget>[
            FlatButton(
              color: Colors.grey,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              child: Text("确定"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _EnterpeiseWidget() {
    List<Widget> _list = [];
    _list.add(SizedBox(
      height: 15,
    ));
    _list.add(ListItem(
        message: "申请人类型",
        widget: Text(
          "企业",
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "认证时间",
        widget: Text(
          transferTimeStamp(response.data['auth_time'].toString()),
          style: TextStyle(fontSize: 17),
        )));

    _list.add(ListItem(
        message: "企业名称",
        widget: Text(
          response.data['enterprise_name'],
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业地址",
        widget: Text(
          response.data['enterprise_add'],
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(
        message: "企业代码",
        widget: Text(
          response.data['institution_code'],
          style: TextStyle(fontSize: 17),
        )));
    _list.add(ListItem(message: "企业经营执照:", widget: Text("")));
    _list.add(Image.network(
      response.data['business_license'],
      width: transferWidth(250),
      height: transferlength(250),
      fit: BoxFit.contain,
    ));
    return Container(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange.withOpacity(0.5),
              brightness: Brightness.light,
              title: Text('申请人信息'),
            ),
            body: ListView.builder(
                itemCount: _list
                    .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
                itemBuilder: (content, index) {
                  return _list[index];
                })));
  }
}
