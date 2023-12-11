import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("회원가입"),),
      body: _buildLogin(),
    );
  }

  Future<dynamic> _showDialog(BuildContext context) {
    return showDialog(
        context: context, builder: (BuildContext context) =>
        AlertDialog(
          elevation: 10.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          title: Text('로그인 실패'),
          content: Text(' 이메일 또는 비밀번호가 일치하지 않습니다.'),
          actions: [
            ElevatedButton(onPressed: () =>
                Navigator.of(context).pop(), child: Text('확인'))
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
                  labelText: '이메일',
                  hintText: 'ex) kooyh108@xxx.com',
                  border: OutlineInputBorder(),
                ),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: 'ex) very hard key',
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이름',
                  hintText: 'ex) 구윤형',
                  border: OutlineInputBorder(),
                ),
                controller: sexController,
                obscureText: true,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '전화번호',
                  hintText: 'ex) 01041073965',
                  border: OutlineInputBorder(),
                ),
                controller: phoneController,
                obscureText: true,
              ),
              SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '성별',
                  hintText: 'ex) 구윤형',
                  border: OutlineInputBorder(),
                ),
                controller: nameController,
                obscureText: true,
              ),
              SizedBox(height: 10,),
              SignInButton(Buttons.Email, onPressed: (){

              })
            ],
          )
      ),
    );
  }
}
