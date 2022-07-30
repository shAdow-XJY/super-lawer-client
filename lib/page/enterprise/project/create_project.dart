import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/util/number_util.dart';

import '../../../common/show_message_dialog.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({Key? key}) : super(key: key);

  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  // 提交
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _content = '';
  DateTime _endTime = DateTime.now();
  bool _visible = false;
  int _serviceIndex = -1;

  List<Widget> _servicedata = [];

  @override
  void initState() {
    super.initState();
    _getServiceData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getServiceData() async {
    RResponse rResponse = await EnterpeiseService.listServices();
    _servicedata = [];
    for (var item in rResponse.data['services']) {
      setState(() {
        _servicedata.add(_ServiceItem(item['service_name'],
            item['price'], item['service_content']));
      });
    }
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _endTime, //选中的日期
      firstDate: DateTime(1900), //日期选择器上可选择的最早日期
      lastDate: DateTime(2100), //日期选择器上可选择的最晚日期
    ).then((result) {
      setState(() {
        if (result != null) _endTime = result;
      });
    });
  }

  onsubmit() async {
    _formKey.currentState?.save();

    if (_name.isEmpty) {
      showMessageDialog("咨询名称为空",context);
      return;
    }
    if (_content.isEmpty) {
      showMessageDialog("咨询内容为空",context);
      return;
    }
    if (_serviceIndex == -1) {
      showMessageDialog("请选择服务方案",context);
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
        showMessageDialog(rResponse.message,context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('咨询申请'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const Text(
                    "咨询名称",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  TextFormField(
                      autofocus: false,
                      initialValue: _name,
                      onSaved: (val) => setState(() => _name = val!),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '请输入咨询名称';
                        }
                        return null;
                      },
                      maxLength: 30,
                      decoration: const InputDecoration(
                        hintText: '',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _visible = !_visible;
                      });
                    },
                    child: Row(
                      children: [
                        const Text(
                          "服务方案",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Icon(
                          !_visible
                              ? Icons.arrow_drop_down_outlined
                              : Icons.arrow_drop_up_outlined,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  _visible
                      ? Column(
                          //children: _servicedata,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _serviceIndex,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      setState(() {
                                        _serviceIndex = value as int;
                                      });
                                    }
                                ),
                                _servicedata[0]
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: _serviceIndex,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      setState(() {
                                        _serviceIndex = value as int;
                                      });
                                    }
                                ),
                                _servicedata[1]
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 3,
                                    groupValue: _serviceIndex,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      setState(() {
                                        _serviceIndex = value as int;
                                      });
                                    }
                                ),
                                _servicedata[2]
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        "结束日期",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          child: Text(
                            '${_endTime.year.toString()}年${_endTime.month.toString()}月${_endTime.day.toString()}日',
                            style:
                                const TextStyle(fontSize: 20, color: Colors.blue),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "咨询内容",
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                      autofocus: false,
                      initialValue: _content,
                      maxLines: 20,
                      maxLength: 1000,
                      onSaved: (val) => _content = val!,
                      validator: (value) {
                        if (value!.isEmpty) return '请输入咨询内容';
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: '请键入咨询内容',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(),
                      )
                  ),
                  const SizedBox(
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
                      shape: const StadiumBorder(side: BorderSide.none),
                      color: Colors.orange,
                      child: const Text(
                        '提交申请',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  )
                ],
              )),
        ));
  }

  Widget _ServiceItem(String serviceName, int price, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: transferlength(100),
              child: Text(
                "$price/月",
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              serviceName,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Text(
            "服务方案: $detail",
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
