import 'package:flutter/material.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/sub_category.dart';
import 'package:provider/provider.dart';

import '../../../viewobject/common/ps_value_holder.dart';

class SubCategoryVerticalListItem extends StatelessWidget {
  const SubCategoryVerticalListItem({
    Key? key,
    required this.subCategory,
    this.onTap,
  }) : super(key: key);

  final SubCategory subCategory;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = 
        Provider.of<PsValueHolder>(context, listen: false);
    return GestureDetector(
        onTap: onTap as void Function()?,
        child: Card(
          elevation: 0.3,
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space16, vertical: PsDimens.space4),
          child: Container(
            padding: const EdgeInsets.all(PsDimens.space16),
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space4,
                ),
                PsNetworkImage(
                  photoKey: '',
                  defaultPhoto: subCategory.defaultPhoto!,
                  width: PsDimens.space44,
                  height: PsDimens.space44,
                  onTap: () {
                    Utils.psPrint(subCategory.defaultPhoto!.imgParentId!);
                  },
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space4,
                    ),
                    Text(
                      subCategory.name!,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)
                              .fontWeight),
                    ),
                    const SizedBox(
                      height: PsDimens.space4,
                    ),
                    Text(
                        subCategory.addedDate == ''
                            ? ''
                            : Utils.getDateFormat(subCategory.addedDate!,psValueHolder),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(
                      height: PsDimens.space4,
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
