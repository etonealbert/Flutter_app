import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_hero.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/product.dart';

class ProductVeticalListItem extends StatelessWidget {
  const ProductVeticalListItem(
      {Key? key,
      required this.product,
      this.onTap,
      this.onButtonTap,
      this.animationController,
      this.animation,
      this.coreTagKey,
      required this.valueHolder,
      })
      : super(key: key);

  final Product product;
  final Function? onTap;
  final Function? onButtonTap;
  final String? coreTagKey;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final PsValueHolder valueHolder;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: GestureDetector(
          onTap: onTap as void Function()?,
          child: GridTile(
            header: Container(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      child: product.isDiscount == PsConst.ONE
                          ? Container(
                              width: PsDimens.space52,
                              height: PsDimens.space24,
                              child: Stack(
                                children: <Widget>[
                                  Image.asset(
                                      'assets/images/baseline_percent_tag_orange_24.png',
                                      matchTextDirection: true,
                                      color: PsColors.mainColor),
                                  Center(
                                    child: Text(
                                      '-${product.discountPercent}%',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: PsColors.white),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8, top: PsDimens.space8),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: product.isFeatured == PsConst.ONE
                            ? Image.asset(
                                'assets/images/baseline_feature_circle_24.png',
                                width: PsDimens.space32,
                                height: PsDimens.space32,
                              )
                            : Container()),
                  )
                ],
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space8, vertical: PsDimens.space8),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(PsDimens.space8)),
                      ),
                      child: ClipPath(
                        child: Container(
                          width: PsDimens.space180,
                          height: PsDimens.space200,
                          child: PsNetworkImage(
                            photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                            defaultPhoto: product.defaultPhoto!,

                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto!.imgParentId!);
                              onTap!();
                            },
                          ),
                        ),
                        clipper: const ShapeBorderClipper(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(PsDimens.space8),
                                    topRight:
                                        Radius.circular(PsDimens.space8)))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space12,
                        right: PsDimens.space8,
                        bottom: PsDimens.space4),
                    child: PsHero(
                      tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                      child: Text(
                        product.name!,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space4,
                        right: PsDimens.space8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: PsHero(
                            tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                            flightShuttleBuilder: Utils.flightShuttleBuilder,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                  '${product.currencySymbol}${Utils.getPriceFormat(product.unitPrice!,valueHolder)}',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: PsColors.mainColor,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: product.isDiscount == PsConst.ONE
                                  ? PsHero(
                                      tag:
                                          '$coreTagKey$PsConst.HERO_TAG__ORIGINAL_PRICE',
                                      flightShuttleBuilder:
                                          Utils.flightShuttleBuilder,
                                      child: Material(
                                        color: PsColors.transparent,
                                        child: Text(
                                            '${product.currencySymbol}${Utils.getPriceFormat(product.originalPrice!,valueHolder)}',
                                            textAlign: TextAlign.start,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1),
                                      ),
                                    )
                                  : Container()),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space8,
                        top: PsDimens.space8,
                        right: PsDimens.space4),
                    child: SmoothStarRating(
                        key: Key(product.ratingDetail!.totalRatingValue!),
                        rating:
                            double.parse(product.ratingDetail!.totalRatingValue!),
                        allowHalfRating: false,
                        onRated: (double? v) {
                          onTap!();
                        },
                        starCount: 5,
                        size: 18.0,
                        color: PsColors.ratingColor,
                        borderColor: PsColors.grey.withAlpha(100),
                        spacing: 0.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: PsDimens.space12,
                        left: PsDimens.space12,
                        right: PsDimens.space4),
                    child: Row(
                      children: <Widget>[
                        Text(
                            '${product.ratingDetail!.totalRatingValue} ${Utils.getString(context, 'feature_slider__rating')}',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall),
                        Text(
                            '( ${product.ratingDetail!.totalRatingCount} ${Utils.getString(context, 'feature_slider__reviewer')} )',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodySmall),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: PsDimens.space4),
                              child: IconButton(
                                  iconSize: 28,
                                  icon: Icon(Icons.add_circle,
                                      color: PsColors.mainColor),
                                  onPressed: () {
                                    onButtonTap!();
                                  })),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}
