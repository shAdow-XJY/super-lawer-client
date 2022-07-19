import 'package:flutter/material.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/user_service.dart';
import 'package:super_lawer/util/number_util.dart';

class MyPage extends StatefulWidget {
  Map userInfo;
  MyPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    RResponse r = await UserService.getNewInfo();
    if (r.code == 1) widget.userInfo = r.data;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        Container(
          height: height / 2.7,
          child: Stack(
            alignment: const AlignmentDirectional(0, 0.2),
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 0.5),
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius:
                          const BorderRadius.vertical(bottom: Radius.circular(25)))),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        height: height / 3.4,
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.white, width: 0.5),
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: ClipOval(
                                    child: Image.network(
                                  widget.userInfo["cover"],
                                  width: transferWidth(80),
                                  height: transferlength(80),
                                  fit: BoxFit.cover,
                                ))),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, top: 30),
                                  child: Text(
                                    widget.userInfo["nickname"],
                                    style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: SizedBox(
                                height: 80,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 10),
                                  child: Column(
                                    children: [
                                      const Text(
                                        "认证状态",
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.black),
                                      ),
                                      Text(
                                        widget.userInfo["user_type"],
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "常用操作",
            style: TextStyle(fontSize: 30),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PersonalInfoButton(width: width),
                const SizedBox(
                  width: 15,
                ),
                _AuthButton(width: width),
              ],
            )),
        SizedBox(
          height: height / 7,
        ),
        _LogoutButton(width: width),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/auth");
      },
      child: Container(
        height: transferlength(80),
        width: width / 2.3,
        padding: const EdgeInsets.only(left: 5, top: 6),
        decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "认证申请",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Text("进行身份认证", style: TextStyle(color: Colors.grey))
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 4),
              child: Icon(
                Icons.format_align_center,
                size: 35,
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoButton extends StatelessWidget {
  const _PersonalInfoButton({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/personal/info");
      },
      child: Container(
        height: transferlength(80),
        width: width / 2.3,
        padding: const EdgeInsets.only(left: 5, top: 6),
        decoration: BoxDecoration(
            border:
                Border.all(color: Colors.grey.withOpacity(0.3), width: 0.5),
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "个人信息",
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                Text("查看个人信息", style: TextStyle(color: Colors.grey))
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 8.0, bottom: 4),
              child: Icon(
                Icons.settings,
                size: 35,
                color: Colors.orange,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: transferlength(45),
      margin: EdgeInsets.symmetric(horizontal: transferWidth(width / 10)),
      child: RaisedButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, "/");
        },
        shape: const StadiumBorder(side: BorderSide.none),
        color: Colors.orange,
        child: const Text(
          '退出登录',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }
}
