import 'package:flutter/material.dart';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/user/user_provider.dart';
import 'package:flutterstore/repository/user_repository.dart';
import 'package:flutterstore/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterstore/ui/common/dialog/error_dialog.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/utils/ps_progress_dialog.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/api_status.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/delete_user_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../constant/ps_constants.dart';

class MoreView extends StatefulWidget {
  const MoreView({Key? key, required this.animationController,
  required this.closeMoreContainerView})
      : super(key: key);

  final AnimationController animationController;
    final Function closeMoreContainerView;

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;
  late PsValueHolder _valueHolder;
  bool _showAds = false;
  UserProvider? userProvider;
  UserRepository? userRepository;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && _showAds) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    _valueHolder = Provider.of<PsValueHolder>(context);
    if (_valueHolder.isShowAdmob != null &&
        _valueHolder.isShowAdmob == PsConst.ONE) {
      _showAds = true;
    } else {
      _showAds = false;
    }

    if (!isConnectedToInternet && _showAds) {
      print('loading ads....');
      checkConnection();
    }
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    widget.animationController.forward();

    return ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepository!, psValueHolder: _valueHolder);
          return userProvider!;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider userProvider, Widget? child) {
          return AnimatedBuilder(
            animation: widget.animationController,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _MoreActivityTitleWidget(),
                  _MoreFavouriteWidget(),
                  const SizedBox(height: PsDimens.space8),
                  _MoreTransactionWidget(),
                  const SizedBox(height: PsDimens.space8),
                  _MoreHistoryWidget(),
                  _MoreSettingAndPrivacyTitleWidget(),
                  const SizedBox(height: PsDimens.space4),
                    _MoreDeactivateAccWidget(
                       userProvider: userProvider,
                       closeMoreContainerView: widget.closeMoreContainerView,
                    ),
                  _MoreSettingWidget(),
                  const SizedBox(height: PsDimens.space8),
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.mediumRectangle,
                    // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ],
              ),
            ),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - animation.value), 0.0),
                    child: child),
              );
            },
          );
        }));
  }
}

class _MoreActivityTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.coreBackgroundColor,
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.touch_app, color: PsColors.mainColor),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Text(
            Utils.getString(context, 'more__activity_title'),
            softWrap: false,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: PsColors.mainColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MoreFavouriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.favouriteProductList);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__favourite_title'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__favourite_post'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreTransactionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.transactionList);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'profile__transaction'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__your_transction_history'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreHistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.historyList);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'more__history_title'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__history_browse'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreSettingAndPrivacyTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: PsColors.coreBackgroundColor,
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.settings, color: PsColors.mainColor),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Text(
            Utils.getString(context, 'more__setting_and_privacy_title'),
            softWrap: false,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: PsColors.mainColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MoreSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RoutePaths.setting);
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__toolbar_name'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    Utils.getString(context, 'more__app_setting'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.mainColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreDeactivateAccWidget extends StatelessWidget {
  const _MoreDeactivateAccWidget(
      {required this.userProvider, required this.closeMoreContainerView});

  final UserProvider userProvider;
  final Function closeMoreContainerView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
          return ConfirmDialogView(
                  description: Utils.getString(
                      context, 'profile__deactivate_confirm_text'),
                  leftButtonText: Utils.getString(context, 'dialog__cancel'),
                  rightButtonText: Utils.getString(context, 'dialog__ok'),
                  onAgreeTap: () async {
                    Navigator.of(context).pop();
                    await PsProgressDialog.showDialog(context);
                    final DeleteUserHolder deleteUserHolder = DeleteUserHolder(
                        userId: userProvider.psValueHolder!.loginUserId);
                    final PsResource<ApiStatus> _apiStatus = await userProvider
                        .postDeleteUser(deleteUserHolder.toMap());
                    PsProgressDialog.dismissDialog();
                    if (_apiStatus.data != null) {
                      closeMoreContainerView();
                    } else {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(message: _apiStatus.message);
                          });
                    }
                  });
            });
      },
      child: Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Utils.getString(
                          context, 'more__deactivate_account_title'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      Utils.getString(
                          context, 'more__recover_account_after_deactivate'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
