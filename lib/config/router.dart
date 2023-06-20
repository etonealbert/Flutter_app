import 'package:flutter/material.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/ui/app_info/app_info_view.dart';
import 'package:flutterstore/ui/app_loading/app_loading_view.dart';
import 'package:flutterstore/ui/basket/list/basket_list_container.dart';
import 'package:flutterstore/ui/best_choice/best_choice_list_by_collection_id_view.dart';
import 'package:flutterstore/ui/blog/detail/blog_view.dart';
import 'package:flutterstore/ui/blog/list/blog_list_container.dart';
import 'package:flutterstore/ui/category/filter_list/category_filter_list_view.dart';
import 'package:flutterstore/ui/category/list/category_list_view_container.dart';
import 'package:flutterstore/ui/category/trending_list/trending_category_list_view.dart';
import 'package:flutterstore/ui/checkout/checkout_container_view.dart';
import 'package:flutterstore/ui/checkout/checkout_status_view.dart';
import 'package:flutterstore/ui/checkout/credit_card_view.dart';
import 'package:flutterstore/ui/checkout/one_page_checkout/billing_address_view.dart';
import 'package:flutterstore/ui/checkout/one_page_checkout/shipping_address_view.dart';
import 'package:flutterstore/ui/checkout/paystack_view.dart';
import 'package:flutterstore/ui/collection/header_list/collection_header_list_container.dart';
import 'package:flutterstore/ui/comment/detail/comment_detail_list_view.dart';
import 'package:flutterstore/ui/comment/list/comment_list_view.dart';
import 'package:flutterstore/ui/contact/contact_us_container_view.dart';
import 'package:flutterstore/ui/dashboard/core/dashboard_view.dart';
import 'package:flutterstore/ui/force_update/force_update_view.dart';
import 'package:flutterstore/ui/gallery/detail/gallery_view.dart';
import 'package:flutterstore/ui/gallery/grid/gallery_grid_view.dart';
import 'package:flutterstore/ui/history/list/history_list_container.dart';
import 'package:flutterstore/ui/introslider/intro_slider_view.dart';
import 'package:flutterstore/ui/language/list/language_list_view.dart';
import 'package:flutterstore/ui/noti/detail/noti_view.dart';
import 'package:flutterstore/ui/noti/list/noti_list_view.dart';
import 'package:flutterstore/ui/noti/notification_setting/notification_setting_view.dart';
import 'package:flutterstore/ui/privacy_policy/privacy_policy_container_view.dart';
import 'package:flutterstore/ui/product/attribute_detail/attribute_detail_list_view.dart';
import 'package:flutterstore/ui/product/collection_product/product_list_by_collection_id_view.dart';
import 'package:flutterstore/ui/product/detail/product_detail_view.dart';
import 'package:flutterstore/ui/product/favourite/favourite_product_list_container.dart';
import 'package:flutterstore/ui/product/list_with_filter/filter/category/filter_list_view.dart';
import 'package:flutterstore/ui/product/list_with_filter/filter/filter/item_search_view.dart';
import 'package:flutterstore/ui/product/list_with_filter/filter/sort/item_sorting_view.dart';
import 'package:flutterstore/ui/product/list_with_filter/product_list_with_filter_container.dart';
import 'package:flutterstore/ui/rating/list/rating_list_view.dart';
import 'package:flutterstore/ui/search_history/search_history_list_view.dart';
import 'package:flutterstore/ui/search_item/search_item_list_view.dart';
import 'package:flutterstore/ui/setting/setting_container_view.dart';
import 'package:flutterstore/ui/subcategory/filter/sub_category_search_list_view.dart';
import 'package:flutterstore/ui/subcategory/list/sub_category_grid_view.dart';
import 'package:flutterstore/ui/terms_and_refund/terms_and_refund_container_view.dart';
import 'package:flutterstore/ui/transaction/detail/transaction_item_list_view.dart';
import 'package:flutterstore/ui/transaction/list/transaction_list_container.dart';
import 'package:flutterstore/ui/user/edit_profile/city_list_view.dart';
import 'package:flutterstore/ui/user/edit_profile/country_list_view.dart';
import 'package:flutterstore/ui/user/edit_profile/edit_profile_view.dart';
import 'package:flutterstore/ui/user/forgot_password/forgot_password_container_view.dart';
import 'package:flutterstore/ui/user/login/login_container_view.dart';
import 'package:flutterstore/ui/user/more/more_container_view.dart';
import 'package:flutterstore/ui/user/password_update/change_password_view.dart';
import 'package:flutterstore/ui/user/phone/sign_in/phone_sign_in_container_view.dart';
import 'package:flutterstore/ui/user/phone/verify_phone/verify_phone_container_view.dart';
import 'package:flutterstore/ui/user/register/register_container_view.dart';
import 'package:flutterstore/ui/user/verify/verify_email_container_view.dart';
import 'package:flutterstore/viewobject/blog.dart';
import 'package:flutterstore/viewobject/category.dart';
import 'package:flutterstore/viewobject/comment_header.dart';
import 'package:flutterstore/viewobject/default_photo.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/address_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/attribute_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/checkout_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/checkout_status_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/credit_card_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/privacy_policy_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/noti.dart';
import 'package:flutterstore/viewobject/product.dart';
import 'package:flutterstore/viewobject/ps_app_version.dart';
import 'package:flutterstore/viewobject/transaction_header.dart';

import '../ui/checkout/one_page_checkout/billing_to_view.dart';
import '../ui/checkout/one_page_checkout/one_page_checkout_container_view.dart';
import '../ui/checkout/one_page_checkout/payment_method_view.dart';
import '../ui/checkout/whatsapp_checkout /whatsapp_checkout_container_view.dart';
import '../ui/search/search_category_view_all/search_category_view_all_container.dart';
import '../ui/search/search_item_view_all/search_item_view_all_container.dart';
import '../ui/search/search_sub_category_view_all/search_sub_category_view_all_container.dart';
import '../viewobject/holder/intent_holder/billing_to_intent_holder.dart';
import '../viewobject/holder/intent_holder/payment_intent_holder.dart';
import '../viewobject/holder/intent_holder/whatsapp_checkout_intent_holder.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());

    case '${RoutePaths.home}':
      // return PageRouteBuilder<dynamic>(
      //     pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
      //         DashboardView());

      return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: RoutePaths.home),
          builder: (BuildContext context) {
            return DashboardView();
          });

    case '${RoutePaths.force_update}':
      final Object? args = settings.arguments;
      final PSAppVersion psAppVersion = args as PSAppVersion;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForceUpdateView(psAppVersion: psAppVersion));

    case '${RoutePaths.user_register_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RegisterContainerView());
    case '${RoutePaths.login_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LoginContainerView());
    case '${RoutePaths.appinfo}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => AppInfoView());
    case '${RoutePaths.subCategoryGrid}':
      return MaterialPageRoute<Category>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final Category category = args as Category;
        return SubCategoryGridView(category: category);
      });

    case '${RoutePaths.user_verify_email_container}':
      final Object? args = settings.arguments;
      final String userId = args as String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyEmailContainerView(userId: userId));

    case '${RoutePaths.user_forgot_password_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ForgotPasswordContainerView());

    case '${RoutePaths.setting}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SettingContainerView());

    case '${RoutePaths.more}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final String userName = args as String;
        return MoreContainerView(userName: userName);
      });

    case '${RoutePaths.introSlider}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object? args = settings.arguments;
        final int settingSlider = args as int;
        return IntroSliderView(settingSlider: settingSlider);
      });

    case '${RoutePaths.user_phone_signin_container}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PhoneSignInContainerView());

    case '${RoutePaths.user_phone_verify_container}':
      final Object? args = settings.arguments;

      final VerifyPhoneIntentHolder verifyPhoneIntentParameterHolder =
          args as VerifyPhoneIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              VerifyPhoneContainerView(
                userName: verifyPhoneIntentParameterHolder.userName,
                phoneNumber: verifyPhoneIntentParameterHolder.phoneNumber,
                phoneId: verifyPhoneIntentParameterHolder.phoneId,
              ));

    case '${RoutePaths.payStack}':
      final Object? args = settings.arguments;

      final CreditCardIntentHolder creditCardInterntHolder =
          args as CreditCardIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PayStackView(
                  basketList: creditCardInterntHolder.basketList,
                  couponDiscount: creditCardInterntHolder.couponDiscount,
                  transactionSubmitProvider:
                      creditCardInterntHolder.transactionSubmitProvider,
                  psValueHolder: creditCardInterntHolder.psValueHolder,
                  basketProvider: creditCardInterntHolder.basketProvider,
                  userLoginProvider: creditCardInterntHolder.userProvider,
                  memoText: creditCardInterntHolder.memoText,
                  payStackKey: creditCardInterntHolder.payStackKey,
                  shippingCostProvider:
                      creditCardInterntHolder.shippingCostProvider,
                  shippingMethodProvider:
                      creditCardInterntHolder.shippingMethodProvider));

    case '${RoutePaths.user_update_password}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ChangePasswordView());

    case '${RoutePaths.contactUs}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ContactUsContainerView());


    case '${RoutePaths.languageList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              LanguageListView());

    case '${RoutePaths.categoryList}':
      final Object? args = settings.arguments;
      final String title = args as String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CategoryListViewContainerView(appBarTitle: title));

    case '${RoutePaths.notiList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              const NotiListView());
    case '${RoutePaths.creditCard}':
      final Object? args = settings.arguments;

      final CreditCardIntentHolder creditCardParameterHolder =
          args as CreditCardIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CreditCardView(
                  basketList: creditCardParameterHolder.basketList,
                  couponDiscount: creditCardParameterHolder.couponDiscount,
                  transactionSubmitProvider:
                      creditCardParameterHolder.transactionSubmitProvider,
                  userLoginProvider: creditCardParameterHolder.userProvider,
                  basketProvider: creditCardParameterHolder.basketProvider,
                  psValueHolder: creditCardParameterHolder.psValueHolder,
                  shippingCostProvider:
                      creditCardParameterHolder.shippingCostProvider,
                  shippingMethodProvider:
                      creditCardParameterHolder.shippingMethodProvider,
                  memoText: creditCardParameterHolder.memoText,
                  publishKey: creditCardParameterHolder.publishKey));

    case '${RoutePaths.notiSetting}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotificationSettingView());

    case '${RoutePaths.termsAndRefund}':
      final Object? args = settings.arguments;
      final PrivacyPolicyIntentHolder privacyPolicyIntentHolder =
          args as PrivacyPolicyIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TermsAndRefundContainerView(
                  title: privacyPolicyIntentHolder.title,
                  description: privacyPolicyIntentHolder.description));

    // case '${RoutePaths.subCategoryList}':
    //   final Object? args = settings.arguments;
    //   final Category category = args ?? Category;
    //   return PageRouteBuilder<dynamic>(
    //       pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
    //           SubCategoryListView(category: category));

    case '${RoutePaths.noti}':
      final Object? args = settings.arguments;
      final Noti noti = args as Noti;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              NotiView(noti: noti));

    case '${RoutePaths.filterProductList}':
      final Object? args = settings.arguments;
      final ProductListIntentHolder productListIntentHolder =
          args as ProductListIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ProductListWithFilterContainerView(
                  appBarTitle: productListIntentHolder.appBarTitle,
                  productParameterHolder:
                      productListIntentHolder.productParameterHolder));

    case '${RoutePaths.checkoutSuccess}':
      final Object? args = settings.arguments;

      final CheckoutStatusIntentHolder checkoutStatusIntentHolder =
          args as CheckoutStatusIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CheckoutStatusView(
                transactionHeader: checkoutStatusIntentHolder.transactionHeader,
              ));

    case '${RoutePaths.privacyPolicy}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              PrivacyPolicyContainerView());

    case '${RoutePaths.blogList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BlogListContainerView());

    case '${RoutePaths.blogDetail}':
      final Object? args = settings.arguments;
      final Blog blog = args as Blog;
      return MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return BlogView(
          blog: blog,
          heroTagImage: blog.id!,
        );
      });

    case '${RoutePaths.transactionList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TransactionListContainerView());

    case '${RoutePaths.historyList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              HistoryListContainerView());

    case '${RoutePaths.transactionDetail}':
      final Object? args = settings.arguments;
      final TransactionHeader transaction = args as TransactionHeader;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TransactionItemListView(
                transaction: transaction,
              ));

    case '${RoutePaths.productDetail}':
      final Object? args = settings.arguments;
      final ProductDetailIntentHolder holder =
          args as ProductDetailIntentHolder;
      return MaterialPageRoute<Widget>(builder: (BuildContext context) {
        return ProductDetailView(
          productId: holder.productId,
          heroTagImage: holder.heroTagImage,
          heroTagTitle: holder.heroTagTitle,
          heroTagOriginalPrice: holder.heroTagOriginalPrice,
          heroTagUnitPrice: holder.heroTagUnitPrice,
          intentQty: holder.qty,
          intentSelectedColorId: holder.selectedColorId,
          intentSelectedColorValue: holder.selectedColorValue,
          intentBasketPrice: holder.basketPrice,
          intentBasketSelectedAttributeList: holder.basketSelectedAttributeList,
        );
      });

    case '${RoutePaths.filterExpantion}':
      final dynamic args = settings.arguments;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FilterListView(selectedData: args));

    case '${RoutePaths.commentList}':
      final Object? args = settings.arguments;
      final Product product = args as Product;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CommentListView(product: product));

    case '${RoutePaths.itemSearch}':
      final Object? args = settings.arguments;
      final ProductParameterHolder productParameterHolder =
          args as ProductParameterHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemSearchView(productParameterHolder: productParameterHolder));

    case '${RoutePaths.itemSort}':
      final Object? args = settings.arguments;
      final ProductParameterHolder productParameterHolder =
          args as ProductParameterHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ItemSortingView(productParameterHolder: productParameterHolder));

    case '${RoutePaths.commentDetail}':
      final Object? args = settings.arguments;
      final CommentHeader commentHeader = args as CommentHeader;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CommentDetailListView(
                commentHeader: commentHeader,
              ));

    case '${RoutePaths.favouriteProductList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              FavouriteProductListContainerView());

    case '${RoutePaths.collectionProductList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CollectionHeaderListContainerView());

    case '${RoutePaths.productListByCollectionId}':
      final Object? args = settings.arguments;
      final ProductListByCollectionIdView productCollectionIdView =
          args as ProductListByCollectionIdView;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ProductListByCollectionIdView(
                productCollectionHeader:
                    productCollectionIdView.productCollectionHeader,
                appBarTitle: productCollectionIdView.appBarTitle,
              ));

    case '${RoutePaths.ratingList}':
      final Object? args = settings.arguments;
      final String productDetailId = args as String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              RatingListView(productDetailid: productDetailId));

    case '${RoutePaths.editProfile}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              EditProfileView());

    case '${RoutePaths.countryList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CountryListView());
    case '${RoutePaths.cityList}':
      final Object? args = settings.arguments;
      final String countryId = args as String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CityListView(countryId: countryId));

    case '${RoutePaths.galleryGrid}':
      final Object? args = settings.arguments;
      final Product product = args as Product;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryGridView(product: product));

    case '${RoutePaths.galleryDetail}':
      final Object? args = settings.arguments;
      final DefaultPhoto selectedDefaultImage = args as DefaultPhoto;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              GalleryView(selectedDefaultImage: selectedDefaultImage));

    case '${RoutePaths.searchCategory}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CategoryFilterListView());
    case '${RoutePaths.searchSubCategory}':
      final Object? args = settings.arguments;
      final String category = args as String;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SubCategorySearchListView(categoryId: category));

    case '${RoutePaths.basketList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BasketListContainerView());

    case '${RoutePaths.checkout_container}':
      final Object? args = settings.arguments;

      final CheckoutIntentHolder checkoutIntentHolder =
          args as CheckoutIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              CheckoutContainerView(
                basketList: checkoutIntentHolder.basketList,
              ));

    case '${RoutePaths.searchHistory}':
      return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => SearchHistoryListView());

    case '${RoutePaths.searchItemList}':
      final Object? args = settings.arguments;
      final ProductParameterHolder productParameterHolder =
          args as ProductParameterHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SearchItemListView(
                  productParameterHolder: productParameterHolder));

    case '${RoutePaths.bestChoiceListByCollectionId}':
      final Object? args = settings.arguments;
      final BestChoiceListByCollectionIdView bestChoiceListByCollectionIdView =
          args as BestChoiceListByCollectionIdView;

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BestChoiceListByCollectionIdView(
                bestChoice: bestChoiceListByCollectionIdView.bestChoice,
                appBarTitle: bestChoiceListByCollectionIdView.appBarTitle,
                backgroundColor:
                    bestChoiceListByCollectionIdView.backgroundColor,
                titleTextColor: bestChoiceListByCollectionIdView.titleTextColor,
              ));

    case '${RoutePaths.trendingCategoryList}':
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              TrendingCategoryListView());

    case '${RoutePaths.attributeDetailList}':
      final Object? args = settings.arguments;
      final AttributeDetailIntentHolder attributeDetailIntentHolder =
          args as AttributeDetailIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AttributeDetailListView(
                attributeDetail: attributeDetailIntentHolder.attributeDetail,
                product: attributeDetailIntentHolder.product,
              ));
        case '${RoutePaths.searchCategoryViewAll}':
      final Map<String, dynamic> args = settings.arguments as Map<String,dynamic>;
      final String title = args['title'];
      final String keyword = args['keyword'];

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SearchCategoryViewAllContainer(
                  appBarTitle: title, keyword: keyword));

    case '${RoutePaths.searchSubCategoryViewAll}':
      final Map<String, dynamic> args = settings.arguments as Map<String,dynamic>;
      final String title = args['title'];
      final String keyword = args['keyword'];

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SearchSubCategoryViewAllContainer(
                  appBarTitle: title, keyword: keyword));

      case '${RoutePaths.searchItemViewAll}':
      final Map<String, dynamic> args = settings.arguments as Map<String,dynamic>;
      final String title = args['title'];
      final String keyword = args['keyword'];

      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              SearchItemViewAllContainer(appBarTitle: title, keyword: keyword));




    case '${RoutePaths.onepage_checkout_container}':
      final Object args = settings.arguments!;

      final CheckoutIntentHolder checkoutIntentHolder =
          args as CheckoutIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              OnePageCheckoutContainerView(
                basketList: checkoutIntentHolder.basketList,
                shopInfoProvider: checkoutIntentHolder.shopInfoProvider!,
              ));

    case '${RoutePaths.whatsAppCheckout_container}':
      final Object args = settings.arguments!;

      final WhatsAppCheckoutIntentHolder whatsAppCheckoutIntentHolder =
          args as WhatsAppCheckoutIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              WhatsappCheckoutContainerView(
                basketList: whatsAppCheckoutIntentHolder.basketList,
              ));
    case '${RoutePaths.billingTo}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments!;
        final BillingToIntentHolder billingToIntentHolder =
            args as BillingToIntentHolder;
        return BillingToView(
          userEmail: billingToIntentHolder.userEmail,
          userPhoneNo: billingToIntentHolder.userPhoneNo,
        );
      });

    case '${RoutePaths.shippingAddress}':
      final Object args = settings.arguments!;

      final AddressIntentHolder checkoutIntentHolder =
          args as AddressIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              ShippingAddressView(
                userEmail: checkoutIntentHolder.email,
                userPhoneNo: checkoutIntentHolder.phone,
                firstName: checkoutIntentHolder.firstName,
                lastName: checkoutIntentHolder.lastName,
                address1: checkoutIntentHolder.address1,
                address2: checkoutIntentHolder.address2,
                city: checkoutIntentHolder.city,
                companyName: checkoutIntentHolder.company,
                country: checkoutIntentHolder.country,
                state: checkoutIntentHolder.state,
                postalCode: checkoutIntentHolder.postalCode,
                userProvider: checkoutIntentHolder.userProvider,
              ));
    case '${RoutePaths.billingAddress}':
      final Object args = settings.arguments!;

      final AddressIntentHolder checkoutIntentHolder =
          args as AddressIntentHolder;
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              BillingAddressView(
                userEmail: checkoutIntentHolder.email,
                userPhoneNo: checkoutIntentHolder.phone,
                firstName: checkoutIntentHolder.firstName,
                lastName: checkoutIntentHolder.lastName,
                address1: checkoutIntentHolder.address1,
                address2: checkoutIntentHolder.address2,
                city: checkoutIntentHolder.city,
                companyName: checkoutIntentHolder.company,
                country: checkoutIntentHolder.country,
                state: checkoutIntentHolder.state,
                postalCode: checkoutIntentHolder.postalCode,
                userProvider: checkoutIntentHolder.userProvider,
                shippingAddress1: checkoutIntentHolder.shippingAddress1!,
                shippingAddress2: checkoutIntentHolder.shippingAddress2!,
                shippingCity: checkoutIntentHolder.shippingCity!,
                shippingCompany: checkoutIntentHolder.shippingCompany!,
                shippingCountry: checkoutIntentHolder.shippingCountry!,
                shippingEmail: checkoutIntentHolder.shippingEmail!,
                shippingFirstName: checkoutIntentHolder.shippingFirstName!,
                shippingLastName: checkoutIntentHolder.shippingLastName!,
                shippingPhone: checkoutIntentHolder.shippingPhone!,
                shippingPostalCode: checkoutIntentHolder.shippingPostalCode!,
                shippingState: checkoutIntentHolder.shippingState!,
              ));
    case '${RoutePaths.paymentMethod}':
      return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
        final Object args = settings.arguments!;
        final PaymentIntentHolder holder = args as PaymentIntentHolder;
        return PaymentMethodView(
          userProvider: holder.userProvider,
        );
      });

    default:
      return PageRouteBuilder<dynamic>(
          pageBuilder: (_, Animation<double> a1, Animation<double> a2) =>
              AppLoadingView());
  }
}
