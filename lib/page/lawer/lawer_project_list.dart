import 'package:flutter/material.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:super_lawer/util/number_util.dart';

class LawerProjectListPage extends StatefulWidget {
  const LawerProjectListPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<LawerProjectListPage> {
  String _filter = "全部";

  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    getProjectData();
    _list.add(SizedBox(
      height: 10,
    ));
    _list.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "筛选",
            style: TextStyle(fontSize: 20),
          ),
          PopupMenuButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 30,
            ),
            onSelected: (value) {
              this.setState(() {
                _filter = value.toString();
                getProjectData();
              });
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  value: '全部',
                  child: InkWell(
                    child: Text(
                      '全部',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: _filter == '全部' ? Colors.blue : Colors.black),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: '待承接',
                  child: InkWell(
                    child: Text(
                      '待承接',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: _filter == '待承接' ? Colors.blue : Colors.black),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: '进行中',
                  child: InkWell(
                    child: Text(
                      '进行中',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: _filter == '进行中' ? Colors.blue : Colors.black),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: '已到期',
                  child: InkWell(
                    child: Text(
                      '已到期',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: _filter == '已到期' ? Colors.blue : Colors.black),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  getProjectData() async {
    String filter = '';
    switch (_filter) {
      case '待承接':
        filter = 'new';
        break;
      case '进行中':
        filter = 'running';
        break;
      case '已过期':
        filter = 'end';
        break;
    }
    RResponse rResponse = await EnterpeiseService.listProjects(filter);
    if (rResponse.code == 1 && mounted) {
      this.setState(() {
        _list.removeRange(2, _list.length);
        for (var item in rResponse.data['projects']) {
          _list.add(_ListItem(
            title: item['project_name'],
            subtitle: transferTimeStamp(item['commit_time'].toString()),
            callback: () {
              Navigator.pushNamed(context, '/lawer/project/detail',
                  arguments: {"id": item['project_id']});
            },
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getProjectData();
    return Scaffold(
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
