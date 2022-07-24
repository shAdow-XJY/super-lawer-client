import 'package:flutter/material.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/admin_service.dart';
import 'package:super_lawer/service/enterpeise_service.dart';
import 'package:super_lawer/util/date_util.dart';
import 'package:super_lawer/util/number_util.dart';

import '../../../common/loading_diglog.dart';

class ProjectHandleListPage extends StatefulWidget {
  const ProjectHandleListPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectHandleListPage> {
  List<Widget> _list = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getProjectData();
  }

  getProjectData() async {
    setState(() {
      debugPrint("startloading");
      loading = true;
    });
    _list.add(const SizedBox(
      height: 10,
    ));
    RResponse rResponse = await AdminService.listProject();
    if (rResponse.code == 1) {
      setState(() {
        _list = [];
        for (var item in rResponse.data['projects']) {
          _list.add(_ListItem(
            person: item['from_name'],
            title: item['project_name'],
            subtitle: transferTimeStamp(item['commit_time'].toString()),
            callback: () {
              Navigator.pushNamed(context, '/admin/manage/project/detail',
                  arguments: {"id": item['project_id']}
              ).then((value) => {getProjectData()});
            },
          ));
        }
      });
      setState(() {
        debugPrint("endlloading");
        loading = false;
        _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("项目审核"),
          backgroundColor: Colors.orange,
        ),
        body: loading
            ?LoadingDialog()
            :ListView.builder(
            itemCount: _list.length, //此处展示需要写成 3，实际适用时  _listData==null?0:_listData.length
            itemBuilder: (content, index) {
              return _list[index];
            }));
  }
}

class _ListItem extends StatelessWidget {
  String title;
  String subtitle;
  String person;
  dynamic callback;
  _ListItem(
      {Key? key,
      required this.person,
      required this.subtitle,
      this.callback,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.circle,
              size: 30,
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              "申请人:$person    申请时间: $subtitle",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
