import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'BoardUpdatePage.dart';
import '../../api/user_api.dart';
import '../../main.dart';

class BoardDetailPage extends StatefulWidget {
  BoardDetailPage(
      {Key? key,
      required this.pk,
      required this.boardPk,
      required this.email,
      required this.name,
      required this.creator,
      required this.sex,
      required this.phone,
      required this.title,
      required this.content,
      required this.like,
      required this.bookmark,
      required this.date})
      : super(key: key);

  int pk;
  int boardPk;
  String email;
  String name;
  String creator;
  String sex;
  String phone;
  String title;
  String content;
  int like;
  bool bookmark;
  String date;

  @override
  _BoardDetailPageState createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      // 기기 자체의 뒤로 가기버튼이나 상단 AppBar 의 뒤로가기 버튼을 눌렀을때 변경된 사항이 메임화면에 전달될 수 있는 위젯
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      pk: widget.pk,
                      email: widget.email,
                      name: widget.name,
                      sex: widget.sex,
                      phone: widget.phone,
                    )));
      },
      child: Scaffold(
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
              '게시판',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            centerTitle: true,
          ),
        ),
        body: contents(
            width: width,
            height: height,
            title: widget.title,
            pk: widget.pk,
            boardPk: widget.boardPk,
            name: widget.name,
            creator: widget.creator,
            email: widget.email,
            sex: widget.sex,
            phone: widget.phone,
            content: widget.content,
            like: widget.like,
            bookmark: widget.bookmark,
            date: widget.date),
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
      required this.name,
      required this.creator,
      required this.email,
      required this.sex,
      required this.phone,
      required this.title,
      required this.content,
      required this.like,
      required this.bookmark,
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
  // 좋아요, 즐겨찾기 변형 임시 저장 변수
  var likeTmp;
  var bookmarkTmp;

  // 댓글창 보기 버튼 활성화 유무
  var commentWindow;

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    likeTmp = widget.like;
    bookmarkTmp = widget.bookmark;
    commentWindow = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          _title(widget.width, widget.height, widget.title, widget.date),
          _creator(widget.width, widget.height, widget.creator),
          _content(widget.width, widget.height, widget.content),
          _likeBookmark(widget.width, widget.height),
          _button(widget.boardPk),
          _comment(widget.boardPk)
        ],
      ),
    );
  }

  Widget _title(width, height, title, date) {
    // String 타입의 날짜 변수 Date 타입으로 파싱 후 알맞은 형식으로 Format
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
                child: Text(
                  title,
                  style: TextStyle(fontSize: 20),
                ),
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
              child: Text(
                creator,
                style: TextStyle(fontSize: 20),
              ))
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
        child: Text(
          content,
          style: TextStyle(fontSize: 15),
        ));
  }

  Widget _likeBookmark(width, height) {
    return Container(
        width: width * 0.9,
        height: height * 0.1,
        padding: EdgeInsets.symmetric(vertical: 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () async {
                      if (widget.pk == -1) {
                        _showDialog(context, "오류", "로그인 후 이용 가능합니다.");
                      } else {
                        // 임시 변수에 저장
                        int newLikeValue = likeTmp + 1;

                        try {
                          // 좋아요 버튼을 눌렀을 시 API 호출 (클릭 제한 수 무한이라는 점 한계 => 차후 유저별 제한 수 도입 예정)
                          final response =
                              await UserAPI(context: context).updateBoard(
                            pk: widget.boardPk,
                            title: widget.title,
                            creator: widget.creator,
                            content: widget.content,
                            like: newLikeValue,
                            bookmark: bookmarkTmp,
                          );

                          // Elastic Search API 호출 (일반 RDBMS에 업데이트, 저장된 정보를 ELastic Search 인덱스에도 동기화 시켜야함)
                          final response2 = await UserAPI(context: context)
                              .insertElasticSearchBoard(
                                  id: widget.boardPk,
                                  title: widget.title,
                                  creator: widget.creator,
                                  content: widget.content,
                                  like: newLikeValue,
                                  bookmark: bookmarkTmp,
                                  date: widget.date.toString());

                          if (response['statusCode'] == 200) {
                            setState(() {
                              likeTmp = newLikeValue;
                            });
                          } else {
                            print(response['statusCode']);
                          }
                        } catch (error) {
                          print('Error: $error');
                        }
                      }
                    },
                    child: Icon(
                      Icons.thumb_up,
                      size: 50,
                    )),
                Text(
                  '$likeTmp',
                  style: TextStyle(fontSize: 40),
                )
              ],
            ),
            Row(
              children: [
                bookmarkTmp
                    ? InkWell(
                        onTap: () async {
                          if (widget.pk == -1) {
                            _showDialog(context, "오류", "로그인 후 이용 가능합니다.");
                          } else {
                            // 임시 변수에 저장
                            bool newBookmarkValue = !bookmarkTmp;

                            try {
                              final response =
                                  await UserAPI(context: context).updateBoard(
                                pk: widget.boardPk,
                                title: widget.title,
                                creator: widget.creator,
                                content: widget.content,
                                like: likeTmp,
                                bookmark: newBookmarkValue,
                              );

                              final response2 = await UserAPI(context: context)
                                  .insertElasticSearchBoard(
                                      id: widget.boardPk,
                                      title: widget.title,
                                      creator: widget.creator,
                                      content: widget.content,
                                      like: likeTmp,
                                      bookmark: newBookmarkValue,
                                      date: widget.date.toString());

                              if (response['statusCode'] == 200) {
                                setState(() {
                                  bookmarkTmp = newBookmarkValue;
                                });
                              } else {
                                print(response['statusCode']);
                              }
                            } catch (error) {
                              print('Error: $error');
                            }
                          }
                        },
                        child: Icon(
                          Icons.star,
                          size: 60,
                          color: Colors.yellow,
                        ),
                      )
                    : InkWell(
                        onTap: () async {
                          if (widget.pk == -1) {
                            _showDialog(context, "오류", "로그인 후 이용 가능합니다.");
                          } else {
                            // 임시 변수에 저장
                            bool newBookmarkValue = !bookmarkTmp;

                            try {
                              final response =
                                  await UserAPI(context: context).updateBoard(
                                pk: widget.boardPk,
                                title: widget.title,
                                creator: widget.creator,
                                content: widget.content,
                                like: likeTmp,
                                bookmark: newBookmarkValue,
                              );

                              final response2 = await UserAPI(context: context)
                                  .insertElasticSearchBoard(
                                      id: widget.boardPk,
                                      title: widget.title,
                                      creator: widget.creator,
                                      content: widget.content,
                                      like: likeTmp,
                                      bookmark: newBookmarkValue,
                                      date: widget.date.toString());

                              if (response['statusCode'] == 200) {
                                setState(() {
                                  bookmarkTmp = newBookmarkValue;
                                });
                              } else {
                                print(response['statusCode']);
                              }
                            } catch (error) {
                              print('Error: $error');
                            }
                          }
                        },
                        child: Icon(
                          Icons.star_border_rounded,
                          size: 60,
                        ),
                      ),
              ],
            )
          ],
        ));
  }

  Widget _button(boardPk) {
    return (widget.name == widget.creator)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.deepPurple),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BoardUpdatePage(
                                pk: widget.pk,
                                boardPk: boardPk,
                                email: widget.email,
                                sex: widget.sex,
                                phone: widget.phone,
                                title: widget.title,
                                name: widget.name,
                                creator: widget.creator,
                                content: widget.content,
                                like: likeTmp,
                                bookmark: bookmarkTmp,
                                date: widget.date)));
                  },
                  child: Text('수정')),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () async {
                    try {
                      // 삭제 API 호출
                      final response = await UserAPI(context: context)
                          .deleteBoard(pk: boardPk);

                      // Elastic Search 인덱스에서도 해당 도큐먼트 삭제
                      UserAPI(context: context)
                          .deleteElasticSearchBoard(pk: boardPk);

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  pk: widget.pk,
                                  email: widget.email,
                                  name: widget.name,
                                  sex: widget.sex,
                                  phone: widget.phone,
                                )),
                        (route) => false,
                      );

                      _showDialog(context, "완료", "게시글이 삭제 되었습니다.");
                    } catch (e) {
                      print('Error: $e');
                      // Handle the error appropriately
                    }
                  },
                  child: Text('삭제')),
            ],
          )
        : Container();
  }

  Widget _comment(boardPk) {
    return commentWindow // 해당 임시 변수의 상태에 따라 댓글 목록을 볼 수 있는 여부 결정
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  commentWindow = !commentWindow; // 클릭시 반댓값으로 설정
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                width: widget.width,
                height: widget.height * 0.05,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('댓글'),
                    Icon(Icons.keyboard_arrow_down_rounded)
                  ],
                ),
              ),
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      commentWindow = !commentWindow;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    width: widget.width,
                    height: widget.height * 0.05,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('댓글'),
                        Icon(Icons.keyboard_arrow_up_rounded)
                      ],
                    ),
                  ),
                ),
              ),
              FutureBuilder(
                // 댓글 목록 불러오는 API 호출 후 받은 정보 리스트로 출력
                future: _fetchBoardComments(context, boardPk),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData == false) {
                    return Container(
                        child: Center(
                            child: Container(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator())));
                  } else if (snapshot.hasError) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        ...List.generate(
                            snapshot.data.length,
                            (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${DateFormat('yyyy년 MM월 dd일 HH:mm').format(DateTime.parse(snapshot.data[index]['sbc_date']).toLocal())}',
                                      // String => Date => Format
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        '${snapshot.data[index]['sbc_creator']}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      title: Text(
                                          '${snapshot.data[index]['sbc_content']}'),
                                      onTap: () {},
                                    ),
                                    Container(
                                      width: widget.width,
                                      height: 0.3,
                                      color: Colors.grey[700],
                                    )
                                  ],
                                )),
                        Row(
                          children: [
                            Container(
                              width: widget.width * 0.7,
                              height: widget.height * 0.05,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 2.0),
                                child: TextFormField(
                                  controller: commentController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 5.0)),
                                ),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (widget.pk == -1) {
                                    _showDialog(
                                        context, "오류", "로그인 후 이용 가능합니다.");
                                  } else if (commentController.text.trim() ==
                                      '') {
                                    _showDialog(context, "오류", '댓글 내용을 입력하세요.');
                                  } else {
                                    await UserAPI(context: context)
                                        .createBoardComment(
                                            creator: widget.name,
                                            content: commentController.text,
                                            boardId: widget.boardPk,
                                            boardTitle: widget.title,
                                            boardCreator: widget.creator,
                                            boardContent: widget.content,
                                            boardLike: widget.like,
                                            boardBookmark: widget.bookmark);

                                    setState(
                                        () {}); // 댓글 입력후 화면에 바로 띄워질수 있게 페이지 재렌더링 하는 역할을 함
                                  }
                                },
                                child: Text('댓글등록'))
                          ],
                        ),
                      ],
                    );
                  }
                },
              )
            ],
          );
  }

  // 해당 게시물에 달린 댓글 목록을 불러오는 API 함수 호출
  Future<dynamic> _fetchBoardComments(context, boardPk) async {
    dynamic boardCommentList =
        await UserAPI(context: context).readBoardComments(pk: boardPk);
    return boardCommentList;
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
}
