import 'package:flutter/material.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_expansion_tile.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/product.dart';

class DescriptionTileView extends StatelessWidget {
  const DescriptionTileView({
    Key? key,
    required this.productDetail,
  }) : super(key: key);

  final Product productDetail;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'description_tile__product_description'),
        style: Theme.of(context).textTheme.titleMedium);
    if ( productDetail.description != null) {
      return Container(
        child: PsExpansionTile(
          initiallyExpanded: true,
          title: _expansionTileTitleWidget,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  bottom: PsDimens.space16,
                  left: PsDimens.space16,
                  right: PsDimens.space16),
              child: Text(
                productDetail.description ?? '',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      height: 1.3,
                      letterSpacing: 0.5,
                    ),
              ),
            )
          ],
        ),
      );
    } else {
      return const Card();
    }
  }
}
