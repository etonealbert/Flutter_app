import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/basket/basket_provider.dart';
import 'package:flutterstore/provider/product/favourite_product_provider.dart';
import 'package:flutterstore/repository/basket_repository.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/ui/common/dialog/choose_attribute_dialog.dart';
import 'package:flutterstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/product/item/product_vertical_list_item.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/basket.dart';
import 'package:flutterstore/viewobject/basket_selected_attribute.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class FavouriteProductListView extends StatefulWidget {
  const FavouriteProductListView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _FavouriteProductListView createState() => _FavouriteProductListView();
}

class _FavouriteProductListView extends State<FavouriteProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  FavouriteProductProvider? _favouriteProductProvider;
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  bool _showAds = false;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _favouriteProductProvider!.nextFavouriteProductList();
      }
    });

    super.initState();
  }

  BasketProvider? basketProvider;
  BasketRepository ?basketRepository;
  ProductRepository? repo1;
  late PsValueHolder _valueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

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
    repo1 = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
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
    print(
        '............................Build UI Again ............................');
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<FavouriteProductProvider>(
          lazy: false,
          create: (BuildContext context) {
            final FavouriteProductProvider provider = FavouriteProductProvider(
                repo: repo1!, psValueHolder: _valueHolder);
            provider.loadFavouriteProductList();
            _favouriteProductProvider = provider;
            return _favouriteProductProvider!;
          },
        ),
        ChangeNotifierProvider<BasketProvider>(
            lazy: false,
            create: (BuildContext context) {
              basketProvider = BasketProvider(repo: basketRepository!);
              basketProvider!.loadBasketList();
              return basketProvider!;
            }),
      ],
      child: Consumer<FavouriteProductProvider>(
        builder: (BuildContext context, FavouriteProductProvider provider,
            Widget? child) {
          return Column(
            children: <Widget>[
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
                child: Stack(children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space4,
                          right: PsDimens.space4,
                          top: PsDimens.space4,
                          bottom: PsDimens.space4),
                      child: RefreshIndicator(
                        child: CustomScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 220.0,
                                        childAspectRatio: 0.6),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.favouriteProductList.data !=
                                            null ||
                                        provider.favouriteProductList.data!
                                            .isNotEmpty) {
                                      final int count = provider
                                          .favouriteProductList.data!.length;
                                      final Product product = provider
                                          .favouriteProductList.data![index];
                                      return ProductVeticalListItem(
                                        coreTagKey:
                                            provider.hashCode.toString() +
                                                provider.favouriteProductList
                                                    .data![index].id!,
                                        animationController:
                                            widget.animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(
                                          CurvedAnimation(
                                            parent: widget.animationController,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          ),
                                        ),
                                        product: provider
                                            .favouriteProductList.data![index],
                                        onTap: () async {
                                          final ProductDetailIntentHolder
                                              holder =
                                              ProductDetailIntentHolder(
                                            productId: product.id,
                                            heroTagImage:
                                                provider.hashCode.toString() +
                                                    product.id! +
                                                    PsConst.HERO_TAG__IMAGE,
                                            heroTagTitle:
                                                provider.hashCode.toString() +
                                                    product.id! +
                                                    PsConst.HERO_TAG__TITLE,
                                            heroTagOriginalPrice: provider
                                                    .hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst
                                                    .HERO_TAG__ORIGINAL_PRICE,
                                            heroTagUnitPrice: provider.hashCode
                                                    .toString() +
                                                product.id! +
                                                PsConst.HERO_TAG__UNIT_PRICE,
                                          );

                                          await Navigator.pushNamed(
                                              context, RoutePaths.productDetail,
                                              arguments: holder);

                                          await provider
                                              .resetFavouriteProductList();
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
                                                  builder:
                                                      (BuildContext context) {
                                                    return ChooseAttributeDialog(
                                                        product: product);
                                                  });
                                            } else {
                                              id =
                                                  '${product.id}$colorId${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                              basket = Basket(
                                                  id: id,
                                                  productId: product.id,
                                                  qty: qty ??
                                                      product.minimumOrder,
                                                  shopId: _valueHolder.shopId,
                                                  selectedColorId: colorId,
                                                  selectedColorValue:
                                                      colorValue,
                                                  basketPrice:
                                                      bottomSheetPrice == null
                                                          ? product.unitPrice
                                                          : bottomSheetPrice
                                                              .toString(),
                                                  basketOriginalPrice:
                                                      totalOriginalPrice == 0.0
                                                          ? product
                                                              .originalPrice
                                                          : totalOriginalPrice
                                                              .toString(),
                                                  selectedAttributeTotalPrice:
                                                      basketSelectedAttribute
                                                          .getTotalSelectedAttributePrice()
                                                          .toString(),
                                                  product: product,
                                                  basketSelectedAttributeList:
                                                      basketSelectedAttribute
                                                          .getSelectedAttributeList());

                                              await basketProvider!
                                                  .addBasket(basket!);

                                              Fluttertoast.showToast(
                                                  msg: Utils.getString(context,
                                                      'product_detail__success_add_to_basket'),
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                                                builder:
                                                    (BuildContext context) {
                                                  return WarningDialog(
                                                    message: Utils.getString(
                                                        context,
                                                        'product_detail__is_not_available'),
                                                    onPressed: () {},
                                                  );
                                                });
                                          }
                                        }, valueHolder: _valueHolder,
                                      );
                                    } else {
                                      return null;
                                    }
                                  },
                                  childCount:
                                      provider.favouriteProductList.data!.length,
                                ),
                              ),
                            ]),
                        onRefresh: () {
                          return provider.resetFavouriteProductList();
                        },
                      )),
                  PSProgressIndicator(provider.favouriteProductList.status)
                ]),
              )
            ],
          );
        },
      ),
    );
  }
}
