import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../api/common/ps_status.dart';
import '../../../config/ps_colors.dart';
import '../../../config/ps_config.dart';
import '../../../constant/ps_constants.dart';
import '../../../constant/ps_dimens.dart';
import '../../../constant/route_paths.dart';
import '../../../provider/basket/basket_provider.dart';
import '../../../provider/product/search_product_provider.dart';
import '../../../repository/basket_repository.dart';
import '../../../repository/product_repository.dart';
import '../../../repository/search_result_repository.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/basket.dart';
import '../../../viewobject/basket_selected_attribute.dart';
import '../../../viewobject/common/ps_value_holder.dart';
import '../../../viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import '../../../viewobject/holder/product_parameter_holder.dart';
import '../../../viewobject/product.dart';
import '../../common/dialog/choose_attribute_dialog.dart';
import '../../common/dialog/warning_dialog_view.dart';
import '../../common/ps_admob_banner_widget.dart';
import '../../common/ps_ui_widget.dart';
import '../../product/item/product_vertical_list_item.dart';
import '../../product/list_with_filter/product_list_with_filter_view.dart';

class SearchItemViewAllContainer extends StatefulWidget {
  const SearchItemViewAllContainer({
    required this.appBarTitle,
    required this.keyword,
  });

  final String appBarTitle;
  final String keyword;
  @override
  _SearchItemViewAllContainerState createState() =>
      _SearchItemViewAllContainerState();
}

final ScrollController _scrollController = ScrollController();
// late Animation<double>? animation;
PsValueHolder? psValueHolder;
late AnimationController animationController;
SearchResultRepository? searchResultRepository;
BasketRepository? basketRepository;
const double _containerMaxHeight = 60;

class _SearchItemViewAllContainerState extends State<SearchItemViewAllContainer>
    with SingleTickerProviderStateMixin {
  late String? qty;
  String colorId = '';
  late String colorValue;
  late bool checkAttribute;
  late Basket basket;
  late String id;
  late double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  BasketProvider? basketProvider;
  ProductRepository? productRepository;
  SearchProductProvider? searchProductProvider;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final ProductParameterHolder parameterHolder = ProductParameterHolder();
        parameterHolder.searchTerm = widget.keyword;
        searchProductProvider!.nextProductListByKey(parameterHolder);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> _requestPop() {
    animationController.reverse().then<dynamic>(
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

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Utils.getBrightnessForAppBar(context)),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            widget.appBarTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold)
                .copyWith(),
          ),
          elevation: 0,
          actions: <Widget>[
            ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                final BasketProvider provider = BasketProvider(
                    repo: basketRepository!, psValueHolder: psValueHolder);
                provider.loadBasketList();
                basketProvider = provider;
                return provider;
              },
              child: Consumer<BasketProvider>(builder: (BuildContext context,
                  BasketProvider basketProvider, Widget? child) {
                return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: PsDimens.space40,
                          height: PsDimens.space40,
                          margin: const EdgeInsets.only(
                              top: PsDimens.space8,
                              left: PsDimens.space8,
                              right: PsDimens.space8),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.shopping_basket,
                              color: PsColors.mainColor,
                            ),
                          ),
                        ),
                        if (basketProvider.basketList.data!.isNotEmpty)
                          Positioned(
                            right: PsDimens.space4,
                            top: PsDimens.space1,
                            child: Container(
                              width: PsDimens.space28,
                              height: PsDimens.space28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PsColors.black.withAlpha(200),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  basketProvider.basketList.data!.length > 99
                                      ? '99+'
                                      : basketProvider.basketList.data!.length
                                          .toString(),
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: PsColors.white),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        RoutePaths.basketList,
                      );
                    });
              }),
            )
          ],
        ),
        body: ChangeNotifierProvider<SearchProductProvider>(
          lazy: false,
          create: (BuildContext content) {
            final SearchProductProvider _searchProductProvider =
                SearchProductProvider(repo: productRepository!);
            final ProductParameterHolder parameterHolder =
                ProductParameterHolder();
            parameterHolder.searchTerm = widget.keyword;
            _searchProductProvider.productParameterHolder = parameterHolder;
            _searchProductProvider.loadProductListByKey(
                _searchProductProvider.productParameterHolder);
            searchProductProvider = _searchProductProvider;
            return _searchProductProvider;
          },
          child: Consumer<SearchProductProvider>(builder: (BuildContext context,
              SearchProductProvider searchProductProvider, _) {
            if (searchProductProvider.productList.data != null) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(admobSize: AdSize.banner),
                  Expanded(
                    child: Container(
                      color: PsColors.coreBackgroundColor,
                      child: Stack(children: <Widget>[
                        if (searchProductProvider.productList.data != null ||
                            searchProductProvider.productList.data!.isNotEmpty)
                          Container(
                              color: PsColors.coreBackgroundColor,
                              margin: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8,
                                  top: PsDimens.space4,
                                  bottom: PsDimens.space4),
                              child: RefreshIndicator(
                                child: CustomScrollView(
                                    controller: _scrollController,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    slivers: <Widget>[
                                      SliverGrid(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 220,
                                                childAspectRatio: 0.6),
                                        delegate: SliverChildBuilderDelegate(
                                          (BuildContext context, int index) {
                                            if (searchProductProvider
                                                        .productList.data !=
                                                    null ||
                                                searchProductProvider
                                                    .productList
                                                    .data!
                                                    .isNotEmpty) {
                                              final Product product =
                                                  searchProductProvider
                                                      .productList.data![index];
                                              return ProductVeticalListItem(
                                                coreTagKey:
                                                    searchProductProvider
                                                            .hashCode
                                                            .toString() +
                                                        product.id!,
                                                product: product,
                                                animationController:
                                                    animationController,
                                                valueHolder: psValueHolder!,
                                                animation: Tween<double>(
                                                        begin: 0.0, end: 1.0)
                                                    .animate(
                                                  CurvedAnimation(
                                                    parent: animationController,
                                                    curve: Interval(
                                                        (1 /
                                                                searchProductProvider
                                                                    .productList
                                                                    .data!
                                                                    .length) *
                                                            index,
                                                        1.0,
                                                        curve: Curves
                                                            .fastOutSlowIn),
                                                  ),
                                                ),
                                                onTap: () async {
                                                  final ProductDetailIntentHolder
                                                      holder =
                                                      ProductDetailIntentHolder(
                                                    productId: product.id,
                                                    heroTagImage:
                                                        searchProductProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__IMAGE,
                                                    heroTagTitle:
                                                        searchProductProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__TITLE,
                                                    heroTagOriginalPrice:
                                                        searchProductProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__ORIGINAL_PRICE,
                                                    heroTagUnitPrice:
                                                        searchProductProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id! +
                                                            PsConst
                                                                .HERO_TAG__UNIT_PRICE,
                                                  );

                                                  await Navigator.pushNamed(
                                                      context,
                                                      RoutePaths.productDetail,
                                                      arguments: holder);
                                                },
                                                onButtonTap: () async {
                                                  if (product.minimumOrder ==
                                                      '0') {
                                                    product.minimumOrder = '1';
                                                  }
                                                  if (product.isAvailable ==
                                                      '1') {
                                                    if (product
                                                            .attributesHeaderList!
                                                            .isNotEmpty &&
                                                        product
                                                                .attributesHeaderList![
                                                                    0]
                                                                .id !=
                                                            '') {
                                                      showDialog<dynamic>(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ChooseAttributeDialog(
                                                                product:
                                                                    product);
                                                          });
                                                    } else {
                                                      id =
                                                          '${product.id}$colorId${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                                                      basket = Basket(
                                                          id: id,
                                                          productId: product.id,
                                                          qty:
                                                              qty ??
                                                                  product
                                                                      .minimumOrder,
                                                          shopId:
                                                              psValueHolder!
                                                                  .shopId,
                                                          selectedColorId:
                                                              colorId,
                                                          selectedColorValue:
                                                              colorValue,
                                                          basketPrice:
                                                              bottomSheetPrice ==
                                                                      null
                                                                  ? product
                                                                      .unitPrice
                                                                  : bottomSheetPrice
                                                                      .toString(),
                                                          basketOriginalPrice:
                                                              totalOriginalPrice ==
                                                                      0.0
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
                                                          .addBasket(basket);

                                                      Fluttertoast.showToast(
                                                          msg: Utils.getString(
                                                              context,
                                                              'product_detail__success_add_to_basket'),
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              PsColors
                                                                  .mainColor,
                                                          textColor:
                                                              PsColors.white);

                                                      await Navigator.pushNamed(
                                                        context,
                                                        RoutePaths.basketList,
                                                      );
                                                    }
                                                  } else {
                                                    await showDialog<dynamic>(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return WarningDialog(
                                                            message:
                                                                Utils.getString(
                                                                    context,
                                                                    'product_detail__is_not_available'),
                                                            onPressed: () {},
                                                          );
                                                        });
                                                  }
                                                },
                                              );
                                            } else {
                                              return null;
                                            }
                                          },
                                          childCount: searchProductProvider
                                              .productList.data!.length,
                                        ),
                                      ),
                                    ]),
                                onRefresh: () {
                                  return searchProductProvider
                                      .resetLatestProductList(
                                          searchProductProvider
                                              .productParameterHolder);
                                },
                              ))
                        else if (searchProductProvider.productList.status !=
                                PsStatus.PROGRESS_LOADING &&
                            searchProductProvider.productList.status !=
                                PsStatus.BLOCK_LOADING &&
                            searchProductProvider.productList.status !=
                                PsStatus.NOACTION)
                          Align(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/baseline_empty_item_grey_24.png',
                                    height: 100,
                                    width: 150,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space32,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: PsDimens.space20,
                                        right: PsDimens.space20),
                                    child: Text(
                                      Utils.getString(context,
                                          'procuct_list__no_result_data'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: PsDimens.space12,
                                top: PsDimens.space8,
                                right: PsDimens.space12,
                                bottom: PsDimens.space16),
                            child: Container(
                                width: double.infinity,
                                height: _containerMaxHeight,
                                child: BottomNavigationImageAndText(
                                  searchProductProvider: searchProductProvider,
                                  // changeAppBarTitle: widget.changeAppBarTitle,
                                )),
                          ),
                        ),
                        PSProgressIndicator(
                            searchProductProvider.productList.status),
                      ]),
                    ),
                  )
                ],
              );
            } else {
              return Container();
            }
          }),
        ),
      ),
    );
  }
}

class BottomNavigationImageAndText extends StatefulWidget {
  const BottomNavigationImageAndText(
      {this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider? searchProductProvider;
  final Function? changeAppBarTitle;

  @override
  _BottomNavigationImageAndTextState createState() =>
      _BottomNavigationImageAndTextState();
}

class _BottomNavigationImageAndTextState
    extends State<BottomNavigationImageAndText> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: PsColors.mainLightShadowColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PsIconWithCheck(
                    icon: MaterialCommunityIcons.format_list_bulleted_type,
                    color: isClickBaseLineList
                        ? PsColors.mainColor
                        : PsColors.iconColor,
                  ),
                  Text(Utils.getString(context, 'search__category'),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: isClickBaseLineList
                              ? PsColors.mainColor
                              : PsColors.textPrimaryColor)),
                ],
              ),
              onTap: () async {
                final Map<String, String> dataHolder = <String, String>{};
                dataHolder[PsConst.CATEGORY_ID] =
                    widget.searchProductProvider!.productParameterHolder.catId!;
                dataHolder[PsConst.SUB_CATEGORY_ID] = widget
                    .searchProductProvider!.productParameterHolder.subCatId!;
                final dynamic result = await Navigator.pushNamed(
                    context, RoutePaths.filterExpantion,
                    arguments: dataHolder);

                if (result != null) {
                  widget.searchProductProvider!.productParameterHolder.catId =
                      result[PsConst.CATEGORY_ID];
                  widget.searchProductProvider!.productParameterHolder
                      .subCatId = result[PsConst.SUB_CATEGORY_ID];
                  widget.searchProductProvider!.resetLatestProductList(
                      widget.searchProductProvider!.productParameterHolder);
                }
              }),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.filter_list,
                  color: isClickBaseLineTune
                      ? PsColors.mainColor
                      : PsColors.iconColor,
                ),
                Text(Utils.getString(context, 'search__filter'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSearch,
                  arguments:
                      widget.searchProductProvider!.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider!.productParameterHolder = result;
                widget.searchProductProvider!.resetLatestProductList(
                    widget.searchProductProvider!.productParameterHolder);
              }
            },
          ),
          GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                PsIconWithCheck(
                  icon: Icons.sort,
                  color: PsColors.mainColor,
                ),
                Text(Utils.getString(context, 'search__sort'),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: isClickBaseLineTune
                            ? PsColors.mainColor
                            : PsColors.textPrimaryColor))
              ],
            ),
            onTap: () async {
              final dynamic result = await Navigator.pushNamed(
                  context, RoutePaths.itemSort,
                  arguments:
                      widget.searchProductProvider!.productParameterHolder);
              if (result != null) {
                widget.searchProductProvider!.productParameterHolder = result;
                widget.searchProductProvider!.resetLatestProductList(
                    widget.searchProductProvider!.productParameterHolder);
              }
            },
          ),
        ],
      ),
    );
  }
}
