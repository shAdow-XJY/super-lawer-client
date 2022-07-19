import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../common/loading_diglog.dart';
import '../../model/response.dart';
import '../../service/file_service.dart';
import '../../service/user_service.dart';
import '../../util/number_util.dart';

class ApplyEnterprise extends StatefulWidget {
  const ApplyEnterprise({Key? key}) : super(key: key);

  @override
  _ApplyEnterpriseState createState() => _ApplyEnterpriseState();
}

class _ApplyEnterpriseState extends State<ApplyEnterprise> {
  late RResponse response;

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




  @override
  Widget build(BuildContext context) {
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
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      initialValue: enterprise_name,
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
                              borderRadius: BorderRadius.circular(32.0))))
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      autofocus: false,
                      initialValue: enterprise_add,
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
                              borderRadius: BorderRadius.circular(32.0))))
              ),
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  color: Colors.white,
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      initialValue: institution_code,
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
                              borderRadius: BorderRadius.circular(32.0))))
              ),
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
  
}