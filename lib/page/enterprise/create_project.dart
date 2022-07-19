import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/util/number_util.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  // 提交
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _name = '';
  String _content = '';
  DateTime _endTime = DateTime.now();
  bool _visible = false;
  int _serviceIndex = -1;

  List<Widget> _servicedata = [];

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _endTime, //选中的日期
      firstDate: DateTime(1900), //日期选择器上可选择的最早日期
      lastDate: DateTime(2100), //日期选择器上可选择的最晚日期
    ).then((result) {
      this.setState(() {
        if (result != null) _endTime = result;
      });
    });
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

  @override
  void initState() {
    super.initState();
    _getServiceData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onsubmit() async {
    if (_serviceIndex == -1) {
      _showMessageDialog("请选择服务方案");
      return;
    }
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      showDialog(context: context, builder: (context) => LoadingDialog());
      RResponse rResponse = await EnterpeiseService.createProject(
          _name, _content, _serviceIndex, _endTime);
      Navigator.pop(context);
      if (rResponse.code == 1) {
        Fluttertoast.showToast(
            msg: "申请成功,正在返回",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.pop(context);
        return;
      } else {
        _showMessageDialog(rResponse.message);
      }
    }
  }

  _getServiceData() async {
    RResponse rResponse = await EnterpeiseService.listServices();
    _servicedata = [];
    for (var item in rResponse.data['services']) {
      this.setState(() {
        _servicedata.add(_ServiceItem(item['id'], item['service_name'],
            item['price'], item['service_content']));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getServiceData();
    final _name = new TextFormField(
        autofocus: false,
        initialValue: '',
        onSaved: (val) => this._name = val!,
        validator: (value) {
          if (value!.length == 0) {
            return '请输入咨询名称';
          }
          return null;
        },
        maxLength: 30,
        decoration: new InputDecoration(
          hintText: '',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ));
    final _content = new TextFormField(
        autofocus: false,
        initialValue: '',
        maxLines: 20,
        maxLength: 1000,
        onSaved: (val) => this._content = val!,
        validator: (value) {
          if (value!.length == 0) return '请输入咨询内容';
          return null;
        },
        decoration: new InputDecoration(
          hintText: '请键入咨询内容',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: new OutlineInputBorder(),
        ));
    return Container(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
            brightness: Brightness.light,
            title: Text('咨询申请'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Text(
                      "咨询名称",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    _name,
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "服务方案",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            this.setState(() {
                              _visible = !_visible;
                            });
                          },
                          child: Icon(
                            !_visible
                                ? Icons.arrow_drop_down_outlined
                                : Icons.arrow_drop_up_outlined,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                    _visible
                        ? Column(
                            children: _servicedata,
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "结束日期",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        TextButton(
                            onPressed: () {
                              _showDatePicker();
                            },
                            child: Text(
                              '${_endTime.year.toString()}年${_endTime.month.toString()}月${_endTime.day.toString()}日',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "咨询内容",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _content,
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: double.infinity,
                      height: transferlength(45),
                      margin: EdgeInsets.symmetric(
                          horizontal: transferWidth(
                              MediaQuery.of(context).size.width / 10)),
                      child: RaisedButton(
                        onPressed: () {
                          onsubmit();
                        },
                        shape: StadiumBorder(side: BorderSide.none),
                        color: Colors.orange,
                        child: Text(
                          '提交申请',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                )),
          )),
    );
  }

  Widget _ServiceItem(int id, String serviceName, int price, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio(
                value: id,
                groupValue: _serviceIndex,
                activeColor: Colors.orange,
                onChanged: (value) {
                  this.setState(() {
                    _serviceIndex = value as int;
                  });
                }),
            Container(
              width: transferlength(100),
              child: Text(
                "$price/月",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              serviceName,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: Text(
            "服务方案: " + detail,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
