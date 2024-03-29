import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/api/ps_api_service.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/db/product_collection_header_dao.dart';
import 'package:flutterstore/repository/Common/ps_repository.dart';
import 'package:flutterstore/viewobject/product_collection_header.dart';

class ProductCollectionRepository extends PsRepository {
  ProductCollectionRepository(
      {required PsApiService psApiService,
      required ProductCollectionDao productCollectionDao}) {
    _psApiService = psApiService;
    _productCollectionDao = productCollectionDao;
  }

 late PsApiService _psApiService;
 late ProductCollectionDao _productCollectionDao;
  final String _primaryKey = 'id';

  void sinkProductListStream(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      PsResource<List<ProductCollectionHeader>> ?dataList) {
    if (dataList != null) {
      productCollectionListStream.sink.add(dataList);
    }
  }

  void sinkProductStream(
      StreamController<PsResource<ProductCollectionHeader>>
          productCollectionStream,
      PsResource<ProductCollectionHeader>? data) {
    if (data != null) {
      productCollectionStream.sink.add(data);
    }
  }

  Future<dynamic> insert(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.insert(_primaryKey, productCollectionHeader);
  }

  Future<dynamic> update(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.update(productCollectionHeader);
  }

  Future<dynamic> delete(
      ProductCollectionHeader productCollectionHeader) async {
    return _productCollectionDao.delete(productCollectionHeader);
  }

  Future<dynamic> getProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));

    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _psApiService.getProductCollectionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        await _productCollectionDao.deleteAll();
        await _productCollectionDao.insertAll(_primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _productCollectionDao.deleteAll();
        }
      }
      sinkProductListStream(
          productCollectionListStream, await _productCollectionDao.getAll());
    }
  }

  Future<dynamic> getNextPageProductCollectionList(
      StreamController<PsResource<List<ProductCollectionHeader>>>
          productCollectionListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    sinkProductListStream(productCollectionListStream,
        await _productCollectionDao.getAll(status: status));
    if (isConnectedToInternet) {
      final PsResource<List<ProductCollectionHeader>> _resource =
          await _psApiService.getProductCollectionList(limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        _productCollectionDao
            .insertAll(_primaryKey, _resource.data!)
            .then((dynamic data) async {
          sinkProductListStream(productCollectionListStream,
              await _productCollectionDao.getAll());
        });
      } else {
        sinkProductListStream(
            productCollectionListStream, await _productCollectionDao.getAll());
      }
    }
  }
}
