import 'package:flutter/material.dart';

import '../../api/user_api.dart';
import '../../main.dart';

class BoardCreatePage extends StatefulWidget {
  BoardCreatePage(
      {Key? key,
      required this.pk,
      required this.email,
      required this.name,
      required this.sex,
      required this.phone})
      : super(key: key);

  int pk;
  String email;
  String name;
  String sex;
  String phone;

  @override
  _BoardCreatePageState createState() => _BoardCreatePageState();
}

class _BoardCreatePageState extends State<BoardCreatePage> {
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
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone,
          width: width,
          height: height),
    );
  }
}

class contents extends StatefulWidget {
  contents(
      {Key? key,
      required this.pk,
      required this.email,
      required this.name,
      required this.sex,
      required this.phone,
      required this.width,
      required this.height})
      : super(key: key);

  int pk;
  String email;
  String name;
  String sex;
  String phone;
  double width;
  double height;

  @override
  _contentsState createState() => _contentsState();
}

class _contentsState extends State<contents> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _title(widget.width, widget.height),
          _creator(widget.width, widget.height),
          _content(widget.width, widget.height),
          _button()
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
            '제목',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          Container(
            width: width * 0.78,
            height: height * 0.05,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: TextFormField(
                controller: title,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _creator(width, height) {
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
                border: Border.all(color: Colors.deepPurple, width: 2),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              '${widget.name}',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _content(width, height) {
    return Container(
      width: width * 0.9,
      height: height * 0.6,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: TextFormField(
          controller: content,
          keyboardType: TextInputType.multiline,
          maxLines: 3000,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
        ),
      ),
    );
  }

  Widget _button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () async {
              //내용이 비어 있으면 다이얼로그 메세지
              if (title.text.trim() == '') {
                _showDialog(context,'오류' ,'제목을 입력하세요.');
              } else if (content.text.trim()==''){
                _showDialog(context,'오류','내용을 입력하세요.');
              } else{
                final response = await UserAPI(context: context).createBoard(
                  title: title.text,
                  creator: widget.name,
                  content: content.text,
                );

                int id = response["obj"]["sb_id"];
                String date = response["obj"]["sb_date"];

                final response2 = await UserAPI(context: context)
                    .insertElasticSearchBoard(
                    id: id,
                    title: title.text,
                    creator: widget.name,
                    content: content.text,
                    like: 0,
                    bookmark: false,
                    date: date);

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

                _showDialog(context,'완료','게시글이 생성 되었습니다.');
              }
            },
            child: Text('CREATE')),
      ],
    );
  }
}

Future<dynamic> _showDialog(BuildContext context, String title, String content) {
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
