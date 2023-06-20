import 'dart:async';
import 'package:sembast/sembast.dart';

import '../api/common/ps_resource.dart';
import '../api/common/ps_status.dart';
import '../api/ps_api_service.dart';
import '../db/search_result_dao.dart';
import '../viewobject/search_result.dart';
import 'Common/ps_repository.dart';

class SearchResultRepository extends PsRepository {
  SearchResultRepository({
    required PsApiService apiService,
    required SearchResultDao searchResultDao,
  }) {
    _apiService = apiService;
    _searchResultDao = searchResultDao;
  }
  PsApiService? _apiService;
  SearchResultDao? _searchResultDao;
  String primaryKey = 'id';

  Future<dynamic> getSearchResult(
    StreamController<PsResource<SearchResult>> searchResultStream,
    PsStatus status,
    bool isConnectedToInternet,
    Map<String, dynamic> json,
  ) async {
    sinkSearchResultStream(
        searchResultStream,
        await _searchResultDao!.getOne(
          finder: Finder(
            filter: Filter.equals(primaryKey, json['searchterm']),
          ),
          status: status,
        ));

    if (isConnectedToInternet) {
      final PsResource<SearchResult> _resource =
          await _apiService!.getSearchResult(json);

      final SearchResult searchResult = SearchResult(
        id: json['searchterm'],
        categories: _resource.data?.categories,
        subCategories: _resource.data?.subCategories,
        products: _resource.data?.products,
      );
      await _searchResultDao!.insert(primaryKey, searchResult);
      if (_resource.status == PsStatus.SUCCESS) {
        sinkSearchResultStream(searchResultStream, _resource);
      }
    }
  }
}

void sinkSearchResultStream(
    StreamController<PsResource<SearchResult>>? searchResultStream,
    PsResource<SearchResult>? data) {
  if (searchResultStream != null && data != null) {
    searchResultStream.sink.add(data);
  }
}
