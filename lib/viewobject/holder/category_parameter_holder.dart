import '../../constant/ps_constants.dart';
import '../common/ps_holder.dart';

class CategoryParameterHolder extends PsHolder<dynamic> {
  CategoryParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
  }

  String? orderBy;
  String? searchTerm;


 CategoryParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;
    searchTerm = '';
    return this;
  }

  CategoryParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm=  '';
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['order_by'] = orderBy;
    map['searchterm'] = searchTerm;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
  
    orderBy = PsConst.FILTERING__ADDED_DATE;
    searchTerm = dynamicData['searchterm'];
    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy! + ':';
    }

    return result;
  }
}
