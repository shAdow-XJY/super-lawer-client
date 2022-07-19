import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_lawer/common/global_data.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/config/http/http_options.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/login_service.dart';
import 'package:super_lawer/util/number_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String errMsg = "";
  String _userID = "";
  String _password = "";
  bool _isChecked = true;

  IconData _checkIcon = Icons.check_box;

  void _changeFormToLogin() {
    _formKey.currentState!.reset();
  }

  Future<void> _onLogin() async {

    showDialog(
        context: context,
        builder: (context) {
          return LoadingDialog();
        });
    final form = _formKey.currentState;
    form!.save();

    if (!_isChecked) {
      Navigator.pop(context);
      _showMessageDialog('请勾选用户协议后再试');
      return;
    }

    if (_userID == '') {
      Navigator.pop(context);
      _showMessageDialog('账号不可为空');
      return;
    }
    if (_password == '') {
      Navigator.pop(context);
      _showMessageDialog('密码不可为空');
      return;
    }



    _userID = _userID.trim();
    _password = _password.trim();
    RResponse r = await LoginService.login(_userID, _password);
    Navigator.pop(context);
    if (r.code != 1) {
      setState(() {
        errMsg = r.message;
      });
    } else {
      errMsg = "";
      HttpOptions.token = r.data["token"];
      if (r.data["user_type"] != "管理员")
        Navigator.popAndPushNamed(context, "/index", arguments: r.data);
      else {
        //TODO 检查用户身份进行相应跳转
        Navigator.popAndPushNamed(context, "/admin/index", arguments: r.data);
      }
    }
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

  Widget _showPassportInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: const TextStyle(fontSize: 15),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '请输入帐号',
            icon: Icon(
              Icons.email,
              color: Colors.grey,
            )),
        onSaved: (value) => _userID = value!.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: const TextStyle(fontSize: 15),
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userWidth = MediaQuery.of(context).size.width;
    userLength = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: Text('SUPER-LAWER'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: 220,
              child: const Image(
                  image: AssetImage('assets/images/public/login/login.png')),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                          errMsg,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        _showPassportInput(),
                        Divider(
                          height: 0.5,
                          indent: 16.0,
                          color: Colors.grey[300],
                        ),
                        _showPasswordInput(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/regisster");
                    },
                    child: const Text('立即注册',
                        style: TextStyle(
                          color: Colors.orange,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/forget/pwd");
                    },
                    child: const Text('忘记密码',
                        style: TextStyle(
                          color: Colors.orange,
                        )),
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
              child: FlatButton(
                textColor: Colors.orange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.orange, width: 1),
                ),
                onPressed: () {
                  _onLogin();
                },
                child: const Text("登录"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 50, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(_checkIcon),
                      color: Colors.orange,
                      onPressed: () {
                        setState(() {
                          _isChecked = !_isChecked;
                          if (_isChecked) {
                            _checkIcon = Icons.check_box;
                          } else {
                            _checkIcon = Icons.check_box_outline_blank;
                          }
                        });
                      }),
                  Expanded(
                    child: RichText(
                        text: const TextSpan(
                            text: '我已经详细阅读并同意',
                            style: TextStyle(color: Colors.black, fontSize: 13),
                            children: <TextSpan>[
                          TextSpan(
                              text: '《隐私政策》',
                              style: TextStyle(
                                color: Colors.blue,
                              )),
                          TextSpan(text: '和'),
                          TextSpan(
                              text: '《用户协议》',
                              style: TextStyle(
                                color: Colors.blue,
                              ))
                        ])),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
