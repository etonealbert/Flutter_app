import 'dart:async';
import '../../api/common/ps_resource.dart';
import '../../api/common/ps_status.dart';
import '../../repository/search_result_repository.dart';
import '../../utils/utils.dart';
import '../../viewobject/search_result.dart';
import '../common/ps_provider.dart';

class SearchResultProvider extends PsProvider {
  SearchResultProvider(SearchResultRepository repo, {int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    _controller = StreamController<PsResource<SearchResult>>.broadcast();
    _subscription =
        _controller.stream.listen((PsResource<SearchResult> resource) {
      _searchResult = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  late StreamSubscription<PsResource<SearchResult>> _subscription;
  late StreamController<PsResource<SearchResult>> _controller;
  SearchResultRepository? _repo;
  PsResource<SearchResult> _searchResult =
      PsResource<SearchResult>(PsStatus.NOACTION, '', null);
  PsResource<SearchResult> get searchResult => _searchResult;

  @override
  void dispose() {
    _subscription.cancel();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> loadSearchResult(Map<String, dynamic> jsonMap) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    return await _repo!.getSearchResult(
        _controller, PsStatus.PROGRESS_LOADING, isConnectedToInternet, jsonMap);
  }
}
