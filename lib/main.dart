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

void main() {
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _index = 0; //페이지 인덱스 0,1,2
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
                child: Column(
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
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage()));
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
                                style:
                                    TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => JoinPage()));
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
                                style:
                                    TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        )
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
      body: frame(),
    );
  }
}

class frame extends StatefulWidget {
  const frame({Key? key}) : super(key: key);

  @override
  _frameState createState() => _frameState();
}

class _frameState extends State<frame> {
  var _index = 0; //페이지 인덱스 0,1,2

  @override
  Widget build(BuildContext context) {
    var _pages = [
      BoardPage(), // 전체글
      PopularBoardPage(), // 인기글
      BookMarkedPage(), // 즐겨찬기
      NoticePage() // 전체공지
    ];

    return ListView(
      children: [_buildTop(), _buildMiddle(context), _pages[_index]],
    );
  }

  // 상단
  Widget _buildTop() {
    return CarouselSlider(
      options: CarouselOptions(height: 200.0),
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
                  style: TextStyle(fontSize: 21),
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
                  style: TextStyle(fontSize: 21),
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
                  style: TextStyle(fontSize: 21),
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
                  style: TextStyle(fontSize: 21),
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
  const BoardPage({Key? key}) : super(key: key);

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
                          title: Text('${snapshot.data[index]['sb_title']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                        pk: snapshot.data[index]['sb_id'],
                                        title: snapshot.data[index]['sb_title'],
                                        creator: snapshot.data[index]
                                            ['sb_creator'],
                                        content: snapshot.data[index]
                                            ['sb_content'],
                                        like: snapshot.data[index]['sb_like'],
                                        bookmark: snapshot.data[index]
                                            ['sb_bookmark'])));
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
                              '${snapshot.data[index]["_source"]['boardTitle']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                        pk: snapshot.data[index]['_source']
                                            ['boardId'],
                                        title: snapshot.data[index]['_source']
                                            ['boardTitle'],
                                        creator: snapshot.data[index]['_source']
                                            ['boardCreator'],
                                        content: snapshot.data[index]['_source']
                                            ['boardContent'],
                                        like: snapshot.data[index]['_source']
                                            ['boardLike'],
                                        bookmark: snapshot.data[index]
                                            ['_source']['boardBookmark'])));
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BoardCreatePage()));
              },
              child: Text('게시글 작성')),
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
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(border: InputBorder.none),
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
      print(searchedData);
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

class PopularBoardPage extends StatelessWidget {
  const PopularBoardPage({Key? key}) : super(key: key);

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
                          title: Text('${snapshot.data[index]['sb_title']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                        pk: snapshot.data[index]['sb_id'],
                                        title: snapshot.data[index]['sb_title'],
                                        creator: snapshot.data[index]
                                            ['sb_creator'],
                                        content: snapshot.data[index]
                                            ['sb_content'],
                                        like: snapshot.data[index]['sb_like'],
                                        bookmark: snapshot.data[index]
                                            ['sb_bookmark'])));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardCreatePage()));
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

class BookMarkedPage extends StatelessWidget {
  const BookMarkedPage({Key? key}) : super(key: key);

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
                          title: Text('${snapshot.data[index]['sb_title']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BoardDetailPage(
                                        pk: snapshot.data[index]['sb_id'],
                                        title: snapshot.data[index]['sb_title'],
                                        creator: snapshot.data[index]
                                            ['sb_creator'],
                                        content: snapshot.data[index]
                                            ['sb_content'],
                                        like: snapshot.data[index]['sb_like'],
                                        bookmark: snapshot.data[index]
                                            ['sb_bookmark'])));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BoardCreatePage()));
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
  const NoticePage({Key? key}) : super(key: key);

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
      children: [_pages[_index], _buildButton(context, width, height)],
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
                          title: Text('${snapshot.data[index]['sn_title']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoticeDetailPage(
                                        pk: snapshot.data[index]['sn_id'],
                                        title: snapshot.data[index]['sn_title'],
                                        creator: snapshot.data[index]
                                            ['sn_creator'],
                                        content: snapshot.data[index]
                                            ['sn_content'])));
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
                              '${snapshot.data[index]['_source']["noticeTitle"]}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NoticeDetailPage(
                                        pk: snapshot.data[index]['_source']
                                            ['noticeId'],
                                        title: snapshot.data[index]['_source']
                                            ['noticeTitle'],
                                        creator: snapshot.data[index]['_source']
                                            ['noticeCreator'],
                                        content: snapshot.data[index]['_source']
                                            ['noticeContent'])));
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NoticeCreatePage()));
            },
            child: Text('공지사항 작성')),
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
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(5)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: TextField(
                  controller: searchController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(border: InputBorder.none),
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
