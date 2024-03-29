
import 'package:flutterstore/viewobject/common/ps_object.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:quiver/core.dart';

import 'default_photo.dart';

class BestChoice extends PsObject<BestChoice> {
  BestChoice(
      {this.id,
      this.name,
      this.status,
      this.addedDate,
      this.addedUserId,
      this.updatedDate,
      this.updatedUserId,
      this.updatedFlag,
      this.addedDateStreet,
      this.ratingStatus,
      this.defaultPhoto,
      this.productList,});
  String? id;
  String? name;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? addedDateStreet;
  String? ratingStatus;
  DefaultPhoto? defaultPhoto;
  List<Product>? productList;

  @override
  bool operator ==(dynamic other) =>
      other is BestChoice && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  BestChoice fromMap(dynamic dynamicData) {
   // if (dynamicData != null) {
      return BestChoice(
          id: dynamicData['id'],
          name: dynamicData['name'],
          status: dynamicData['status'],
          addedDate: dynamicData['added_date'],
          addedUserId: dynamicData['added_user_id'],
          updatedDate: dynamicData['updated_date'],
          updatedUserId: dynamicData['updated_user_id'],
          updatedFlag: dynamicData['updated_flag'],
          addedDateStreet: dynamicData['added_date_str'],
          ratingStatus: dynamicData['rating_status'],
          defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
          productList: Product().fromMapList(dynamicData['products']),
          );
    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic> ?toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['name'] = object.name;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['added_date_str'] = object.addedDateStreet;
      data['rating_status'] = object.ratingStatus;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['products'] = Product().toMapList(object.productList);
      return data;
    } else {
      return null;
    }
  }

  @override
  List<BestChoice> fromMapList(List<dynamic> dynamicDataList) {
    final List<BestChoice> subCategoryList =
        <BestChoice>[];

   // if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          subCategoryList.add(fromMap(json));
        }
      }
   // }
    return subCategoryList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> mapList = <Map<String, dynamic>?>[];
   // if (objectList != null) {
      for (dynamic data in objectList) {
        if (data != null) {
          mapList.add(toMap(data));
        }
      }
   // }

    return mapList;
  }
}