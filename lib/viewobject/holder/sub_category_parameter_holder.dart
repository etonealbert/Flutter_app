import '../../constant/ps_constants.dart';
import '../common/ps_holder.dart';

class SubCategoryParameterHolder extends PsHolder<dynamic> {
  SubCategoryParameterHolder() {
    orderType = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm = '';
  }

  String? orderBy;
  String? orderType;
  String? searchTerm;

  // SubCategoryParameterHolder getTrendingParameterHolder() {
  //   orderType = '';
  //   orderBy = PsConst.FILTERING__TRENDING;
  //   searchTerm = '';
  //   return this;
  // }

  // SubCategoryParameterHolder getLatestParameterHolder() {
  //   orderType = '';
  //   orderBy = PsConst.FILTERING__ADDED_DATE;
  //   searchTerm = '';
  //   return this;
  // }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_type'] = orderType;
    map['order_by'] = orderBy;
    map['searchterm'] = searchTerm;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderType = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm = dynamicData['searchterm'];
    return this;
  }

  @override
  String getParamKey() {
    const String result = '';

    // if (shopId != '') {
    //   result += shopId + ':';
    // }
    // if (orderBy != '') {
    //   result += orderBy + ':';
    // }

    return result;
  }
}
