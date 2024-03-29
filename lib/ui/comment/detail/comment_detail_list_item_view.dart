import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/viewobject/comment_detail.dart';

class CommetDetailListItemView extends StatelessWidget {
  const CommetDetailListItemView({
    Key? key,
    required this.comment,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final CommentDetail comment;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (comment != null) {
      return AnimatedBuilder(
          animation: animationController!,
          child: GestureDetector(
            onTap: onTap as void Function()?,
            child: Container(
              color: PsColors.backgroundColor,
              margin: const EdgeInsets.only(top: PsDimens.space8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _ImageAndTextWidget(
                  comment: comment,
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
    } else {
      return Container();
    }
  }
}

class _ImageAndTextWidget extends StatelessWidget {
  const _ImageAndTextWidget({
    Key? key,
    required this.comment,
  }) : super(key: key);

  final CommentDetail comment;

  @override
  Widget build(BuildContext context) {
    if ( comment.user != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PsNetworkImageWithUrl(
            width: PsDimens.space40,
            height: PsDimens.space40,
            photoKey: '',
            imagePath: comment.user!.userProfilePhoto!,
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Text(
                    comment.user!.userName!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Container(
                  child: Text(
                    comment.detailComment!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          Text(comment.addedDateStr!, style: Theme.of(context).textTheme.bodySmall)
        ],
      );
    } else {
      return Container();
    }
  }
}
