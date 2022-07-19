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
            backgroundColor: Colors.orange.withOpacity(0.5),
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
              groupValue == 0 ? _EnterpeiseAuth() : _LawerAuth()
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

  /*
  *企业申请认证页
  */
  late File _EImage;
  bool _eVisible = true;
  _EnterpeiseAuth() {
    // 提交
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String enterprise_add = '';
    String enterprise_name = '';
    String institution_code = '';

    Future getImage() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _EImage = File(pickedFile.path);
          _eVisible = false;
        } else {
          debugPrint('No image selected.');
        }
      });
    }

    onsubmit() async {
      if (_eVisible) {
        _showMessageDialog("企业营业执照不允许为空");
        return;
      }
      final form = _formKey.currentState;
      if (form!.validate()) {
        form.save();
        showDialog(context: context, builder: (context) => LoadingDialog());
        RResponse rResponse = await FileService.uploadFile(_EImage.path);
        if (rResponse.code != 1) {
          Navigator.pop(context);
          _showMessageDialog("文件上传发生错误,请重试");
          return;
        }
        rResponse = await UserService.authEnterpeise(rResponse.data['url'],
            enterprise_name, enterprise_add, institution_code);
        if (rResponse.code != 1) {
          Navigator.pop(context);
          _showMessageDialog("认证失败,请重试");
          return;
        }
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "认证申请提交成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.popAndPushNamed(context, "/auth");
      }
    }

    final enterpriseName = TextFormField(
        keyboardType: TextInputType.name,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => enterprise_name = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '请输入完整的企业名';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: '企业名',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final institutionCode = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => institution_code = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '企业代码不可为空';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: '企业代码',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    final enterpriseAdd = TextFormField(
        keyboardType: TextInputType.number,
        autofocus: false,
        initialValue: '',
        onSaved: (val) => enterprise_add = val!,
        // onEditingComplete: () => {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '企业地址不可为空';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: '企业地址',
            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
    return Form(
      key: _formKey,
      child: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "企业营业执照:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 200,
                child: InkWell(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: _eVisible
                        ? Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                "assets/images/public/index/upload.png",
                                width: transferWidth(30),
                                height: transferlength(30),
                                fit: BoxFit.contain),
                          )
                        : Image.file(_EImage,
                            width: MediaQuery.of(context).size.width / 2,
                            height: transferlength(200),
                            fit: BoxFit.contain),
                  ),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: enterpriseName),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: enterpriseAdd),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: institutionCode),
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
                    '认证',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  /*
  *律师申请认证页
  */
  late File _idFront;
  late File _idBack;
  late File _bussinessImage;
  bool _lVisible1 = true;
  bool _lVisible2 = true;
  bool _lVisible3 = true;
  String degree = '未接受教育';
  int sex = 0;
  // 提交
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String id_number = '';
  String real_name = '';

  int working_time = 0;

  Future getIdFrontImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _idFront = File(pickedFile.path);
        _lVisible1 = false;
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future getIdbackImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _idBack = File(pickedFile.path);
        _lVisible2 = false;
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future getBussinessImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _bussinessImage = File(pickedFile.path);
        _lVisible3 = false;
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  onsubmit() async {
    if (_lVisible1) {
      _showMessageDialog("身份证正面不允许为空");
      return;
    }
    if (_lVisible2) {
      _showMessageDialog("身份证反面不允许为空");
      return;
    }
    if (_lVisible3) {
      _showMessageDialog("执业资格证不允许为空");
      return;
    }
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      showDialog(context: context, builder: (context) => LoadingDialog());
      //todo
      // TODO: 上传速度过慢,有时间改成并行化操作
      RResponse r1 = await FileService.uploadFile(_idFront.path);
      RResponse r2 = await FileService.uploadFile(_idBack.path);
      RResponse r3 = await FileService.uploadFile(_bussinessImage.path);

      if (r1.code != 1 || r2.code != 1 || r3.code != 1) {
        Navigator.pop(context);
        _showMessageDialog("文件上传失败,请重试");
        return;
      }
      RResponse rResponse = await UserService.authlawer(
          r3.data['url'],
          degree,
          id_number,
          r2.data['url'],
          r1.data['url'],
          real_name,
          sex,
          working_time);
      Navigator.pop(context);
      if (rResponse.code == 1) {
        Fluttertoast.showToast(
            msg: "认证申请提交成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 17.0);
        Navigator.popAndPushNamed(context, "/auth");
      } else {
        _showMessageDialog("认证申请失败,请重试");
      }
    }
  }

  _LawerAuth() {
    return Form(
      key: _formKey,
      child: Container(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: TextFormField(
                      initialValue: real_name,
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      onSaved: (val) => real_name = val!,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '名字不能为空';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: '真实姓名',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: TextFormField(
                      initialValue: id_number,
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      onSaved: (val) => id_number = val!,
                      validator: (value) {
                        if (!checkIdNumber(value!)) {
                          return '身份证号码格式错误';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: '身份证号',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      )
                  )
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "性别:   ",
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    "男",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 0,
                      groupValue: sex,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          sex = value as int;
                        });
                      }),
                  const Text(
                    "女",
                    style: TextStyle(fontSize: 20),
                  ),
                  Radio(
                      value: 1,
                      groupValue: sex,
                      activeColor: Colors.orange,
                      onChanged: (value) {
                        setState(() {
                          sex = value as int;
                        });
                      }),
                ],
              ),
              //added
              Row(
                children: [
                  const Text(
                    "学位:   ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                      width: 130.0,
                      child: DropdownButton<String>(
                        value: degree,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.white,
                        underline: const SizedBox(),
                        onChanged: (newValue) {
                          setState(() {
                            degree = newValue!;
                          });
                        },
                        items: <String>['未接受教育', '小学', '高中', '本科', '硕士', '博士']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(fontSize: 19)),
                          );
                        }).toList(),
                      )),
                ],
              ),
              const Divider(),
              const Text(
                "身份证正面:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 200,
                child: InkWell(
                  onTap: () {
                    getIdFrontImage();
                  },
                  child: Center(
                    child: _lVisible1
                        ? Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                "assets/images/public/index/upload.png",
                                width: transferWidth(30),
                                height: transferlength(30),
                                fit: BoxFit.contain),
                          )
                        : Image.file(_idFront,
                            width: MediaQuery.of(context).size.width / 2,
                            height: transferlength(200),
                            fit: BoxFit.contain),
                  ),
                ),
              ),
              const Text(
                "身份证背面:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 200,
                child: InkWell(
                  onTap: () {
                    getIdbackImage();
                  },
                  child: Center(
                    child: _lVisible2
                        ? Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                "assets/images/public/index/upload.png",
                                width: transferWidth(30),
                                height: transferlength(30),
                                fit: BoxFit.contain),
                          )
                        : Image.file(_idBack,
                            width: MediaQuery.of(context).size.width / 2,
                            height: transferlength(200),
                            fit: BoxFit.contain),
                  ),
                ),
              ),
              const Text(
                "执业资格证:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 200,
                child: InkWell(
                  onTap: () {
                    getBussinessImage();
                  },
                  child: Center(
                    child: _lVisible3
                        ? Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                                "assets/images/public/index/upload.png",
                                width: transferWidth(30),
                                height: transferlength(30),
                                fit: BoxFit.contain),
                          )
                        : Image.file(_bussinessImage,
                            width: MediaQuery.of(context).size.width / 2,
                            height: transferlength(200),
                            fit: BoxFit.contain),
                  ),
                ),
              ),
              const Divider(),
              Container(
                width: double.infinity,
                height: 45,
                margin: const EdgeInsets.only(top: 20),
                child: RaisedButton(
                  onPressed: () {
                    onsubmit();
                  },
                  shape: const StadiumBorder(side: BorderSide.none),
                  color: const Color(0xff44c5fe),
                  child: const Text(
                    '认证',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
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
          backgroundColor: Colors.orange.withOpacity(0.5),
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
            style: const TextStyle(fontSize: 17),
          )));
    } else {
      _list.add(ListItem(
          message: "认证申请时间",
          widget: Text(
            enterpeiseAuth.authStatus!,
            style: const TextStyle(fontSize: 17),
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
          style: const TextStyle(fontSize: 17),
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
          backgroundColor: Colors.orange.withOpacity(0.5),
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
