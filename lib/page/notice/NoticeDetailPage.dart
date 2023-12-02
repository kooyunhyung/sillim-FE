import 'package:flutter/material.dart';

import 'NoticeUpdatePage.dart';
import '../../api/user_api.dart';
import '../../main.dart';

class NoticeDetailPage extends StatefulWidget {
  NoticeDetailPage(
      {Key? key,
      required this.pk,
      required this.title,
      required this.creator,
      required this.content})
      : super(key: key);

  int pk;
  String title;
  String creator;
  String content;

  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage())),
          ),
          title: Text(
            '공지사항',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
        ),
      ),
      body: contents(
          width: width,
          height: height,
          title: widget.title,
          pk: widget.pk,
          creator: widget.creator,
          content: widget.content),
    );
  }
}

class contents extends StatefulWidget {
  contents(
      {Key? key,
      required this.width,
      required this.height,
      required this.pk,
      required this.title,
      required this.creator,
      required this.content})
      : super(key: key);

  double width;
  double height;
  int pk;
  String title;
  String creator;
  String content;

  @override
  _contentsState createState() => _contentsState();
}

class _contentsState extends State<contents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _title(widget.width, widget.height, widget.title),
          _creator(widget.width, widget.height, widget.creator),
          _content(widget.width, widget.height, widget.content),
          _button(widget.pk)
        ],
      ),
    );
  }

  Widget _title(width, height, title) {
    return Container(
      width: width * 0.9,
      height: height * 0.08,
      child: Row(
        children: [
          Text(
            "제목",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Container(
            width: width * 0.78,
            height: height * 0.05,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 5),
                borderRadius: BorderRadius.circular(10)),
            child: Text(title),
          )
        ],
      ),
    );
  }

  Widget _creator(width, height, creator) {
    return Container(
      width: width * 0.9,
      height: height * 0.08,
      child: Row(
        children: [
          Text(
            '작성자',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Container(
              width: width * 0.7,
              height: height * 0.05,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 5),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(creator))
        ],
      ),
    );
  }

  Widget _content(width, height, content) {
    return Container(
        width: width * 0.9,
        height: height * 0.6,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue, width: 5),
            borderRadius: BorderRadius.circular(10)),
        child: Text(content));
  }

  Widget _button(pk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoticeUpdatePage(
                            pk: pk,
                            title: widget.title,
                            creator: widget.creator,
                            content: widget.content,
                          )));
            },
            child: Text('UPDATE')),
        ElevatedButton(
            onPressed: () async {
              final response =
                  await UserAPI(context: context).deleteNotice(pk: pk);

              if (response['statusCode'] == 200) {
                print(response['statusCode']);
              } else {
                print(response['statusCode']);
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (route) => false);
            },
            child: Text('DELETE')),
      ],
    );
  }
}
