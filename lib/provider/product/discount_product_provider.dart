import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

class DiscountProductProvider extends PsProvider {
  DiscountProductProvider({required ProductRepository repo, int limit = 0})
      : super(repo, limit) {
    _repo = repo;

    print('DiscountProductProvider : $hashCode');
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });

    productListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        productListStream.stream.listen((PsResource<List<Product>> resource) {
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
  ProductRepository? _repo;
  PsResource<List<Product>> _productList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get productList => _productList;
late  StreamSubscription<PsResource<List<Product>>> subscription;
late  StreamController<PsResource<List<Product>>> productListStream;
  @override
  void dispose() {
    //_repo.cate.close();
    subscription.cancel();
    isDispose = true;
    print('Discount Product Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo!.getProductList(
        productListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        ProductParameterHolder().getDiscountParameterHolder());
  }

  Future<dynamic> resetProductList() async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    updateOffset(0);
    await _repo!.getProductList(
        productListStream,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING,
        ProductParameterHolder().getDiscountParameterHolder());
  }

  Future<dynamic> nextProductList() async {
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    if (!isLoading && !isReachMaxData) {
      super.isLoading = true;

      await _repo!.getProductList(
          productListStream,
          isConnectedToInternet,
          limit,
          offset,
          PsStatus.PROGRESS_LOADING,
          ProductParameterHolder().getDiscountParameterHolder());
    }
  }
}
