import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/viewobject/holder/tag_object_holder.dart';

class RelatedTagsHorizontalListItem extends StatelessWidget {
  const RelatedTagsHorizontalListItem({
    Key? key,
    required this.tagParameterHolder,
    required this.onTap,
  }) : super(key: key);

  final TagParameterHolder tagParameterHolder;
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Card(
        elevation: 0,
        shape: BeveledRectangleBorder(
            side: BorderSide(color: PsColors.mainColor),
            borderRadius: const BorderRadius.all(Radius.circular(7.0))),
        child: Container(
          margin: const EdgeInsets.all(PsDimens.space4),
          padding: const EdgeInsets.only(
              left: PsDimens.space8, right: PsDimens.space8),
          child: Center(
            child: Text(
              tagParameterHolder.tagName,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: PsColors.mainColor),
            ),
          ),
        ),
      ),
    );
  }
}
