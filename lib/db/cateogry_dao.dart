import 'package:flutterstore/db/common/ps_dao.dart' show PsDao;
import 'package:flutterstore/viewobject/category.dart';
import 'package:sembast/sembast.dart';

class CategoryDao extends PsDao<Category> {
  CategoryDao() {
    init(Category());
  }
  static const String STORE_NAME = 'Category';
  final String _primaryKey = 'id';

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(Category object) {
    return object.id;
  }

  @override
  Filter getFilter(Category object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
