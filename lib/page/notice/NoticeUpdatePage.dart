import 'package:flutter/material.dart';
import 'package:flutter_app/page/notice/NoticeDetailPage.dart';
import 'package:intl/intl.dart';

import '../../api/user_api.dart';
import '../../main.dart';

class NoticeUpdatePage extends StatefulWidget {
  NoticeUpdatePage(
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
  _NoticeUpdatePageState createState() => _NoticeUpdatePageState();
}

class _NoticeUpdatePageState extends State<NoticeUpdatePage> {
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
            onPressed: () => Navigator.of(context).pop(),
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
          pk: widget.pk,
          email: widget.email,
          sex: widget.sex,
          phone: widget.phone,
          title: widget.title,
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
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    titleController.text = widget.title;
    contentController.text = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _title(widget.width, widget.height, widget.date),
          _creator(widget.width, widget.height, widget.name),
          _content(widget.width, widget.height),
          _button(widget.pk)
        ],
      ),
    );
  }

  Widget _title(width, height, date) {
    DateTime dateParse = DateTime.parse(date).toLocal();
    String dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm').format(dateParse);

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
                width: width * 0.78,
                height: height * 0.05,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
                ),
              ),
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
              child: Text(
                creator,
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  Widget _content(width, height) {
    return Container(
      width: width * 0.9,
      height: height * 0.6,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple, width: 2),
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: contentController,
        keyboardType: TextInputType.multiline,
        maxLines: 3000,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
      ),
    );
  }

  Widget _button(pk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim() == '') {
                _showDialog(context, '오류', '제목을 입력하세요.');
              } else if (contentController.text.trim() == '') {
                _showDialog(context, '오류', '내용을 입력하세요.');
              } else {
                final response = await UserAPI(context: context).updateNotice(
                    pk: pk,
                    title: titleController.text,
                    creator: widget.name,
                    content: contentController.text);

                final response2 = await UserAPI(context: context)
                    .insertElasticSearchNotice(
                        id: pk,
                        title: titleController.text,
                        creator: widget.name,
                        content: contentController.text,
                        date: widget.date);

                if (response['statusCode'] == 200) {
                  print(response['statusCode']);
                } else {
                  print(response['statusCode']);
                }

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => NoticeDetailPage(
                            pk: widget.pk,
                            email: widget.email,
                            sex: widget.sex,
                            phone: widget.phone,
                            title: widget.title,
                            name: widget.name,
                            content: widget.content,
                            date: widget.date)),
                    (route) => false);

                _showDialog(context, '완료', '게시글이 수정 되었습니다.');
              }
            },
            child: Text('UPDATE')),
      ],
    );
  }
}

Future<dynamic> _showDialog(
    BuildContext context, String title, String content) {
  return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            title: Text('$title'),
            content: Text('$content'),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('확인'))
            ],
          ));
}
