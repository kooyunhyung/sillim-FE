import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BoardUpdatePage.dart';
import '../../api/user_api.dart';
import '../../main.dart';

class BoardDetailPage extends StatefulWidget {
  BoardDetailPage(
      {Key? key,
      required this.pk,
      required this.title,
      required this.creator,
      required this.content,
      required this.like,
      required this.bookmark})
      : super(key: key);

  int pk;
  String title;
  String creator;
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
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => MyHomePage())),
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
            creator: widget.creator,
            content: widget.content,
            like: widget.like,
            bookmark: widget.bookmark),
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
      required this.title,
      required this.creator,
      required this.content,
      required this.like,
      required this.bookmark})
      : super(key: key);

  double width;
  double height;
  int pk;
  String title;
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

  @override
  void initState() {
    likeTmp = widget.like;
    bookmarkTmp = widget.bookmark;
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
                      int newLikeValue = likeTmp + 1;
                      try {
                        final response =
                            await UserAPI(context: context).updateBoard(
                          pk: widget.pk,
                          title: widget.title,
                          creator: widget.creator,
                          content: widget.content,
                          like: newLikeValue,
                          bookmark: bookmarkTmp,
                        );

                        final response2 = await UserAPI(context: context)
                            .insertElasticSearchBoard(
                          id: widget.pk,
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
                              pk: widget.pk,
                              title: widget.title,
                              creator: widget.creator,
                              content: widget.content,
                              like: likeTmp,
                              bookmark: newBookmarkValue,
                            );

                            final response2 =
                            await UserAPI(context: context).insertElasticSearchBoard(
                              id: widget.pk,
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
                              pk: widget.pk,
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
                          Icons.star_border_rounded,
                          size: 60,
                        ),
                      ),
              ],
            )
          ],
        ));
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
                      builder: (context) => BoardUpdatePage(
                          pk: pk,
                          title: widget.title,
                          creator: widget.creator,
                          content: widget.content,
                          like: likeTmp,
                          bookmark: bookmarkTmp)));
            },
            child: Text('UPDATE')),
        ElevatedButton(
            onPressed: () async {
              final response =
                  await UserAPI(context: context).deleteBoard(pk: pk);

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
