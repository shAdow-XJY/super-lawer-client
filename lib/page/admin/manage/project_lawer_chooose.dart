import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/admin_service.dart';
import 'package:super_lawer/util/number_util.dart';

class ChooseLawerPage extends StatefulWidget {
  final Map arguments;
  ChooseLawerPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _ChooseLawerState createState() => _ChooseLawerState();
}

class _ChooseLawerState extends State<ChooseLawerPage> {
  List<Widget> _lawerData = [];
  int _lawerId = -1;

  @override
  void initState() {
    super.initState();
    _getLawerData();
  }

  _getLawerData() async {
    RResponse rResponse = await AdminService.listLawers();
    if (rResponse.code == 1) {
      _lawerData = [];
      for (var item in rResponse.data['lawers']) {
        this.setState(() {
          _lawerData.add(_LawerItem(item['id'], item['nickname']));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLawerData();
    return Scaffold(
        appBar: AppBar(
          title: Text("律师分配"),
          backgroundColor: Colors.orange.withOpacity(0.5),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "请为此项目分配律师,目前律所拥有的律师如下列表所示:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: _lawerData,
            ),
            SizedBox(
              height: transferlength(450),
            ),
            Container(
              width: double.infinity,
              height: transferlength(45),
              margin: EdgeInsets.symmetric(
                  horizontal:
                      transferWidth(MediaQuery.of(context).size.width / 10)),
              child: RaisedButton(
                onPressed: () async {
                  if (_lawerId == -1) {
                    _showMessageDialog("请选择项目律师");
                    return;
                  }
                  showDialog(
                      context: context, builder: (context) => LoadingDialog());
                  RResponse rResponse = await AdminService.handleProject(
                      widget.arguments['id'], true, _lawerId);
                  Navigator.pop(context);
                  if (rResponse.code != 1) {
                    _showMessageDialog("处理失败,请重试");
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
                    Navigator.pop(context);
                  }
                },
                shape: StadiumBorder(side: BorderSide.none),
                color: Colors.orange,
                child: Text(
                  '确认分配',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            )
          ],
        ));
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

  _LawerItem(int id, String serviceName) {
    return Row(
      children: [
        Radio(
            value: id,
            groupValue: _lawerId,
            activeColor: Colors.orange,
            onChanged: (value) {
              this.setState(() {
                _lawerId = value as int;
              });
            }),
        Text(
          serviceName,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}
