import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../common/loading_diglog.dart';
import '../../common/show_message_dialog.dart';
import '../../model/response.dart';
import '../../service/file_service.dart';
import '../../service/user_service.dart';
import '../../util/number_util.dart';

class ApplyLawer extends StatefulWidget {
  const ApplyLawer({Key? key}) : super(key: key);

  @override
  _ApplyLawerState createState() => _ApplyLawerState();
}

class _ApplyLawerState extends State<ApplyLawer> {
  late RResponse response;

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    final form = _formKey.currentState;
    form?.save();

    if (_lVisible1) {
      showMessageDialog("身份证正面不允许为空",context);
      return;
    }
    if (_lVisible2) {
      showMessageDialog("身份证反面不允许为空",context);
      return;
    }
    if (_lVisible3) {
      showMessageDialog("执业资格证不允许为空",context);
      return;
    }

    if (form!.validate()) {
      showDialog(context: context, builder: (context) => LoadingDialog());
      //todo
      // TODO: 上传速度过慢,有时间改成并行化操作
      RResponse r1 = await FileService.uploadFile(_idFront.path);
      RResponse r2 = await FileService.uploadFile(_idBack.path);
      RResponse r3 = await FileService.uploadFile(_bussinessImage.path);

      if (r1.code != 1 || r2.code != 1 || r3.code != 1) {
        Navigator.pop(context);
        showMessageDialog("文件上传失败,请重试",context);
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
        showMessageDialog("认证申请失败,请重试",context);
      }
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
  
}