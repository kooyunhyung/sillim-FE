import 'package:flutter/material.dart';

import '../../api/user_api.dart';
import '../../main.dart';

class NoticeCreatePage extends StatefulWidget {
  NoticeCreatePage(
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
  _NoticeCreatePageState createState() => _NoticeCreatePageState();
}

class _NoticeCreatePageState extends State<NoticeCreatePage> {
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
  // 공지 글 생성을 위한 제목, 내용 컨트롤러
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
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () async {
              //내용이 비어 있으면 다이얼로그 메세지
              if (title.text.trim() == '') {
                _showDialog(context, '오류', '제목을 입력하세요.');
              } else if (content.text.trim() == '') {
                _showDialog(context, '오류', '내용을 입력하세요.');
              } else {
                // 공지 생성 API 함수 호출
                final response = await UserAPI(context: context).createNotice(
                  title: title.text,
                  creator: widget.name,
                  content: content.text,
                );

                int id = response["obj"]["sn_id"];
                String date = response["obj"]["sn_date"];

                // Elastic Search 인덱스에도 공지 생성 하도록 API 함수 호출 (검색 필터링 시 싱크를 맞출 수 있음)
                final response2 = await UserAPI(context: context)
                    .insertElasticSearchNotice(
                        id: id,
                        title: title.text,
                        creator: widget.name,
                        content: content.text,
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

                _showDialog(context, '완료', '공지사항이 생성 되었습니다.');
              }
            },
            child: Text('등록')),
      ],
    );
  }
}

// 다이얼로그 창
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
