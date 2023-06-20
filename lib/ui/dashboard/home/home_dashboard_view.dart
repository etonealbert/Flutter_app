import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/basket/basket_provider.dart';
import 'package:flutterstore/provider/category/category_provider.dart';
import 'package:flutterstore/provider/category/trending_category_provider.dart';
import 'package:flutterstore/provider/product/discount_product_provider.dart';
import 'package:flutterstore/provider/product/feature_product_provider.dart';
import 'package:flutterstore/provider/product/search_product_provider.dart';
import 'package:flutterstore/provider/product/trending_product_provider.dart';
import 'package:flutterstore/provider/productcollection/product_collection_provider.dart';
import 'package:flutterstore/provider/shop_info/shop_info_provider.dart';
import 'package:flutterstore/repository/Common/notification_repository.dart';
import 'package:flutterstore/repository/basket_repository.dart';
import 'package:flutterstore/repository/category_repository.dart';
import 'package:flutterstore/repository/product_collection_repository.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/repository/shop_info_repository.dart';
import 'package:flutterstore/ui/category/item/category_horizontal_list_item.dart';
import 'package:flutterstore/ui/category/item/category_horizontal_trending_list_item.dart';
import 'package:flutterstore/ui/common/dialog/choose_attribute_dialog.dart';
import 'package:flutterstore/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterstore/ui/common/dialog/noti_dialog.dart';
import 'package:flutterstore/ui/common/dialog/rating_dialog/core.dart';
import 'package:flutterstore/ui/common/dialog/rating_dialog/style.dart';
import 'package:flutterstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterstore/ui/dashboard/home/collection_product_slider.dart';
import 'package:flutterstore/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:flutterstore/ui/product/item/product_horizontal_list_item.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/basket.dart';
import 'package:flutterstore/viewobject/basket_selected_attribute.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/category_parameter_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:flutterstore/viewobject/product_collection_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shimmer/shimmer.dart';

class HomeDashboardViewWidget extends StatefulWidget {
  const HomeDashboardViewWidget(
      this.animationController, this.context, this.onNotiClicked);

  final AnimationController animationController;
  final BuildContext context;

  final Function onNotiClicked;

  @override
  _HomeDashboardViewWidgetState createState() =>
      _HomeDashboardViewWidgetState();
}

class _HomeDashboardViewWidgetState extends State<HomeDashboardViewWidget> {
  late PsValueHolder valueHolder;
  CategoryRepository? repo1;
  ProductRepository? repo2;
  ProductCollectionRepository? repo3;
  ShopInfoRepository? shopInfoRepository;
  NotificationRepository? notificationRepository;
  CategoryProvider? _categoryProvider;
  ShopInfoProvider? _shopInfoProvider;
  TrendingCategoryProvider? _trendingCategoryProvider;
  SearchProductProvider? _searchProductProvider;
  DiscountProductProvider? _discountProductProvider;
  TrendingProductProvider? _trendingProductProvider;
  FeaturedProductProvider? _featuredProductProvider;
  ProductCollectionProvider? _productCollectionProvider;
  BasketProvider? _basketProvider;
  BasketRepository? basketRepository;

  final int count = 8;

  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();

  final CategoryParameterHolder trendingCategory = CategoryParameterHolder();
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

  final RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 5,
      remindLaunches: 1);

  @override
  void initState() {
    super.initState();
    if (_categoryProvider != null) {
      _categoryProvider!.loadCategoryList(categoryIconList.toMap());
    }

    if (Platform.isAndroid) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: Utils.getString(context, 'home__menu_drawer_rate_this_app'),
            message: Utils.getString(context, 'rating_popup_dialog_message'),
            ignoreNativeDialog: true,
            actionsBuilder: (BuildContext context, double? stars) {
              return <Widget>[
                TextButton(
                  child: Text(
                    Utils.getString(context, 'dialog__ok'),
                  ),
                  onPressed: () async {
                    if (stars != null) {
                      // _rateMyApp.save().then((void v) => Navigator.pop(context));
                      Navigator.pop(context);
                      if (stars < 1) {
                      } else if (stars >= 1 && stars <= 3) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.laterButtonPressed);
                        await showDialog<dynamic>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialogView(
                                description: Utils.getString(
                                    context, 'rating_confirm_message'),
                                leftButtonText:
                                    Utils.getString(context, 'dialog__cancel'),
                                rightButtonText: Utils.getString(
                                    context, 'home__menu_drawer_contact_us'),
                                onAgreeTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    RoutePaths.contactUs,
                                  );
                                },
                              );
                            });
                      } else if (stars >= 4) {
                        await _rateMyApp
                            .callEvent(RateMyAppEventType.rateButtonPressed);
                        if (Platform.isIOS) {
                          Utils.launchAppStoreURL(
                              iOSAppId: valueHolder.iOSAppStoreId,
                              writeReview: true);
                        } else {
                          Utils.launchURL();
                        }
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )
              ];
            },
            onDismissed: () =>
                _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 16.0),
            ),
            starRatingOptions: const StarRatingOptions(),
          );
        }
      });
    }
  }

  Future<void> onSelectNotification(String payload) async {
    // ignore: unnecessary_null_comparison
    if (context == null) {
      widget.onNotiClicked(payload);
    } else {
      return showDialog<dynamic>(
        context: context,
        builder: (_) {
          return NotiDialog(message: '$payload');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<CategoryRepository>(context);
    repo2 = Provider.of<ProductRepository>(context);
    repo3 = Provider.of<ProductCollectionRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    notificationRepository = Provider.of<NotificationRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ShopInfoProvider>(
              lazy: false,
              create: (BuildContext context) {
                _shopInfoProvider = ShopInfoProvider(
                    repo: shopInfoRepository!,
                    psValueHolder: valueHolder,
                    ownerCode: 'HomeDashboardViewWidget');
                _shopInfoProvider!.loadShopInfo();
                return _shopInfoProvider!;
              }),
          ChangeNotifierProvider<CategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _categoryProvider ??= CategoryProvider(
                    repo: repo1!,
                    psValueHolder: valueHolder,
                    limit: int.parse(valueHolder.categoryLoadingLimit!));
                _categoryProvider!
                    .loadCategoryList(categoryIconList.toMap())
                    .then((dynamic value) {
                  // Utils.psPrint("Is Has Internet " + value);
                  final bool isConnectedToIntenet = value ?? bool;
                  if (!isConnectedToIntenet) {
                    Fluttertoast.showToast(
                        msg: 'No Internet Connectiion. Please try again !',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white);
                  }
                });
                return _categoryProvider!;
              }),
          ChangeNotifierProvider<TrendingCategoryProvider>(
              lazy: false,
              create: (BuildContext context) {
                _trendingCategoryProvider = TrendingCategoryProvider(
                    repo: repo1!,
                    psValueHolder: valueHolder,
                    limit: int.parse(valueHolder.categoryLoadingLimit!));
                _trendingCategoryProvider!
                    .loadTrendingCategoryList(trendingCategory.toMap());
                return _trendingCategoryProvider!;
              }),
          ChangeNotifierProvider<SearchProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _searchProductProvider = SearchProductProvider(
                    repo: repo2!, limit: int.parse(valueHolder.latestProductLoadingLimit!));
                _searchProductProvider!.loadProductListByKey(
                    ProductParameterHolder().getLatestParameterHolder());
                return _searchProductProvider!;
              }),
          ChangeNotifierProvider<DiscountProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _discountProductProvider = DiscountProductProvider(
                    repo: repo2!,
                    limit: int.parse(valueHolder.discountProductLoadingLimit!));
                _discountProductProvider!.loadProductList();
                return _discountProductProvider!;
              }),
          ChangeNotifierProvider<TrendingProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _trendingProductProvider = TrendingProductProvider(
                    repo: repo2!,
                    limit: int.parse(valueHolder.trendingProductLoadingLimit!));
                _trendingProductProvider!.loadProductList();
                return _trendingProductProvider!;
              }),
          ChangeNotifierProvider<FeaturedProductProvider>(
              lazy: false,
              create: (BuildContext context) {
                _featuredProductProvider = FeaturedProductProvider(
                    repo: repo2!, limit: int.parse(valueHolder.featureProductLoadingLimit!));
                _featuredProductProvider!.loadProductList();
                return _featuredProductProvider!;
              }),
          ChangeNotifierProvider<ProductCollectionProvider>(
              lazy: false,
              create: (BuildContext context) {
                _productCollectionProvider = ProductCollectionProvider(
                    repo: repo3!,
                    limit: int.parse(valueHolder.collectionProductLoadingLimit!));
                _productCollectionProvider!.loadProductCollectionList();
                return _productCollectionProvider!;
              }),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                _basketProvider = BasketProvider(repo: basketRepository!);
                _basketProvider!.loadBasketList();
                return _basketProvider!;
              }),

        ],
        child: Container(
          color: PsColors.coreBackgroundColor,
          child: RefreshIndicator(
            onRefresh: () {
              _productCollectionProvider!.resetProductCollectionList();
              _featuredProductProvider!.resetProductList();
              _trendingProductProvider!.resetProductList();
              _discountProductProvider!.resetProductList();
              _searchProductProvider!.resetLatestProductList(
                  ProductParameterHolder().getLatestParameterHolder());
              _trendingCategoryProvider!
                  .resetTrendingCategoryList(trendingCategory.toMap());
              _categoryProvider!
                  .resetCategoryList(categoryIconList.toMap())
                  .then((dynamic value) {
                // Utils.psPrint("Is Has Internet " + value);
                final bool isConnectedToIntenet = value ?? bool;
                if (!isConnectedToIntenet) {
                  Fluttertoast.showToast(
                      msg: 'No Internet Connectiion. Please try again !',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white);
                }
              });
              return _shopInfoProvider!.loadShopInfo();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                _SearchWidget(valueHolder: valueHolder,),
                _HomeCollectionProductSliderListWidget(
                  animationController: widget.animationController,

                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 1, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),

                ///
                /// category List Widget
                ///
                _HomeCategoryHorizontalListWidget(
                  psValueHolder: valueHolder,
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 2, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),
                // if(PsConfig.showBestChoiceSlider)
                // _HomeBestChoiceSliderListWidget(
                //       animationController:
                //           widget.animationController, //animationController,
                //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                //           CurvedAnimation(
                //               parent: widget.animationController,
                //               curve: Interval((1 / count) * 5, 1.0,
                //                   curve: Curves.fastOutSlowIn))), //animation
                //   )
                // else
                // _HomeBestChoiceHorizontalListWidget(
                //   psValueHolder: valueHolder,
                //   animationController:
                //       widget.animationController, //animationController,
                //   animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                //       CurvedAnimation(
                //           parent: widget.animationController,
                //           curve: Interval((1 / count) * 2, 1.0,
                //               curve: Curves.fastOutSlowIn))), //animation
                // ),
                _DiscountProductHorizontalListWidget(
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 3, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  basketProvider: _basketProvider,
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAttribute: basketSelectedAttribute, //animation
                ),

                _HomeFeaturedProductHorizontalListWidget(
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 4, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  basketProvider: _basketProvider,
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAttribute: basketSelectedAttribute,
                ),

                _HomeSelectingProductTypeWidget(
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 5, 1.0,
                              curve: Curves.fastOutSlowIn))),
                ),
                _HomeTrendingCategoryHorizontalListWidget(
                  psValueHolder: valueHolder,
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 6, 1.0,
                              curve: Curves.fastOutSlowIn))), //animation
                ),

                _HomeLatestProductHorizontalListWidget(
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 7, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  basketProvider: _basketProvider,
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAttribute: basketSelectedAttribute,
                  //animation
                ),

                _HomeTrendingProductHorizontalListWidget(
                  animationController: widget.animationController,
                  //animationController,
                  animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.animationController,
                          curve: Interval((1 / count) * 8, 1.0,
                              curve: Curves.fastOutSlowIn))),
                  basketProvider: _basketProvider,
                  bottomSheetPrice: bottomSheetPrice,
                  totalOriginalPrice: totalOriginalPrice,
                  basketSelectedAttribute: basketSelectedAttribute, //animation
                ),
              ],
            ),
          ),
        ));
  }
}

class _HomeLatestProductHorizontalListWidget extends StatefulWidget {
  const _HomeLatestProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.basketProvider,
      required this.bottomSheetPrice,
      required this.totalOriginalPrice,
      required this.basketSelectedAttribute})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final BasketProvider? basketProvider;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAttribute basketSelectedAttribute;

  @override
  __HomeLatestProductHorizontalListWidgetState createState() =>
      __HomeLatestProductHorizontalListWidgetState();
}

class __HomeLatestProductHorizontalListWidgetState
    extends State<_HomeLatestProductHorizontalListWidget> {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;
  PsValueHolder ?psValueHolder;

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: Consumer<SearchProductProvider>(
        builder: (BuildContext context, SearchProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
              animation: widget.animationController,
              child: (productProvider.productList.data != null &&
                      productProvider.productList.data!.isNotEmpty)
                  ? Column(children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__latest_product'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                appBarTitle: Utils.getString(
                                    context, 'dashboard__latest_product'),
                                productParameterHolder: ProductParameterHolder()
                                    .getLatestParameterHolder(),
                              ));
                        },
                      ),
                      Container(
                          height: PsDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              itemCount:
                                  productProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                  return ProductHorizontalListItem(
                                    valueHolder: psValueHolder!,
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!, //'latest',
                                    product: product,
                                    onTap: () async {
                                      print(product.defaultPhoto!.imgPath);

                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                        productId: product.id,
                                        heroTagImage: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__IMAGE,
                                        heroTagTitle: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__TITLE,
                                        heroTagOriginalPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                        heroTagUnitPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                      );

                                      final dynamic result =
                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);
                                      if (result == null) {
                                        setState(() {
                                          productProvider.resetLatestProductList(
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder());
                                        });
                                      }
                                    },
                                    onButtonTap: () async {
                                      if (product.minimumOrder == '0') {
                                        product.minimumOrder = '1';
                                      }
                                      if (product.isAvailable == '1') {
                                        if (product.attributesHeaderList!
                                                .isNotEmpty &&
                                            product.attributesHeaderList![0]
                                                    .id !=
                                                '') {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ChooseAttributeDialog(
                                                    product: productProvider
                                                        .productList
                                                        .data![index]);
                                              });
                                        } else {
                                          id =
                                              '${product.id}$colorId${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                          basket = Basket(
                                              id: id,
                                              productId: product.id,
                                              qty: qty ?? product.minimumOrder,
                                              shopId: psValueHolder!.shopId,
                                              selectedColorId: colorId,
                                              selectedColorValue: colorValue,
                                              basketPrice:
                                                  widget.bottomSheetPrice ==
                                                          null
                                                      ? product.unitPrice
                                                      : widget.bottomSheetPrice
                                                          .toString(),
                                              basketOriginalPrice: widget
                                                          .totalOriginalPrice ==
                                                      0.0
                                                  ? product.originalPrice
                                                  : widget.totalOriginalPrice
                                                      .toString(),
                                              selectedAttributeTotalPrice: widget
                                                  .basketSelectedAttribute
                                                  .getTotalSelectedAttributePrice()
                                                  .toString(),
                                              product: product,
                                              basketSelectedAttributeList: widget
                                                  .basketSelectedAttribute
                                                  .getSelectedAttributeList());

                                          await widget.basketProvider!
                                              .addBasket(basket!);

                                          Fluttertoast.showToast(
                                              msg: Utils.getString(context,
                                                  'product_detail__success_add_to_basket'),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  PsColors.mainColor,
                                              textColor: PsColors.white);

                                          await Navigator.pushNamed(
                                            context,
                                            RoutePaths.basketList,
                                          );
                                        }
                                      } else {
                                        await showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return WarningDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'product_detail__is_not_available'),
                                                onPressed: () {},
                                              );
                                            });
                                      }
                                    },
                                  );
                                }
                              }))
                    ])
                  : Container(),
              builder: (BuildContext context, Widget? child) {
                return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - widget.animation.value), 0.0),
                      child: child),
                );
              });
        },
      ),
    );
  }
}

class _HomeFeaturedProductHorizontalListWidget extends StatefulWidget {
  const _HomeFeaturedProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.basketProvider,
      required this.bottomSheetPrice,
      required this.totalOriginalPrice,
      required this.basketSelectedAttribute})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final BasketProvider? basketProvider;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAttribute basketSelectedAttribute;

  @override
  __HomeFeaturedProductHorizontalListWidgetState createState() =>
      __HomeFeaturedProductHorizontalListWidgetState();
}

class __HomeFeaturedProductHorizontalListWidgetState
    extends State<_HomeFeaturedProductHorizontalListWidget> {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;
  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: Consumer<FeaturedProductProvider>(
        builder: (BuildContext context, FeaturedProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__feature_product'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(
                                      context, 'dashboard__feature_product'),
                                  productParameterHolder:
                                      ProductParameterHolder()
                                          .getFeaturedParameterHolder()));
                        },
                      ),
                      Container(
                          height: PsDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              itemCount:
                                  productProvider.productList.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                  return ProductHorizontalListItem(
                                    valueHolder: psValueHolder!,
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!, //'feature',
                                    product:
                                        productProvider.productList.data![index],
                                    onTap: () async {
                                      print(productProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                        productId: productProvider
                                            .productList.data![index].id,
                                        heroTagImage: productProvider.hashCode
                                                .toString() +
                                            product.id !+
                                            PsConst.HERO_TAG__IMAGE,
                                        heroTagTitle: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__TITLE,
                                        heroTagOriginalPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                        heroTagUnitPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                      );

                                      final dynamic result =
                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);
                                      if (result == null) {
                                        setState(() {
                                          productProvider.resetProductList();
                                        });
                                      }
                                    },
                                    onButtonTap: () async {
                                      if (product.minimumOrder == '0') {
                                        product.minimumOrder = '1';
                                      }
                                      if (product.isAvailable == '1') {
                                        if (product.attributesHeaderList!
                                                .isNotEmpty &&
                                            product.attributesHeaderList![0]
                                                    .id !=
                                                '') {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ChooseAttributeDialog(
                                                    product: productProvider
                                                        .productList
                                                        .data![index]);
                                              });
                                        } else {
                                          id =
                                              '${product.id}$colorId${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                          basket = Basket(
                                              id: id,
                                              productId: product.id,
                                              qty: qty ?? product.minimumOrder,
                                              shopId: psValueHolder!.shopId,
                                              selectedColorId: colorId,
                                              selectedColorValue: colorValue,
                                              basketPrice:
                                                  widget.bottomSheetPrice ==
                                                          null
                                                      ? product.unitPrice
                                                      : widget.bottomSheetPrice
                                                          .toString(),
                                              basketOriginalPrice: widget
                                                          .totalOriginalPrice ==
                                                      0.0
                                                  ? product.originalPrice
                                                  : widget.totalOriginalPrice
                                                      .toString(),
                                              selectedAttributeTotalPrice: widget
                                                  .basketSelectedAttribute
                                                  .getTotalSelectedAttributePrice()
                                                  .toString(),
                                              product: product,
                                              basketSelectedAttributeList: widget
                                                  .basketSelectedAttribute
                                                  .getSelectedAttributeList());

                                          await widget.basketProvider!
                                              .addBasket(basket!);

                                          Fluttertoast.showToast(
                                              msg: Utils.getString(context,
                                                  'product_detail__success_add_to_basket'),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  PsColors.mainColor,
                                              textColor: PsColors.white);

                                          await Navigator.pushNamed(
                                            context,
                                            RoutePaths.basketList,
                                          );
                                        }
                                      } else {
                                        await showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return WarningDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'product_detail__is_not_available'),
                                                onPressed: () {},
                                              );
                                            });
                                      }
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeTrendingProductHorizontalListWidget extends StatefulWidget {
  const _HomeTrendingProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.basketProvider,
      required this.bottomSheetPrice,
      required this.totalOriginalPrice,
      required this.basketSelectedAttribute})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final BasketProvider? basketProvider;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAttribute basketSelectedAttribute;

  @override
  __HomeTrendingProductHorizontalListWidgetState createState() =>
      __HomeTrendingProductHorizontalListWidgetState();
}

class __HomeTrendingProductHorizontalListWidgetState
    extends State<_HomeTrendingProductHorizontalListWidget> {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;
  PsValueHolder? psValueHolder;

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: Consumer<TrendingProductProvider>(
        builder: (BuildContext context, TrendingProductProvider productProvider,
            Widget? child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: (productProvider.productList.data != null &&
                    productProvider.productList.data!.isNotEmpty)
                ? Column(
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__trending_product'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                              context, RoutePaths.filterProductList,
                              arguments: ProductListIntentHolder(
                                  appBarTitle: Utils.getString(
                                      context, 'dashboard__trending_product'),
                                  productParameterHolder:
                                      ProductParameterHolder()
                                          .getTrendingParameterHolder()));
                        },
                      ),
                      Container(
                          height: PsDimens.space320,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  productProvider.productList.data!.length,
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              itemBuilder: (BuildContext context, int index) {
                                if (productProvider.productList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  final Product product =
                                      productProvider.productList.data![index];
                                  return ProductHorizontalListItem(
                                    valueHolder: psValueHolder!,
                                    coreTagKey:
                                        productProvider.hashCode.toString() +
                                            product.id!,
                                    product:
                                        productProvider.productList.data![index],
                                    onTap: () async {
                                      print(productProvider.productList
                                          .data![index].defaultPhoto!.imgPath);
                                      final ProductDetailIntentHolder holder =
                                          ProductDetailIntentHolder(
                                        productId: productProvider
                                            .productList.data![index].id,
                                        heroTagImage: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__IMAGE,
                                        heroTagTitle: productProvider.hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__TITLE,
                                        heroTagOriginalPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                        heroTagUnitPrice: productProvider
                                                .hashCode
                                                .toString() +
                                            product.id !+
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                      );
                                      final dynamic result =
                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);
                                      if (result == null) {
                                        setState(() {
                                          productProvider.resetProductList();
                                        });
                                      }
                                    },
                                    onButtonTap: () async {
                                      if (product.minimumOrder == '0') {
                                        product.minimumOrder = '1';
                                      }
                                      if (product.isAvailable == '1') {
                                        if (product.attributesHeaderList!
                                                .isNotEmpty &&
                                            product.attributesHeaderList![0]
                                                    .id !=
                                                '') {
                                          showDialog<dynamic>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ChooseAttributeDialog(
                                                    product: productProvider
                                                        .productList
                                                        .data![index]);
                                              });
                                        } else {
                                          id =
                                              '${product.id}$colorId${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                          basket = Basket(
                                              id: id,
                                              productId: product.id,
                                              qty: qty ?? product.minimumOrder,
                                              shopId: psValueHolder!.shopId,
                                              selectedColorId: colorId,
                                              selectedColorValue: colorValue,
                                              basketPrice:
                                                  widget.bottomSheetPrice ==
                                                          null
                                                      ? product.unitPrice
                                                      : widget.bottomSheetPrice
                                                          .toString(),
                                              basketOriginalPrice: widget
                                                          .totalOriginalPrice ==
                                                      0.0
                                                  ? product.originalPrice
                                                  : widget.totalOriginalPrice
                                                      .toString(),
                                              selectedAttributeTotalPrice: widget
                                                  .basketSelectedAttribute
                                                  .getTotalSelectedAttributePrice()
                                                  .toString(),
                                              product: product,
                                              basketSelectedAttributeList: widget
                                                  .basketSelectedAttribute
                                                  .getSelectedAttributeList());

                                          await widget.basketProvider!
                                              .addBasket(basket!);

                                          Fluttertoast.showToast(
                                              msg: Utils.getString(context,
                                                  'product_detail__success_add_to_basket'),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  PsColors.mainColor,
                                              textColor: PsColors.white);

                                          await Navigator.pushNamed(
                                            context,
                                            RoutePaths.basketList,
                                          );
                                        }
                                      } else {
                                        await showDialog<dynamic>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return WarningDialog(
                                                message: Utils.getString(
                                                    context,
                                                    'product_detail__is_not_available'),
                                                onPressed: () {},
                                              );
                                            });
                                      }
                                    },
                                  );
                                }
                              }))
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeSelectingProductTypeWidget extends StatelessWidget {
  const _HomeSelectingProductTypeWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
          animation: animationController,
          child: Container(
            color: PsColors.backgroundColor,
            margin: const EdgeInsets.only(top: PsDimens.space20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space28,
                ),
                Text(Utils.getString(context, 'dashboard__welcome_text'),
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(
                  height: PsDimens.space12,
                ),
                Text(Utils.getString(context, 'app_name'),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: PsColors.mainColor)),
                const SizedBox(
                  height: PsDimens.space12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _SelectingImageAndTextWidget(
                          imagePath: 'assets/images/trending.png',
                          title: Utils.getString(
                              context, 'dashboard__popular_product'),
                          description: Utils.getString(
                              context, 'dashboard__popular_description'),
                          onTap: () {
                            print('popular download');
                            Navigator.pushNamed(
                                context, RoutePaths.filterProductList,
                                arguments: ProductListIntentHolder(
                                    appBarTitle: Utils.getString(
                                        context, 'dashboard__popular_product'),
                                    productParameterHolder:
                                        ProductParameterHolder()
                                            .getTrendingParameterHolder()));
                          }),
                    ),
                    Expanded(
                      child: _SelectingImageAndTextWidget(
                          imagePath: 'assets/images/home_icon/easy_payment.png',
                          title: Utils.getString(
                              context, 'dashboard__easy_payment'),
                          description: Utils.getString(
                              context, 'dashboard__easy_payment_description'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.basketList,
                            );
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: _SelectingImageAndTextWidget(
                          imagePath:
                              'assets/images/home_icon/featured_products.png',
                          title: Utils.getString(
                              context, 'dashboard__feature_product'),
                          description: Utils.getString(context,
                              'dashboard__feature_product_description'),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.filterProductList,
                                arguments: ProductListIntentHolder(
                                    appBarTitle: Utils.getString(
                                        context, 'dashboard__feature_product'),
                                    productParameterHolder:
                                        ProductParameterHolder()
                                            .getFeaturedParameterHolder()));
                          }),
                    ),
                    Expanded(
                      child: _SelectingImageAndTextWidget(
                          imagePath:
                              'assets/images/home_icon/discount_products.png',
                          title: Utils.getString(
                              context, 'dashboard__discount_product'),
                          description: Utils.getString(context,
                              'dashboard__discount_product_description'),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePaths.filterProductList,
                                arguments: ProductListIntentHolder(
                                    appBarTitle: Utils.getString(
                                        context, 'dashboard__discount_product'),
                                    productParameterHolder:
                                        ProductParameterHolder()
                                            .getDiscountParameterHolder()));
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: PsDimens.space12,
                ),
              ],
            ),
          ),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child),
            );
          }),
    );
  }
}

class _SelectingImageAndTextWidget extends StatelessWidget {
  const _SelectingImageAndTextWidget(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.description,
      required this.onTap})
      : super(key: key);

  final String imagePath;
  final String title;
  final String description;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                imagePath,
                width: PsDimens.space60,
                height: PsDimens.space60,
              ),
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(
              height: PsDimens.space12,
            ),
            Text(description,
                maxLines: 3,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _HomeTrendingCategoryHorizontalListWidget extends StatelessWidget {
  const _HomeTrendingCategoryHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {

    
    return SliverToBoxAdapter(child: Consumer<TrendingCategoryProvider>(builder:
        (BuildContext context,
            TrendingCategoryProvider trendingCategoryProvider, Widget? child) {
      return AnimatedBuilder(
        animation: animationController,
        child: Consumer<TrendingCategoryProvider>(builder:
            (BuildContext context,
                TrendingCategoryProvider trendingCategoryProvider,
                Widget? child) {
          return (trendingCategoryProvider.categoryList.data != null &&
                  trendingCategoryProvider.categoryList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName: Utils.getString(
                        context, 'dashboard__trending_category'),
                    viewAllClicked: () {
                      Navigator.pushNamed(
                          context, RoutePaths.trendingCategoryList,
                          arguments: Utils.getString(context,
                              'tranding_category__trending_category_list'));
                    },
                  ),
                  Container(
                    height: PsDimens.space300,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                        top: PsDimens.space12,
                        bottom: PsDimens.space12,
                        left: PsDimens.space16),
                    child: CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200.0,
                                    childAspectRatio: 0.8),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                if (trendingCategoryProvider
                                        .categoryList.status ==
                                    PsStatus.BLOCK_LOADING) {
                                  return Shimmer.fromColors(
                                      baseColor: PsColors.grey,
                                      highlightColor: PsColors.white,
                                      child: Row(children: const <Widget>[
                                        PsFrameUIForLoading(),
                                      ]));
                                } else {
                                  if (trendingCategoryProvider
                                              .categoryList.data !=
                                          null ||
                                      trendingCategoryProvider
                                          .categoryList.data!.isNotEmpty) {
                                    return CategoryHorizontalTrendingListItem(
                                      category: trendingCategoryProvider
                                          .categoryList.data![index],
                                      animationController: animationController,
                                      animation:
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(
                                        CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 /
                                                      trendingCategoryProvider
                                                          .categoryList
                                                          .data!
                                                          .length) *
                                                  index,
                                              1.0,
                                              curve: Curves.fastOutSlowIn),
                                        ),
                                      ),
                                      onTap: () {
                                        final String loginUserId =
                                            Utils.checkUserLoginId(
                                                psValueHolder);

                                        final TouchCountParameterHolder
                                            touchCountParameterHolder =
                                            TouchCountParameterHolder(
                                                typeId: trendingCategoryProvider
                                                    .categoryList
                                                    .data![index]
                                                    .id!,
                                                typeName: PsConst
                                                    .FILTERING_TYPE_NAME_CATEGORY,
                                                userId: loginUserId);

                                        trendingCategoryProvider.postTouchCount(
                                            touchCountParameterHolder.toMap());

                                        if (PsConfig.isShowSubCategory) {
                                          Navigator.pushNamed(context,
                                              RoutePaths.subCategoryGrid,
                                              arguments:
                                                  trendingCategoryProvider
                                                      .categoryList
                                                      .data![index]);
                                        } else {
                                          final ProductParameterHolder
                                              productParameterHolder =
                                              ProductParameterHolder()
                                                  .getLatestParameterHolder();
                                          productParameterHolder.catId =
                                              trendingCategoryProvider
                                                  .categoryList.data![index].id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments:
                                                  ProductListIntentHolder(
                                                appBarTitle:
                                                    trendingCategoryProvider
                                                        .categoryList
                                                        .data![index]
                                                        .name!,
                                                productParameterHolder:
                                                    productParameterHolder,
                                              ));
                                        }
                                      },
                                    );
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              childCount: trendingCategoryProvider
                                  .categoryList.data!.length,
                            ),
                          ),
                        ]),
                  )
                ])
              : Container();
        }),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        },
      );
    }));
  }
}

// class _HomeBestChoiceSliderListWidget extends StatelessWidget {
//   const _HomeBestChoiceSliderListWidget({
//     Key key,
//     @required this.animationController,
//     @required this.animation,
//   }) : super(key: key);

//   final AnimationController animationController;
//   final Animation<double> animation;

//   @override
//   Widget build(BuildContext context) {
//     const int count = 6;
//     final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
//         .animate(CurvedAnimation(
//             parent: animationController,
//             curve: const Interval((1 / count) * 1, 1.0,
//                 curve: Curves.fastOutSlowIn)));

//     return SliverToBoxAdapter(
//       child: Consumer<BestChoiceProvider>(builder:
//           (BuildContext context, BestChoiceProvider bestChoiceProvider, Widget child) {
//         return AnimatedBuilder(
//             animation: animationController,
//              child: (bestChoiceProvider.productCollectionList.data != null &&
//                     bestChoiceProvider.productCollectionList.data.isNotEmpty)
//               ? Container(
//                   child: BestChoiceSliderView(
//                     bestChoiceList: bestChoiceProvider.productCollectionList.data,
//                     onTap: (BestChoice bestChoice) {
//                       Navigator.pushNamed(context,
//                         RoutePaths.bestChoiceListByCollectionId,
//                         arguments: BestChoiceListByCollectionIdView(
//                           bestChoice: bestChoice,
//                           appBarTitle: bestChoice
//                               .name,
//                           backgroundColor: PsColors.white,
//                           titleTextColor: PsColors.mainColor,
//                       )); 
//                   },
//                 ),
//               )
//               : Container(),
//             builder: (BuildContext context, Widget child) {
//               return FadeTransition(
//                   opacity: animation,
//                   child: Transform(
//                       transform: Matrix4.translationValues(
//                           0.0, 100 * (1.0 - animation.value), 0.0),
//                       child: child));
//             });
//       }),
//     );
//   }
// }


class _DiscountProductHorizontalListWidget extends StatefulWidget {
  const _DiscountProductHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.basketProvider,
      required this.bottomSheetPrice,
      required this.totalOriginalPrice,
      required this.basketSelectedAttribute})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final BasketProvider? basketProvider;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAttribute basketSelectedAttribute;

  @override
  __DiscountProductHorizontalListWidgetState createState() =>
      __DiscountProductHorizontalListWidgetState();
}

class __DiscountProductHorizontalListWidgetState
    extends State<_DiscountProductHorizontalListWidget> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;
  late PsValueHolder _valueHolder;
  bool _showAds = false;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && _showAds) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _valueHolder = Provider.of<PsValueHolder>(context);
     if (_valueHolder.isShowAdmob != null &&
        _valueHolder.isShowAdmob == PsConst.ONE) {
      _showAds = true;
    } else {
      _showAds = false;
    }
    if (!isConnectedToInternet && _showAds) {
      print('loading ads....');
      checkConnection();
    }
    return SliverToBoxAdapter(child: Consumer<DiscountProductProvider>(builder:
        (BuildContext context, DiscountProductProvider productProvider,
            Widget? child) {
      return AnimatedBuilder(
          animation: widget.animationController,
          child: (productProvider.productList.data != null &&
                  productProvider.productList.data!.isNotEmpty)
              ? Column(children: <Widget>[
                  _MyHeaderWidget(
                    headerName:
                        Utils.getString(context, 'dashboard__discount_product'),
                    viewAllClicked: () {
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                              appBarTitle: Utils.getString(
                                  context, 'dashboard__discount_product'),
                              productParameterHolder: ProductParameterHolder()
                                  .getDiscountParameterHolder()));
                    },
                  ),
                  Container(
                      height: PsDimens.space320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          itemCount: productProvider.productList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (productProvider.productList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              final Product product =
                                  productProvider.productList.data![index];
                              return ProductHorizontalListItem(
                                valueHolder: _valueHolder,
                                coreTagKey:
                                    productProvider.hashCode.toString() +
                                        product.id!,
                                product:
                                    productProvider.productList.data![index],
                                onTap: () async {
                                  print(productProvider.productList.data![index]
                                      .defaultPhoto!.imgPath);
                                  final ProductDetailIntentHolder holder =
                                      ProductDetailIntentHolder(
                                    productId: productProvider
                                        .productList.data![index].id,
                                    heroTagImage:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__IMAGE,
                                    heroTagTitle:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__TITLE,
                                    heroTagOriginalPrice:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__ORIGINAL_PRICE,
                                    heroTagUnitPrice:
                                        productProvider.hashCode.toString() +
                                            product.id! +
                                            PsConst.HERO_TAG__UNIT_PRICE,
                                  );
                                  final dynamic result =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.productDetail,
                                          arguments: holder);
                                  if (result == null) {
                                    setState(() {
                                      productProvider.resetProductList();
                                    });
                                  }
                                },
                                onButtonTap: () async {
                                  if (product.minimumOrder == '0') {
                                    product.minimumOrder = '1';
                                  }
                                  if (product.isAvailable == '1') {
                                    if (product
                                            .attributesHeaderList!.isNotEmpty &&
                                        product.attributesHeaderList![0].id !=
                                            '') {
                                      showDialog<dynamic>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ChooseAttributeDialog(
                                                product: productProvider
                                                    .productList.data![index]);
                                          });
                                    } else {
                                      id =
                                          '${product.id}$colorId${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                      basket = Basket(
                                          id: id,
                                          productId: product.id,
                                          qty: qty ?? product.minimumOrder,
                                          shopId: _valueHolder.shopId,
                                          selectedColorId: colorId,
                                          selectedColorValue: colorValue,
                                          basketPrice:
                                              widget.bottomSheetPrice == null
                                                  ? product.unitPrice
                                                  : widget.bottomSheetPrice
                                                      .toString(),
                                          basketOriginalPrice:
                                              widget.totalOriginalPrice == 0.0
                                                  ? product.originalPrice
                                                  : widget.totalOriginalPrice
                                                      .toString(),
                                          selectedAttributeTotalPrice: widget
                                              .basketSelectedAttribute
                                              .getTotalSelectedAttributePrice()
                                              .toString(),
                                          product: product,
                                          basketSelectedAttributeList: widget
                                              .basketSelectedAttribute
                                              .getSelectedAttributeList());

                                      await widget.basketProvider!
                                          .addBasket(basket!);

                                      Fluttertoast.showToast(
                                          msg: Utils.getString(context,
                                              'product_detail__success_add_to_basket'),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: PsColors.mainColor,
                                          textColor: PsColors.white);

                                      await Navigator.pushNamed(
                                        context,
                                        RoutePaths.basketList,
                                      );
                                    }
                                  } else {
                                    await showDialog<dynamic>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WarningDialog(
                                            message: Utils.getString(context,
                                                'product_detail__is_not_available'),
                                            onPressed: () {},
                                          );
                                        });
                                  }
                                },
                              );
                            }
                          })),
                  const PsAdMobBannerWidget(admobSize: AdSize.mediumRectangle
                      // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                      ),
                  // Visibility(
                  //   visible: PsConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  //     listener: (AdmobAdEvent event,
                  //         Map<String, dynamic> map) {
                  //       print('BannerAd event is $event');
                  //       if (event == AdmobAdEvent.loaded) {
                  //         isSuccessfullyLoaded = true;
                  //       } else {
                  //         isSuccessfullyLoaded = false;
                  //         setState(() {});
                  //       }
                  //     },
                  //   ),
                  // ),
                ])
              : Container(),
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: child));
          });
    }));
  }
}

class _HomeCollectionProductSliderListWidget extends StatelessWidget {
  const _HomeCollectionProductSliderListWidget({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    const int count = 6;
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval((1 / count) * 1, 1.0,
                curve: Curves.fastOutSlowIn)));

    return SliverToBoxAdapter(
      child: Consumer<ProductCollectionProvider>(builder: (BuildContext context,
          ProductCollectionProvider collectionProvider, Widget? child) {
        return AnimatedBuilder(
            animation: animationController,
            child: (
              //collectionProvider.productCollectionList != null &&
                    collectionProvider.productCollectionList.data!.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _MyHeaderWidget(
                        headerName: Utils.getString(
                            context, 'dashboard__collection_product'),
                        viewAllClicked: () {
                          Navigator.pushNamed(
                            context,
                            RoutePaths.collectionProductList,
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: PsColors.mainLightShadowColor,
                                offset: const Offset(1.1, 1.1),
                                blurRadius: PsDimens.space8),
                          ],
                        ),
                        margin: const EdgeInsets.only(
                            top: PsDimens.space8, bottom: PsDimens.space20),
                        width: double.infinity,
                        child: CollectionProductSliderView(
                          collectionProductList:
                              collectionProvider.productCollectionList.data!,
                          onTap: (ProductCollectionHeader collectionProduct) {
                            Navigator.pushNamed(
                                context, RoutePaths.productListByCollectionId,
                                arguments: ProductListByCollectionIdView(
                                  productCollectionHeader: collectionProduct,
                                  appBarTitle: collectionProduct.name!,
                                ));
                          },
                        ),
                      )
                    ],
                  )
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
    );
  }
}

class _HomeCategoryHorizontalListWidget extends StatefulWidget {
  const _HomeCategoryHorizontalListWidget(
      {Key? key,
      required this.animationController,
      required this.animation,
      required this.psValueHolder})
      : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final PsValueHolder psValueHolder;

  @override
  __HomeCategoryHorizontalListWidgetState createState() =>
      __HomeCategoryHorizontalListWidgetState();
}

class __HomeCategoryHorizontalListWidgetState
    extends State<_HomeCategoryHorizontalListWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider categoryProvider,
          Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController,
            child: (categoryProvider.categoryList.data != null &&
                    categoryProvider.categoryList.data!.isNotEmpty)
                ? Column(children: <Widget>[
                    _MyHeaderWidget(
                      headerName:
                          Utils.getString(context, 'dashboard__categories'),
                      viewAllClicked: () {
                        Navigator.pushNamed(context, RoutePaths.categoryList,
                            arguments: Utils.getString(
                                context, 'dashboard__categories'));
                      },
                    ),
                    Container(
                      height: PsDimens.space140,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding:
                              const EdgeInsets.only(left: PsDimens.space16),
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryProvider.categoryList.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (categoryProvider.categoryList.status ==
                                PsStatus.BLOCK_LOADING) {
                              return Shimmer.fromColors(
                                  baseColor: PsColors.grey,
                                  highlightColor: PsColors.white,
                                  child: Row(children: const <Widget>[
                                    PsFrameUIForLoading(),
                                  ]));
                            } else {
                              return CategoryHorizontalListItem(
                                category:
                                    categoryProvider.categoryList.data![index],
                                onTap: () {
                                  final String loginUserId =
                                      Utils.checkUserLoginId(
                                          categoryProvider.psValueHolder!);

                                  final TouchCountParameterHolder
                                      touchCountParameterHolder =
                                      TouchCountParameterHolder(
                                          typeId: categoryProvider
                                              .categoryList.data![index].id!,
                                          typeName: PsConst
                                              .FILTERING_TYPE_NAME_CATEGORY,
                                          userId: loginUserId);

                                  categoryProvider.postTouchCount(
                                      touchCountParameterHolder.toMap());
                                  if (PsConfig.isShowSubCategory) {
                                    Navigator.pushNamed(
                                        context, RoutePaths.subCategoryGrid,
                                        arguments: categoryProvider
                                            .categoryList.data![index]);
                                  } else {
                                    final ProductParameterHolder
                                        productParameterHolder =
                                        ProductParameterHolder()
                                            .getLatestParameterHolder();
                                    productParameterHolder.catId =
                                        categoryProvider
                                            .categoryList.data![index].id;
                                    Navigator.pushNamed(
                                        context, RoutePaths.filterProductList,
                                        arguments: ProductListIntentHolder(
                                          appBarTitle: categoryProvider
                                              .categoryList.data![index].name!,
                                          productParameterHolder:
                                              productParameterHolder,
                                        ));
                                  }
                                },
                              );
                            }
                          }),
                    )
                  ])
                : Container(),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: widget.animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.animation.value), 0.0),
                      child: child));
            });
      },
    ));
  }
}

class _MyHeaderWidget extends StatefulWidget {
  const _MyHeaderWidget({
    Key? key,
    required this.headerName,
    // ignore: unused_element
    this.productCollectionHeader,
    required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final Function? viewAllClicked;
  final ProductCollectionHeader? productCollectionHeader;

  @override
  __MyHeaderWidgetState createState() => __MyHeaderWidgetState();
}

class __MyHeaderWidgetState extends State<_MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(widget.headerName,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: PsColors.textPrimaryDarkColor)),
            ),
            Text(
              Utils.getString(context, 'dashboard__view_all'),
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: PsColors.mainColor),
            ),
          ],
        ),
      ),
    );
  }
}
class _SearchWidget extends StatelessWidget {
  const _SearchWidget(
      { Key? key,
      required this.valueHolder,}) : super(key: key);
  final PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: PsDimens.space8,
              ),
              // Flexible(
              //     child: PsTextFieldWidgetWithIcon(
              //         hintText:
              //             Utils.getString(context, 'home__bottom_app_bar_search'),
              //         textEditingController: addressController,
              //         psValueHolder: valueHolder,
              //         textInputAction: TextInputAction.search,
              //         currentPosition: (newShopProvider != null &&
              //                 newShopProvider.shopNearYouParameterHolder != null &&
              //                 newShopProvider.shopNearYouParameterHolder.lat !=
              //                     null &&
              //                 newShopProvider.shopNearYouParameterHolder.lat != '')
              //             ? LatLng(
              //                 double.parse(
              //                     newShopProvider.shopNearYouParameterHolder.lat),
              //                 double.parse(
              //                     newShopProvider.shopNearYouParameterHolder.lng),
              //               )
              //             : LatLng(0, 0))),
               Flexible(
                child: InkWell(
                  child: Container(
                    height: PsDimens.space44,
                    width: double.infinity,
                    margin: const EdgeInsets.all(PsDimens.space12),
                    decoration: BoxDecoration(
                      color: PsColors.baseDarkColor,
                      borderRadius: BorderRadius.circular(PsDimens.space4),
                      border: Border.all(color: PsColors.mainDividerColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: PsDimens.space10),
                        child: Icon(
                          Icons.search,
                          color: PsColors.iconColor,
                          size: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: PsDimens.space8),
                          child: Text(
                            Utils.getString(
                                context, 'home__bottom_app_bar_search'),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall     
                          ),
                        ),
                      ])),
                    onTap: () {
                      Navigator.pushNamed(
                        context, RoutePaths.searchHistory);
                }),
              ),
              // Container(
              //   height: PsDimens.space44,
              //   alignment: Alignment.center,
              //   decoration: BoxDecoration(
              //     color: PsColors.baseDarkColor,
              //     borderRadius: BorderRadius.circular(PsDimens.space4),
              //     border: Border.all(color: PsColors.mainDividerColor),
              //   ),
              //   child: InkWell(
              //       child: Container(
              //         height: double.infinity,
              //         width: PsDimens.space44,
              //         child: Icon(
              //           Octicons.settings,
              //           color: PsColors.iconColor,
              //           size: PsDimens.space20,
              //         ),
              //       ),
              //       onTap: () async {
              //         final ProductParameterHolder productParameterHolder =
              //             ProductParameterHolder().getLatestParameterHolder();
              //         productParameterHolder.searchTerm = addressController.text;
              //         Utils.psPrint(productParameterHolder.searchTerm);
              //         Navigator.pushNamed(context, RoutePaths.dashboardsearchFood,
              //             arguments: ProductListIntentHolder(
              //                 appBarTitle: Utils.getString(
              //                     context, 'home_search__app_bar_title'),
              //                 productParameterHolder: productParameterHolder));
              //       }),
              // ),
              const SizedBox(
                width: PsDimens.space8,
              ),
            ],
          ),
        ),
      );
  }
}
