import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_lawer/common/loading_diglog.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/login_service.dart';

class ForgetPwdPage extends StatefulWidget {
  @override
  _ForgetPwdPage createState() => _ForgetPwdPage();
}

class _ForgetPwdPage extends State<ForgetPwdPage> {
  bool isButtonEnable = true; //按钮状态  是否可点击
  String buttonText = '发送验证码'; //初始文本
  int count = 60; //初始倒计时时间
  late Timer timer; //倒计时的计时器
  TextEditingController mController = TextEditingController();

  final GlobalKey<FormState> _passport_form_key = GlobalKey<FormState>();
  String _passport = '';
  String _code = '';

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

  @override
  void initState() {
    super.initState();
  }

  void _initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        count--;
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          buttonText = '发送验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  @override
  void dispose() {
    if (timer.isActive) timer.cancel(); //销毁计时器
    super.dispose();
  }

  void _buttonClickListen() async {
    if (isButtonEnable) {
      //当按钮可点击时
      final form = _passport_form_key.currentState;
      form!.save();
      showDialog(
          context: context,
          builder: (context) {
            return LoadingDialog();
          });
      RResponse response = await LoginService.forgetPwd(passport: _passport);
      Navigator.pop(context);
      _showMessageDialog(response.message);
      if (response.code != 1) return;
      setState(() {
        isButtonEnable = false; //按钮状态标记
        _initTimer();
      });
      return null; //返回null按钮禁止点击

    }
    return null;
  }

  onsubmit() async {
    final phoneform = _passport_form_key.currentState;
    if (phoneform!.validate()) {
      phoneform.save();
      showDialog(context: context, builder: (context) => LoadingDialog());
      RResponse rResponse =
          await LoginService.checkCode(passport: _passport, checkCode: _code);
      Navigator.pop(context);
      if (rResponse.code != 1) {
        _showMessageDialog(rResponse.message);
      } else {
        Navigator.pushNamed(context, "/forget/pwd/change",
            arguments: {"passport": _passport});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final passport = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => _passport = val!.trim(),
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '用户通行证不可为空';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: '请输入用户通行证',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          brightness: Brightness.light,
          title: const Text('忘记密码'),
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
                        passport,
                        Container(
                          // height: 70,
                          color: Colors.white,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: <Widget>[
                              Expanded(
                                  child: TextFormField(
                                keyboardType: TextInputType.number,
                                // maxLines: 6,
                                // maxLength: 1,
                                onSaved: (value) =>
                                    _code = value!.trim(),
                                validator: (value) {
                                  if (value!.length != 4) {
                                    return '验证码为4位数';
                                  }
                                  return null;
                                },
                                controller: mController,
                                textAlign: TextAlign.left,
                                // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(6)],
                                decoration: InputDecoration(
                                  hintText: ('填写验证码'),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  // contentPadding: EdgeInsets.only(top: -5,bottom: 0),
                                  hintStyle: const TextStyle(
                                    color: Color(0xff999999),
                                    fontSize: 13,
                                  ),
                                  alignLabelWithHint: true,
                                  // border: OutlineInputBorder(borderSide: BorderSide.none),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                ),
                              )),
                              Container(
                                margin: const EdgeInsets.only(left: 20),
                                width: 120,
                                child: FlatButton(
                                  disabledColor: Colors.grey
                                      .withOpacity(0.1), //按钮禁用时的颜色
                                  disabledTextColor:
                                      Colors.white, //按钮禁用时的文本颜色
                                  textColor: isButtonEnable
                                      ? Colors.white
                                      : Colors.black
                                          .withOpacity(0.2), //文本颜色
                                  color: isButtonEnable
                                      ? const Color(0xff44c5fe)
                                      : Colors.grey
                                          .withOpacity(0.1), //按钮的颜色
                                  splashColor: isButtonEnable
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.transparent,
                                  shape:
                                      const StadiumBorder(side: BorderSide.none),
                                  onPressed: () {
                                    setState(() {
                                      _buttonClickListen();
                                    });
                                  },
                                  //                        child: Text('重新发送 (${secondSy})'),
                                  child: Text(
                                    buttonText,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                      '确定',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            )));
  }
}
