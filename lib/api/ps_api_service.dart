import 'dart:io';

import 'package:flutterstore/api/ps_url.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/viewobject/about_app.dart';
import 'package:flutterstore/viewobject/api_status.dart';
import 'package:flutterstore/viewobject/blog.dart';
import 'package:flutterstore/viewobject/category.dart';
import 'package:flutterstore/viewobject/comment_detail.dart';
import 'package:flutterstore/viewobject/comment_header.dart';
import 'package:flutterstore/viewobject/coupon_discount.dart';
import 'package:flutterstore/viewobject/default_photo.dart';
import 'package:flutterstore/viewobject/download_product.dart';
import 'package:flutterstore/viewobject/noti.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:flutterstore/viewobject/product_collection_header.dart';
import 'package:flutterstore/viewobject/ps_app_info.dart';
import 'package:flutterstore/viewobject/rating.dart';
import 'package:flutterstore/viewobject/shipping_city.dart';
import 'package:flutterstore/viewobject/shipping_cost.dart';
import 'package:flutterstore/viewobject/shipping_country.dart';
import 'package:flutterstore/viewobject/shipping_method.dart';
import 'package:flutterstore/viewobject/shop_info.dart';
import 'package:flutterstore/viewobject/sub_category.dart';
import 'package:flutterstore/viewobject/transaction_detail.dart';
import 'package:flutterstore/viewobject/transaction_header.dart';
import 'package:flutterstore/viewobject/user.dart';

import '../viewobject/search_result.dart';
import 'common/ps_api.dart';
import 'common/ps_resource.dart';

class PsApiService extends PsApi {
  ///
  /// App Info
  ///
  Future<PsResource<PSAppInfo>> postPsAppInfo(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_app_info_url}';
    return await postData<PSAppInfo, PSAppInfo>(PSAppInfo(), url, jsonMap);
  }

  ///
  /// User Zone ShippingMethod
  ///
  Future<PsResource<ShippingCost>> postZoneShippingMethod(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_zone_shipping_method_url}';
    return await postData<ShippingCost, ShippingCost>(
        ShippingCost(), url, jsonMap);
  }

  ///
  /// User Register
  ///
  Future<PsResource<User>> postUserRegister(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_register_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Verify Email
  ///
  Future<PsResource<User>> postUserEmailVerify(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_email_verify_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Login
  ///
  Future<PsResource<User>> postUserLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// FB Login
  ///
  Future<PsResource<User>> postFBLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_fb_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Google Login
  ///
  Future<PsResource<User>> postGoogleLogin(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_google_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// Apple Login
  ///
  Future<PsResource<User>> postAppleLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_apple_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Forgot Password
  ///
  Future<PsResource<ApiStatus>> postForgotPassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_forgot_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Change Password
  ///
  Future<PsResource<ApiStatus>> postChangePassword(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_change_password_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// User Profile Update
  ///
  Future<PsResource<User>> postProfileUpdate(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_user_update_profile_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Phone Login
  ///
  Future<PsResource<User>> postPhoneLogin(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_phone_login_url}';
    return await postData<User, User>(User(), url, jsonMap);
  }

  ///
  /// User Resend Code
  ///
  Future<PsResource<ApiStatus>> postResendCode(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_resend_code_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// Touch Count
  ///
  Future<PsResource<ApiStatus>> postTouchCount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_post_ps_touch_count_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// About App
  ///
  Future<PsResource<List<AboutApp>>> getAboutAppDataList() async {
    const String url =
        '${PsUrl.ps_about_app_url}/api_key/${PsConfig.ps_api_key}/';
    return await getServerCall<AboutApp, List<AboutApp>>(AboutApp(), url);
  }

  ///
  /// Get User
  ///
  Future<PsResource<List<User>>> getUser(String userId) async {
    final String url =
        '${PsUrl.ps_user_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId';

    return await getServerCall<User, List<User>>(User(), url);
  }

  Future<PsResource<User>> postImageUpload(
      String userId, String platformName, File imageFile) async {
    const String url = '${PsUrl.ps_image_upload_url}';

    return await postUploadImage<User, User>(
        User(), url, userId, platformName, imageFile);
  }

  ///
  /// Get Shipping Method
  ///
  Future<PsResource<List<ShippingMethod>>> getShippingMethod() async {
    const String url =
        '${PsUrl.ps_shipping_method_url}/api_key/${PsConfig.ps_api_key}';

    return await getServerCall<ShippingMethod, List<ShippingMethod>>(
        ShippingMethod(), url);
  }

  ///
  /// Category
  ///
  Future<PsResource<List<Category>>> getCategoryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  Future<PsResource<List<Category>>> getAllCategoryList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url =
        '${PsUrl.ps_category_url}/api_key/${PsConfig.ps_api_key}';

    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  Future<PsResource<List<Category>>> getCategoryListByKey(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${PsUrl.ps_category_search_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';
    return await postData<Category, List<Category>>(Category(), url, jsonMap);
  }

  ///
  /// Sub Category
  ///
  Future<PsResource<List<SubCategory>>> getSubCategoryList(
      int limit, int offset, String categoryId) async {
    final String url =
        '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset/cat_id/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

  Future<PsResource<List<SubCategory>>> getAllSubCategoryList(
      String categoryId) async {
    final String url =
        '${PsUrl.ps_subCategory_url}/api_key/${PsConfig.ps_api_key}/cat_id/$categoryId';

    return await getServerCall<SubCategory, List<SubCategory>>(
        SubCategory(), url);
  }

  Future<PsResource<List<SubCategory>>> getSubCategoryListByKey(
      int limit, int offset, Map<String, dynamic> json) async {
    final String url =
        '${PsUrl.ps_subCategory_search_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';
    return await postData<SubCategory, List<SubCategory>>(
        SubCategory(), url, json);
  }

  //noti
  Future<PsResource<List<Noti>>> getNotificationList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_noti_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Noti, List<Noti>>(Noti(), url, paramMap);
  }

  //
  /// Product
  ///
  Future<PsResource<List<Product>>> getProductList(
      Map<dynamic, dynamic> paramMap, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_product_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<Product, List<Product>>(Product(), url, paramMap);
  }

  Future<PsResource<Product>> getProductDetail(
      String productId, String loginUserId) async {
    final String url =
        '${PsUrl.ps_product_detail_url}/api_key/${PsConfig.ps_api_key}/id/$productId/login_user_id/$loginUserId';
    return await getServerCall<Product, Product>(Product(), url);
  }

  Future<PsResource<List<Product>>> getRelatedProductList(
      String productId, String categoryId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_relatedProduct_url}/api_key/${PsConfig.ps_api_key}/id/$productId/cat_id/$categoryId/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  //
  /// Product Collection
  ///
  Future<PsResource<List<ProductCollectionHeader>>> getProductCollectionList(
      int limit, int offset) async {
    final String url =
        '${PsUrl.ps_collection_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<ProductCollectionHeader,
        List<ProductCollectionHeader>>(ProductCollectionHeader(), url);
  }

  ///Setting
  ///

  Future<PsResource<ShopInfo>> getShopInfo() async {
    const String url =
        '${PsUrl.ps_shop_info_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ShopInfo, ShopInfo>(ShopInfo(), url);
  }

  ///Blog
  ///

  Future<PsResource<List<Blog>>> getBlogList(int limit, int offset) async {
    final String url =
        '${PsUrl.ps_bloglist_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await getServerCall<Blog, List<Blog>>(Blog(), url);
  }

  ///Transaction
  ///

  Future<PsResource<List<TransactionHeader>>> getTransactionList(
      String userId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transactionList_url}/api_key/${PsConfig.ps_api_key}/user_id/$userId/limit/$limit/offset/$offset';

    return await getServerCall<TransactionHeader, List<TransactionHeader>>(
        TransactionHeader(), url);
  }

  Future<PsResource<List<TransactionDetail>>> getTransactionDetail(
      String id, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_transactionDetail_url}/api_key/${PsConfig.ps_api_key}/transactions_header_id/$id/limit/$limit/offset/$offset';
    print(url);
    return await getServerCall<TransactionDetail, List<TransactionDetail>>(
        TransactionDetail(), url);
  }

  Future<PsResource<TransactionHeader>> postTransactionSubmit(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_transaction_submit_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  ///
  /// Comments
  ///
  Future<PsResource<List<CommentHeader>>> getCommentList(
      String productId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_commentList_url}/api_key/${PsConfig.ps_api_key}/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url);
  }

  Future<PsResource<List<CommentDetail>>> getCommentDetail(
      String headerId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_commentDetail_url}/api_key/${PsConfig.ps_api_key}/header_id/$headerId/limit/$limit/offset/$offset';

    return await getServerCall<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url);
  }

  Future<PsResource<CommentHeader>> getCommentHeaderById(
      String commentId) async {
    final String url =
        '${PsUrl.ps_commentList_url}/api_key/${PsConfig.ps_api_key}/id/$commentId';

    return await getServerCall<CommentHeader, CommentHeader>(
        CommentHeader(), url);
  }

  ///
  /// Favourites
  ///
  Future<PsResource<List<Product>>> getFavouritesList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_favouriteList_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Product List By Collection Id
  ///
  Future<PsResource<List<Product>>> getProductListByCollectionId(
      String collectionId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_all_collection_url}/api_key/${PsConfig.ps_api_key}/id/$collectionId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  ///
  /// Best Choice
  ///

  Future<PsResource<List<CommentHeader>>> postCommentHeader(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentHeaderPost_url}';
    return await postData<CommentHeader, List<CommentHeader>>(
        CommentHeader(), url, jsonMap);
  }

  Future<PsResource<List<CommentDetail>>> postCommentDetail(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_commentDetailPost_url}';
    return await postData<CommentDetail, List<CommentDetail>>(
        CommentDetail(), url, jsonMap);
  }

  Future<PsResource<List<DownloadProduct>>> postDownloadProductList(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_downloadProductPost_url}';
    return await postData<DownloadProduct, List<DownloadProduct>>(
        DownloadProduct(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_register_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<ApiStatus>> rawUnRegisterNotiToken(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_unregister_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  Future<PsResource<Noti>> postNoti(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_noti_post_url}';
    return await postData<Noti, Noti>(Noti(), url, jsonMap);
  }

  ///
  /// Rating
  ///
  Future<PsResource<Rating>> postRating(Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_ratingPost_url}';
    return await postData<Rating, Rating>(Rating(), url, jsonMap);
  }

  Future<PsResource<List<Rating>>> getRatingList(
      String productId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_ratingList_url}/api_key/${PsConfig.ps_api_key}/product_id/$productId/limit/$limit/offset/$offset';

    return await getServerCall<Rating, List<Rating>>(Rating(), url);
  }

  ///
  ///Favourite
  ///
  Future<PsResource<List<Product>>> getFavouriteList(
      String loginUserId, int limit, int offset) async {
    final String url =
        '${PsUrl.ps_ratingList_url}/api_key/${PsConfig.ps_api_key}/login_user_id/$loginUserId/limit/$limit/offset/$offset';

    return await getServerCall<Product, List<Product>>(Product(), url);
  }

  Future<PsResource<Product>> postFavourite(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_favouritePost_url}';
    return await postData<Product, Product>(Product(), url, jsonMap);
  }

  ///
  /// Gallery
  ///
  Future<PsResource<List<DefaultPhoto>>> getImageList(
      String parentImgId,
      // String imageType,
      int limit,
      int offset) async {
    final String url =
        '${PsUrl.ps_gallery_url}/api_key/${PsConfig.ps_api_key}/img_parent_id/$parentImgId/limit/$limit/offset/$offset';

    return await getServerCall<DefaultPhoto, List<DefaultPhoto>>(
        DefaultPhoto(), url);
  }

  ///
  /// Contact
  ///
  Future<PsResource<ApiStatus>> postContactUs(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_contact_us_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }

  ///
  /// CouponDiscount
  ///
  Future<PsResource<CouponDiscount>> postCouponDiscount(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_couponDiscount_url}';
    return await postData<CouponDiscount, CouponDiscount>(
        CouponDiscount(), url, jsonMap);
  }

  ///
  /// Token
  ///
  Future<PsResource<ApiStatus>> getToken() async {
    const String url = '${PsUrl.ps_token_url}/api_key/${PsConfig.ps_api_key}';
    return await getServerCall<ApiStatus, ApiStatus>(ApiStatus(), url);
  }

  ///
  /// Shipping Country And City
  ///
  Future<PsResource<List<ShippingCountry>>> getCountryList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${PsUrl.ps_shipping_country_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<ShippingCountry, List<ShippingCountry>>(
        ShippingCountry(), url, jsonMap);
  }

  Future<PsResource<List<ShippingCity>>> getCityList(
      int limit, int offset, Map<dynamic, dynamic> jsonMap) async {
    final String url =
        '${PsUrl.ps_shipping_city_url}/api_key/${PsConfig.ps_api_key}/limit/$limit/offset/$offset';

    return await postData<ShippingCity, List<ShippingCity>>(
        ShippingCity(), url, jsonMap);
  }

   Future<PsResource<SearchResult>> getSearchResult(
      Map<String, dynamic> json) async {
    const String url =
        '${PsUrl.ps_search_result_url}/api_key/${PsConfig.ps_api_key}/limit/4/offset/0/';
    return await postData(SearchResult(), url, json);
  }

  ///
  /// Refund
  ///
  Future<PsResource<TransactionHeader>> postRefund(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_cancel_order_refund_url}';
    return await postData<TransactionHeader, TransactionHeader>(
        TransactionHeader(), url, jsonMap);
  }

  //   Future<PsResource<List<ShippingCountry>>> postShopIdForShippingCountry(
  //     Map<dynamic, dynamic> jsonMap) async {
  //   const String url = '${PsUrl.ps_post_ps_touch_count_url}';
  //    return await postData<ShippingCity, List<ShippingCity>>(ShippingCity(), url, jsonMap);
  // }

  ///
  ///user delete
  ///
  Future<PsResource<ApiStatus>> postDeleteUser(
      Map<dynamic, dynamic> jsonMap) async {
    const String url = '${PsUrl.ps_delete_user_url}';
    return await postData<ApiStatus, ApiStatus>(ApiStatus(), url, jsonMap);
  }
}
