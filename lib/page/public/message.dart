import 'package:flutter/material.dart';
import 'package:super_lawer/model/response.dart';
import 'package:super_lawer/service/message_service.dart';
import 'package:super_lawer/util/number_util.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Widget> _list = [];

  @override
  void initState() {
    super.initState();
    _list.add(const SizedBox(
      height: 10,
    ));
    _list.add(_ListItem(
      cover:
          "http://www.topgoer.cn/uploads/202009/cover_16326bd0af0aada3_small.jpg",
      title: "系统消息",
      subtitle: "",
      callback: () {
        Navigator.pushNamed(context, '/msg/sys');
      },
    ));
    _list.add(Container());
    getContacts();
  }

  getContacts() async {
    RResponse rResponse = await MessageService.listContacts();
    if (rResponse.code == 1) {
      _list.removeRange(2, _list.length);
      setState(() {
        for (var item in rResponse.data['contacts']) {
          _list.add(_ListItem(
            cover: item['cover'],
            title: item['contact_name'],
            subtitle: item['content_type'] == 0 ? item['content'] : "",
            callback: () {
              Navigator.pushNamed(context, '/msg/chat', arguments: {
                "id": item['contact_id'],
                "contact_name": item['contact_name']
              });
            },
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getContacts();
    return Scaffold(
        appBar: AppBar(
          title: const Text("超级律师"),
          backgroundColor: Colors.orange,
        ),
        body: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (content, index) {
              return _list[index];
            })
    );
  }
}

class _ListItem extends StatelessWidget {
  String title;
  String subtitle;
  String cover;
  dynamic callback;
  _ListItem(
      {Key? key,
      required this.cover,
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
            leading: ClipOval(
              child: Image.network(
                cover,
                fit: BoxFit.cover,
                width: transferWidth(60),
                height: transferlength(60),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
