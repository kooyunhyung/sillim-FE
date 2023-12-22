import 'package:flutter/material.dart';
import 'package:flutter_app/page/board/BoardDetailPage.dart';
import 'package:intl/intl.dart';

import '../../api/user_api.dart';

class BoardUpdatePage extends StatefulWidget {
  BoardUpdatePage(
      {Key? key,
      required this.pk,
      required this.boardPk,
      required this.title,
      required this.email,
      required this.sex,
      required this.phone,
      required this.name,
      required this.creator,
      required this.content,
      required this.like,
      required this.bookmark,
      required this.date})
      : super(key: key);

  int pk;
  int boardPk;
  String email;
  String sex;
  String phone;
  String title;
  String name;
  String creator;
  String content;
  int like;
  bool bookmark;
  String date;

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
        boardPk: widget.boardPk,
        email: widget.email,
        sex: widget.sex,
        phone: widget.phone,
        title: widget.title,
        name: widget.name,
        content: widget.content,
        like: widget.like,
        bookmark: widget.bookmark,
        creator: widget.creator,
        date: widget.date,
      ),
    );
  }
}

class contents extends StatefulWidget {
  contents(
      {Key? key,
      required this.width,
      required this.height,
      required this.pk,
      required this.boardPk,
      required this.email,
      required this.sex,
      required this.phone,
      required this.title,
      required this.name,
      required this.content,
      required this.like,
      required this.bookmark,
      required this.creator,
      required this.date})
      : super(key: key);

  double width;
  double height;
  int pk;
  int boardPk;
  String email;
  String sex;
  String phone;
  String title;
  String name;
  String creator;
  String content;
  int like;
  bool bookmark;
  String date;

  @override
  _contentsState createState() => _contentsState();
}

class _contentsState extends State<contents> {
  // 수정하기 위한 제목, 내용 글 컨트롤러
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    // 처음 페이지 화면에 기존의 글이 필드창에 뜨도록 컨트롤러 텍스트 초기화
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
          _creator(widget.width, widget.height, widget.creator),
          _content(widget.width, widget.height),
          _button(widget.boardPk)
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

  Widget _button(boardPk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () async {
              if (titleController.text.trim() == '') {
                _showDialog(context, '오류', '제목을 입력하세요.');
              } else if (contentController.text.trim() == '') {
                _showDialog(context, '오류', '내용을 입력하세요.');
              } else {
                final response = await UserAPI(context: context).updateBoard(
                  pk: boardPk,
                  title: titleController.text,
                  creator: widget.name,
                  content: contentController.text,
                  like: widget.like,
                  bookmark: widget.bookmark,
                );

                final response2 = await UserAPI(context: context)
                    .insertElasticSearchBoard(
                        id: boardPk,
                        title: titleController.text,
                        creator: widget.name,
                        content: contentController.text,
                        like: widget.like,
                        bookmark: widget.bookmark,
                        date: widget.date);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => BoardDetailPage(
                              pk: widget.pk,
                              boardPk: widget.boardPk,
                              email: widget.email,
                              name: widget.name,
                              creator: widget.creator,
                              sex: widget.sex,
                              phone: widget.phone,
                              title: widget.title,
                              content: widget.content,
                              like: widget.like,
                              bookmark: widget.bookmark,
                              date: widget.date,
                            )),
                    (route) => false);

                _showDialog(context, '완료', '게시글이 수정 되었습니다.');
              }
            },
            child: Text('등록')),
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
