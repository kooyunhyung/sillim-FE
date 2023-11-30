import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/user_api.dart';

import 'page/notice/CreatePage.dart';
import 'page/notice/DetailPage.dart';

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
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 30),
                )),
            ListTile(
              title: const Text('Home'),
              selected: _drawerIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _drawerIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(
                Icons.house_rounded,
                color: Colors.black,
                size: 42,
              ),
              onPressed: () {},
            ),
          ),
        ],
        centerTitle: true, //제목을 가운데로
      ),
      body: frame(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index, //선택된 인덱스
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: '숙박정보',
            icon: Icon(Icons.hotel),
          ),
          BottomNavigationBarItem(
            label: '음식점 정보',
            icon: Icon(Icons.restaurant),
          ),
        ],
      ),
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
      //PopularBoardPage(), // 인기글
      //BookMarkedPage(), // 즐겨찬기
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
class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

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
                          leading: Icon(Icons.notifications_none),
                          title: Text('${snapshot.data[index]['sb_title']}'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        pk: snapshot.data[index]['sb_id'],
                                        title: snapshot.data[index]['sb_title'],
                                        creator: snapshot.data[index]
                                            ['sb_creator'],
                                        content: snapshot.data[index]
                                            ['sb_content'])));
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
                  MaterialPageRoute(builder: (context) => CreatePage()));
            },
            child: Text('게시글 작성')),
      ],
    );
  }

  Future<dynamic> _fetchBoards(context) async {
    dynamic boardList = await UserAPI(context: context).readBoards();
    print(boardList);
    return boardList;
  }
}

// class PopularBoardPage extends StatelessWidget {
//   const PopularBoardPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         '이용 서비스',
//         style: TextStyle(fontSize: 40),
//       ),
//     );
//   }
// }

// class BookMarkedPage extends StatelessWidget {
//   const BookMarkedPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         '내 정보',
//         style: TextStyle(fontSize: 40),
//       ),
//     );
//   }
// }

class NoticePage extends StatelessWidget {
  const NoticePage({Key? key}) : super(key: key);

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
                      leading: Icon(Icons.notifications_none),
                      title: Text('${snapshot.data[index]['sb_title']}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    pk: snapshot.data[index]['sb_id'],
                                    title: snapshot.data[index]['sb_title'],
                                    creator: snapshot.data[index]
                                    ['sb_creator'],
                                    content: snapshot.data[index]
                                    ['sb_content'])));
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
                  MaterialPageRoute(builder: (context) => CreatePage()));
            },
            child: Text('게시글 작성')),
      ],
    );
  }

  Future<dynamic> _fetchNotices(context) async {
    dynamic noticeList = await UserAPI(context: context).readNotices();
    print(noticeList);
    return noticeList;
  }

}
