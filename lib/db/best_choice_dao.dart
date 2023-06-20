
import 'package:flutterstore/db/common/ps_dao.dart';
import 'package:flutterstore/viewobject/best_choice.dart';
import 'package:sembast/sembast.dart';

class BestChoiceDao extends PsDao<BestChoice> {
  BestChoiceDao._() {
    init(BestChoice());
  }

  static const String STORE_NAME = 'BestChoice';
  final String _primaryKey = 'id';
  // Singleton instance
  static final BestChoiceDao _singleton = BestChoiceDao._();

  // Singleton accessor
  static BestChoiceDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String ?getPrimaryKey(BestChoice object) {
    return object.id;
  }

  @override
  Filter getFilter(BestChoice object) {
    return Filter.equals(_primaryKey, object.id);
  }
}