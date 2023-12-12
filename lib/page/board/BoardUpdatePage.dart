import 'package:flutter/material.dart';
import 'package:flutter_app/page/board/BoardDetailPage.dart';

import '../../api/user_api.dart';
import '../../main.dart';

class BoardUpdatePage extends StatefulWidget {
  BoardUpdatePage(
      {Key? key,
      required this.pk,
      required this.title,
        required this.email,
      required this.sex,
      required this.phone,
      required this.name,
      required this.content,
      required this.like,
      required this.bookmark})
      : super(key: key);

  int pk;
  String email;
  String sex;
  String phone;
  String title;
  String name;
  String content;
  int like;
  bool bookmark;

  @override
  _BoardUpdatePageState createState() => _BoardUpdatePageState();
}

class _BoardUpdatePageState extends State<BoardUpdatePage> {
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
            '게시판',
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
          like: widget.like,
          bookmark: widget.bookmark),
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
      required this.like,
      required this.bookmark})
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
  int like;
  bool bookmark;

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
          _title(widget.width, widget.height),
          _creator(widget.width, widget.height, widget.name),
          _content(widget.width, widget.height),
          _button(widget.pk)
        ],
      ),
    );
  }

  Widget _title(width, height) {
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
            child: TextField(
              controller: titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(border: InputBorder.none),
            ),
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

  Widget _content(width, height) {
    return Container(
      width: width * 0.9,
      height: height * 0.6,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 5),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: contentController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget _button(pk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () async {
              final response = await UserAPI(context: context).updateBoard(
                  pk: pk,
                  title: titleController.text,
                  creator: widget.name,
                  content: contentController.text,
                  like: widget.like,
                  bookmark: widget.bookmark);

              final response2 = await UserAPI(context: context)
                  .insertElasticSearchBoard(
                      id: pk,
                      title: titleController.text,
                      creator: widget.name,
                      content: contentController.text,
                      like: widget.like,
                      bookmark: widget.bookmark);

              if (response['statusCode'] == 200) {
                print(response['statusCode']);
              } else {
                print(response['statusCode']);
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => BoardDetailPage(
                          pk: widget.pk,
                          email: widget.email,
                          name: widget.name,
                          sex: widget.sex,
                          phone: widget.phone,
                          title: widget.title,
                          content: widget.content,
                          like: widget.like,
                          bookmark: widget.bookmark)),
                  (route) => false);
            },
            child: Text('UPDATE')),
      ],
    );
  }
}
