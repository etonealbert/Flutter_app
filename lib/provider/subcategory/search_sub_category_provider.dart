import 'dart:async';
import '../../api/common/ps_resource.dart';
import '../../api/common/ps_status.dart';
import '../../repository/sub_category_repository.dart';
import '../../utils/utils.dart';
import '../../viewobject/common/ps_value_holder.dart';
import '../../viewobject/holder/sub_category_parameter_holder.dart';
import '../../viewobject/sub_category.dart';
import '../common/ps_provider.dart';

class SearchSubCategoryProvider extends PsProvider {
  SearchSubCategoryProvider(
      {required SubCategoryRepository repo,
      required this.valueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    _subCategoryListStream =
        StreamController<PsResource<List<SubCategory>>>.broadcast();
    _subscription = _subCategoryListStream.stream
        .listen((PsResource<List<SubCategory>> resource) {
      updateOffset(resource.data!.length);
      _subCategoryList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  SubCategoryRepository? _repo;
  PsValueHolder valueHolder;
  PsResource<List<SubCategory>> _subCategoryList =
      PsResource<List<SubCategory>>(PsStatus.NOACTION, '', <SubCategory>[]);
  PsResource<List<SubCategory>> get subCategoryList => _subCategoryList;
  late StreamController<PsResource<List<SubCategory>>> _subCategoryListStream;
  late StreamSubscription<PsResource<List<SubCategory>>> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<dynamic> loadSubCategoryListByKey(
      SubCategoryParameterHolder subCategoryParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getSubCategoryListByKey(
        _subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        subCategoryParameterHolder);
  }

  Future<dynamic> resetSubCategoryList(
      SubCategoryParameterHolder subCategoryParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    updateOffset(0);
    await _repo!.getSubCategoryListByKey(
        _subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        subCategoryParameterHolder);
  }

  Future<dynamic> loadNextSubCategoryList(
      SubCategoryParameterHolder subCategoryParameterHolder) async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getNextPageSubCategoryListByKey(
        _subCategoryListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        subCategoryParameterHolder);
  }
}
