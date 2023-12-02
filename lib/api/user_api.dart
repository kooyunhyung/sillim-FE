import 'dart:convert';
import 'package:flutter/material.dart';
import 'common_api.dart';

class UserAPI extends CommonAPI {
  UserAPI({required BuildContext context, bool? listen})
      : super(context, listen: listen);

  // 새 공지 생성
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

  // 공지 조회 (전체)
  Future<dynamic> readNotices() async {
    final response = await get('sillim/notice', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 공지 조회 (단건)
  Future<dynamic> readNotice(int pk) async {
    final response = await get('sillim/notice/$pk', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  //공지 수정
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

  // 공지 삭제
  Future<Map<String, dynamic>> deleteNotice({required pk}) async {
    final request =
        await delete('sillim/notice/$pk', body: {}, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(request.bodyBytes));
    return result;
  }

  // 새 게시글 생성
  Future<Map<String, dynamic>> createBoard(
      {required String title,
      required String creator,
      required String content}) async {
    final response = await post('sillim/board', body: {
      "sb_title": title,
      "sb_creator": creator,
      "sb_content": content,
      "sb_like": 0,
      "sb_bookmark": false
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 게시글 조회 (전체)
  Future<dynamic> readBoards() async {
    final response = await get('sillim/board', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 게시 인기글 조회 (좋아요 5 이상)
  Future<dynamic> readPopularBoards() async {
    final response = await get('sillim/board/popular', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 게시글 즐겨찾기 조회 (즐겨찾기 표시한 글)
  Future<dynamic> readBookmarkedBoards() async {
    final response = await get('sillim/board/bookmark', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }



  // 게시글 조회 (단건)
  Future<dynamic> readBoard(int pk) async {
    final response = await get('sillim/board/$pk', headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 게시글 수정
  Future<Map<String, dynamic>> updateBoard(
      {required pk,
      required String title,
      required String creator,
      required String content,
      required int like,
      required bool bookmark}) async {
    final response = await post('sillim/board/$pk', body: {
      "sb_title": title,
      "sb_creator": creator,
      "sb_content": content,
      "sb_like": like,
      "sb_bookmark": bookmark
    }, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // 게시글 삭제
  Future<Map<String, dynamic>> deleteBoard({required pk}) async {
    final request =
        await delete('sillim/board/$pk', body: {}, params: {}, headers: {});
    final result = jsonDecode(utf8.decode(request.bodyBytes));
    return result;
  }
}
