import 'package:flutter/material.dart';
import 'package:flutter_app/api/user_api.dart';
import 'package:flutter_app/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 이메일과 비밀번호 입력 컨트롤러
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
      ),
      body: _buildLogin(),
    );
  }

  // 로그인 실패시 뜨는 다이얼로그 창
  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              title: Text('로그인 실패'),
              content: Text(' 이메일 또는 비밀번호가 일치하지 않습니다.'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('확인'))
              ],
            ));
  }

  _buildLogin() {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'eg) kooyh108@xxx.com',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'eg) very hard key',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {

                    // 유저 로그인 API 함수 호출
                    dynamic response = await UserAPI(context: context)
                        .userLogin(
                            email: emailController.text,
                            password: passwordController.text);

                    if (response["statusCode"] == 200) {
                      int userId = response['obj']['su_id'];
                      String userEmail = response['obj']['su_email'];
                      String userName = response['obj']['su_name'];
                      String userSex = response['obj']['su_sex'];
                      String userPhone = response['obj']['su_phone'];

                      // 로그인 성공시 유저 정보 DB에서 가져와 페이지 파라미터로 넘겨 메인 페이지로 이동
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    pk: userId,
                                    email: userEmail,
                                    name: userName,
                                    sex: userSex,
                                    phone: userPhone,
                                  )),
                          (route) => false);
                    } else {
                      _showDialog(context);
                    }
                  },
                  child: Text('로그인'))
            ],
          )),
    );
  }
}
