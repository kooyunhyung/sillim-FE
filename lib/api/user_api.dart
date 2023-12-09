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

  // 새 공지 elastic search에게 insert
  Future<Map<String, dynamic>> insertElasticSearchNotice(
      {required int id,
      required String title,
      required String creator,
      required String content}) async {
    final response = await post('apis3/insert', body: {
      "noticeId": id,
      "noticeTitle": title,
      "noticeCreator": creator,
      "noticeContent": content,
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

  // elastic search 로부터 공지 조회 (제목별)
  Future<dynamic> readElasticSearchNoticesByTitle({required String searchText}) async {
    final response = await getElastic('notices_index/_search', body: {
      "query": {
        "bool": {
          "must": [
            {
              "match_phrase": {"noticeTitle": searchText}
            }
          ],
          "should": [
            {
              "match": {
                "noticeTitle": {"query": searchText}
              }
            },
            {
              "match": {
                "noticeContent": {"query": searchText}
              }
            }
          ]
        }
      }
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // elastic search 로부터 공지 조회 (작성자별)
  Future<dynamic> readElasticSearchNoticesByCreator(
      {required String searchText}) async {
    final response = await getElastic('notices_index/_search', body: {
      "query": {
        "wildcard": {"noticeCreator": "*$searchText*"}
      }
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // elastic search 로부터 공지 조회 (내용별)
  Future<dynamic> readElasticSearchNoticesByContent(
      {required String searchText}) async {
    final response = await getElastic('notices_index/_search', body: {
      "query": {
        "match": {
          "noticeContent": searchText
        }
      }
    }, headers: {}, params: {});
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

  // elastic search 공지 삭제
  void deleteElasticSearchNotice({required pk}) {
    delete('apis3/delete/$pk', body: {}, params: {}, headers: {});
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

  // 새 게시글 elastic search에게 insert
  Future<Map<String, dynamic>> insertElasticSearchBoard(
      {required int id,
      required String title,
      required String creator,
      required String content,
      required int like,
      required bool bookmark}) async {
    final response = await post('apis2/insert', body: {
      "boardId": id,
      "boardTitle": title,
      "boardCreator": creator,
      "boardContent": content,
      "boardLike": like,
      "boardBookmark": bookmark
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

  // elastic search 로부터 게시글 조회 (제목별)
  Future<dynamic> readElasticSearchBoardsByTitle(
      {required String searchText}) async {
    final response = await getElastic('boards_index/_search', body: {
      "query": {
        "bool": {
          "must": [
            {
              "match_phrase": {"boardTitle": searchText}
            }
          ],
          "should": [
            {
              "match": {
                "boardTitle": {"query": searchText}
              }
            },
            {
              "match": {
                "boardContent": {"query": searchText}
              }
            }
          ]
        }
      }
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // elastic search 로부터 게시글 조회 (작성자별)
  Future<dynamic> readElasticSearchBoardsByCreator(
      {required String searchText}) async {
    final response = await getElastic('boards_index/_search', body: {
      "query": {
        "wildcard": {"boardCreator": "*$searchText*"}
      }
    }, headers: {}, params: {});
    final result = jsonDecode(utf8.decode(response.bodyBytes));
    return result;
  }

  // elastic search 로부터 게시글 조회 (내용별)
  Future<dynamic> readElasticSearchBoardsByContent(
      {required String searchText}) async {
    final response = await getElastic('boards_index/_search', body: {
      "query": {
        "match": {
          "boardContent": searchText
        }
      }
    }, headers: {}, params: {});
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
    final response =
        await get('sillim/board/bookmark', headers: {}, params: {});
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

  // elastic search 게시글 삭제
  void deleteElasticSearchBoard({required pk}) {
    delete('apis2/delete/$pk', body: {}, params: {}, headers: {});
  }
}
