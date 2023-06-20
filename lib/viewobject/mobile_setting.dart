import 'package:flutterstore/viewobject/common/language.dart';

import 'common/ps_object.dart';

class MobileSetting extends PsObject<MobileSetting> {
  MobileSetting(
      {
      //   this.lat,
      // this.lng,
      this.googlePlayStoreUrl,
      this.appleAppStoreUrl,
      this.priceFormat,
      this.dateFormat,
      this.iosAppStoreId,
      this.isUseThumbnailAsPlaceholder,
      this.isShowTokenId,
      this.isShowSubCategory,
      this.fbKey,
      this.isShowAdmob,
      this.defaultLoadingLimit,
      this.categoryLoadingLimit,
      this.collectionProductLoadingLimit,
      this.discountProductLoadingLimit,
      this.featureProductLoadingLimit,
      this.latestProductLoadingLimit,
      this.trendingProductLoadingLimit,
      this.shopLoadingLimit,
      this.showFacebookLogin,
      this.showGoogleLogin,
      this.showPhoneLogin,
      this.showMainMenu,
      this.showSpecialCollections,
      this.showFeaturedItems,
      this.showBestChoiceSlider,
      this.isRazorSupportMultiCurrency,
      this.defaultRazorCurrency,
      this.defaultFlutterWaveCurrency,
      this.defaultLanguage,
      this.excludedLanguages
      });
  // String? lat;
  // String? lng;
  String? googlePlayStoreUrl;
  String? appleAppStoreUrl;
  String? priceFormat;
  String? dateFormat;
  String? iosAppStoreId;
  String? isUseThumbnailAsPlaceholder;
  String? isShowTokenId;
  String? isShowSubCategory;
  String? fbKey;
  String? isShowAdmob;
  String? defaultLoadingLimit;
  String? categoryLoadingLimit;
  String? collectionProductLoadingLimit;
  String? discountProductLoadingLimit;
  String? featureProductLoadingLimit;
  String? latestProductLoadingLimit;
  String? trendingProductLoadingLimit;
  String? shopLoadingLimit;
  String? showFacebookLogin;
  String? showGoogleLogin;
  String? showPhoneLogin;
  String? showMainMenu;
  String? showSpecialCollections;
  String? showFeaturedItems;
  String? showBestChoiceSlider;
  String? isRazorSupportMultiCurrency;
  String? defaultRazorCurrency;
  String? defaultFlutterWaveCurrency;
  Language? defaultLanguage;
  List<Language?>? excludedLanguages;


  @override
  String getPrimaryKey() {
    return '';
  }

  @override
  MobileSetting fromMap(dynamic dynamicData) {
    // if (dynamicData != null) {
      return MobileSetting(
          // lat: dynamicData['lat'],
          // lng: dynamicData['lng'],
          googlePlayStoreUrl: dynamicData['google_playstore_url'],
          appleAppStoreUrl: dynamicData['apple_appstore_url'],
          priceFormat: dynamicData['price_format'],
          dateFormat: dynamicData['date_format'],
          iosAppStoreId: dynamicData['ios_appstore_id'],
          isUseThumbnailAsPlaceholder: dynamicData['is_use_thumbnail_as_placeholder'],
          isShowTokenId: dynamicData['is_show_token_id'],
          isShowSubCategory: dynamicData['is_show_subcategory'],
          fbKey: dynamicData['fb_key'],
          isShowAdmob: dynamicData['is_show_admob'],
          defaultLoadingLimit: dynamicData['default_loading_limit'],
          categoryLoadingLimit: dynamicData['category_loading_limit'],
          collectionProductLoadingLimit: dynamicData['collection_product_loading_limit'],
          discountProductLoadingLimit: dynamicData['discount_product_loading_limit'],
          featureProductLoadingLimit: dynamicData['feature_product_loading_limit'],
          latestProductLoadingLimit: dynamicData['latest_product_loading_limit'],
          trendingProductLoadingLimit: dynamicData['trending_product_loading_limit'],
          shopLoadingLimit: dynamicData['shop_loading_limit'],
          showFacebookLogin: dynamicData['show_facebook_login'],
          showGoogleLogin: dynamicData['show_google_login'],
          showPhoneLogin: dynamicData['show_phone_login'],
          showMainMenu: dynamicData['show_main_menu'],
          showSpecialCollections: dynamicData['show_special_collections'],
          showFeaturedItems: dynamicData['show_featured_items'],
          showBestChoiceSlider: dynamicData['show_best_choice_slider'],
          isRazorSupportMultiCurrency: dynamicData['is_razor_support_multi_currency'],
          defaultRazorCurrency: dynamicData['default_razor_currency'],
          defaultFlutterWaveCurrency: dynamicData['default_flutter_wave_currency'],
          defaultLanguage: Language().fromMap(dynamicData['default_language']),
          excludedLanguages: Language().fromMapList(dynamicData['exclude_language']));

    // } else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      // data['lat'] = object.lat;
      // data['lng'] = object.lng;
      data['google_playstore_url'] = object.googlePlayStoreUrl;
      data['apple_appstore_url'] = object.appleAppStoreUrl;
      data['price_format'] = object.priceFormat;
      data['date_format'] = object.dateFormat;
      data['ios_appstore_id'] = object.iosAppStoreId;
      data['is_use_thumbnail_as_placeholder'] = object.isUseThumbnailAsPlaceholder;
      data['is_show_token_id'] = object.isShowTokenId;
      data['is_show_subcategory'] = object.isShowSubCategory;
      data['fb_key'] = object.fbKey;
      data['is_show_admob'] = object.isShowAdmob;
      data['default_loading_limit'] = object.defaultLoadingLimit;
      data['category_loading_limit'] = object.categoryLoadingLimit;
      data['collection_product_loading_limit'] = object.collectionProductLoadingLimit;
      data['discount_product_loading_limit'] = object.discountProductLoadingLimit;
      data['feature_product_loading_limit'] = object.featureProductLoadingLimit;
      data['latest_product_loading_limit'] = object.latestProductLoadingLimit;
      data['trending_product_loading_limit'] = object.trendingProductLoadingLimit;
      data['shop_loading_limit'] = object.shopLoadingLimit;
      data['show_facebook_login'] = object.showFacebookLogin;
      data['show_google_login'] = object.showGoogleLogin;
      data['show_phone_login'] = object.showPhoneLogin;
      data['show_main_menu'] = object.showMainMenu;
      data['show_special_collections'] = object.showSpecialCollections;
      data['show_featured_items'] = object.showFeaturedItems;
      data['show_best_choice_slider'] = object.showBestChoiceSlider;
      data['is_razor_support_multi_currency'] = object.isRazorSupportMultiCurrency;
      data['default_razor_currency'] = object.defaultRazorCurrency;
      data['default_flutter_wave_currency'] = object.defaultFlutterWaveCurrency;
      data['default_language'] = Language().toMap(object.defaultLanguage);
      data['exclude_language'] = Language().toMapList(object.excludedLanguages);

      return data;
    } else {
      return null;
    }
  }

  @override
  List<MobileSetting> fromMapList(List<dynamic>? dynamicDataList) {
    final List<MobileSetting> psAppVersionList = <MobileSetting>[];

    if (dynamicDataList != null) {
      for (dynamic json in dynamicDataList) {
        if (json != null) {
          psAppVersionList.add(fromMap(json));
        }
      }
    }
    return psAppVersionList;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<MobileSetting>? objectList) {
    final List<Map<String, dynamic>> mapList = <Map<String, dynamic>>[];
    if (objectList != null) {
      for (MobileSetting? data in objectList) {
        if (data != null) {
          mapList.add(toMap(data)!);
        }
      }
    }

    return mapList;
  }
}
