
import 'package:flutterstore/db/common/ps_dao.dart';
import 'package:flutterstore/viewobject/search_history.dart';
import 'package:sembast/sembast.dart';

class SearchHistoryDao extends PsDao<SearchHistory> {
  SearchHistoryDao._() {
    init(SearchHistory());
  }
  static const String STORE_NAME = 'SearchHistory';
  final String _primaryKey = 'searchterm';

  // Singleton instance
  static final SearchHistoryDao _singleton = SearchHistoryDao._();

  // Singleton accessor
  static SearchHistoryDao get instance => _singleton;

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  String? getPrimaryKey(SearchHistory object) {
    return object.searchTeam;
  }

  @override
  Filter getFilter(SearchHistory object) {
    return Filter.equals(_primaryKey, object.searchTeam);
  }
}
