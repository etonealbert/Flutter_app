import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/comment_header.dart';

class CommetListItem extends StatelessWidget {
  const CommetListItem({
    Key? key,
    required this.comment,
    this.animationController,
    this.animation,
    this.onTap,
  }) : super(key: key);

  final CommentHeader comment;
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
                padding: const EdgeInsets.all(8.0),
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

  final CommentHeader comment;

  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(comment.addedDateStr!,
        style:
            Theme.of(context).textTheme.bodySmall!.copyWith(color: PsColors.grey));

    if ( comment.user != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PsNetworkImageWithUrl(
            photoKey: '',
            width: PsDimens.space40,
            height: PsDimens.space40,
            imagePath: comment.user!.userProfilePhoto!,
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          comment.user!.userName!,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const Icon(
                        Icons.reply_all,
                        size: PsDimens.space20,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: PsDimens.space8),
                  child: Text(
                    comment.headerComment!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          comment.commentReplyCount == '0'
                              ? ''
                              : '- ${comment.commentReplyCount} ${Utils.getString(context, 'comment_list__replies')}',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                    _textWidget
                  ],
                )
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
