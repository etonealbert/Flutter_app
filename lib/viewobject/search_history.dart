

import 'package:flutterstore/viewobject/common/ps_map_object.dart';

class SearchHistory extends PsMapObject<SearchHistory> {
  SearchHistory({
    this.searchTeam});

  String? searchTeam;

  @override
  String? getPrimaryKey() {
    return searchTeam;
  }

  @override
  SearchHistory fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return SearchHistory(
        searchTeam: dynamicData['searchterm']);
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic> ?toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['searchterm'] = object.searchTeam;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<SearchHistory> fromMapList(List<dynamic> dynamicDataList) {
    final List<SearchHistory> favouriteProductMapList = <SearchHistory>[];

    //if (dynamicDataList != null) {
      for (dynamic dynamicData in dynamicDataList) {
        if (dynamicData != null) {
          favouriteProductMapList.add(fromMap(dynamicData));
        }
      }
    //}
    return favouriteProductMapList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];
    //if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          dynamicList.add(toMap(data));
        }
      }
   // }

    return dynamicList;
  }

  @override
  List<String> getIdList(List<dynamic> mapList) {
    final List<String> idList = <String>[];
   // if (mapList != null) {
      for (dynamic product in mapList) {
        if (product != null) {
          idList.add(product.id);
        }
      }
   // }
    return idList;
  }
}