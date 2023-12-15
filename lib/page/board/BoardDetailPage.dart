import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BoardUpdatePage.dart';
import '../../api/user_api.dart';
import '../../main.dart';

class BoardDetailPage extends StatefulWidget {
  BoardDetailPage({
    Key? key,
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
  }) : super(key: key);

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

  @override
  _BoardDetailPageState createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
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
        ),
      ),
    );
  }
}

class contents extends StatefulWidget {
  contents({
    Key? key,
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
  }) : super(key: key);

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

  @override
  _contentsState createState() => _contentsState();
}

class _contentsState extends State<contents> {
  var likeTmp;
  var bookmarkTmp;

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
          _title(widget.width, widget.height, widget.title),
          _creator(widget.width, widget.height, widget.creator),
          _content(widget.width, widget.height, widget.content),
          _like_bookmark(widget.width, widget.height),
          _button(widget.boardPk),
          _comment(widget.boardPk)
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

  Widget _like_bookmark(width, height) {
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
                        _showDialog(context, "로그인 후 이용 가능합니다.");
                      } else {
                        int newLikeValue = likeTmp + 1;
                        try {
                          final response =
                              await UserAPI(context: context).updateBoard(
                            pk: widget.boardPk,
                            title: widget.title,
                            creator: widget.creator,
                            content: widget.content,
                            like: newLikeValue,
                            bookmark: bookmarkTmp,
                          );

                          final response2 = await UserAPI(context: context)
                              .insertElasticSearchBoard(
                            id: widget.boardPk,
                            title: widget.title,
                            creator: widget.creator,
                            content: widget.content,
                            like: newLikeValue,
                            bookmark: bookmarkTmp,
                          );

                          if (response['statusCode'] == 200) {
                            setState(() {
                              likeTmp = newLikeValue;
                            });
                            print(response['statusCode']);
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
                            );

                            if (response['statusCode'] == 200) {
                              setState(() {
                                bookmarkTmp = newBookmarkValue;
                              });
                              print(response['statusCode']);
                            } else {
                              print(response['statusCode']);
                            }
                          } catch (error) {
                            print('Error: $error');
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
                            );

                            if (response['statusCode'] == 200) {
                              setState(() {
                                bookmarkTmp = newBookmarkValue;
                              });
                              print(response['statusCode']);
                              print(response2);
                            } else {
                              print(response['statusCode']);
                            }
                          } catch (error) {
                            print('Error: $error');
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
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
                          )));
            },
            child: Text('UPDATE')),
        ElevatedButton(
            onPressed: () async {
              try {
                final response =
                    await UserAPI(context: context).deleteBoard(pk: boardPk);
                UserAPI(context: context).deleteElasticSearchBoard(pk: boardPk);

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
                  (route) => false,
                );
              } catch (e) {
                print('Error: $e');
                // Handle the error appropriately
              }
            },
            child: Text('DELETE')),
      ],
    );
  }

  Widget _comment(boardPk) {
    return commentWindow
        ? Padding(
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
                            (index) => ListTile(
                                  leading: Text(
                                    '${snapshot.data[index]['sbc_creator']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  title: Text(
                                      '${snapshot.data[index]['sbc_content']}'),
                                  onTap: () {},
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
                                    _showDialog(context, "로그인 후 이용 가능합니다.");
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

                                    setState(() {});
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

  Future<dynamic> _fetchBoardComments(context, boardPk) async {
    dynamic boardCommentList =
        await UserAPI(context: context).readBoardComments(pk: boardPk);
    print(boardCommentList);
    return boardCommentList;
  }

  Future<dynamic> _showDialog(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              title: Text('오류'),
              content: Text('$text'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('확인'))
              ],
            ));
  }
}
