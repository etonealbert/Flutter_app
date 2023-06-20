import 'dart:async';
import '../../api/common/ps_resource.dart';
import '../../api/common/ps_status.dart';
import '../../repository/category_repository.dart';
import '../../utils/utils.dart';
import '../../viewobject/category.dart';
import '../../viewobject/common/ps_value_holder.dart';
import '../../viewobject/holder/category_parameter_holder.dart';
import '../common/ps_provider.dart';

class SearchCategoryProvider extends PsProvider {
  SearchCategoryProvider(
      {required CategoryRepository repo,
      required this.valueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
  
    Utils.checkInternetConnectivity()
        .then((bool value) => isConnectedToInternet = value);

    _categoryListStream =
        StreamController<PsResource<List<Category>>>.broadcast();
    _subscription = _categoryListStream.stream
        .listen((PsResource<List<Category>> resource) {
      updateOffset(resource.data!.length);
      _categoryList = resource;
      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }
      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  CategoryRepository? _repo;
  PsValueHolder valueHolder;
  PsResource<List<Category>> _categoryList =
      PsResource<List<Category>>(PsStatus.NOACTION, '', <Category>[]);
  PsResource<List<Category>> get categoryList => _categoryList;
  late StreamSubscription<PsResource<List<Category>>> _subscription;
  late StreamController<PsResource<List<Category>>> _categoryListStream;

  @override
  void dispose() {
    _subscription.cancel();
    isDispose = true;
    super.dispose();
  }

  Future<dynamic> loadCatgoryListByKey(
      CategoryParameterHolder categoryParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    if (isConnectedToInternet) {
      await _repo!.getCategoryListByKey(
          _categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          categoryParameterHolder,
          PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }

  Future<dynamic> loadNextCatgoryListByKey(
      CategoryParameterHolder categoryParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (isConnectedToInternet) {
      await _repo!.getCategoryListByKey(
          _categoryListStream,
          isConnectedToInternet,
          limit,
          offset,
          categoryParameterHolder,
          PsStatus.PROGRESS_LOADING);
    }
    return isConnectedToInternet;
  }
}
