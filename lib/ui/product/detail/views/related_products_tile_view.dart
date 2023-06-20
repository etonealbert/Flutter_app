import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/basket/basket_provider.dart';
import 'package:flutterstore/provider/product/product_provider.dart';
import 'package:flutterstore/provider/product/related_product_provider.dart';
import 'package:flutterstore/ui/common/dialog/choose_attribute_dialog.dart';
import 'package:flutterstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterstore/ui/common/ps_expansion_tile.dart';
import 'package:flutterstore/ui/product/item/product_horizontal_list_item.dart';
import 'package:flutterstore/ui/product/item/related_tags_horizontal_list_item.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/basket.dart';
import 'package:flutterstore/viewobject/basket_selected_attribute.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/holder/tag_object_holder.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RelatedProductsTileView extends StatefulWidget {
  const RelatedProductsTileView({
    Key? key,
    required this.productDetail,
    required this.basketProvider,
  }) : super(key: key);

  final ProductDetailProvider productDetail;
  final BasketProvider? basketProvider;

  @override
  _RelatedProductsTileViewState createState() =>
      _RelatedProductsTileViewState();
}

class _RelatedProductsTileViewState extends State<RelatedProductsTileView> {
  double? bottomSheetPrice;
  double totalOriginalPrice = 0.0;
  PsValueHolder? valueHolder;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'related_product_tile__related_product'),
        style: Theme.of(context).textTheme.titleMedium!.copyWith());

    final List<String> tags =
        widget.productDetail.productDetail.data!.searchTag!.split(',');

    final List<TagParameterHolder> tagObjectList = <TagParameterHolder>[
      TagParameterHolder(
          fieldName: PsConst.CONST_CATEGORY,
          tagId: widget.productDetail.productDetail.data!.category!.id!,
          tagName: widget.productDetail.productDetail.data!.category!.name!),
      TagParameterHolder(
          fieldName: PsConst.CONST_SUB_CATEGORY,
          tagId: widget.productDetail.productDetail.data!.subCategory!.id!,
          tagName: widget.productDetail.productDetail.data!.subCategory!.name!),
      for (String? tag in tags)
        if (tag != null && tag != '')
          TagParameterHolder(
              fieldName: PsConst.CONST_PRODUCT, tagId: tag, tagName: tag),
    ];

    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    bottom: PsDimens.space16,
                    left: PsDimens.space16,
                    right: PsDimens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      Utils.getString(
                          context, 'related_product_tile__related_tag'),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    _RelatedTagsWidget(
                      tagObjectList: tagObjectList,
                      productDetailProvider: widget.productDetail,
                    ),
                  ],
                ),
              ),
              _RelatedProductWidget(
                basketProvider: widget.basketProvider,
                bottomSheetPrice: bottomSheetPrice,
                totalOriginalPrice: totalOriginalPrice,
                basketSelectedAttribute: basketSelectedAttribute, 
                valueHolder : valueHolder!,//animation
              )
            ],
          )
        ],
        onExpansionChanged: (bool expanding) {},
      ),
    );
  }
}

class _RelatedTagsWidget extends StatelessWidget {
  const _RelatedTagsWidget({
    Key? key,
    required this.tagObjectList,
    required this.productDetailProvider,
  }) : super(key: key);

  final List<TagParameterHolder>? tagObjectList;
  final ProductDetailProvider productDetailProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PsDimens.space40,
      child: CustomScrollView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                if (tagObjectList != null) {
                  return RelatedTagsHorizontalListItem(
                    tagParameterHolder: tagObjectList![index],
                    onTap: () async {
                      final ProductParameterHolder productParameterHolder =
                          ProductParameterHolder().resetParameterHolder();

                      if (index == 0) {
                        productParameterHolder.catId =
                            productDetailProvider.productDetail.data!.catId;
                      } else if (index == 1) {
                        productParameterHolder.catId =
                            productDetailProvider.productDetail.data!.catId;
                        productParameterHolder.subCatId =
                            productDetailProvider.productDetail.data!.subCatId;
                      } else {
                        productParameterHolder.searchTerm =
                            tagObjectList![index].tagName;
                      }
                      print('productParameterHolder.catId ' +
                          productParameterHolder.catId! +
                          'productParameterHolder.subCatId ' +
                          productParameterHolder.subCatId! +
                          'productParameterHolder.searchTerm ' +
                          productParameterHolder.searchTerm!);
                      Navigator.pushNamed(context, RoutePaths.filterProductList,
                          arguments: ProductListIntentHolder(
                            appBarTitle: tagObjectList![index].tagName,
                            productParameterHolder: productParameterHolder,
                          ));
                    },
                  );
                } else {
                  return null;
                }
              }, childCount: tagObjectList!.length),
            ),
          ]),
    );
  }
}

class _RelatedProductWidget extends StatefulWidget {
  const _RelatedProductWidget(
      {Key? key,
      required this.basketProvider,
      required this.bottomSheetPrice,
      required this.totalOriginalPrice,
      required this.basketSelectedAttribute,
      required this.valueHolder,
      })
      : super(key: key);

  final BasketProvider? basketProvider;
  final double? bottomSheetPrice;
  final double totalOriginalPrice;
  final BasketSelectedAttribute basketSelectedAttribute;
  final PsValueHolder valueHolder;

  @override
  __RelatedProductWidgetState createState() => __RelatedProductWidgetState();
}

class __RelatedProductWidgetState extends State<_RelatedProductWidget> {
  String? qty;
  String? colorId = '';
  String? colorValue;
  bool? checkAttribute;
  Basket? basket;
  String? id;

  @override
  Widget build(BuildContext context) {
    return Consumer<RelatedProductProvider>(builder:
        (BuildContext context, RelatedProductProvider provider, Widget? child) {
      if (
          provider.relatedProductList.data != null &&
          provider.relatedProductList.data!.isNotEmpty) {
        return Container(
          height: PsDimens.space300,
          color: PsColors.coreBackgroundColor,
          child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final Product relatedProduct =
                          provider.relatedProductList.data![index];
                      return ProductHorizontalListItem(
                        valueHolder: widget.valueHolder,
                        coreTagKey: provider.hashCode.toString() +
                            provider.relatedProductList.data![index].id!,
                        product: provider.relatedProductList.data![index],
                        onTap: () {
                          final ProductDetailIntentHolder holder =
                              ProductDetailIntentHolder(
                            productId: relatedProduct.id,
                            heroTagImage: provider.hashCode.toString() +
                                relatedProduct.id! +
                                PsConst.HERO_TAG__IMAGE,
                            heroTagTitle: provider.hashCode.toString() +
                                relatedProduct.id! +
                                PsConst.HERO_TAG__TITLE,
                            heroTagOriginalPrice: provider.hashCode.toString() +
                                relatedProduct.id! +
                                PsConst.HERO_TAG__ORIGINAL_PRICE,
                            heroTagUnitPrice: provider.hashCode.toString() +
                                relatedProduct.id! +
                                PsConst.HERO_TAG__UNIT_PRICE,
                          );

                          Navigator.pushNamed(context, RoutePaths.productDetail,
                              arguments: holder);
                        },
                        onButtonTap: () async {
                          if (relatedProduct.minimumOrder == '0') {
                            relatedProduct.minimumOrder = '1';
                          }
                          if (relatedProduct.isAvailable == '1') {
                            if (relatedProduct
                                    .attributesHeaderList!.isNotEmpty &&
                                relatedProduct.attributesHeaderList![0].id !=
                                    '') {
                              showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ChooseAttributeDialog(
                                        product: relatedProduct);
                                  });
                            } else {
                              id =
                                  '${relatedProduct.id}$colorId${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${widget.basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
                              basket = Basket(
                                  id: id,
                                  productId: relatedProduct.id,
                                  qty: qty ?? relatedProduct.minimumOrder,
                                  shopId: widget
                                      .basketProvider!.psValueHolder!.shopId,
                                  selectedColorId: colorId,
                                  selectedColorValue: colorValue,
                                  basketPrice: widget.bottomSheetPrice == null
                                      ? relatedProduct.unitPrice
                                      : widget.bottomSheetPrice.toString(),
                                  basketOriginalPrice:
                                      widget.totalOriginalPrice == 0.0
                                          ? relatedProduct.originalPrice
                                          : widget.totalOriginalPrice
                                              .toString(),
                                  selectedAttributeTotalPrice: widget
                                      .basketSelectedAttribute
                                      .getTotalSelectedAttributePrice()
                                      .toString(),
                                  product: relatedProduct,
                                  basketSelectedAttributeList: widget
                                      .basketSelectedAttribute
                                      .getSelectedAttributeList());

                              await widget.basketProvider!.addBasket(basket!);

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
                    },
                    childCount: provider.relatedProductList.data!.length,
                  ),
                ),
              ]),
        );
      } else {
        return Container();
      }
    });
  }
}
