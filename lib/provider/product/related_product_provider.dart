import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

class RelatedProductProvider extends PsProvider {
  RelatedProductProvider(
      {required ProductRepository repo,
      required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('RelatedProductProvider : $hashCode');

    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
    });
    relatedProductListStream =
        StreamController<PsResource<List<Product>>>.broadcast();
    subscription = relatedProductListStream.stream
        .listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _relatedProductList = Utils.removeDuplicateObj<Product>(resource);

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  PsValueHolder psValueHolder;
  ProductRepository? _repo;

  PsResource<List<Product>> _relatedProductList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get relatedProductList => _relatedProductList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
 late StreamController<PsResource<List<Product>>> relatedProductListStream;

  @override
  void dispose() {
    subscription.cancel();
    print('Related Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> loadRelatedProductList(
    String productId,
    String categoryId,
  ) async {
    isLoading = true;

    limit = 10;
    offset = 0;

    isConnectedToInternet = await Utils.checkInternetConnectivity();
    await _repo!.getRelatedProductList(
        relatedProductListStream,
        productId,
        categoryId,
        isConnectedToInternet,
        limit,
        offset,
        PsStatus.PROGRESS_LOADING);
  }
}
