import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';

class PsSearchTextFieldWidget extends StatelessWidget {
  const PsSearchTextFieldWidget(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.psValueHolder
      });

  final TextEditingController?  textEditingController;
  final String ?hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder? psValueHolder;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final ProductParameterHolder productParameterHolder =
        ProductParameterHolder().getLatestParameterHolder();
    final Widget _productTextFieldWidget = TextField(
      keyboardType: TextInputType.text,
      textInputAction: textInputAction,
      maxLines: null,
      controller: textEditingController,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
          left: PsDimens.space12,
          bottom: PsDimens.space12,
        ),
        border: InputBorder.none,
        hintText: hintText,
      ),
      onSubmitted: (String value) {
        productParameterHolder.searchTerm = textEditingController!.text;
        Navigator.pushNamed(
            context, RoutePaths.searchItemList,
            arguments: productParameterHolder);
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: height,
          margin: const EdgeInsets.all(PsDimens.space12),
          decoration: BoxDecoration(
              color: PsColors.mainDividerColor,
              borderRadius: BorderRadius.circular(PsDimens.space4),
              border: Border.all(color: PsColors.mainDividerColor),
            ),
          child: _productTextFieldWidget,
        ),
      ],
    );
  }
}
