import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterstore/viewobject/rating.dart';

class RatingListItem extends StatelessWidget {
  const RatingListItem({
    Key? key,
    required this.rating,
    this.onTap,
  }) : super(key: key);

  final Rating rating;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _RatingListDataWidget(
              rating: rating,
            ),
            const Divider(
              height: PsDimens.space1,
            ),
            ImageAndTextWidget(
              rating: rating,
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingListDataWidget extends StatelessWidget {
  const _RatingListDataWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget _ratingStarsWidget = SmoothStarRating(
        key: Key(rating.rating!),
        rating: double.parse(rating.rating!),
        allowHalfRating: false,
        starCount: 5,
        size: PsDimens.space16,
        color: PsColors.ratingColor,
        borderColor: PsColors.grey.withAlpha(100),
        spacing: 0.0);

    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space8,
    );
    final Widget _titleTextWidget = Text(
      rating.title!,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
    final Widget _descriptionTextWidget = Text(
      rating.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _ratingStarsWidget,
          _spacingWidget,
          _titleTextWidget,
          _spacingWidget,
          _descriptionTextWidget,
        ],
      ),
    );
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key? key,
    required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  Widget build(BuildContext context) {
    final Widget _imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(PsDimens.space8),
      child: PsNetworkImageWithUrl(
        photoKey: '',
        imagePath: rating.user!.userProfilePhoto!,
        width: PsDimens.space40,
        height: PsDimens.space40,
      ),
    );
    final Widget _personNameTextWidget = Text(rating.user!.userName!,
        style: Theme.of(context).textTheme.titleMedium!.copyWith());

    final Widget _timeWidget = Text(
      rating.addedDateStr!,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(),
    );
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              _imageWidget,
              const SizedBox(
                width: PsDimens.space12,
              ),
              _personNameTextWidget,
            ],
          ),
          _timeWidget,
        ],
      ),
    );
  }
}
