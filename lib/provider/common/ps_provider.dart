import 'package:flutter/foundation.dart';
import 'package:flutterstore/repository/Common/ps_repository.dart';

import '../../constant/ps_constants.dart';

class PsProvider extends ChangeNotifier {
  PsProvider(this.psRepository, int limit) {
    if (limit != 0) {
      this.limit = limit;
    }
  }

  bool isConnectedToInternet = false;
  bool isLoading = false;
  PsRepository psRepository;

  int offset = 0;
  int limit = PsConst.DEFAULT_LOADING_LIMIT;
  int _cacheDataLength = 0;
  int maxDataLoadingCount = 0;
  int maxDataLoadingCountLimit = 4;
  bool isReachMaxData = false;
  bool isDispose = false;

  void updateOffset(int dataLength) {
    if (offset == 0) {
      isReachMaxData = false;
      maxDataLoadingCount = 0;
    }
    if (dataLength == _cacheDataLength) {
      maxDataLoadingCount++;
      if (maxDataLoadingCount == maxDataLoadingCountLimit) {
        isReachMaxData = true;
      }
    } else {
      maxDataLoadingCount = 0;
    }

    offset = dataLength;
    _cacheDataLength = dataLength;
  }

  Future<void> loadValueHolder() async {
   await psRepository.loadValueHolder();
  }

  Future<void> replaceLoginUserId(String loginUserId) async {
   await psRepository.replaceLoginUserId(loginUserId);
  }

  Future<void> replaceLoginUserName(String loginUserName) async {
   await psRepository.replaceLoginUserName(loginUserName);
  }

  Future<void> replaceNotiToken(String notiToken) async {
   await psRepository.replaceNotiToken(notiToken);
  }

  Future<void> replaceNotiSetting(bool notiSetting) async {
   await psRepository.replaceNotiSetting(notiSetting);
  }

  Future<void> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
   await psRepository.replaceIsToShowIntroSlider(doNotShowAgain);
  }

  Future<void> replaceIsUserAlreadyChoose(bool isUserAlreadyChoose) async {
    await psRepository.replaceIsUserAlreadyChoose(isUserAlreadyChoose);
  }

  Future<void> replaceDate(String startDate, String endDate) async {
  await  psRepository.replaceDate(startDate, endDate);
  }

  Future<void> replaceMobileSettingData(
    // String lat,
    // String lng,
    String googlePlayStoreUrl, 
    String appleAppStoreUrl,
    String defaultLanguageCode,
    String defaultLanguageCountryCode,
    String defaultLanguageName,
    String priceForamat,
    String dataForamat,
    String iOSAppStoreId,
    String isUseThumbnailAsPlaceholder,
    String isShowTokenId,
    String isShowSubCategory,
    String fbKey,
    String isShowAdmob,
    String defaultLoadingLimit,
    String categoryLoadingLimit,
    String collectionProductLoadingLimit,
    String discountProductLoadingLimit,
    String featureProductLoadingLimit,
    String latestProductLoadingLimit,
    String trendingProductLoadingLimit,
    String shopLoadingLimit,
    String showFacebookLogin,
    String showGoogleLogin,
    String showPhoneLogin,
    String showMainMenu,
    String showSpecialCollections,
    String showFeaturedItems,
    String showBestChoiceSlider,
    String isRazorSupportMultiCurrency,
    String defaultRazorCurrency,
    String defaultFlutterWaveCurrency
    ) async {
    await psRepository.replaceMobileSettingData(
      // lat,
      // lng,
      googlePlayStoreUrl, 
      appleAppStoreUrl,
      defaultLanguageCode,
      defaultLanguageCountryCode,
      defaultLanguageName,
      priceForamat,
      dataForamat,
      iOSAppStoreId,
      isUseThumbnailAsPlaceholder,
      isShowTokenId,
      isShowSubCategory,
      fbKey,
      isShowAdmob,
      defaultLoadingLimit,
      categoryLoadingLimit,
      collectionProductLoadingLimit,
      discountProductLoadingLimit,
      featureProductLoadingLimit,
      latestProductLoadingLimit,
      trendingProductLoadingLimit,
      shopLoadingLimit,
      showFacebookLogin,
      showGoogleLogin,
      showPhoneLogin,
      showMainMenu,
      showSpecialCollections,
      showFeaturedItems,
      showBestChoiceSlider,
      isRazorSupportMultiCurrency,
      defaultRazorCurrency,
      defaultFlutterWaveCurrency
    );
  }


  Future<void> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
   await psRepository.replaceVerifyUserData(userIdToVerify, userNameToVerify,
        userEmailToVerify, userPasswordToVerify);
  }

  Future<void> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
   await psRepository.replaceVersionForceUpdateData(appInfoForceUpdate);
  }

  Future<void> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
   await psRepository.replaceAppInfoData(appInfoVersionNo, appInfoForceUpdate,
        appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<void> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) async {
   await psRepository.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  Future<void> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
   await psRepository.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<void> replacePublishKey(String pubKey) async {
   await psRepository.replacePublishKey(pubKey);
  }

  Future<void> replacePayStackKey(String payStackKey) async {
   await psRepository.replacePayStackKey(payStackKey);
  }
}
