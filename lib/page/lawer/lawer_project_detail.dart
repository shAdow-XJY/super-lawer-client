import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_lawer/common/list_item.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/common/service_list_item.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/service/lawer_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:super_lawer/util/number_util.dart';

import '../../common/show_message_dialog.dart';
import '../enterprise/project/project_ proposer_detail.dart';
import '../enterprise/project/project_lawer_detail.dart';

class LawerProjectDetailPage extends StatefulWidget {
  LawerProjectDetailPage({Key? key, required this.arguments}) : super(key: key);
  Map arguments;

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<LawerProjectDetailPage> {
  List<Widget> _list = [];

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
                  _getDetail();
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
      });
      _list.add(ListItem(
          message: "项目文档",
          widget: const InkWell(child: Icon(Icons.arrow_forward_ios))));

      if (r['status'] == 1) {
        _list.add(const SizedBox(
          height: 20,
        ));
        _list.add(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: transferWidth(MediaQuery.of(context).size.width / 3),
            height: transferlength(45),
            child: RaisedButton(
              onPressed: () async {
                showDialog(
                    context: context, builder: (context) => LoadingDialog());
                RResponse rResponse =
                    await LawerService.handleProject(widget.arguments['id'], 0);
                Navigator.pop(context);
                if (rResponse.code != 1) {
                  showMessageDialog("处理失败,请重试",context);
                } else {
                  Fluttertoast.showToast(
                      msg: "处理成功",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 17.0);
                  Navigator.pop(context);
                }
              },
              shape: const StadiumBorder(side: BorderSide.none),
              color: Colors.red.withOpacity(0.8),
              child: const Text(
                '拒绝',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            width: transferWidth(MediaQuery.of(context).size.width / 3),
            height: transferlength(45),
            child: RaisedButton(
              onPressed: () async {
                showDialog(
                    context: context, builder: (context) => LoadingDialog());
                RResponse rResponse =
                    await LawerService.handleProject(widget.arguments['id'], 1);
                Navigator.pop(context);
                if (rResponse.code != 1) {
                  showMessageDialog("处理失败,请重试",context);
                } else {
                  Fluttertoast.showToast(
                      msg: "处理成功",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 17.0);
                  Navigator.pop(context);
                }
              },
              shape: const StadiumBorder(side: BorderSide.none),
              color: Colors.green.withOpacity(0.7),
              child: const Text(
                '同意申请',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          )
        ]));
      } else if (r['status'] == 2 || r['status'] == 3) {
        _list.add(ListItem(
            message: "项目费用", widget: Text("${r["total_money"].toString()}元")));
        _list.add(ListItem(
            message: "是否支付", widget: Text(r["is_payment"] ? '是' : '否')));
        if (r["is_payment"]) {
          _list.add(ListItem(message: "支付证明", widget: const Text("")));
          _list.add(Image.network(
            r['pay_picture_url'],
            width: transferWidth(250),
            height: transferlength(250),
            fit: BoxFit.contain,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("项目详情"),
          backgroundColor: Colors.orange,
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }

}
