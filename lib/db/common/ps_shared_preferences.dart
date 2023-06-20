import 'dart:async';

import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PsSharedPreferences {
  PsSharedPreferences._() {
    Utils.psPrint('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }

  late Future<SharedPreferences> futureShared;
  late SharedPreferences shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences._();

  // Singleton accessor
  static PsSharedPreferences get instance => _singleton;

  final StreamController<PsValueHolder> _valueController =
      StreamController<PsValueHolder>();
  Stream<PsValueHolder> get psValueHolder => _valueController.stream;

  Future<dynamic> loadValueHolder() async {
    final String? _loginUserId =
        shared.getString(PsConst.VALUE_HOLDER__USER_ID);
    final String? _userIdToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String? _userNameToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String? _userEmailToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String? _userPasswordToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String? _notiToken =
        shared.getString(PsConst.VALUE_HOLDER__NOTI_TOKEN);
    final bool _isToShowIntroSlider =
        shared.getBool(PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final bool? _notiSetting =
        shared.getBool(PsConst.VALUE_HOLDER__NOTI_SETTING);
    final String? _overAllTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL);
    final String? _overAllTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE);
    final String? _shippingTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL);
    final String? _shippingTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE);
    final String? _minimumOrderAmount =
        shared.getString(PsConst.VALUE_HOLDER__MINIMUM_ORDER_AMOUNT);
    final String? _shippingId =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_ID);
    final String? _shopId = shared.getString(PsConst.VALUE_HOLDER__SHOP_ID);
    final String? _messenger =
        shared.getString(PsConst.VALUE_HOLDER__MESSENGER);
    final String? _whatsApp = shared.getString(PsConst.VALUE_HOLDER__WHATSAPP);
    final String? _phone = shared.getString(PsConst.VALUE_HOLDER__PHONE);
    final String? _appInfoVersionNo =
        shared.getString(PsConst.APPINFO_PREF_VERSION_NO);
    final bool? _appInfoForceUpdate =
        shared.getBool(PsConst.APPINFO_PREF_FORCE_UPDATE);
    final String? _appInfoForceUpdateTitle =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_TITLE);
    final String? _appInfoForceUpdateMsg =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_MSG);
    final String? _startDate =
        shared.getString(PsConst.VALUE_HOLDER__START_DATE);
    final bool? _isUserAlradyChoose =
        shared.getBool(PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE);    
    final String? _endDate = shared.getString(PsConst.VALUE_HOLDER__END_DATE);
    // final String? _lat = shared.getString(PsConst.VALUE_HOLDER__LAT);
    // final String? _lng = shared.getString(PsConst.VALUE_HOLDER__LNG);
    final String? _googlePlayStoreUrl =
        shared.getString(PsConst.VALUE_HOLDER__GOOGLE_PLAY_STORE_URL);
    final String? _appleAppStoreUrl =
        shared.getString(PsConst.VALUE_HOLDER__APPLE_APP_STORE_URL);
    final String? _defaultLanguageCode =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_CODE);
    final String? _defaultLanguageCountryCode =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_COUNTRY_CODE);
    final String? _defaultLanguageName =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_NAME);
    final String? _priceFormat =
        shared.getString(PsConst.VALUE_HOLDER__PRICE_FORMAT);
    final String? _dateFormat =
        shared.getString(PsConst.VALUE_HOLDER__DATE_FORMAT);
    final String? _iOSAppStoreId =
        shared.getString(PsConst.VALUE_HOLDER__IOS_APP_STORE_ID);
    final String? _isUseThumbnailAsPlaceholder =
        shared.getString(PsConst.VALUE_HOLDER__IS_USE_THUMBNAIL_AS_PLACEHOLDER);
    final String? _isShowSubCategory =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_SUB_CATEGORY);
    final String? _fbKey =
        shared.getString(PsConst.VALUE_HOLDER__FB_KEY);
    final String? _isShowAdmob =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_ADMOB);
    final String? _defaultLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_LOADING_LIMIT);
    final String? _categoryLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__CATEGORY_LOADING_LIMIT);
    final String? _collectionProductLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__COLLECTION_PRODUCT_LOADING_LIMIT);
    final String? _discountProductLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__DISCOUNT_PRODUCT_LOADING_LIMIT);
    final String? _featureProductLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__FEATURE_PRODUCT_LOADING_LIMIT);
    final String? _latestProductLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__LATEST_PRODUCT_LOADING_LIMIT);
    final String? _trendingProductLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__TRENDING_PRODUCT_LOADING_LIMIT);
    final String? _shopLoadingLimit =
        shared.getString(PsConst.VALUE_HOLDER__SHOP_LOADING_LIMIT);
    final String? _showFacebookLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_FACEBOOK_LOGIN);
    final String? _showGoogleLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_GOOGLE_LOGIN);
    final String? _showPhoneLogin =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_PHONE_LOGIN);
    final String? _showMainMenu =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_MAIN_MENU);
    final String? _showSpecialCollections =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_SPECIAL_COLLECTIONS);
    final String? _showFeaturedItems =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_FEATURED_ITEM);
    final String? _showBestChoiceSlider =
        shared.getString(PsConst.VALUE_HOLDER__SHOW_BEST_CHOICE_SLIDER);
    final String? _isRazorSupportMultiCurrency =
        shared.getString(PsConst.VALUE_HOLDER__IS_RAZOR_SUPPORT_MULTI_CURRENCY);
    final String? _defaultRazorCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_RAZOR_CURRENCY);
    final String? _defaultflutterWaveCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_FLUTTER_WAVE_CURRENCY);
    final String? _paypalEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED);
    final String? _stripeEnabled =
        shared.getString(PsConst.VALUE_HOLDER__STRIPE_ENABLED);
    final String? _payStackEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYSTACK_ENABLED);
    final String? _codEnabled =
        shared.getString(PsConst.VALUE_HOLDER__COD_ENABLED);
    final String? _bankEnabled =
        shared.getString(PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE);
    final String? _publishKey =
        shared.getString(PsConst.VALUE_HOLDER__PUBLISH_KEY);
    final String? _payStackKey =
        shared.getString(PsConst.VALUE_HOLDER__PAYSTACK_KEY);
    final String? _isShowTokenId =
        shared.getString(PsConst.VALUE_HOLDER__IS_SHOW_TOKEN_ID);
    final String? _standardShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE);
    final String? _zoneShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE);
    final String? _noShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final PsValueHolder _valueHolder = PsValueHolder(
        loginUserId: _loginUserId,
        // loginUserName: _loginUserName,
        userIdToVerify: _userIdToVerify,
        userNameToVerify: _userNameToVerify,
        userEmailToVerify: _userEmailToVerify,
        userPasswordToVerify: _userPasswordToVerify,
        deviceToken: _notiToken,
        notiSetting: _notiSetting,
        isToShowIntroSlider: _isToShowIntroSlider,
        overAllTaxLabel: _overAllTaxLabel,
        overAllTaxValue: _overAllTaxValue,
        shippingTaxLabel: _shippingTaxLabel,
        shippingTaxValue: _shippingTaxValue,
        shopId: _shopId,
        messenger: _messenger,
        whatsApp: _whatsApp,
        phone: _phone,
        appInfoVersionNo: _appInfoVersionNo,
        appInfoForceUpdate: _appInfoForceUpdate,
        appInfoForceUpdateTitle: _appInfoForceUpdateTitle,
        appInfoForceUpdateMsg: _appInfoForceUpdateMsg,
        startDate: _startDate,
        endDate: _endDate,
        paypalEnabled: _paypalEnabled,
        stripeEnabled: _stripeEnabled,
        codEnabled: _codEnabled,
        bankEnabled: _bankEnabled,
        publishKey: _publishKey,
        payStackKey: _payStackKey,
        shippingId: _shippingId,
        standardShippingEnable: _standardShippingEnable,
        zoneShippingEnable: _zoneShippingEnable,
        noShippingEnable: _noShippingEnable,
        appleAppStoreUrl: _appleAppStoreUrl,
        categoryLoadingLimit: _categoryLoadingLimit,
        collectionProductLoadingLimit: _collectionProductLoadingLimit,
        dateFormat: _dateFormat,
        defaultFlutterWaveCurrency: _defaultflutterWaveCurrency,
        isRazorSupportMultiCurrency: _isRazorSupportMultiCurrency,
        defaultLanguageCode: _defaultLanguageCode,
        defaultLanguageCountryCode: _defaultLanguageCountryCode,
        defaultLanguageName: _defaultLanguageName,
        defaultLoadingLimit: _defaultLoadingLimit,
        defaultRazorCurrency: _defaultRazorCurrency,
        discountProductLoadingLimit: _discountProductLoadingLimit,
        fbKey: _fbKey,
        featureProductLoadingLimit: _featureProductLoadingLimit,
        googlePlayStoreUrl: _googlePlayStoreUrl,
        iOSAppStoreId: _iOSAppStoreId,
        isShowAdmob: _isShowAdmob,
        isShowSubCategory: _isShowSubCategory,
        isShowTokenId: _isShowTokenId,
        isUserAlreadyChoose: _isUserAlradyChoose,
        isUseThumbnailAsPlaceholder: _isUseThumbnailAsPlaceholder,
        // lat: '',
        latestProductLoadingLimit: _latestProductLoadingLimit,
        // lng: '',
        minimumOrderAmount: _minimumOrderAmount,
        payStackEnabled: _payStackEnabled,
        priceFormat: _priceFormat,
        shopLoadingLimit: _shopLoadingLimit,
        showBestChoiceSlider: _showBestChoiceSlider,
        showFacebookLogin: _showFacebookLogin,
        showFeaturedItems: _showFeaturedItems,
        showGoogleLogin: _showGoogleLogin,
        showMainMenu: _showMainMenu,
        showPhoneLogin: _showPhoneLogin,
        showSpecialCollections: _showSpecialCollections,
        trendingProductLoadingLimit: _trendingProductLoadingLimit);

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_ID, loginUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, doNotShowAgain);

    loadValueHolder();
  }

  Future<dynamic> replaceIsUserAlreadyChoose(bool isUserAlreadyChoose) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE, isUserAlreadyChoose);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared.setString(PsConst.VALUE_HOLDER__START_DATE, startDate);
    await shared.setString(PsConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

   Future<dynamic> replaceMobileSettingData(
    // String lat,
    // String lng,
    String googlePlayStoreUrl, 
    String appleAppStoreUr,
    String defaultLanguageCode,
    String defaultLanguageCountryCode,
    String defaultLanguageName,
    String priceFormat,
    String dateFormat,
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
    // await shared.setString(PsConst.VALUE_HOLDER__LAT, lat);
    // await shared.setString(PsConst.VALUE_HOLDER__LNG, lng);
    await shared.setString(
        PsConst.VALUE_HOLDER__GOOGLE_PLAY_STORE_URL, googlePlayStoreUrl);
    await shared.setString(
        PsConst.VALUE_HOLDER__APPLE_APP_STORE_URL, appleAppStoreUr);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_CODE, defaultLanguageCode);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_COUNTRY_CODE, defaultLanguageCountryCode);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_LANGUAGE_NAME, defaultLanguageName);
     await shared.setString(
        PsConst.VALUE_HOLDER__PRICE_FORMAT, priceFormat);
    await shared.setString(
        PsConst.VALUE_HOLDER__DATE_FORMAT, dateFormat);
    await shared.setString(
        PsConst.VALUE_HOLDER__IOS_APP_STORE_ID, iOSAppStoreId);
    await shared.setString(
        PsConst.VALUE_HOLDER__IS_USE_THUMBNAIL_AS_PLACEHOLDER, isUseThumbnailAsPlaceholder);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_TOKEN_ID, isShowTokenId);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_SUB_CATEGORY, isShowSubCategory);
    await shared.setString(
      PsConst.VALUE_HOLDER__FB_KEY, fbKey);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_SHOW_ADMOB, isShowAdmob);
    await shared.setString(
      PsConst.VALUE_HOLDER__DEFAULT_LOADING_LIMIT, defaultLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__CATEGORY_LOADING_LIMIT, categoryLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__COLLECTION_PRODUCT_LOADING_LIMIT, collectionProductLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__DISCOUNT_PRODUCT_LOADING_LIMIT, discountProductLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__FEATURE_PRODUCT_LOADING_LIMIT, featureProductLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__LATEST_PRODUCT_LOADING_LIMIT, latestProductLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__TRENDING_PRODUCT_LOADING_LIMIT, trendingProductLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOP_LOADING_LIMIT, shopLoadingLimit);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_FACEBOOK_LOGIN, showFacebookLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_GOOGLE_LOGIN, showGoogleLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_PHONE_LOGIN, showPhoneLogin);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_MAIN_MENU, showMainMenu);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_SPECIAL_COLLECTIONS, showSpecialCollections);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_FEATURED_ITEM, showFeaturedItems);
    await shared.setString(
      PsConst.VALUE_HOLDER__SHOW_BEST_CHOICE_SLIDER, showBestChoiceSlider);
    await shared.setString(
      PsConst.VALUE_HOLDER__IS_RAZOR_SUPPORT_MULTI_CURRENCY, isRazorSupportMultiCurrency);
    await shared.setString(
      PsConst.VALUE_HOLDER__DEFAULT_RAZOR_CURRENCY, defaultRazorCurrency);
    await shared.setString(
      PsConst.VALUE_HOLDER__DEFAULT_FLUTTER_WAVE_CURRENCY, defaultFlutterWaveCurrency);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared.setString(PsConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsapp,
    String phone,
  ) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL, overAllTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE, overAllTaxValue);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL, shippingTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE, shippingTaxValue);
    await shared.setString(PsConst.VALUE_HOLDER__SHIPPING_ID, shippingId);
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(PsConst.VALUE_HOLDER__MESSENGER, messenger);
    await shared.setString(PsConst.VALUE_HOLDER__WHATSAPP, whatsapp);
    await shared.setString(PsConst.VALUE_HOLDER__PHONE, phone);

    loadValueHolder();
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED, paypalEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__STRIPE_ENABLED, stripeEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__COD_ENABLED, codEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE, bankEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE, standardShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE, zoneShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE, noShippingEnable);

    loadValueHolder();
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }

  Future<dynamic> replacePayStackKey(String payStackKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYSTACK_KEY, payStackKey);

    loadValueHolder();
  }
}
