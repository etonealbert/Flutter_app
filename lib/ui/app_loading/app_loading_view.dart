import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/app_info/app_info_provider.dart';
import 'package:flutterstore/provider/clear_all/clear_all_data_provider.dart';
import 'package:flutterstore/provider/language/language_provider.dart';
import 'package:flutterstore/repository/app_info_repository.dart';
import 'package:flutterstore/repository/clear_all_data_repository.dart';
import 'package:flutterstore/ui/common/dialog/version_update_dialog.dart';
import 'package:flutterstore/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/app_info_parameter_holder.dart';
import 'package:flutterstore/viewobject/ps_app_info.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../repository/language_repository.dart';
import '../../viewobject/common/language.dart';

class AppLoadingView extends StatelessWidget {
  Future<dynamic> loadDeleteHistory(AppInfoProvider provider,LanguageProvider languageProvider,
      ClearAllDataProvider clearAllDataProvider, BuildContext context) async {
    String realStartDate = '0';
    String realEndDate = '0';
    AppInfoParameterHolder appInfoParameterHolder;
    if (await Utils.checkInternetConnectivity()) {
      if (provider.psValueHolder == null ||
          provider.psValueHolder!.startDate == null) {
        realStartDate =
            DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
      } else {
        realStartDate = provider.psValueHolder!.endDate!;
      }

      appInfoParameterHolder = AppInfoParameterHolder(
          startDate: realStartDate,
          endDate: realEndDate,
          userId: Utils.checkUserLoginId(provider.psValueHolder!));

      realEndDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());

      final PsResource<PSAppInfo> _psAppInfo =
          await provider.loadDeleteHistory(appInfoParameterHolder.toMap());

      if (_psAppInfo.status == PsStatus.SUCCESS) {
        await provider.replaceDate(realStartDate, realEndDate);

        if (_psAppInfo.data!.mobileSetting != null) {
          await provider.replaceMobileSettingData(
              // _psAppInfo.data!.mobileSetting!.lat!,
              // _psAppInfo.data!.mobileSetting!.lng!,
              _psAppInfo.data!.mobileSetting!.googlePlayStoreUrl ?? '', 
              _psAppInfo.data!.mobileSetting!.appleAppStoreUrl?? '',
              _psAppInfo.data!.mobileSetting!.defaultLanguage!.languageCode?? '',
              _psAppInfo.data!.mobileSetting!.defaultLanguage!.countryCode?? '',
              _psAppInfo.data!.mobileSetting!.defaultLanguage!.name ?? '',
              _psAppInfo.data!.mobileSetting!.priceFormat ?? '',
              _psAppInfo.data!.mobileSetting!.dateFormat ?? '',
              _psAppInfo.data!.mobileSetting!.iosAppStoreId ?? '',
              _psAppInfo.data!.mobileSetting!.isUseThumbnailAsPlaceholder ?? '',
              _psAppInfo.data!.mobileSetting!.isShowTokenId ?? '',
              _psAppInfo.data!.mobileSetting!.isShowSubCategory ?? '',
              _psAppInfo.data!.mobileSetting!.fbKey ?? '',
              _psAppInfo.data!.mobileSetting!.isShowAdmob ?? '',
              _psAppInfo.data!.mobileSetting!.defaultLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.categoryLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.collectionProductLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.discountProductLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.featureProductLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.latestProductLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.trendingProductLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.shopLoadingLimit ?? '',
              _psAppInfo.data!.mobileSetting!.showFacebookLogin ?? '',
              _psAppInfo.data!.mobileSetting!.showGoogleLogin ?? '',
              _psAppInfo.data!.mobileSetting!.showPhoneLogin ?? '',
              _psAppInfo.data!.mobileSetting!.showMainMenu ?? '',
              _psAppInfo.data!.mobileSetting!.showSpecialCollections ?? '',
              _psAppInfo.data!.mobileSetting!.showFeaturedItems ?? '',
              _psAppInfo.data!.mobileSetting!.showBestChoiceSlider ?? '',
              _psAppInfo.data!.mobileSetting!.isRazorSupportMultiCurrency ?? '',
              _psAppInfo.data!.mobileSetting!.defaultRazorCurrency ?? '',
              _psAppInfo.data!.mobileSetting!.defaultFlutterWaveCurrency ?? '',
              );

          final Language languageFromApi = _psAppInfo.data!.mobileSetting!.defaultLanguage!;
          languageProvider.saveApiDefaultLanguage(languageFromApi);
          if(provider.psValueHolder!.isUserAlreadyChoose != true) { 
          if (!languageProvider.isUserChangesLocalLanguage() && 
                _psAppInfo.data!.mobileSetting!.defaultLanguage != null) {
            await languageProvider.addLanguage(languageFromApi);
            EasyLocalization.of(context)?.setLocale(Locale(languageFromApi.languageCode!, languageFromApi.countryCode));
          }
         } 
         if (_psAppInfo.data!.mobileSetting!.excludedLanguages != null) {
            await languageProvider.replaceExcludedLanguages(
              _psAppInfo.data!.mobileSetting!.excludedLanguages!
            );
          }
        }

        print(Utils.getString(context, 'app_info__cancel_button_name'));
        print(Utils.getString(context, 'app_info__update_button_name'));

        if (_psAppInfo.data!.userInfo!.userStatus == PsConst.USER_BANNED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__banned'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (_psAppInfo.data!.userInfo!.userStatus ==
            PsConst.USER_DELECTED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__deleted'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else if (_psAppInfo.data!.userInfo!.userStatus ==
            PsConst.USER_UN_PUBLISHED) {
          callLogout(
              provider,
              // deleteTaskProvider,
              PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
              context);
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return WarningDialog(
                  message: Utils.getString(context, 'user_status__unpublished'),
                  onPressed: () {
                    checkVersionNumber(context, _psAppInfo.data!, provider,
                        clearAllDataProvider);
                    realStartDate = realEndDate;
                  },
                );
              });
        } else {
          checkVersionNumber(
              context, _psAppInfo.data!, provider, clearAllDataProvider);
          realStartDate = realEndDate;
        }
      } else if (_psAppInfo.status == PsStatus.ERROR) {
        final PsValueHolder valueHolder =
            Provider.of<PsValueHolder>(context, listen: false);

        if (valueHolder.isToShowIntroSlider == true) {
          Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
              arguments: 0);
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.home,
          );
        }
      }
    } else {
      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);

      if (valueHolder.isToShowIntroSlider == true) {
        Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: 0);
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    }
  }

  dynamic callLogout(
      AppInfoProvider appInfoProvider, int index, BuildContext context) async {
    // updateSelectedIndex( index);
    await appInfoProvider.replaceLoginUserId('');
    await appInfoProvider.replaceLoginUserName('');
    // await deleteTaskProvider.deleteTask();
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/fs_android_3x.png',
    ),
  );

  dynamic checkVersionNumber(
      BuildContext context,
      PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider,
      ClearAllDataProvider clearAllDataProvider) async {
    if (PsConfig.app_version != psAppInfo.psAppVersion!.versionNo) {
      if (psAppInfo.psAppVersion!.versionNeedClearData == PsConst.ONE) {
        await clearAllDataProvider.clearAllData();
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      } else {
        checkForceUpdate(context, psAppInfo, appInfoProvider);
      }
    } else {
      await appInfoProvider.replaceVersionForceUpdateData(false);

      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);

      if (valueHolder.isToShowIntroSlider == true) {
        Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: 0);
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    }
  }

  dynamic checkForceUpdate(BuildContext context, PSAppInfo psAppInfo,
      AppInfoProvider appInfoProvider) async {
    if (psAppInfo.psAppVersion!.versionForceUpdate == PsConst.ONE) {
      await appInfoProvider.replaceAppInfoData(
          psAppInfo.psAppVersion!.versionNo!,
          true,
          psAppInfo.psAppVersion!.versionTitle!,
          psAppInfo.psAppVersion!.versionMessage!);

      Navigator.pushReplacementNamed(
        context,
        RoutePaths.force_update,
        arguments: psAppInfo.psAppVersion,
      );
    } else if (psAppInfo.psAppVersion!.versionForceUpdate == PsConst.ZERO) {
      await appInfoProvider.replaceVersionForceUpdateData(false);
      callVersionUpdateDialog(context, psAppInfo);
    } else {
      final PsValueHolder valueHolder =
          Provider.of<PsValueHolder>(context, listen: false);

      if (valueHolder.isToShowIntroSlider == true) {
        Navigator.pushReplacementNamed(context, RoutePaths.introSlider,
            arguments: 0);
      } else {
        Navigator.pushReplacementNamed(
          context,
          RoutePaths.home,
        );
      }
    }
  }

  dynamic callVersionUpdateDialog(BuildContext context, PSAppInfo psAppInfo) {
    showDialog<dynamic>(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (BuildContext context) {
          return 
               VersionUpdateDialog(
                title: psAppInfo.psAppVersion!.versionTitle!,
                description: psAppInfo.psAppVersion!.versionMessage!,
                leftButtonText:
                    Utils.getString(context, 'app_info__cancel_button_name'),
                rightButtonText:
                    Utils.getString(context, 'app_info__update_button_name'),
                onCancelTap: () {
                  final PsValueHolder valueHolder =
                      Provider.of<PsValueHolder>(context, listen: false);

                  if (valueHolder.isToShowIntroSlider == true) {
                    Navigator.pushReplacementNamed(
                        context, RoutePaths.introSlider,
                        arguments: 0);
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  }
                },
                onUpdateTap: () async {
                  final PsValueHolder valueHolder =
                      Provider.of<PsValueHolder>(context, listen: false);

                  if (valueHolder.isToShowIntroSlider == true) {
                    Navigator.pushReplacementNamed(
                        context, RoutePaths.introSlider,
                        arguments: 0);
                  } else {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutePaths.home,
                    );
                  }

                  if (Platform.isIOS) {
                    Utils.launchAppStoreURL(iOSAppId: valueHolder.iOSAppStoreId);
                  } else if (Platform.isAndroid) {
                    Utils.launchURL();
                  }
                },
              );
        });
  }

  @override
  Widget build(BuildContext context) {
    AppInfoRepository repo1;
    AppInfoProvider? provider;
    LanguageProvider? languageProvider;
    LanguageRepository? languageRepository;
    ClearAllDataRepository clearAllDataRepository;
    ClearAllDataProvider? clearAllDataProvider;
    PsValueHolder? valueHolder;

    PsColors.loadColor(context);

    repo1 = Provider.of<AppInfoRepository>(context);
    clearAllDataRepository = Provider.of<ClearAllDataRepository>(context);
    languageRepository = Provider.of<LanguageRepository>(context);
    valueHolder = Provider.of<PsValueHolder?>(context);

    if (valueHolder == null) {
      return Container();
    }
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    return
        // EasyLocalizationProvider(
        //   data: data,
        //   child:
        MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ClearAllDataProvider>(
            lazy: false,
            create: (BuildContext context) {
              clearAllDataProvider = ClearAllDataProvider(
                  repo: clearAllDataRepository, psValueHolder: valueHolder);

              return clearAllDataProvider!;
            }),
         ChangeNotifierProvider<LanguageProvider>(
            lazy: false,
            create: (BuildContext context) {
              languageProvider = LanguageProvider(
                  repo: languageRepository!,);
              // languageProvider.getLanguageList();
              return languageProvider!;
            }),
        ChangeNotifierProvider<AppInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              provider =
                  AppInfoProvider(repo: repo1, psValueHolder: valueHolder);
              loadDeleteHistory(provider!,languageProvider!, clearAllDataProvider!, context);
              return provider!;
            }),
      ],
      child: Consumer<AppInfoProvider>(
        builder: (BuildContext context, AppInfoProvider clearAllDataProvider,
            Widget? child) {
          return Consumer<AppInfoProvider>(builder: (BuildContext context,
              AppInfoProvider clearAllDataProvider, Widget? child) {
            return Container(
                height: 400,
                color: PsColors.mainColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _imageWidget,
                        const SizedBox(
                          height: PsDimens.space16,
                        ),
                        Text(
                          Utils.getString(context, 'app_name'),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: PsColors.white),
                        ),
                        const SizedBox(
                          height: PsDimens.space8,
                        ),
                        Text(
                          Utils.getString(context, 'app_info__splash_name'),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: PsColors.white),
                        ),
                        Container(
                          padding: const EdgeInsets.all(PsDimens.space16),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: PsButtonWidget(
                              provider: provider,
                              text: Utils.getString(
                                  context, 'app_info__submit_button_name'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
          });
        },
      ),
      // ),
    );
  }
}

class PsButtonWidget extends StatefulWidget {
  const PsButtonWidget({
    required this.provider,
    required this.text,
  });
  final AppInfoProvider? provider;
  final String text;

  @override
  _PsButtonWidgetState createState() => _PsButtonWidgetState();
}

class _PsButtonWidgetState extends State<PsButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(PsColors.loadingCircleColor),
        strokeWidth: 5.0);
  }
}
