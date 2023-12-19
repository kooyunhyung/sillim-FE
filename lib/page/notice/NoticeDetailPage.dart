import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'NoticeUpdatePage.dart';
import '../../api/user_api.dart';
import '../../main.dart';

class NoticeDetailPage extends StatefulWidget {
  NoticeDetailPage(
      {Key? key,
      required this.pk,
      required this.email,
      required this.sex,
      required this.phone,
      required this.title,
      required this.name,
      required this.content,
      required this.date})
      : super(key: key);

  int pk;
  String email;
  String sex;
  String phone;
  String title;
  String name;
  String content;
  String date;

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
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          pk: widget.pk,
                          email: widget.email,
                          name: widget.name,
                          sex: widget.sex,
                          phone: widget.phone,
                        ))),
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
          email: widget.email,
          sex: widget.sex,
          phone: widget.phone,
          name: widget.name,
          content: widget.content,
          date: widget.date),
    );
  }
}

class contents extends StatefulWidget {
  contents(
      {Key? key,
      required this.width,
      required this.height,
      required this.pk,
      required this.email,
      required this.sex,
      required this.phone,
      required this.title,
      required this.name,
      required this.content,
      required this.date})
      : super(key: key);

  double width;
  double height;
  int pk;
  String email;
  String sex;
  String phone;
  String title;
  String name;
  String content;
  String date;

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
          _title(widget.width, widget.height, widget.title, widget.date),
          _creator(widget.width, widget.height, widget.name),
          _content(widget.width, widget.height, widget.content),
          _button(widget.pk)
        ],
      ),
    );
  }

  Widget _title(width, height, title, date) {
    DateTime dateParsing = DateTime.parse(date).toLocal();
    String dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateParsing);

    return Container(
      width: width * 0.9,
      height: height * 0.11,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('$dateFormat'),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Text(
                "제목",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: width * 0.03,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                width: width * 0.78,
                height: height * 0.05,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(title,style: TextStyle(fontSize: 20)),
              )
            ],
          ),
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
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              width: width * 0.7,
              height: height * 0.05,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(creator,style: TextStyle(fontSize: 20)))
        ],
      ),
    );
  }

  Widget _content(width, height, content) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        width: width * 0.9,
        height: height * 0.6,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple, width: 2),
            borderRadius: BorderRadius.circular(5)),
        child: Text(content,style: TextStyle(fontSize: 20)));
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
                            email: widget.email,
                            sex: widget.sex,
                            phone: widget.phone,
                            title: widget.title,
                            name: widget.name,
                            content: widget.content,
                            date: widget.date,
                          )));
            },
            child: Text('UPDATE')),
        ElevatedButton(
            onPressed: () async {
              final response =
                  await UserAPI(context: context).deleteNotice(pk: pk);

              UserAPI(context: context).deleteElasticSearchNotice(pk: pk);

              if (response['statusCode'] == 200) {
                print(response['statusCode']);
              } else {
                print(response['statusCode']);
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                            pk: widget.pk,
                            email: widget.email,
                            name: widget.name,
                            sex: widget.sex,
                            phone: widget.phone,
                          )),
                  (route) => false);
            },
            child: Text('DELETE')),
      ],
    );
  }
}
