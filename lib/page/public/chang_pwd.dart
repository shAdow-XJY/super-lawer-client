import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/file_service.dart';
import 'package:super_lawer/service/login_service.dart';
import 'package:super_lawer/util/number_util.dart';

import '../../common/show_message_dialog.dart';

class ChangePwdPage extends StatefulWidget {
  Map arguments;
  ChangePwdPage({Key? key, required this.arguments}) : super(key: key);

  @override
  _ChangePwdPage createState() => _ChangePwdPage();
}

class _ChangePwdPage extends State<ChangePwdPage> {
  final GlobalKey<FormState> _passport_form_key = GlobalKey<FormState>();
  String _passport = '';
  String _rpassport = '';

  // 密码显示、隐藏
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  onsubmit() async {
    final phoneform = _passport_form_key.currentState;
    if (phoneform!.validate()) {
      phoneform.save();
      if (_passport != _rpassport) {
        showMessageDialog("两次输入的密码不一致,请重试",context);
        phoneform.reset();
        return;
      }
      showDialog(context: context, builder: (context) => LoadingDialog());
      RResponse rResponse = await LoginService.changePwd(
          passport: widget.arguments["passport"], pwd: _passport);
      Navigator.pop(context);
      if (rResponse.code != 1) {
        showMessageDialog(rResponse.message,context);
      } else {
        Fluttertoast.showToast(
            msg: "密码修改成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final password = TextFormField(
      autofocus: false,
      initialValue: '',
      onSaved: (val) => _passport = val!,
      obscureText: _isObscure,
      validator: (value) {
        if (value!.length < 6 || value.length > 16) {
          return '密码在6-16位数之间哦';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: '密码',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
              color: _eyeColor,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                _eyeColor = (_isObscure
                    ? Colors.grey
                    : Theme.of(context).iconTheme.color)!;
              });
            }),
      ),
    );
    final rpassword = TextFormField(
      autofocus: false,
      initialValue: '',
      onSaved: (val) => _rpassport = val!,
      obscureText: _isObscure,
      validator: (value) {
        if (value!.length < 6 || value.length > 16) {
          return '密码在6-16位数之间哦';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        hintText: '密码',
        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('修改密码'),
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Container(
                  color: Colors.white,
                  child: Form(
                    key: _passport_form_key,
                    child: Column(
                      children: [
                        password,
                        const SizedBox(
                          height: 10,
                        ),
                        rpassword
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: const EdgeInsets.only(top: 50),
                  child: RaisedButton(
                    onPressed: () {
                      onsubmit();
                    },
                    shape: const StadiumBorder(side: BorderSide.none),
                    color: const Color(0xff44c5fe),
                    child: const Text(
                      '确认修改',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            )));
  }
}
