import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/provider/common/ps_provider.dart';
import 'package:flutterstore/repository/clear_all_data_repository.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

class ClearAllDataProvider extends PsProvider {
  ClearAllDataProvider(
      {required ClearAllDataRepository repo,
      this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    print('ClearAllData Provider: $hashCode');
    allListStream = StreamController<PsResource<List<Product>>>.broadcast();
    subscription =
        allListStream.stream.listen((PsResource<List<Product>> resource) {
      updateOffset(resource.data!.length);

      _basketList = resource;

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

 late StreamController<PsResource<List<Product>>> allListStream;
  ClearAllDataRepository? _repo;
  PsValueHolder? psValueHolder;

  PsResource<List<Product>> _basketList =
      PsResource<List<Product>>(PsStatus.NOACTION, '', <Product>[]);

  PsResource<List<Product>> get basketList => _basketList;
 late StreamSubscription<PsResource<List<Product>>> subscription;
  @override
  void dispose() {
    subscription.cancel();

    isDispose = true;
    print('ClearAll Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> clearAllData() async {
    isLoading = true;
    _repo!.clearAllData(allListStream);
  }
}
