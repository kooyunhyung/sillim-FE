import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/user_api.dart';

import 'page/board/BoardCreatePage.dart';
import 'page/board/BoardDetailPage.dart';
import 'page/join/JoinPage.dart';
import 'page/login/LoginPage.dart';
import 'page/notice/NoticeCreatePage.dart';
import 'page/notice/NoticeDetailPage.dart';

final dummyItems = [
  'https://www.housingherald.co.kr/news/photo/202109/42098_18894_922.jpg',
  'https://img.seoul.co.kr/img/upload/2023/08/28/SSC_20230828180347_V.jpg',
  'https://cdn.rcnews.co.kr/news/photo/202306/31797_32539_4734.jpg',
];

void main() async {
  runApp(MyApp());
}

// 루트 위젯
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sillim Dong Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        pk: -1,
        email: "",
        name: "",
        sex: "",
        phone: "",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _drawerIndex = 0; // Drawer 인덱스 0,1,2

  void _onItemTapped(int index) {
    setState(() {
      _drawerIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  color: Colors.indigo,
                ),
                child: widget.pk == -1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.account_circle_sharp,
                            color: Colors.white,
                            size: 73,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.power_settings_new,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      '로그인',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => JoinPage()));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    Text(
                                      '회원가입',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.account_circle_sharp,
                                color: Colors.white,
                                size: 73,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                                pk: -1,
                                                email: "",
                                                name: "",
                                                sex: "",
                                                phone: "",
                                              )),
                                      (route) => false);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '로그아웃',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.name}님 환영합니다.',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              Text(
                                '${widget.email}',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      )),
            ListTile(
              leading: Icon(Icons.house),
              title: const Text('Home'),
              trailing: Icon(Icons.add),
              selected: _drawerIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Setting'),
              trailing: Icon(Icons.add),
              selected: _drawerIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: const Text('Q&A'),
              trailing: Icon(Icons.add),
              selected: _drawerIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        //배경색을 흰색으로
        iconTheme: IconThemeData(color: Colors.black, size: 35),
        title: Text(
          '신림동 소식',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, //제목을 가운데로
      ),
      body: frame(
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone),
    );
  }
}

class frame extends StatefulWidget {
  frame(
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
  _frameState createState() => _frameState();
}

class _frameState extends State<frame> {
  var _index = 0; //페이지 인덱스 0,1,2

  @override
  Widget build(BuildContext context) {
    var _pages = [
      BoardPage(
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone), // 전체글
      PopularBoardPage(
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone), // 인기글
      BookMarkedPage(
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone), // 즐겨찬기
      NoticePage(
          pk: widget.pk,
          email: widget.email,
          name: widget.name,
          sex: widget.sex,
          phone: widget.phone) // 전체공지
    ];

    return ListView(
      children: [_buildTop(), _buildMiddle(context), _pages[_index]],
    );
  }

  // 상단
  Widget _buildTop() {
    return CarouselSlider(
      options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enableInfiniteScroll: true,
          enlargeCenterPage: true,
          autoPlayInterval: const Duration(seconds: 3),

          // autoPlayAnimationDuration: Duration(seconds: 4)
      ),
      items: dummyItems.map((url) {
        //다섯 페이지
        return Builder(
          builder: (BuildContext context) {
            //context를 사용하고자 할 때
            return Container(
                width: MediaQuery.of(context).size.width, //기기의 가로 길이
                margin: EdgeInsets.symmetric(horizontal: 5.0), //좌우 여백 5
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                  ),
                ));
          },
        );
      }).toList(),
    );
  }

  // 중단
  Widget _buildMiddle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20), //위, 아래 여백
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _index = 0;
                  });
                },
                child: Text(
                  '전체글',
                  style: TextStyle(
                      decoration: _index == 0
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 5,
                      fontSize: 21,
                      color: _index == 0 ? Colors.deepPurple : Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _index = 1;
                  });
                },
                child: Text(
                  '인기글',
                  style: TextStyle(
                      decoration: _index == 1
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 5,
                      fontSize: 21,
                      color: _index == 1 ? Colors.deepPurple : Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _index = 2;
                  });
                },
                child: Text(
                  '즐겨찾기',
                  style: TextStyle(
                      decoration: _index == 2
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 5,
                      fontSize: 21,
                      color: _index == 2 ? Colors.deepPurple : Colors.black),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _index = 3;
                  });
                },
                child: Text(
                  '전체공지',
                  style: TextStyle(
                      decoration: _index == 3
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.deepPurple,
                      decorationThickness: 5,
                      fontSize: 21,
                      color: _index == 3 ? Colors.deepPurple : Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 1.0,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

// 전체글
class BoardPage extends StatefulWidget {
  BoardPage(
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
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  var _index = 0; // 일반 글이냐 검색된 글이냐

  final _search_condition = ['제목', '작성자', '내용'];
  String? _selectedCondition;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedCondition = _search_condition[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    var _pages = [_buildBottomAll(context), _buildBottomSearched(context)];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: [_pages[_index], _buildButton(context, width, height)],
    );
  }

  // 하단 (전체글 불러오기)
  Widget _buildBottomAll(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchBoards(context),
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
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.message_outlined),
                          title: Text(
                            '${snapshot.data[index]['sb_title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                          pk: widget.pk,
                                          boardPk: snapshot.data[index]
                                              ['sb_id'],
                                          email: widget.email,
                                          sex: widget.sex,
                                          phone: widget.phone,
                                          title: snapshot.data[index]
                                              ['sb_title'],
                                          name: widget.name,
                                          creator: snapshot.data[index]
                                              ['sb_creator'],
                                          content: snapshot.data[index]
                                              ['sb_content'],
                                          like: snapshot.data[index]['sb_like'],
                                          bookmark: snapshot.data[index]
                                              ['sb_bookmark'],
                                          date: snapshot.data[index]['sb_date'],
                                        )));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  // 하단 (검색된 글 불러오기)
  Widget _buildBottomSearched(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchBoardsSearched(context),
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
        } else if (snapshot.data.length == 0) {
          return Container(
            child: Text('검색결과가 존재하지 않습니다'),
          );
        } else {
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.message_outlined),
                          title: Text(
                            '${snapshot.data[index]["_source"]['boardTitle']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                          pk: widget.pk,
                                          boardPk: snapshot.data[index]
                                              ['_source']['boardId'],
                                          email: widget.email,
                                          sex: widget.sex,
                                          phone: widget.phone,
                                          title: snapshot.data[index]['_source']
                                              ['boardTitle'],
                                          name: widget.name,
                                          creator: snapshot.data[index]
                                              ['_source']['boardCreator'],
                                          content: snapshot.data[index]
                                              ['_source']['boardContent'],
                                          like: snapshot.data[index]['_source']
                                              ['boardLike'],
                                          bookmark: snapshot.data[index]
                                              ['_source']['boardBookmark'],
                                          date: snapshot.data[index]['_source']
                                              ['boardDate'],
                                        )));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(context, width, height) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                if (widget.pk == -1) {
                  _showDialog(context, '로그인 후 작성할 수 있습니다');
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BoardCreatePage(
                                pk: widget.pk,
                                email: widget.email,
                                name: widget.name,
                                sex: widget.sex,
                                phone: widget.phone,
                              )));
                }
              },
              child: Text('게시글 작성')),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.05,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                    underline: SizedBox.shrink(),
                    value: _selectedCondition,
                    items: _search_condition
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCondition = value!;
                        print(_selectedCondition);
                      });
                    }),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              Container(
                width: width * 0.47,
                height: height * 0.05,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _index = 1;
                  });
                },
                child: Container(
                  width: width * 0.1,
                  height: height * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(
                    Icons.search,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> _fetchBoards(context) async {
    dynamic boardList = await UserAPI(context: context).readBoards();
    print(boardList);
    return boardList;
  }

  Future<dynamic> _fetchBoardsSearched(context) async {
    if (_selectedCondition == '제목') {
      dynamic searchedBoard = await UserAPI(context: context)
          .readElasticSearchBoardsByTitle(searchText: searchController.text);
      dynamic searchedData = searchedBoard["hits"]["hits"];
      return searchedData;
    } else if (_selectedCondition == '작성자') {
      dynamic searchedBoard = await UserAPI(context: context)
          .readElasticSearchBoardsByCreator(searchText: searchController.text);
      dynamic searchedData = searchedBoard["hits"]["hits"];
      print(searchedData);
      return searchedData;
    } else {
      dynamic searchedBoard = await UserAPI(context: context)
          .readElasticSearchBoardsByContent(searchText: searchController.text);
      dynamic searchedData = searchedBoard["hits"]["hits"];
      print(searchedData);
      return searchedData;
    }
  }
}

class PopularBoardPage extends StatefulWidget {
  PopularBoardPage(
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
  State<PopularBoardPage> createState() => _PopularBoardPageState();
}

class _PopularBoardPageState extends State<PopularBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildBottom(context), _buildButton(context)],
    );
  }

  // 하단
  Widget _buildBottom(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchPopularBoards(context),
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
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.message_outlined),
                          title: Text(
                            '${snapshot.data[index]['sb_title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                          pk: widget.pk,
                                          boardPk: snapshot.data[index]
                                              ['sb_id'],
                                          title: snapshot.data[index]
                                              ['sb_title'],
                                          email: widget.email,
                                          sex: widget.sex,
                                          phone: widget.phone,
                                          name: widget.name,
                                          creator: snapshot.data[index]
                                              ['sb_creator'],
                                          content: snapshot.data[index]
                                              ['sb_content'],
                                          like: snapshot.data[index]['sb_like'],
                                          bookmark: snapshot.data[index]
                                              ['sb_bookmark'],
                                          date: snapshot.data[index]['sb_date'],
                                        )));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardCreatePage(
                            pk: widget.pk,
                            email: widget.email,
                            name: widget.name,
                            sex: widget.sex,
                            phone: widget.phone,
                          )));
            },
            child: Text('게시글 작성')),
      ],
    );
  }

  Future<dynamic> _fetchPopularBoards(context) async {
    dynamic boardList = await UserAPI(context: context).readPopularBoards();
    print(boardList);
    return boardList;
  }
}

class BookMarkedPage extends StatefulWidget {
  BookMarkedPage(
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
  State<BookMarkedPage> createState() => _BookMarkedPageState();
}

class _BookMarkedPageState extends State<BookMarkedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildBottom(context), _buildButton(context)],
    );
  }

  // 하단
  Widget _buildBottom(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchBookmarkBoards(context),
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
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.message_outlined),
                          title: Text(
                            '${snapshot.data[index]['sb_title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                        pk: widget.pk,
                                        boardPk: snapshot.data[index]['sb_id'],
                                        email: widget.email,
                                        sex: widget.sex,
                                        phone: widget.phone,
                                        title: snapshot.data[index]['sb_title'],
                                        name: widget.name,
                                        creator: snapshot.data[index]
                                            ['sb_creator'],
                                        content: snapshot.data[index]
                                            ['sb_content'],
                                        like: snapshot.data[index]['sb_like'],
                                        bookmark: snapshot.data[index]
                                            ['sb_bookmark'],
                                        date: snapshot.data[index]
                                            ['sb_date'])));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardCreatePage(
                            pk: widget.pk,
                            email: widget.email,
                            name: widget.name,
                            sex: widget.sex,
                            phone: widget.phone,
                          )));
            },
            child: Text('게시글 작성')),
      ],
    );
  }

  Future<dynamic> _fetchBookmarkBoards(context) async {
    dynamic boardList = await UserAPI(context: context).readBookmarkedBoards();
    print(boardList);
    return boardList;
  }
}

class NoticePage extends StatefulWidget {
  NoticePage(
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
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  var _index = 0;
  final _search_condition = ['제목', '작성자', '내용'];
  String? _selectedCondition;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCondition = _search_condition[0];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    var _pages = [_buildBottomAll(context), _buildBottomSearched(context)];

    return Column(
      children: [
        _pages[_index],
        _buildButton(
          context,
          width,
          height,
        )
      ],
    );
  }

  // 하단
  Widget _buildBottomAll(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchNotices(context),
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
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text(
                            '${snapshot.data[index]['sn_title']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoticeDetailPage(
                                          pk: snapshot.data[index]['sn_id'],
                                          email: widget.email,
                                          sex: widget.sex,
                                          phone: widget.phone,
                                          title: snapshot.data[index]
                                              ['sn_title'],
                                          name: snapshot.data[index]
                                              ['sn_creator'],
                                          content: snapshot.data[index]
                                              ['sn_content'],
                                          date: snapshot.data[index]['sn_date'],
                                        )));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomSearched(context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _fetchNoticesSearched(context),
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
          return Container(
            width: width,
            height: height * 0.4,
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                ...List.generate(
                    snapshot.data.length,
                    (index) => ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text(
                            '${snapshot.data[index]['_source']["noticeTitle"]}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoticeDetailPage(
                                          pk: snapshot.data[index]['noticeId'],
                                          email: widget.email,
                                          sex: widget.sex,
                                          phone: widget.phone,
                                          title: snapshot.data[index]
                                              ['noticeTitle'],
                                          name: snapshot.data[index]
                                              ['noticeCreator'],
                                          content: snapshot.data[index]
                                              ['noticeContent'],
                                          date: snapshot.data[index]
                                              ['noticeDate'],
                                        )));
                          },
                        ))
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton(context, width, height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              if (widget.pk == -1) {
                _showDialog(context, "로그인 후 작성할 수 있습니다");
              } else if (widget.name != "운영자") {
                _showDialog(context, "권한이 없습니다.");
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoticeCreatePage(
                            pk: widget.pk,
                            email: widget.email,
                            name: widget.name,
                            sex: widget.sex,
                            phone: widget.phone)));
              }
            },
            child: Text('공지사항 작성')),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height * 0.05,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton(
                  underline: SizedBox.shrink(),
                  value: _selectedCondition,
                  items: _search_condition
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value!;
                    });
                  }),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Container(
              width: width * 0.47,
              height: height * 0.05,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: TextFormField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 5.0)),
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _index = 1;
                });
              },
              child: Container(
                width: width * 0.1,
                height: height * 0.05,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<dynamic> _fetchNotices(context) async {
    dynamic noticeList = await UserAPI(context: context).readNotices();
    print(noticeList);
    return noticeList;
  }

  Future<dynamic> _fetchNoticesSearched(context) async {
    if (_selectedCondition == '제목') {
      dynamic searchedNotice = await UserAPI(context: context)
          .readElasticSearchNoticesByTitle(searchText: searchController.text);
      dynamic searchedData = searchedNotice["hits"]["hits"];
      print(searchedData);
      return searchedData;
    } else if (_selectedCondition == '작성자') {
      dynamic searchedNotice = await UserAPI(context: context)
          .readElasticSearchNoticesByCreator(searchText: searchController.text);
      dynamic searchedData = searchedNotice["hits"]["hits"];
      print(searchedData);
      return searchedData;
    } else {
      dynamic searchedNotice = await UserAPI(context: context)
          .readElasticSearchNoticesByContent(searchText: searchController.text);
      dynamic searchedData = searchedNotice["hits"]["hits"];
      print(searchedData);
      return searchedData;
    }
  }
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
