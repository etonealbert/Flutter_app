import 'dart:async';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/api/ps_api_service.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/db/favourite_product_dao.dart';
import 'package:flutterstore/db/product_collection_dao.dart';
import 'package:flutterstore/db/product_dao.dart';
import 'package:flutterstore/db/product_map_dao.dart';
import 'package:flutterstore/db/related_product_dao.dart';
import 'package:flutterstore/repository/Common/ps_repository.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/api_status.dart';
import 'package:flutterstore/viewobject/download_product.dart';
import 'package:flutterstore/viewobject/favourite_product.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:flutterstore/viewobject/product_collection.dart';
import 'package:flutterstore/viewobject/product_map.dart';
import 'package:flutterstore/viewobject/related_product.dart';
import 'package:sembast/sembast.dart';

class ProductRepository extends PsRepository {
  ProductRepository(
      {required PsApiService psApiService, required ProductDao productDao}) {
    _psApiService = psApiService;
    _productDao = productDao;
  }
  String primaryKey = 'id';
  String mapKey = 'map_key';
  String collectionIdKey = 'collection_id';
  String mainProductIdKey = 'main_product_id';
 late PsApiService _psApiService;
 late ProductDao _productDao;

  void sinkProductListStream(
      StreamController<PsResource<List<Product>>>? productListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && productListStream != null) {
      productListStream.sink.add(dataList);
    }
  }

  void sinkFavouriteProductListStream(
      StreamController<PsResource<List<Product>>>? favouriteProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && favouriteProductListStream != null) {
      favouriteProductListStream.sink.add(dataList);
    }
  }

  void sinkCollectionProductListStream(
      StreamController<PsResource<List<Product>>> ?collectionProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && collectionProductListStream != null) {
      collectionProductListStream.sink.add(dataList);
    }
  }

  void sinkProductDetailStream(
      StreamController<PsResource<Product>> productDetailStream,
      PsResource<Product>? data) {
    if (data != null) {
      productDetailStream.sink.add(data);
    }
  }

  void sinkRelatedProductListStream(
      StreamController<PsResource<List<Product>>>? relatedProductListStream,
      PsResource<List<Product>>? dataList) {
    if (dataList != null && relatedProductListStream != null) {
      relatedProductListStream.sink.add(dataList);
    }
  }

  Future<dynamic> insert(Product product) async {
    return _productDao.insert(primaryKey, product);
  }

  Future<dynamic> update(Product product) async {
    return _productDao.update(product);
  }

  Future<dynamic> delete(Product product) async {
    return _productDao.delete(product);
  }

  Future<dynamic> getProductList(
      StreamController<PsResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;

    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getProductList(holder.toMap(), limit, offset);

      print('Param Key $paramKey');
      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        int i = 0;
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        // Delete and Insert Map Dao
        print('Delete Key $paramKey');
        await productMapDao
            .deleteWithFinder(Finder(filter: Filter.equals(mapKey, paramKey)));
        print('Insert All Key $paramKey');
        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await productMapDao.deleteWithFinder(
              Finder(filter: Filter.equals(mapKey, paramKey)));
        }
      }

      // Load updated Data from Db and Send to UI
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  Future<dynamic> getNextPageProductList(
      StreamController<PsResource<List<Product>>> productListStream,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      ProductParameterHolder holder,
      {bool isLoadFromServer = true}) async {
    final String paramKey = holder.getParamKey();
    final ProductMapDao productMapDao = ProductMapDao.instance;
    // Load from Db and Send to UI
    sinkProductListStream(
        productListStream,
        await _productDao.getAllByMap(
            primaryKey, mapKey, paramKey, productMapDao, ProductMap(),
            status: status));
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getProductList(holder.toMap(), limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductMap> productMapList = <ProductMap>[];
        final PsResource<List<ProductMap>>? existingMapList = await productMapDao
            .getAll(finder: Finder(filter: Filter.equals(mapKey, paramKey)));

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          productMapList.add(ProductMap(
              id: data.id! + paramKey,
              mapKey: paramKey,
              productId: data.id,
              sorting: i++,
              addedDate: '2019'));
        }

        await productMapDao.insertAll(primaryKey, productMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkProductListStream(
          productListStream,
          await _productDao.getAllByMap(
              primaryKey, mapKey, paramKey, productMapDao, ProductMap()));
    }
  }

  Future<dynamic> getProductDetail(
      StreamController<PsResource<Product>> productDetailStream,
      String productId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, productId));
    sinkProductDetailStream(productDetailStream,
        await _productDao.getOne(status: status, finder: finder));

    if (isConnectedToInternet) {
      final PsResource<Product> _resource =
          await _psApiService.getProductDetail(productId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _productDao.deleteWithFinder(finder);
        }
      }
      sinkProductDetailStream(
          productDetailStream, await _productDao.getOne(finder: finder));
    }
  }

  Future<dynamic> getProductDetailForFav(
      StreamController<PsResource<Product>> productDetailStream,
      String productId,
      String loginUserId,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder = Finder(filter: Filter.equals(primaryKey, productId));

    if (isConnectedToInternet) {
      final PsResource<Product> _resource =
          await _psApiService.getProductDetail(productId, loginUserId);

      if (_resource.status == PsStatus.SUCCESS) {
        await _productDao.deleteWithFinder(finder);
        await _productDao.insert(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await _productDao.deleteWithFinder(finder);
        }
      }
      sinkProductDetailStream(
          productDetailStream, await _productDao.getOne(finder: finder));
    }
  }

  Future<PsResource<List<DownloadProduct>>> postDownloadProductList(
      Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<List<DownloadProduct>> _resource =
        await _psApiService.postDownloadProductList(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<List<DownloadProduct>>> completer =
          Completer<PsResource<List<DownloadProduct>>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getAllFavouritesList(
      StreamController<PsResource<List<Product>>> favouriteProductListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final FavouriteProductDao favouriteProductDao =
        FavouriteProductDao.instance;

    // Load from Db and Send to UI
    sinkFavouriteProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, FavouriteProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getFavouritesList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteProduct> favouriteProductMapList =
            <FavouriteProduct>[];
        int i = 0;
        for (Product data in _resource.data!) {
          favouriteProductMapList.add(FavouriteProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await favouriteProductDao.deleteAll();
        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);
        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await favouriteProductDao.deleteAll();
        }
      }

      // Load updated Data from Db and Send to UI
      sinkFavouriteProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, FavouriteProduct()));
    }
  }

  Future<dynamic> getNextPageFavouritesList(
      StreamController<PsResource<List<Product>>> favouriteProductListStream,
      String loginUserId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final FavouriteProductDao favouriteProductDao =
        FavouriteProductDao.instance;
    // Load from Db and Send to UI
    sinkFavouriteProductListStream(
        favouriteProductListStream,
        await _productDao.getAllByJoin(
            primaryKey, favouriteProductDao, FavouriteProduct(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource =
          await _psApiService.getFavouritesList(loginUserId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<FavouriteProduct> favouriteProductMapList =
            <FavouriteProduct>[];
        final PsResource<List<FavouriteProduct>>? existingMapList =
            await favouriteProductDao.getAll();

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          favouriteProductMapList.add(FavouriteProduct(
            id: data.id,
            sorting: i++,
          ));
        }

        await favouriteProductDao.insertAll(
            primaryKey, favouriteProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkFavouriteProductListStream(
          favouriteProductListStream,
          await _productDao.getAllByJoin(
              primaryKey, favouriteProductDao, FavouriteProduct()));
    }
  }

  Future<PsResource<Product>> postFavourite(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<Product> _resource =
        await _psApiService.postFavourite(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<Product>> completer =
          Completer<PsResource<Product>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<PsResource<ApiStatus>> postTouchCount(Map<dynamic, dynamic> jsonMap,
      bool isConnectedToInternet, PsStatus status,
      {bool isLoadFromServer = true}) async {
    final PsResource<ApiStatus> _resource =
        await _psApiService.postTouchCount(jsonMap);
    if (_resource.status == PsStatus.SUCCESS) {
      return _resource;
    } else {
      final Completer<PsResource<ApiStatus>> completer =
          Completer<PsResource<ApiStatus>>();
      completer.complete(_resource);
      return completer.future;
    }
  }

  Future<dynamic> getRelatedProductList(
      StreamController<PsResource<List<Product>>> relatedProductListStream,
      String productId,
      String categoryId,
      bool isConnectedToInternet,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    // Prepare Holder and Map Dao
    // final String paramKey = holder.getParamKey();
    final Finder finder =
        Finder(filter: Filter.equals(mainProductIdKey, productId));
    final RelatedProductDao relatedProductDao = RelatedProductDao.instance;

    // Load from Db and Send to UI

    sinkCollectionProductListStream(
        relatedProductListStream,
        await _productDao.getAllDataListWithFilterId(
            productId, mainProductIdKey, relatedProductDao, RelatedProduct(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getRelatedProductList(productId, categoryId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<RelatedProduct> relatedProductMapList = <RelatedProduct>[];
        int i = 0;
        for (Product data in _resource.data!) {
          relatedProductMapList.add(RelatedProduct(
            id: data.id,
            mainProductId: productId,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        // await relatedProductDao.deleteAll();
        await relatedProductDao.deleteWithFinder(finder);
        await relatedProductDao.insertAll(primaryKey, relatedProductMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);

        // Load updated Data from Db and Send to UI
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await relatedProductDao.deleteWithFinder(finder);
        }
      }
      sinkCollectionProductListStream(
          relatedProductListStream,
          await _productDao.getAllDataListWithFilterId(
              productId, mainProductIdKey, relatedProductDao, RelatedProduct(),
              status: status));
    }
  }

  ///Product list By Collection Id

  Future<dynamic> getAllproductListByCollectionId(
      StreamController<PsResource<List<Product>>> productCollectionStream,
      bool isConnectedToInternet,
      String collectionId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals(collectionIdKey, collectionId));
    final ProductCollectionDao productCollectionDao =
        ProductCollectionDao.instance;

    // Load from Db and Send to UI
    sinkCollectionProductListStream(
        productCollectionStream,
        await _productDao.getAllDataListWithFilterId(collectionId,
            collectionIdKey, productCollectionDao, ProductCollection(),
            status: status));

    // Server Call
    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getProductListByCollectionId(collectionId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductCollection> productCollectionMapList =
            <ProductCollection>[];
        int i = 0;
        for (Product data in _resource.data!) {
          productCollectionMapList.add(ProductCollection(
            id: data.id,
            collectionId: collectionId,
            sorting: i++,
          ));
        }

        // Delete and Insert Map Dao
        await productCollectionDao.deleteWithFinder(finder);
        await productCollectionDao.insertAll(
            primaryKey, productCollectionMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      } else {
        if (_resource.errorCode == PsConst.ERROR_CODE_10001) {
          await productCollectionDao.deleteWithFinder(finder);
        }
      }
      // Load updated Data from Db and Send to UI

      sinkCollectionProductListStream(
          productCollectionStream,
          await _productDao.getAllDataListWithFilterId(collectionId,
              collectionIdKey, productCollectionDao, ProductCollection()));

      Utils.psPrint('End of Collection Product');
    }
  }

  Future<dynamic> getNextPageproductListByCollectionId(
      StreamController<PsResource<List<Product>>> productCollectionStream,
      bool isConnectedToInternet,
      String collectionId,
      int limit,
      int offset,
      PsStatus status,
      {bool isLoadFromServer = true}) async {
    final Finder finder =
        Finder(filter: Filter.equals('collection_id', collectionId));
    final ProductCollectionDao productCollectionDao =
        ProductCollectionDao.instance;
    // Load from Db and Send to UI
    sinkCollectionProductListStream(
        productCollectionStream,
        await _productDao.getAllDataListWithFilterId(collectionId,
            collectionIdKey, productCollectionDao, ProductCollection(),
            status: status));

    if (isConnectedToInternet) {
      final PsResource<List<Product>> _resource = await _psApiService
          .getProductListByCollectionId(collectionId, limit, offset);

      if (_resource.status == PsStatus.SUCCESS) {
        // Create Map List
        final List<ProductCollection> productCollectionMapList =
            <ProductCollection>[];
        final PsResource<List<ProductCollection>>? existingMapList =
            await productCollectionDao.getAll(finder: finder);

        int i = 0;
        if (existingMapList != null) {
          i = existingMapList.data!.length + 1;
        }
        for (Product data in _resource.data!) {
          productCollectionMapList.add(ProductCollection(
            id: data.id,
            collectionId: collectionId,
            sorting: i++,
          ));
        }

        await productCollectionDao.insertAll(
            primaryKey, productCollectionMapList);

        // Insert Product
        await _productDao.insertAll(primaryKey, _resource.data!);
      }
      sinkCollectionProductListStream(
          productCollectionStream,
          await _productDao.getAllDataListWithFilterId(collectionId,
              collectionIdKey, productCollectionDao, ProductCollection()));
      Utils.psPrint('End of Collection Product');
    }
  }
}
