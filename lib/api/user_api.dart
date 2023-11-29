import 'dart:convert';
import 'package:flutter/material.dart';
import 'common_api.dart';

class UserAPI extends CommonAPI {
  UserAPI({required BuildContext context, bool? listen})
      : super(context, listen: listen);

  // 새 계정 생성
  Future<Map<String, dynamic>> createNotice(
      {required String title,
      required String creator,
      required String content}) async {
    final response = await post('sillim/notice', body: {
      "sn_title": title,
      "sn_creator": creator,
      "sn_content": content,
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  Future<dynamic> readNotice() async {
    final response = await get('sillim/notice', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  //계정 수정
  Future<Map<String, dynamic>> updateNotice(
      {required pk,
      required String title,
      required String creator,
      required String content}) async {
    final response = await post('sillim/notice/$pk', body: {
      "sn_title": title,
      "sn_creator": creator,
      "sn_content": content,
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 계정 삭제
  Future<Map<String, dynamic>> deleteNotice({required pk}) async {
    final request =
        await delete('sillim/notice/$pk', body: {}, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(request.bodyBytes));
    return result;
  }
}
