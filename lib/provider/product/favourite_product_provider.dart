import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

class FavouriteProductProvider extends PsProvider {
  FavouriteProductProvider(
      {required ProductRepository repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('Favourite Product Provider: $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    favouriteListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        favouriteListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _productList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<Product>>> favouriteListStream;

  ProductRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<Product> _favourite =
      PsResource<Product>(PsStatus.NOACTION, '', null);
  PsResource<Product> get user => _favourite;

  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get favouriteProductList => _productList;
 late StreamSubscription<PsResource<List<Product>>> subscription;

  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    favouriteListStream.close();
    isDispose = true;
    print('Favourite Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadFavouriteProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getAllFavouritesList(
        favouriteListStream,
        psValueHolder!.loginUserId!,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> nextFavouriteProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;
      await _repo!.getNextPageFavouritesList(
          favouriteListStream,
          psValueHolder!.loginUserId!,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING);
    }
  }

  Future<void> resetFavouriteProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();
    isLoading = true;

    updateOffset(0);

    await _repo!.getAllFavouritesList(
        favouriteListStream,
        psValueHolder!.loginUserId!,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);

    isLoading = false;
  }

  Future<dynamic> postFavourite(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _favourite = await _repo!.postFavourite(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _favourite;
  }
}
