import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/viewobject/shipping_country.dart';

class CountryListItem extends StatelessWidget {
  const CountryListItem(
      {Key? key,
      required this.country,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ShippingCountry country;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();

    return AnimatedBuilder(
      animation: animationController!,
      child: GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: PsColors.backgroundColor,
          height: PsDimens.space52,
          margin: const EdgeInsets.only(top: PsDimens.space4),
          child: Padding(
            padding: const EdgeInsets.all(PsDimens.space16),
            child: Text(
              country.name!,
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.bold),
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
              child: child),
        );
      },
    );
  }
}
