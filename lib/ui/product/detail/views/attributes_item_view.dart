import 'package:flutter/material.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_dropdown_base_widget.dart';
import 'package:flutterstore/viewobject/AttributeHeader.dart';

class AttributesItemView extends StatefulWidget {
  const AttributesItemView({
    Key? key,
    required this.attribute,
    required this.attributeName,
    this.onTap,
  }) : super(key: key);

  final AttributeHeader attribute;
  final Function? onTap;
  final String attributeName;

  @override
  _AttributesItemViewState createState() => _AttributesItemViewState();
}

class _AttributesItemViewState extends State<AttributesItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap as void Function()?,
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: PsDimens.space2, vertical: PsDimens.space2),
        child: PsDropdownBaseWidget(
          title: widget.attribute.name,
          selectedText: widget.attributeName ,
          onTap: () {
            widget.onTap!();
          },
        ),
      ),
    );
  }
}
