import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_lawer/common/list_item.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/common/service_list_item.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/page/enterprise/project_%20proposer_detail.dart';
import 'package:super_lawer/page/enterprise/project_lawer_detail.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/service/file_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:super_lawer/util/number_util.dart';

class ProjectDetailPage extends StatefulWidget {
  ProjectDetailPage({Key? key, required this.arguments}) : super(key: key);
  Map arguments;

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  List<Widget> _list = [];
  late File _image;
  bool _visible = false;

  Future getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _visible = true;
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _list.add(const SizedBox(
      height: 20,
    ));
    _getDetail();
  }

  bool _show = false;
  _getDetail() async {
    RResponse rResponse =
        await EnterpeiseService.getProjectDetail(widget.arguments['id']);
    if (rResponse.code == 1) {
      _list.removeRange(1, _list.length);
      Map r = rResponse.data['proj_detail'];
      setState(() {
        _list.add(ListItem(message: "项目名称", widget: Text(r["project_name"])));
        _list.add(ListItem(message: "项目类型", widget: const Text('法律咨询')));
        _list.add(ListItem(
          message: "申请人",
          widget: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProposerDetailPage(proposerInfo: r['enterprise'])));
            },
            child: Text(
              r['from_name'],
              style:
                  const TextStyle(color: Colors.blue, letterSpacing: 3, fontSize: 18),
            ),
          ),
        ));
        if (r['status'] == 2 || r['status'] == 3) {
          _list.add(ListItem(
              message: "承接人",
              widget: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LawerInfoPage(map: r['lawer'])));
                  },
                  child: Text(
                    "${r["lawer"]['real_name']}",
                    style: const TextStyle(
                        color: Colors.blue, letterSpacing: 3, fontSize: 18),
                  ))));
        }
        _list.add(ListItem(
            message: "申请时间",
            widget: Text(transferTimeStamp(r['commit_time'].toString()))));
        _list.add(ListItem(
            message: "结束时间",
            widget: Text(transferTimeStamp(r['end_time'].toString()))));
        _list.add(ListItem(
            message: "服务方案",
            widget: InkWell(
              onTap: () {
                setState(() {
                  _show = !_show;
                });
              },
              child: Icon(
                _show
                    ? Icons.arrow_drop_up_outlined
                    : Icons.arrow_drop_down_outlined,
                size: 40,
              ),
            )));
        _list.add(!_show
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceListItem(
                    message: "服务等级",
                    widget: Text(
                      "${r['service']['level']}",
                    ),
                  ),
                  ServiceListItem(
                    message: "服务价格",
                    widget: Text(
                      "${r['service']['price']}/月",
                    ),
                  ),
                  ServiceListItem(
                    message: "服务名称",
                    widget: Text(
                      "${r['service']['service_name']}",
                    ),
                  ),
                  ServiceListItem(
                    message: "服务内容",
                    widget: Text(
                      "${r['service']['service_content']}",
                    ),
                  ),
                ],
              ));
        String status = "管理审核中";
        switch (r['status']) {
          case -1:
            status = "已拒绝";
            break;
          case 1:
            status = "律师审核中";
            break;
          case 2:
            status = "进行中";
            break;
          case 3:
            status = "已结束";
            break;
        }
        _list.add(ListItem(message: "项目状态", widget: Text(status)));
        _list.add(ListItem(message: "项目具体内容", widget: const Text("")));
        _list.add(Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.black.withOpacity(0.5)),
              ),
              child: Text(
                r["project_content"],
                maxLines: 13,
              )),
        ));
        _list.add(ListItem(
            message: "项目文档",
            widget: const InkWell(child: Icon(Icons.arrow_forward_ios))));

        if (r['status'] == 2 || r['status'] == 3) {
          _list.add(ListItem(
              message: "项目费用",
              widget: Text("${r["total_money"].toString()}元")));
          _list.add(ListItem(
              message: "是否支付", widget: Text(r["is_payment"] ? '是' : '否')));
          if (r["pay_picture_url"] != null && r["pay_picture_url"].length > 0) {
            _list.add(ListItem(
                message: "支付状态",
                widget: Text(r["is_payment"] ? '审核通过' : '待审核')));
            _list.add(ListItem(message: "支付证明:", widget: const Text("")));
            _list.add(Image.network(
              r['pay_picture_url'],
              width: transferWidth(250),
              height: transferlength(250),
              fit: BoxFit.contain,
            ));
          } else {
            _list.add(const SizedBox(
              height: 20,
            ));
            _list.add(Container(
              width: double.infinity,
              height: transferlength(45),
              margin: EdgeInsets.symmetric(
                  horizontal:
                      transferWidth(MediaQuery.of(context).size.width / 6)),
              child: RaisedButton(
                onPressed: () async {
                  if (!_visible) {
                    getImage();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => LoadingDialog());
                    RResponse rResponse =
                        await FileService.uploadFile(_image.path);
                    rResponse = await EnterpeiseService.uploadCheck(
                        widget.arguments['id'], rResponse.data['url']);
                    Navigator.pop(context);
                    if (rResponse.code != 1) {
                      _showMessageDialog("处理失败,请重试");
                    } else {
                      Fluttertoast.showToast(
                          msg: "上传成功",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 17.0);
                    }
                  }
                },
                shape: const StadiumBorder(side: BorderSide.none),
                color: Colors.orange,
                child: Text(
                  _visible ? '提交' : '上传支付证明',
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ));
            _list.add(const SizedBox(
              height: 30,
            ));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getDetail();
    return Scaffold(
        appBar: AppBar(
          title: const Text("项目详情"),
          backgroundColor: Colors.orange.withOpacity(0.5),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: const Text('提示'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              color: Colors.grey,
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("确定"),
            ),
          ],
        );
      },
    );
  }
}
