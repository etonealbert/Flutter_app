import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/category/category_provider.dart';
import 'package:flutterstore/repository/category_repository.dart';
import 'package:flutterstore/ui/category/item/category_vertical_list_item.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/category_parameter_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class CategoryListView extends StatefulWidget {
  @override
  _CategoryListViewState createState() {
    return _CategoryListViewState();
  }
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider? _categoryProvider;
  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();

  AnimationController? animationController;
  Animation<double>? animation;
  bool _showAds = false;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider!.nextCategoryList(categoryIconList.toMap());
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  CategoryRepository? repo1;
  late PsValueHolder psValueHolder;
  dynamic data;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet &&_showAds) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
     if (psValueHolder.isShowAdmob != null &&
        psValueHolder.isShowAdmob == PsConst.ONE) {
      _showAds = true;
    } else {
      _showAds = false;
    }
    if (!isConnectedToInternet && _showAds) {
      print('loading ads....');
      checkConnection();
    }
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    repo1 = Provider.of<CategoryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<CategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              final CategoryProvider provider =
                  CategoryProvider(repo: repo1!, psValueHolder: psValueHolder);
              provider.loadCategoryList(categoryIconList.toMap());
              _categoryProvider = provider;
              return _categoryProvider!;
            },
            child: Consumer<CategoryProvider>(builder: (BuildContext context,
                CategoryProvider provider, Widget? child) {
              return Stack(children: <Widget>[
                Column(children: <Widget>[
                  const PsAdMobBannerWidget(admobSize: AdSize.banner),
                  // Visibility(
                  //   visible: PsConfig.showAdMob &&
                  //       isSuccessfullyLoaded &&
                  //       isConnectedToInternet,
                  //   child: AdmobBanner(
                  //     adUnitId: Utils.getBannerAdUnitId(),
                  //     adSize: AdmobBannerSize.FULL_BANNER,
                  //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
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
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space8,
                            right: PsDimens.space8,
                            top: PsDimens.space8,
                            bottom: PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200.0,
                                          childAspectRatio: 0.8),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.categoryList.data != null ||
                                          provider
                                              .categoryList.data!.isNotEmpty) {
                                        final int count =
                                            provider.categoryList.data!.length;
                                        return CategoryVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent: animationController!,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          category:
                                              provider.categoryList.data![index],
                                          onTap: () {
                                            // print(provider
                                            //     .categoryList
                                            //     .data[index]
                                            //     .defaultPhoto
                                            //     .imgPath);
                                            // final ProductParameterHolder
                                            if (PsConfig.isShowSubCategory) {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.subCategoryGrid,
                                                  arguments: provider
                                                      .categoryList
                                                      .data![index]);
                                            } else {
                                              final String loginUserId =
                                                  Utils.checkUserLoginId(
                                                      psValueHolder);
                                              final TouchCountParameterHolder
                                                  touchCountParameterHolder =
                                                  TouchCountParameterHolder(
                                                      typeId: provider
                                                          .categoryList
                                                          .data![index]
                                                          .id!,
                                                      typeName: PsConst
                                                          .FILTERING_TYPE_NAME_CATEGORY,
                                                      userId: loginUserId);

                                              provider.postTouchCount(
                                                  touchCountParameterHolder
                                                      .toMap());
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder.catId =
                                                  provider.categoryList
                                                      .data![index].id;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
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
                                    },
                                    childCount:
                                        provider.categoryList.data!.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider
                                .resetCategoryList(categoryIconList.toMap());
                          },
                        )),
                  ),
                ]),
                PSProgressIndicator(provider.categoryList.status)
              ]);
            })));
  }
}
