import 'package:flutter/material.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/best_choice.dart';

class BestChoiceHorizontalListItemView extends StatelessWidget {
  const BestChoiceHorizontalListItemView
    ({required this.bestChoice,
    this.textColor,
    this.backgroundColor,
    this.buttonBgColor,
    this.buttonTextColor,
    this.onTap,
    });

  final BestChoice bestChoice;
  final Function? onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? buttonBgColor;
  final Color? buttonTextColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space8, 
                right: PsDimens.space8),
            width: 120,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        child: PsNetworkImage(
                          photoKey: '',
                          defaultPhoto: bestChoice.defaultPhoto!,
                          width: 120,
                          height: 140,
                          boxfit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: PsDimens.space140,
                        color: backgroundColor!.withOpacity(0.6),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    left: PsDimens.space8,
                    right: PsDimens.space8,
                    top: PsDimens.space16,
                  ),
                  child: Text(
                    bestChoice.name!,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 13,
                    child: Container(
                      width: 68,
                      height: 22,
                      decoration: BoxDecoration(
                          color: buttonBgColor,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(PsDimens.space8)),
                        ),
                        child: 
                        Padding(
                          padding: const EdgeInsets.only(
                            top: PsDimens.space2,
                            ),
                          child: Text(
                            Utils.getString(context, 'best_choice__order_now'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: buttonTextColor),
                          ),
                        ),
                      ),
                  ),
              ],
            )),
        );
  }
}
