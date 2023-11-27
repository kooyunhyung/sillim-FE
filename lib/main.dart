import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DetailPage.dart';

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
  int _selectedIndex = 0; // Drawer 인덱스 0,1,2
  var _pages = [
    Page1(), // home
    Page2(), // 전체글
    Page3(), // 인기글
    //Page4(),      // 즐겨찾기
    //Page5(),      // 전체공지
  ];

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
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
      body: _pages[_index],
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

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildTop(),
        _buildMiddle(context),
        _buildBottom(context),
      ],
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
                  print('클릭');
                },
                child: Text(
                  '전체글',
                  style: TextStyle(fontSize: 21),
                ),
              ),
              InkWell(
                onTap: () {
                  print('클릭');
                },
                child: Text(
                  '인기글',
                  style: TextStyle(fontSize: 21),
                ),
              ),
              InkWell(
                onTap: () {
                  print('클릭');
                },
                child: Text(
                  '즐겨찾기',
                  style: TextStyle(fontSize: 21),
                ),
              ),
              InkWell(
                onTap: () {
                  print('클릭');
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

  // 하단
  Widget _buildBottom(context) {
    final items = List.generate(5, (i) {
      return ListTile(
        leading: Icon(Icons.notifications_none),
        title: Text('[이벤트] 이것은 공지사항입니다'),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage())
          );
        },
      );
    });

    return ListView(
      physics: NeverScrollableScrollPhysics(), //이 리스트의 스크롤 동작 금지
      shrinkWrap: true, //이 리스트가 다른 스크롤 객체 안에 있다면 true로 설정해야 함
      children: items,
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '이용 서비스',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '내 정보',
        style: TextStyle(fontSize: 40),
      ),
    );
  }
}
