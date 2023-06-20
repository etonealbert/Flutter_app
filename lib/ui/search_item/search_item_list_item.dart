import 'package:flutter/material.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/viewobject/product.dart';

class SearchItemListItem extends StatelessWidget {
  const SearchItemListItem(
      {Key? key,
      required this.product,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Product product;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double> ?animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
            onTap: onTap as void Function()?,
            child: Container(
                margin: const EdgeInsets.only(bottom: PsDimens.space2),
                child: Ink(
                    child: SearchItemListItemWidget(
                        product: product)))),
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

class SearchItemListItemWidget extends StatelessWidget {
  const SearchItemListItemWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Text(
        product.name!,
        style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}