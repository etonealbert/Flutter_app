import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/basket/basket_provider.dart';
import 'package:flutterstore/provider/history/history_provider.dart';
import 'package:flutterstore/provider/product/product_provider.dart';
import 'package:flutterstore/repository/basket_repository.dart';
import 'package:flutterstore/repository/history_repsitory.dart';
import 'package:flutterstore/repository/product_repository.dart';
import 'package:flutterstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterstore/ui/common/ps_button_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/product/detail/views/attributes_item_view.dart';
import 'package:flutterstore/ui/product/detail/views/color_list_item_view.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/AttributeDetail.dart';
import 'package:flutterstore/viewobject/basket.dart';
import 'package:flutterstore/viewobject/basket_selected_attribute.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/attribute_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ChooseAttributeDialog extends StatefulWidget {
  const ChooseAttributeDialog({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChooseAttributeDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget, product: widget.product);
  }
}

class NewDialog extends StatefulWidget {
  const NewDialog({
    Key? key,
    required this.widget,
    required this.product,
  }) : super(key: key);

  final ChooseAttributeDialog widget;
  final Product product;

  @override
  _NewDialogState createState() => _NewDialogState();
}

class _NewDialogState extends State<NewDialog> {
  PsValueHolder? psValueHolder;
  ProductDetailProvider? provider;
  HistoryProvider? historyProvider;
  BasketSelectedAttribute basketSelectedAttribute = BasketSelectedAttribute();
  double selectedAddOnPrice = 0.0;
  double selectedAttributePrice = 0.0;
  double? totalPrice;
  double? bottomSheetPrice;
  double? totalOriginalPrice = 0.0;
  ProductRepository? productRepo;
  BasketProvider? basketProvider;
  BasketRepository? basketRepository;
  HistoryRepository? historyRepo;
  bool isCallFirstTime = true;
  String? colorId = '';
  String? colorValue;
  Basket? basket;
  String? id;
  String? qty;
  List<BasketSelectedAttribute>? holderBasketSelectedAttributeList;

  Future<void> addToBasketAndBuyClickEvent(bool isBuyButtonType) async {
    if (widget.product.itemColorList!.isNotEmpty &&
        widget.product.itemColorList![0].id != '') {
      if (colorId == null || colorId == '') {
        await showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                message: Utils.getString(
                    context, 'product_detail__please_select_color'),
                onPressed: () {},
              );
            });
        return;
      }
    }
    id =
        '${widget.product.id}$colorId${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}${basketSelectedAttribute.getSelectedAttributeIdByHeaderId()}';
    // Check All Attribute is selected
    if (widget.product.attributesHeaderList != null) {
      if (widget.product.attributesHeaderList![0].id != '' &&
          widget.product.attributesHeaderList![0].attributesDetail != null &&
          !basketSelectedAttribute.isAllAttributeSelected(
              widget.product.attributesHeaderList!.length)) {
        await showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return WarningDialog(
                message: Utils.getString(
                    context, 'product_detail__please_choose_attribute'),
                onPressed: () {},
              );
            });
        return;
      }
    }

    basket = Basket(
        id: id,
        productId: widget.product.id,
        qty: qty ?? widget.product.minimumOrder,
        shopId: psValueHolder!.shopId,
        selectedColorId: colorId,
        selectedColorValue: colorValue,
        basketPrice: bottomSheetPrice == null
            ? widget.product.unitPrice
            : bottomSheetPrice.toString(),
        basketOriginalPrice: totalOriginalPrice == 0.0
            ? widget.product.originalPrice
            : totalOriginalPrice.toString(),
        selectedAttributeTotalPrice:
            basketSelectedAttribute.getTotalSelectedAttributePrice().toString(),
        product: widget.product,
        basketSelectedAttributeList:
            basketSelectedAttribute.getSelectedAttributeList());

    await basketProvider!.addBasket(basket!);

    Fluttertoast.showToast(
        msg: Utils.getString(context, 'product_detail__success_add_to_basket'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: PsColors.mainColor,
        textColor: PsColors.white);

    if (isBuyButtonType) {
      final dynamic result = await Navigator.pushNamed(
        context,
        RoutePaths.basketList,
      );
      if (result != null && result) {
        provider!.loadProduct(widget.product.id!, psValueHolder!.loginUserId!,
            psValueHolder!.shopId!);
      }
    }
  }

  Future<void> updatePrice(double price, double totalOriginalPrice) async {
    this.totalOriginalPrice = totalOriginalPrice;
    setState(() {
      bottomSheetPrice = price;
    });
  }

  Future<void> updateColorIdAndValue(String id, String value) async {
    colorId = id;
    colorValue = value;
  }

  Future<void> updateQty(String minimumOrder) async {
    setState(() {
      qty = minimumOrder;
    });
  }

  @override
  Widget build(BuildContext context) {
    productRepo = Provider.of<ProductRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    historyRepo = Provider.of<HistoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    final Widget _headerWidget = Container(
        height: PsDimens.space52,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5)),
            color: PsColors.mainColor),
        child: Row(
          children: <Widget>[
            const SizedBox(width: PsDimens.space12),
            Icon(
              Icons.add_shopping_cart,
              color: PsColors.white,
            ),
            const SizedBox(width: PsDimens.space8),
            Text(
              Utils.getString(context, 'choose_attribute_dialog__title'),
              textAlign: TextAlign.start,
              style: TextStyle(
                color: PsColors.white,
              ),
            ),
          ],
        ));

    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ProductDetailProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider = ProductDetailProvider(
                  repo: productRepo!, psValueHolder: psValueHolder!);

              final String loginUserId = Utils.checkUserLoginId(psValueHolder!);
              provider!.loadProduct(widget.product.id!, loginUserId,
                  provider!.psValueHolder!.shopId!);

              return provider!;
            },
          ),
          ChangeNotifierProvider<BasketProvider>(
              lazy: false,
              create: (BuildContext context) {
                basketProvider = BasketProvider(repo: basketRepository!);
                return basketProvider!;
              }),
          ChangeNotifierProvider<HistoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo!);
              return historyProvider!;
            },
          ),
        ],
        child: Consumer<ProductDetailProvider>(builder: (BuildContext context,
            ProductDetailProvider provider, Widget? child) {
          return Consumer<BasketProvider>(builder: (BuildContext context,
              BasketProvider basketProvider, Widget? child) {
            if (
                //provider != null &&
                // provider.productDetail != null &&
                provider.productDetail.data != null) {
              if (isCallFirstTime) {
                ///
                /// Add to History
                ///
                historyProvider!.addHistoryList(provider.productDetail.data!);

                ///
                /// Load Basket List
                ///
                ///
                basketProvider =
                    Provider.of<BasketProvider>(context, listen: false);

                basketProvider.loadBasketList();
                isCallFirstTime = false;
              }
              return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      _headerWidget,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(height: PsDimens.space12),
                          Container(
                            width: PsDimens.space52,
                            height: PsDimens.space4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: PsColors.mainDividerColor,
                            ),
                          ),
                          const SizedBox(height: PsDimens.space24),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _ImageAndTextForBottomSheetWidget(
                            product: widget.product,
                            price: bottomSheetPrice ??
                                double.parse(widget.product.unitPrice!),
                            valueHolder: psValueHolder,
                          ),
                          Divider(
                              height: PsDimens.space20,
                              color: PsColors.mainColor),
                          Flexible(
                              child: SingleChildScrollView(
                                  child: Padding(
                            padding: const EdgeInsets.only(
                                left: PsDimens.space16,
                                right: PsDimens.space16,
                                top: PsDimens.space8,
                                bottom: PsDimens.space16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _ColorsWidget(
                                  product: widget.product,
                                  updateColorIdAndValue: updateColorIdAndValue,
                                  selectedColorId: colorId!,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: PsDimens.space8,
                                      left: PsDimens.space12,
                                      right: PsDimens.space12),
                                  child: Text(
                                    Utils.getString(
                                        context, 'product_detail__how_many'),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                  ),
                                ),
                                _IconAndTextWidget(
                                  product: widget.product,
                                  updateQty: updateQty,
                                  qty: qty,
                                ),
                                _AttributesWidget(
                                    product: widget.product,
                                    updatePrice: updatePrice,
                                    basketSelectedAttribute:
                                        basketSelectedAttribute),
                                const SizedBox(height: PsDimens.space12),
                                Padding(
                                  padding:
                                      const EdgeInsets.all(PsDimens.space8),
                                  child: PSButtonWithIconWidget(
                                    hasShadow: true,
                                    colorData: PsColors.grey,
                                    icon: Icons.add_shopping_cart,
                                    width: double.infinity,
                                    titleText: Utils.getString(context,
                                        'product_detail__add_to_basket'),
                                    onPressed: () async {
                                      if (widget.product.isAvailable ==
                                          PsConst.ONE) {
                                        addToBasketAndBuyClickEvent(false);
                                      } else {
                                        showDialog<dynamic>(
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
                                  ),
                                ),
                                const SizedBox(height: PsDimens.space4),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: PsDimens.space8,
                                      right: PsDimens.space8,
                                      top: PsDimens.space8,
                                      bottom: PsDimens.space32),
                                  child: PSButtonWithIconWidget(
                                    hasShadow: true,
                                    icon: Icons.shopping_cart,
                                    width: double.infinity,
                                    titleText: Utils.getString(
                                        context, 'product_detail__buy'),
                                    onPressed: () async {
                                      if (widget.product.isAvailable ==
                                          PsConst.ONE) {
                                        addToBasketAndBuyClickEvent(true);
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
                                  ),
                                ),
                              ],
                            ),
                          )))
                        ],
                      ),
                    ]),
                  )
                  // )
                  );
            } else {
              return Container();
            }
          });
        }));
  }
}

class _ImageAndTextForBottomSheetWidget extends StatefulWidget {
  const _ImageAndTextForBottomSheetWidget({
    Key? key,
    required this.product,
    required this.price,
    required this.valueHolder,
  }) : super(key: key);

  final Product product;
  final double? price;
  final PsValueHolder? valueHolder;
  @override
  __ImageAndTextForBottomSheetWidgetState createState() =>
      __ImageAndTextForBottomSheetWidgetState();
}

class __ImageAndTextForBottomSheetWidgetState
    extends State<_ImageAndTextForBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(
            left: PsDimens.space16,
            right: PsDimens.space16,
            top: PsDimens.space8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: PsDimens.space60,
              height: PsDimens.space60,
              child: PsNetworkImage(
                photoKey: '',
                defaultPhoto: widget.product.defaultPhoto!,
              ),
            ),
            const SizedBox(
              width: PsDimens.space8,
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: PsDimens.space8),
                    child: (widget.product.isDiscount == PsConst.ONE)
                        ? Row(
                            children: <Widget>[
                              Text(
                                widget.price != null
                                    ? '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.price.toString(), widget.valueHolder!)}'
                                    : '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.unitPrice!, widget.valueHolder!)}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: PsColors.mainColor),
                              ),
                              const SizedBox(
                                width: PsDimens.space8,
                              ),
                              Text(
                                '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.originalPrice!, widget.valueHolder!)}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        decoration: TextDecoration.lineThrough),
                              )
                            ],
                          )
                        : Text(
                            widget.price != null
                                ? '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.price.toString(), widget.valueHolder!)}'
                                : '${widget.product.currencySymbol} ${Utils.getPriceFormat(widget.product.unitPrice!, widget.valueHolder!)}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: PsColors.mainColor),
                          ),
                  ),
                  const SizedBox(
                    height: PsDimens.space2,
                  ),
                  Text(
                    widget.product.name!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: PsColors.grey),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class _IconAndTextWidget extends StatefulWidget {
  const _IconAndTextWidget({
    Key? key,
    required this.product,
    required this.updateQty,
    required this.qty,
  }) : super(key: key);

  final Product product;
  final Function updateQty;
  final String? qty;

  @override
  _IconAndTextWidgetState createState() => _IconAndTextWidgetState();
}

class _IconAndTextWidgetState extends State<_IconAndTextWidget> {
  int orderQty = 1;
  int maximumOrder = 0;
  int minimumOrder = 1; // 1 is default

  void initMinimumOrder() {
    if (widget.product.minimumOrder != '0' &&
        widget.product.minimumOrder != '' &&
        widget.product.minimumOrder != null) {
      minimumOrder = int.parse(widget.product.minimumOrder!);
    }
  }

  void initMaximumOrder() {
    if (widget.product.maximumOrder != '0' &&
        widget.product.maximumOrder != '' &&
        widget.product.maximumOrder != null) {
      maximumOrder = int.parse(widget.product.maximumOrder!);
    }
  }

  void initQty() {
    if (orderQty == 0 && widget.qty != null && widget.qty != '') {
      orderQty = int.parse(widget.qty!);
    } else if (orderQty == 0) {
      orderQty = int.parse(widget.product.minimumOrder!);
    }
  }

  void _increaseItemCount() {
    if (orderQty + 1 <= maximumOrder || maximumOrder == 0) {
      setState(() {
        orderQty++;
        widget.updateQty('$orderQty');
      });
    } else {
      Fluttertoast.showToast(
          msg:
              ' ${Utils.getString(context, 'product_detail__maximum_order')}  ${widget.product.maximumOrder}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: PsColors.mainColor,
          textColor: PsColors.white);
    }
  }

  void _decreaseItemCount() {
    if (orderQty != 0 && orderQty > minimumOrder) {
      orderQty--;
      setState(() {
        widget.updateQty('$orderQty');
      });
    } else {
      Fluttertoast.showToast(
          msg:
              ' ${Utils.getString(context, 'product_detail__minimum_order')}  ${widget.product.minimumOrder}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: PsColors.mainColor,
          textColor: PsColors.white);
    }
  }

  void onUpdateItemCount(int buttonType) {
    if (buttonType == 1) {
      _increaseItemCount();
    } else if (buttonType == 2) {
      _decreaseItemCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    initMinimumOrder();

    initMaximumOrder();

    initQty();

    final Widget _addIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.add_circle, color: PsColors.mainColor),
        onPressed: () {
          onUpdateItemCount(1);
        });

    final Widget _removeIconWidget = IconButton(
        iconSize: PsDimens.space32,
        icon: Icon(Icons.remove_circle, color: PsColors.grey),
        onPressed: () {
          onUpdateItemCount(2);
        });

    return Container(
      margin:
          const EdgeInsets.only(top: PsDimens.space8, bottom: PsDimens.space8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _removeIconWidget,
          Center(
            child: Container(
              height: PsDimens.space24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: PsColors.mainDividerColor)),
              padding: const EdgeInsets.only(
                  left: PsDimens.space24, right: PsDimens.space24),
              child: Text(
                '$orderQty', //?? widget.product.minimumOrder,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColor),
              ),
            ),
          ),
          _addIconWidget,
        ],
      ),
    );
  }
}

class _ColorsWidget extends StatefulWidget {
  const _ColorsWidget({
    Key? key,
    required this.product,
    required this.updateColorIdAndValue,
    required this.selectedColorId,
  }) : super(key: key);

  final Product product;
  final Function updateColorIdAndValue;
  final String selectedColorId;
  @override
  __ColorsWidgetState createState() => __ColorsWidgetState();
}

class __ColorsWidgetState extends State<_ColorsWidget> {
  String _selectedColorId = '';

  @override
  Widget build(BuildContext context) {
    if (_selectedColorId == '') {
      _selectedColorId = widget.selectedColorId;
    }
    if (widget.product.itemColorList!.isNotEmpty &&
        widget.product.itemColorList![0].id != '') {
      return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12, right: PsDimens.space12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Text(
                Utils.getString(context, 'product_detail__available_color'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                height: 50,
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.itemColorList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ColorListItemView(
                            color: widget.product.itemColorList![index],
                            selectedColorId: _selectedColorId,
                            onColorTap: () {
                              setState(() {
                                _selectedColorId =
                                    widget.product.itemColorList![index].id!;

                                widget.updateColorIdAndValue(
                                    _selectedColorId,
                                    widget.product.itemColorList![index]
                                        .colorValue);
                              });
                            },
                          );
                        })),
              ),
              const SizedBox(
                height: PsDimens.space4,
              ),
            ],
          ));
    } else {
      return Container();
    }
  }
}

class _AttributesWidget extends StatefulWidget {
  const _AttributesWidget({
    Key? key,
    required this.product,
    required this.updatePrice,
    required this.basketSelectedAttribute,
  }) : super(key: key);

  final Product product;
  final Function updatePrice;
  final BasketSelectedAttribute basketSelectedAttribute;
  @override
  __AttributesWidgetState createState() => __AttributesWidgetState();
}

class __AttributesWidgetState extends State<_AttributesWidget> {
  double? totalPrice;
  double? totalOriginalPrice;

  @override
  Widget build(BuildContext context) {
    if (widget.product.attributesHeaderList!.isNotEmpty &&
        widget.product.attributesHeaderList![0].id != '') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(
                  top: PsDimens.space8,
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                  bottom: PsDimens.space8),
              child: Text(
                Utils.getString(context, 'product_detail__other_information'),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              )),
          Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space8, right: PsDimens.space8),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.product.attributesHeaderList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AttributesItemView(
                          attribute:
                              widget.product.attributesHeaderList![index],
                          attributeName: widget.basketSelectedAttribute
                              .getSelectedAttributeNameByHeaderId(
                                  widget
                                      .product.attributesHeaderList![index].id!,
                                  widget.product.attributesHeaderList![index]
                                      .name!),
                          onTap: () async {
                            final dynamic result = await Navigator.pushNamed(
                                context, RoutePaths.attributeDetailList,
                                arguments: AttributeDetailIntentHolder(
                                    attributeDetail: widget
                                        .product
                                        .attributesHeaderList![index]
                                        .attributesDetail!,
                                    product: widget.product));

                            if (result != null && result is AttributeDetail) {
                              // Update selected attribute
                              widget.basketSelectedAttribute.addAttribute(
                                  BasketSelectedAttribute(
                                      headerId: result.headerId,
                                      id: result.id,
                                      name: result.name,
                                      price: result.additionalPrice,
                                      currencySymbol:
                                          widget.product.currencySymbol));
                              // Get Total Selected Attribute Price
                              final double selectedAttributePrice = widget
                                  .basketSelectedAttribute
                                  .getTotalSelectedAttributePrice();

                              // Update Price
                              totalPrice =
                                  double.parse(widget.product.unitPrice!) +
                                      selectedAttributePrice;

                              totalOriginalPrice =
                                  double.parse(widget.product.originalPrice!) +
                                      selectedAttributePrice;

                              widget.updatePrice(
                                  totalPrice, totalOriginalPrice);

                              // Update UI
                              setState(() {});
                            } else {}
                          });
                    }),
              )),
        ],
      );
    } else {
      return Container();
    }
  }
}
