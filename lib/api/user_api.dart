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
      required String content
      }) async {
    final response = await post('sillim/notice', body: {
      "sn_title": title,
      "sn_creator": creator,
      "sn_content": content,
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return {"code": result['code']};
  }

  Future<dynamic> readUser() async {
    final response = await get('groad/user/', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  //계정 수정
  Future<Map<String, dynamic>> updateUser(
      {required pk,
      required id,
      required pw,
      required name,
      required gender,
      required birth,
      required email,
      required phone,
      required point,
      required step,
      required profileImage}) async {
    final response = await put('groad/user/$pk/', body: {
      "gu_id": id,
      "gu_pw": pw,
      "gu_name": name,
      "gu_gender": gender,
      "gu_birth_date": birth,
      "gu_email": email,
      "gu_phone_number": phone,
      "gu_point_number": point,
      "gu_step_number": step,
      "gu_profile_image": profileImage
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return {"code": result['code']};
  }

  // 계정 삭제
  Future<Map<String, dynamic>> deleteUser({required pk}) async {
    final request =
        await delete('groad/user/$pk', body: {}, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(request.bodyBytes));
    return {"code": result['code']};
  }
}
