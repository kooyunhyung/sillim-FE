import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../../api/user_api.dart';
import '../../main.dart';
import '../../util/CheckValidate.dart';

class JoinPage extends StatefulWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

enum Sex { M, W }

class _JoinPageState extends State<JoinPage> {
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();
  FocusNode _passwordConfirmFocus = new FocusNode();
  FocusNode _nameFocus = new FocusNode();
  FocusNode _phoneFocus = new FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Sex _sex = Sex.M;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: new Form(
          key: formKey,
          child: Column(
            children: [
              _showEmailInput(),
              _showPasswordInput(),
              _showPasswordConfirmInput(),
              _showNameInput(),
              _showPhoneInput(),
              _showSexInput(),
              _showOkBtn()
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, String text, dynamic response) {
    int userId=response['obj']['su_id'];
    String userEmail=response['obj']['su_email'];
    String userName=response['obj']['su_name'];
    String userSex=response['obj']['su_sex'];
    String userPhone=response['obj']['su_phone'];

    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              title: Text('회원가입 성공'),
              content: Text('$text'),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyHomePage(pk: userId, email: userEmail, name: userName, sex: userSex, phone: userPhone)),
                            (route) => false),
                    child: Text('확인'))
              ],
            ));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  focusNode: _emailFocus,
                  decoration: _textFormDecoration('이메일', '이메일을 입력해주세요'),
                  validator: (value) =>
                      CheckValidate().validateEmail(_emailFocus, value!),
                )),
          ],
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: _textFormDecoration(
                      '비밀번호', '특수문자, 대소문자, 숫자 포함 6자 이상 20자 이내로 입력하세요.'),
                  validator: (value) =>
                      CheckValidate().validatePassword(_passwordFocus, value!),
                )),
          ],
        ));
  }

  Widget _showPasswordConfirmInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _passwordConfirmController,
                  focusNode: _passwordConfirmFocus,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: _textFormDecoration('비밀번호 확인', '비밀번호를 다시 입력하세요.'),
                  validator: (value) => CheckValidate().validatePasswordConfirm(
                      _passwordConfirmFocus, value!, _passwordController.text),
                )),
          ],
        ));
  }

  Widget _showNameInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  keyboardType: TextInputType.name,
                  obscureText: false,
                  decoration: _textFormDecoration('이름', '이름을 입력하세요.'),
                  validator: (value) =>
                      CheckValidate().validateName(_nameFocus, value!),
                )),
          ],
        ));
  }

  Widget _showPhoneInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  obscureText: false,
                  decoration:
                      _textFormDecoration('전화번호', '전화번호를 (-) 없이 입력하세요.'),
                  validator: (value) =>
                      CheckValidate().validatePhone(_phoneFocus, value!),
                )),
          ],
        ));
  }

  Widget _showSexInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      child: RadioListTile(
                          title: Text('남'),
                          value: Sex.M,
                          groupValue: _sex,
                          onChanged: (value) {
                            setState(() {
                              _sex = value!;
                            });
                          }),
                    ),
                    Container(
                      width: 100,
                      child: RadioListTile(
                          title: Text('여'),
                          value: Sex.W,
                          groupValue: _sex,
                          onChanged: (value) {
                            setState(() {
                              _sex = value!;
                            });
                          }),
                    )
                  ],
                )),
          ],
        ));
  }

  Widget _showOkBtn() {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: SignInButton(
          Buttons.Email,
          onPressed: () async {
            bool? flag = formKey.currentState?.validate();

            if (flag == true) {
              final response = await UserAPI(context: context).createUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  name: _nameController.text,
                  sex: (_sex == Sex.M) ? "M" : "W",
                  phone: _phoneController.text);

              print(response);

              _showDialog(context, "회원 가입이 되었습니다.", response);
            }
          },
        ));
  }

  InputDecoration _textFormDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
    );
  }
}
