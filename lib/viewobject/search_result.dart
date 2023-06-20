import 'package:flutterstore/viewobject/product.dart';
import 'package:flutterstore/viewobject/sub_category.dart';

import 'category.dart';
import 'common/ps_object.dart';

class SearchResult extends PsObject<SearchResult> {
  SearchResult({
    this.id,
    this.products,
    this.categories,
    this.subCategories,
  });

  final String? id;
  final List<Product>? products;
  final List<Category>? categories;
  final List<SubCategory>? subCategories;

  @override
  SearchResult fromMap(dynamic dynamicData) {
    
      return SearchResult(
        id: dynamicData['id'],
        products: Product().fromMapList(dynamicData['products']),
        categories: Category().fromMapList(dynamicData['categories']),
        subCategories: SubCategory().fromMapList(dynamicData['subcategories']),
      );
  
  }

  @override
  List<SearchResult> fromMapList(List<dynamic>? dynamicDataList) {
    final List<SearchResult> list = <SearchResult>[];
    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          list.add(fromMap(json));
        }
      }
    }
    return list;
  }

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Map<String, dynamic>? toMap(SearchResult object) {
    
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['products'] = Product().toMapList(object.products!);
      data['categories'] = Category().toMapList(object.categories!);
      data['subcategories'] = SubCategory().toMapList(object.subCategories!);
      return data;
   
  }

  @override
  List<Map<String, dynamic>> toMapList(List<SearchResult>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (dynamic data in mapList) {
        if (data != null) {
          mapList.add(toMap(data)!);
        }
      }
    }
    return mapList;
  }
}
