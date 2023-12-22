import 'package:flutter/material.dart';

class CheckValidate {

  // 이메일 입력 형식 체크
  String? validateEmail(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이메일을 입력하세요.';
    } else {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus(); //포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      } else {
        return null;
      }
    }
  }

  // 비밀번호 입력 형식 체크
  String? validatePassword(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      String pattern =
          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?~^<>,.&+=])[A-Za-z\d$@$!%*#?~^<>,.&+=]{6,20}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '특수문자, 대소문자, 숫자 포함 6자 이상 20자 이내로 입력하세요.';
      } else {
        return null;
      }
    }
  }

  // 비밀번호 확인 입력 형식 체크
  String? validatePasswordConfirm(
      FocusNode focusNode, String value, String value2) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '비밀번호를 입력하세요.';
    } else {
      if (value != value2) {
        focusNode.requestFocus();
        return '비밀번호와 일치하지 않습니다.';
      } else {
        return null;
      }
    }
  }

  // 이름 입력 형식 체크
  String? validateName(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '이름을 입력하세요.';
    } else {
      String pattern = r'^[가-힣A-Za-z]{2,5}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '2자리 이상 5자리 이하의 한글 또는 영문을 입력하여 주십시오.';
      } else {
        return null;
      }
    }
  }

  // 전화번호 입력 형식 체크
  String? validatePhone(FocusNode focusNode, String value) {
    if (value.isEmpty) {
      focusNode.requestFocus();
      return '전화번호를 입력하세요.';
    } else {
      String pattern = r'^(010|011|017|031)\d{8,10}$';
      RegExp regExp = new RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        focusNode.requestFocus();
        return '잘못된 전화번호 형식입니다.';
      } else {
        return null;
      }
    }
  }
}
