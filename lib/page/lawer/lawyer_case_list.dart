import 'package:flutter/material.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/lawer_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:group_button/group_button.dart';

class LawerCaseListPage extends StatefulWidget {
  const LawerCaseListPage({Key? key}) : super(key: key);

  @override
  _LawerCaseListPageState createState() => _LawerCaseListPageState();
}

class _LawerCaseListPageState extends State<LawerCaseListPage> {
  String _caseBelong = "我的";
  String _caseStatus = "全部状态";

  List<Widget> _list = [];

  var _titleTxt = new TextEditingController();
  List<String> _typelist = [
    '争议解决',
    '非诉专项',
    '常年顾问',
    '批量案件',
    '其他',
  ];
  List<String> _startlist = [
    '全部',
    '本月',
    '近三个月',
    '近六个月',
    '今年',
  ];
  List<String> _endlist = [
    '本月',
    '近三个月',
    '已过期',
  ];
  String _selectType = '';
  String _selectStart = '';
  String _selectEnd = '';
  bool _rightButton = false;

  getGridView(_namelist, differenceNum) {
    return GroupButton(
      spacing: 10,
      buttons: _namelist,
      borderRadius: BorderRadius.circular(30),
      onSelected: (i, selected) => {
        debugPrint('Button #$i selected'),
        if (differenceNum == 0)
          this._selectType = _namelist[i]
        else if (differenceNum == 1)
          this._selectStart = _namelist[i]
        else if (differenceNum == 2)
          this._selectEnd = _namelist[i]
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCaseData();
    _list.add(SizedBox(
      height: 10,
    ));
    _list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "我的",
                style: TextStyle(fontSize: 20),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                ),
                onSelected: (value) {
                  this.setState(() {
                    _caseBelong = value.toString();
                    getCaseData();
                  });
                },
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      value: '我的',
                      child: InkWell(
                        child: Text(
                          '我的',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _caseBelong == '我的'
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: '共享',
                      child: InkWell(
                        child: Text(
                          '共享',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _caseBelong == '共享'
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "全部状态",
                style: TextStyle(fontSize: 20),
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                ),
                onSelected: (value) {
                  this.setState(() {
                    _caseStatus = value.toString();
                    getCaseData();
                  });
                },
                itemBuilder: (_) {
                  return [
                    PopupMenuItem(
                      value: '全部状态',
                      child: InkWell(
                        child: Text(
                          '全部状态',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _caseStatus == '全部状态'
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: '在办',
                      child: InkWell(
                        child: Text(
                          '在办',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _caseStatus == '在办'
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: '结案',
                      child: InkWell(
                        child: Text(
                          '结案',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: _caseStatus == '结案'
                                  ? Colors.blue
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "筛选",
                style: TextStyle(fontSize: 20),
              ),
              Builder(builder: (context) {
                return IconButton(
                  icon: new Icon(
                    Icons.keyboard_arrow_down,
                    size: 30,
                  ),
                  tooltip: 'click IconButton',
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  getCaseData() async {
    String caseBelong = '';
    switch (_caseBelong) {
      case '我的':
        caseBelong = '我的';
        break;
      case '共享':
        caseBelong = '共享';
        break;
    }

    String caseStatus = '';
    switch (_caseStatus) {
      case '全部状态':
        caseStatus = '全部状态';
        break;
      case '在办':
        caseStatus = '在办';
        break;
      case '结案':
        caseStatus = '结案';
        break;
    }

    if (this._rightButton) {
      String caseName = _titleTxt.text;
      this._selectType;
      this._selectStart;
      this._selectEnd;

      this._rightButton = false;
    }
    RResponse rResponse = await LawerService.listCase(caseStatus);
    if (rResponse.code == 1) {
      this.setState(() {
        for (var item in rResponse.data['cases']) {
          _list.add(_ListItem(
            title: item['case_type'],
            subtitle: transferTimeStamp(item['case_commit_time'].toString()),
            callback: () {
              // Navigator.pushNamed(context, '/lawer/project/detail',
              //     arguments: {"id": item['project_id']});
            },
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getCaseData();
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text('项目名称'),
              ),
              Container(
                decoration: new BoxDecoration(
                  border: new Border.all(width: 2.0, color: Colors.black12),
                  color: Colors.white10,
                  borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _titleTxt,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                title: Text('项目类型'),
              ),
              this.getGridView(_typelist, 0),
              Divider(),
              ListTile(
                title: Text('开始时间'),
              ),
              this.getGridView(_startlist, 1),
              Divider(),
              ListTile(
                title: Text('结束时间'),
              ),
              this.getGridView(_endlist, 2),
              Divider(),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('重置'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return Colors.black;
                        },
                      ),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      this._rightButton = true;
                      Navigator.pop(context);
                    },
                    child: Text('确定'),
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.resolveWith(
                        (states) {
                          return Colors.white;
                        },
                      ),
                      //背景颜色
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        //背景颜色
                        return Colors.orange;
                      }),
                      side: MaterialStateProperty.all(
                          BorderSide(color: Colors.grey, width: 1)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        body: ListView.builder(
            itemCount: _list
                .length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }
}

class _ListItem extends StatelessWidget {
  String title;
  String subtitle;

  dynamic callback;

  _ListItem(
      {Key? key, required this.subtitle, this.callback, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.circle,
              size: 30,
            ),
            title: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "申请时间: " + subtitle,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
