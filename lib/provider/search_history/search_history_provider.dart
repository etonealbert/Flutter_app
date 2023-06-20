import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/search_history_repository.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/search_history.dart';

class SearchHistoryProvider extends PsProvider {
  SearchHistoryProvider({required SearchHistoryRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('Search History Provider: $hashCode');

    searchHistoryListStream = StreamController<PsResource<List<SearchHistory>>>.broadcast();
    subscription =
        searchHistoryListStream.stream.listen((PsResource<List<SearchHistory>> resource) {
      updateOffset(resource.data!.length);

      _historyList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  SearchHistoryRepository? _repo;

  PsResource<List<SearchHistory>> _historyList =
      PsResource<List<SearchHistory>>(PsStatus.NOACTION, '', <SearchHistory>[]);

  PsResource<List<SearchHistory>> get historyList => _historyList;
 late StreamSubscription<PsResource<List<SearchHistory>>> subscription;
late  StreamController<PsResource<List<SearchHistory>>> searchHistoryListStream;
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('History Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadSearchHistoryList() async {
    isLoading = true;
    await _repo!.getAllSearchHistoryList(searchHistoryListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> addSearchHistoryList(SearchHistory searchHistory) async {
    isLoading = true;
    await _repo!.addAllSearchHistoryList(
        searchHistoryListStream, PsStatus.PROGRESS_LOADING, searchHistory);
  }

  Future<void> resetSearchHistoryList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllSearchHistoryList(searchHistoryListStream, PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> deleteSearchHistory(SearchHistory searchHistory) async {
    isLoading = true;
    await _repo!.deleteSearchHistory(searchHistoryListStream, searchHistory);
  }

}