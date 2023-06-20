import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/address_intent_holder.dart';
import 'package:flutterwave_standard/core/flutterwave.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../api/common/ps_resource.dart';
import '../../../api/common/ps_status.dart';
import '../../../config/ps_colors.dart';
import '../../../config/ps_config.dart';
import '../../../constant/ps_constants.dart';
import '../../../constant/ps_dimens.dart';
import '../../../constant/route_paths.dart';
import '../../../provider/basket/basket_provider.dart';
import '../../../provider/coupon_discount/coupon_discount_provider.dart';
import '../../../provider/shipping_cost/shipping_cost_provider.dart';
import '../../../provider/shipping_method/shipping_method_provider.dart';
import '../../../provider/shop_info/shop_info_provider.dart';
import '../../../provider/token/token_provider.dart';
import '../../../provider/transaction/transaction_header_provider.dart';
import '../../../provider/user/user_provider.dart';
import '../../../repository/basket_repository.dart';
import '../../../repository/coupon_discount_repository.dart';
import '../../../repository/shipping_cost_repository.dart';
import '../../../repository/shipping_method_repository.dart';
import '../../../repository/shop_info_repository.dart';
import '../../../repository/token_repository.dart';
import '../../../repository/transaction_header_repository.dart';
import '../../../repository/user_repository.dart';
import '../../../utils/ps_progress_dialog.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/api_status.dart';
import '../../../viewobject/basket.dart';
import '../../../viewobject/common/ps_value_holder.dart';
import '../../../viewobject/coupon_discount.dart';
import '../../../viewobject/holder/address_callback_holder.dart';
import '../../../viewobject/holder/billing_to_callback_holder.dart';
import '../../../viewobject/holder/coupon_discount_holder.dart';
import '../../../viewobject/holder/intent_holder/billing_to_intent_holder.dart';
import '../../../viewobject/holder/intent_holder/checkout_status_intent_holder.dart';
import '../../../viewobject/holder/intent_holder/credit_card_intent_holder.dart';
import '../../../viewobject/holder/intent_holder/payment_intent_holder.dart';
import '../../../viewobject/holder/payment_callback_holder.dart';
import '../../../viewobject/holder/profile_update_view_holder.dart';
import '../../../viewobject/transaction_header.dart';
import '../../../viewobject/user.dart';
import '../../common/dialog/confirm_dialog_view.dart';
import '../../common/dialog/demo_warning_dialog.dart';
import '../../common/dialog/error_dialog.dart';
import '../../common/dialog/success_dialog.dart';
import '../../common/dialog/warning_dialog_view.dart';
import '../../common/ps_button_widget.dart';
import '../../common/ps_textfield_widget.dart';

class OnePageCheckoutView extends StatefulWidget {
  const OnePageCheckoutView({
    Key? key,
    required this.basketList,
    required this.shopInfoProvider,
  }) : super(key: key);

  final List<Basket> basketList;
  final ShopInfoProvider shopInfoProvider;

  @override
  _OnePageCheckoutViewState createState() {
    final _OnePageCheckoutViewState _state = _OnePageCheckoutViewState();
    return _state;
  }
}

class _OnePageCheckoutViewState extends State<OnePageCheckoutView> {
  AnimationController? animationController;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController memoController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  TextEditingController orderTimeTextEditingController =
      TextEditingController();

  TextEditingController shippingFirstNameController = TextEditingController();
  TextEditingController shippingLastNameController = TextEditingController();
  TextEditingController shippingEmailController = TextEditingController();
  TextEditingController shippingPhoneController = TextEditingController();
  TextEditingController shippingCompanyController = TextEditingController();
  TextEditingController shippingAddress1Controller = TextEditingController();
  TextEditingController shippingAddress2Controller = TextEditingController();
  TextEditingController shippingCountryController = TextEditingController();
  TextEditingController shippingStateController = TextEditingController();
  TextEditingController shippingCityController = TextEditingController();
  TextEditingController shippingPostalCodeController = TextEditingController();

  TextEditingController billingFirstNameController = TextEditingController();
  TextEditingController billingLastNameController = TextEditingController();
  TextEditingController billingEmailController = TextEditingController();
  TextEditingController billingPhoneController = TextEditingController();
  TextEditingController billingCompanyController = TextEditingController();
  TextEditingController billingAddress1Controller = TextEditingController();
  TextEditingController billingAddress2Controller = TextEditingController();
  TextEditingController billingCountryController = TextEditingController();
  TextEditingController billingStateController = TextEditingController();
  TextEditingController billingCityController = TextEditingController();
  TextEditingController billingPostalCodeController = TextEditingController();

  bool isCheckBoxSelect = false;
  UserRepository? userRepository;
  UserProvider? userProvider;
  ShopInfoProvider? shopInfoProvider;
  TransactionHeaderProvider? transactionSubmitProvider;
  CouponDiscountProvider? couponDiscountProvider;
  BasketProvider? basketProvider;
  TokenProvider? tokenProvider;
  TokenRepository? tokenRepository;
  ShippingCostProvider? shippingCostProvider;
  ShippingMethodProvider? shippingMethodProvider;
  ShippingCostRepository? shippingCostRepository;
  ShippingMethodRepository? shippingMethodRepository;
  ShopInfoRepository? shopInfoRepository;
  CouponDiscountRepository? couponDiscountRepo;
  BasketRepository? basketRepository;
  TransactionHeaderRepository? transactionHeaderRepo;
  late PsValueHolder valueHolder;
  bool bindDataFirstTime = true;
  bool isRazorSupportMultiCurrency = false;
  String? deliveryPickUpDate;
  String? deliveryPickUpTime;
  double? couponDiscount;
  double? basketTotalPrice = 0;
  String? currencySymbol;
  double? totalCost;

  dynamic updatDateAndTime(String dateTime) {
    setState(() {});
    deliveryPickUpDate =
        DateFormat('EEEE d MMM').format(DateTime.parse(dateTime));
    deliveryPickUpTime = DateFormat('HH:mm').format(DateTime.parse(dateTime));

    orderTimeTextEditingController.text =
        deliveryPickUpDate! + ' ' + deliveryPickUpTime!;
  }

  dynamic updateUserData() async {
    if (!checkIsDataChange()) {
      await callUpdateUserProfile(userProvider!);
    }
    await calculateShippingCost();
  }

  dynamic checkIsDataChange() {
    if (userProvider!.user.data!.userEmail == userEmailController.text &&
        userProvider!.user.data!.userPhone == userPhoneController.text &&
        userProvider!.user.data!.billingFirstName ==
            billingFirstNameController.text &&
        userProvider!.user.data!.billingLastName ==
            billingLastNameController.text &&
        userProvider!.user.data!.billingCompany ==
            billingCompanyController.text &&
        userProvider!.user.data!.billingAddress_1 ==
            billingAddress1Controller.text &&
        userProvider!.user.data!.billingAddress_2 ==
            billingAddress2Controller.text &&
        userProvider!.user.data!.billingCountry ==
            billingCountryController.text &&
        userProvider!.user.data!.billingState == billingStateController.text &&
        userProvider!.user.data!.billingCity == billingCityController.text &&
        userProvider!.user.data!.billingPostalCode ==
            billingPostalCodeController.text &&
        userProvider!.user.data!.billingEmail == billingEmailController.text &&
        userProvider!.user.data!.billingPhone == billingPhoneController.text &&
        userProvider!.user.data!.shippingFirstName ==
            shippingFirstNameController.text &&
        userProvider!.user.data!.shippingLastName ==
            shippingLastNameController.text &&
        userProvider!.user.data!.shippingCompany ==
            shippingCompanyController.text &&
        userProvider!.user.data!.shippingAddress_1 ==
            shippingAddress1Controller.text &&
        userProvider!.user.data!.shippingAddress_2 ==
            shippingAddress2Controller.text &&
        userProvider!.user.data!.shippingCountry ==
            shippingCountryController.text &&
        userProvider!.user.data!.shippingState ==
            shippingStateController.text &&
        userProvider!.user.data!.shippingCity == shippingCityController.text &&
        userProvider!.user.data!.shippingPostalCode ==
            shippingPostalCodeController.text &&
        userProvider!.user.data!.shippingEmail ==
            shippingEmailController.text &&
        userProvider!.user.data!.shippingPhone ==
            shippingPhoneController.text) {
      return true;
    } else {
      return false;
    }
  }

  dynamic callUpdateUserProfile(UserProvider userProvider) async {
    bool isSuccess = false;

    if (await Utils.checkInternetConnectivity()) {
      final ProfileUpdateParameterHolder profileUpdateParameterHolder =
          ProfileUpdateParameterHolder(
        userId: userProvider.psValueHolder!.loginUserId!,
        userName: userProvider.user.data!.userName!,
        userEmail: userEmailController.text.trim(),
        userPhone: userPhoneController.text,
        userAboutMe: userProvider.user.data!.userAboutMe!,
        billingFirstName: billingFirstNameController.text,
        billingLastName: billingLastNameController.text,
        billingCompany: billingCompanyController.text,
        billingAddress1: billingAddress1Controller.text,
        billingAddress2: billingAddress2Controller.text,
        billingCountry: billingCountryController.text,
        billingState: billingStateController.text,
        billingCity: billingCityController.text,
        billingPostalCode: billingPostalCodeController.text,
        billingEmail: billingEmailController.text,
        billingPhone: billingPhoneController.text,
        shippingFirstName: shippingFirstNameController.text,
        shippingLastName: shippingLastNameController.text,
        shippingCompany: shippingCompanyController.text,
        shippingAddress1: shippingAddress1Controller.text,
        shippingAddress2: shippingAddress2Controller.text,
        shippingCountry: userProvider.selectedCountry!.name!,
        shippingState: shippingStateController.text,
        shippingCity: userProvider.selectedCity!.name!,
        shippingPostalCode: shippingPostalCodeController.text,
        shippingEmail: shippingEmailController.text,
        shippingPhone: shippingPhoneController.text,
        countryId: userProvider.selectedCountry!.id!,
        cityId: userProvider.selectedCity!.id!,
      );
      await PsProgressDialog.showDialog(context);
      final PsResource<User> _apiStatus = await userProvider
          .postProfileUpdate(profileUpdateParameterHolder.toMap());
      if (_apiStatus.data != null) {
        PsProgressDialog.dismissDialog();
        isSuccess = true;

        // showDialog<dynamic>(
        //     context: context,
        //     builder: (BuildContext contet) {
        //       return SuccessDialog(
        //         message: Utils.getString(context, 'edit_profile__success'),
        //       );
        //     });
      } else {
        PsProgressDialog.dismissDialog();

        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }

    return isSuccess;
  }

  dynamic calculateShippingCost() async {
    await PsProgressDialog.showDialog(context);
    if (shippingMethodProvider!.psValueHolder!.zoneShippingEnable ==
            PsConst.ONE &&
        userProvider!.user.data != null &&
        userProvider!.user.data!.city?.id != null) {
      await shippingCostProvider!.postZoneShippingMethod(
          userProvider!.user.data!.country!.id!,
          userProvider!.user.data!.city!.id!,
          userProvider!.psValueHolder!.shopId!,
          widget.basketList);
    }
    if (valueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider!.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider!.couponDiscount,
          psValueHolder: valueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider!.selectedPrice == '0.0'
                  ? shippingMethodProvider!.defaultShippingPrice!
                  : shippingMethodProvider!.selectedPrice ?? '0.0');
    } else if (valueHolder.zoneShippingEnable == PsConst.ONE) {
      basketProvider!.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider!.couponDiscount,
          psValueHolder: valueHolder,
          shippingPriceStringFormatting: shippingCostProvider!
              .shippingCost.data!.shippingZone!.shippingCost!);
    }
    PsProgressDialog.dismissDialog();
    setState(() {});
  }

  dynamic calculateShippingCostTotal() async {
    if (shippingMethodProvider!.psValueHolder!.zoneShippingEnable ==
            PsConst.ONE &&
        userProvider!.user.data != null) {
      await shippingCostProvider!.postZoneShippingMethod(
          userProvider!.user.data!.country!.id!,
          userProvider!.user.data!.city!.id!,
          userProvider!.psValueHolder!.shopId!,
          widget.basketList);
    }
    if (valueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider!.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider!.couponDiscount,
          psValueHolder: valueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider!.selectedPrice == '0.0'
                  ? shippingMethodProvider!.defaultShippingPrice!
                  : shippingMethodProvider!.selectedPrice ?? '0.0');
    } else if (valueHolder.zoneShippingEnable == PsConst.ONE &&
        shippingCostProvider!.shippingCost.data != null) {
      basketProvider!.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider!.couponDiscount,
          psValueHolder: valueHolder,
          shippingPriceStringFormatting: shippingCostProvider!
              .shippingCost.data!.shippingZone!.shippingCost!);
    }
    bindDataFirstTime = false;
  }

  dynamic bankNow() async {
    if (await Utils.checkInternetConnectivity()) {
      if (userProvider!.user.data != null) {
        await PsProgressDialog.showDialog(context);
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider!.postTransactionSubmit(
                userProvider!.user.data!,
                widget.basketList,
                '',
                couponDiscountProvider!.couponDiscount.toString(),
                basketProvider!.checkoutCalculationHelper.tax.toString(),
                basketProvider!.checkoutCalculationHelper.totalDiscount
                    .toString(),
                basketProvider!.checkoutCalculationHelper.subTotalPrice
                    .toString(),
                basketProvider!.checkoutCalculationHelper.shippingTax
                    .toString(),
                basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
                basketProvider!.checkoutCalculationHelper.totalOriginalPrice
                    .toString(),
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ONE,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                '',
                '',
                basketProvider!.checkoutCalculationHelper.shippingCost
                    .toString(),
                (shippingMethodProvider!.selectedShippingName == null)
                    ? shippingMethodProvider!.defaultShippingName!
                    : shippingMethodProvider!.selectedShippingName!,
                memoController.text);

        if (_apiStatus.data != null) {
          PsProgressDialog.dismissDialog();

          await basketProvider!.deleteWholeBasketList();
          Navigator.pop(context, true);
          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data!,
              ));
        } else {
          PsProgressDialog.dismissDialog();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic payNow() async {
    if (await Utils.checkInternetConnectivity()) {
      await calculateShippingCost();
      if (valueHolder.standardShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting:
                shippingMethodProvider!.selectedPrice == '0.0'
                    ? shippingMethodProvider!.defaultShippingPrice!
                    : shippingMethodProvider!.selectedPrice ?? '0.0');
      } else if (valueHolder.zoneShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting: shippingCostProvider!
                .shippingCost.data!.shippingZone!.shippingCost!);
      }
      final PsResource<ApiStatus> tokenResource =
          await tokenProvider!.loadToken();
      final BraintreeDropInRequest request = BraintreeDropInRequest(
        clientToken: tokenResource.data!.message,
        collectDeviceData: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice:
              basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
          currencyCode: shopInfoProvider!.shopInfo.data!.currencyShortForm!,
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount:
              basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
          displayName: userProvider!.user.data!.userName,
        ),
      );

      final BraintreeDropInResult? result =
          await BraintreeDropIn.start(request);
      if (result != null) {
        print('Nonce: ${result.paymentMethodNonce.nonce}');
      } else {
        print('Selection was canceled.');
      }

      if (await Utils.checkInternetConnectivity()) {
        if (result?.paymentMethodNonce.nonce != null) {
          await PsProgressDialog.showDialog(context);

          if (userProvider!.user.data != null && result != null) {
            final PsResource<TransactionHeader> _apiStatus =
                await transactionSubmitProvider!.postTransactionSubmit(
                    userProvider!.user.data!,
                    widget.basketList,
                    result.paymentMethodNonce.nonce,
                    couponDiscountProvider!.couponDiscount.toString(),
                    basketProvider!.checkoutCalculationHelper.tax.toString(),
                    basketProvider!.checkoutCalculationHelper.totalDiscount
                        .toString(),
                    basketProvider!.checkoutCalculationHelper.subTotalPrice
                        .toString(),
                    basketProvider!.checkoutCalculationHelper.shippingTax
                        .toString(),
                    basketProvider!.checkoutCalculationHelper.totalPrice
                        .toString(),
                    basketProvider!.checkoutCalculationHelper.totalOriginalPrice
                        .toString(),
                    PsConst.ZERO,
                    PsConst.ONE,
                    PsConst.ZERO,
                    PsConst.ZERO,
                    PsConst.ZERO,
                    PsConst.ZERO,
                    PsConst.ZERO,
                    '',
                    '',
                    basketProvider!.checkoutCalculationHelper.shippingCost
                        .toString(),
                    (shippingMethodProvider!.selectedShippingName == null)
                        ? shippingMethodProvider!.defaultShippingName!
                        : shippingMethodProvider!.selectedShippingName!,
                    memoController.text);

            if (_apiStatus.data != null) {
              PsProgressDialog.dismissDialog();

              if (_apiStatus.status == PsStatus.SUCCESS) {
                await basketProvider!.deleteWholeBasketList();

                Navigator.pop(context, true);
                await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
                    arguments: CheckoutStatusIntentHolder(
                      transactionHeader: _apiStatus.data!,
                    ));
              } else {
                PsProgressDialog.dismissDialog();

                return showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(
                        message: _apiStatus.message,
                      );
                    });
              }
            } else {
              PsProgressDialog.dismissDialog();

              return showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return ErrorDialog(
                      message: _apiStatus.message,
                    );
                  });
            }
          }
        }
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic payCash() async {
    if (await Utils.checkInternetConnectivity()) {
      await calculateShippingCost();
      if (userProvider!.user.data != null) {
        await PsProgressDialog.showDialog(context);
        print(basketProvider!
            .checkoutCalculationHelper.subTotalPriceFormattedString);
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider!.postTransactionSubmit(
                userProvider!.user.data!,
                widget.basketList,
                '',
                couponDiscountProvider!.couponDiscount.toString(),
                basketProvider!.checkoutCalculationHelper.tax.toString(),
                basketProvider!.checkoutCalculationHelper.totalDiscount
                    .toString(),
                basketProvider!.checkoutCalculationHelper.subTotalPrice
                    .toString(),
                basketProvider!.checkoutCalculationHelper.shippingTax
                    .toString(),
                basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
                basketProvider!.checkoutCalculationHelper.totalOriginalPrice
                    .toString(),
                PsConst.ONE,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                PsConst.ZERO,
                '',
                '',
                basketProvider!.checkoutCalculationHelper.shippingCost
                    .toString(),
                (shippingMethodProvider!.selectedShippingName == null)
                    ? shippingMethodProvider!.defaultShippingName!
                    : shippingMethodProvider!.selectedShippingName!,
                memoController.text);

        if (_apiStatus.data != null) {
          PsProgressDialog.dismissDialog();
          await basketProvider!.deleteWholeBasketList();
          Navigator.pop(context, true);
          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data!,
              ));
        } else {
          PsProgressDialog.dismissDialog();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  dynamic payPayStack() async {
    await calculateShippingCost();

    await Navigator.pushNamed(context, RoutePaths.payStack,
        arguments: CreditCardIntentHolder(
            basketList: widget.basketList,
            couponDiscount: couponDiscountProvider!.couponDiscount,
            transactionSubmitProvider: transactionSubmitProvider!,
            shippingCostProvider: shippingCostProvider!,
            shippingMethodProvider: shippingMethodProvider!,
            userProvider: userProvider!,
            basketProvider: basketProvider!,
            psValueHolder: valueHolder,
            memoText: memoController.text,
            publishKey: valueHolder.publishKey!,
            payStackKey: valueHolder.payStackKey!));
  }

  dynamic payStripe() async {
    await calculateShippingCost();

    await Navigator.pushNamed(context, RoutePaths.creditCard,
        arguments: CreditCardIntentHolder(
            basketList: widget.basketList,
            couponDiscount: couponDiscountProvider!.couponDiscount,
            transactionSubmitProvider: transactionSubmitProvider!,
            userProvider: userProvider!,
            basketProvider: basketProvider!,
            psValueHolder: valueHolder,
            shippingCostProvider: shippingCostProvider!,
            shippingMethodProvider: shippingMethodProvider!,
            memoText: memoController.text,
            publishKey: valueHolder.publishKey!,
            payStackKey: valueHolder.payStackKey!));
  }

  Future<void> _handleWavePaymentSuccess(String transactionId) async {
    // Do something when payment succeeds
    print('success');

    print(transactionId);

    await PsProgressDialog.showDialog(context);
    if (userProvider!.user.data != null) {
      final PsResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider!.postTransactionSubmit(
              userProvider!.user.data!,
              widget.basketList,
              '',
              couponDiscountProvider!.couponDiscount.toString(),
              basketProvider!.checkoutCalculationHelper.tax.toString(),
              basketProvider!.checkoutCalculationHelper.totalDiscount
                  .toString(),
              basketProvider!.checkoutCalculationHelper.subTotalPrice
                  .toString(),
              basketProvider!.checkoutCalculationHelper.shippingTax.toString(),
              basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
              basketProvider!.checkoutCalculationHelper.totalOriginalPrice
                  .toString(),
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO, //razor
              PsConst.ONE, //flutter wave
              '', //razorId
              transactionId, //flutter wave id
              basketProvider!.checkoutCalculationHelper.shippingCost.toString(),
              (shippingMethodProvider!.selectedShippingName == null)
                  ? shippingMethodProvider!.defaultShippingName!
                  : shippingMethodProvider!.selectedShippingName!,
              memoController.text);

      if (_apiStatus.data != null) {
        PsProgressDialog.dismissDialog();

        if (_apiStatus.status == PsStatus.SUCCESS) {
          await basketProvider!.deleteWholeBasketList();

          // Navigator.pop(context, true);
          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data!,
              ));
        } else {
          PsProgressDialog.dismissDialog();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      } else {
        PsProgressDialog.dismissDialog();

        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    }
  }

  dynamic payFlutterWave() async {
    if (await Utils.checkInternetConnectivity()) {
      await calculateShippingCost();
      if (valueHolder.standardShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting:
                shippingMethodProvider!.selectedPrice == '0.0'
                    ? shippingMethodProvider!.defaultShippingPrice!
                    : shippingMethodProvider!.selectedPrice ?? '0.0');
      } else if (valueHolder.zoneShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting: shippingCostProvider!
                .shippingCost.data!.shippingZone!.shippingCost!);
      }

      final String amount = Utils.getPriceTwoDecimal(
          basketProvider!.checkoutCalculationHelper.totalPrice.toString());

      // final FlutterwaveStyle style = FlutterwaveStyle(
      //     appBarText: Utils.getString(context, 'checkout3__wave'),
      //     buttonColor: PsColors.mainColor,
      //     appBarIcon: Icon(
      //       Icons.arrow_back,
      //       color: PsColors.mainColorWithWhite,
      //     ),
      //     mainBackgroundColor: PsColors.backgroundColor,
      //     buttonText: Utils.getString(context, 'flutter_wave_make_payment'),
      //     buttonTextStyle: TextStyle(
      //       color: PsColors.white,
      //       fontWeight: FontWeight.bold,
      //       fontSize: 18,
      //     ),
      //     appBarTitleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
      //           color: PsColors.mainColorWithWhite,
      //           fontWeight: FontWeight.bold,
      //         ),
      //     appBarColor: PsColors.baseColor,
      //     dialogCancelTextStyle: const TextStyle(
      //       color: Colors.redAccent,
      //       fontSize: 18,
      //     ),
      //     dialogContinueTextStyle: const TextStyle(
      //       color: Colors.blue,
      //       fontSize: 18,
      //     ));

      final Customer customer = Customer(
          name: userProvider!.user.data!.userName!,
          phoneNumber: userProvider!.user.data!.userPhone!,
          email: userProvider!.user.data!.userEmail!);

      final Flutterwave flutterwave = Flutterwave(
        redirectUrl: 'https://google.com' ,
        context: context,
        // style: style,
        publicKey: shopInfoProvider!.shopInfo.data!.flutterWavePublishableKey!,
        currency: valueHolder.defaultFlutterWaveCurrency,
        txRef:
            '${DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.now())}-${valueHolder.loginUserId}',
        amount: amount,
        customer: customer,
        paymentOptions: 'ussd, card, barter, payattitude',
        customization: Customization(title: 'Flutterwave Payment'),
        isTestMode: true,
      );

      try {
        if (await Utils.checkInternetConnectivity()) {
          final ChargeResponse? response = await flutterwave.charge();
          if (response != null) {
            print(response.toJson());
            if (response.success!) {
              //  Call the verify transaction endpoint with the transactionID returned in `response.transactionId` to verify transaction before offering value to customer
              PsProgressDialog.dismissDialog();
              print(response.toJson());
              _handleWavePaymentSuccess(response.transactionId!);
            } else {
              print('Transaction not successful');
            }
          } else {
            print('Transaction Cancelled');
          }
        } else {
          showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message:
                      Utils.getString(context, 'error_dialog__no_internet'),
                );
              });
        }
      } catch (error) {
        print(error);
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    print('success');

    print(response);

    await PsProgressDialog.showDialog(context);
    if (userProvider!.user.data != null) {
      final PsResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider!.postTransactionSubmit(
              userProvider!.user.data!,
              widget.basketList,
              '',
              couponDiscountProvider!.couponDiscount.toString(),
              basketProvider!.checkoutCalculationHelper.tax.toString(),
              basketProvider!.checkoutCalculationHelper.totalDiscount
                  .toString(),
              basketProvider!.checkoutCalculationHelper.subTotalPrice
                  .toString(),
              basketProvider!.checkoutCalculationHelper.shippingTax.toString(),
              basketProvider!.checkoutCalculationHelper.totalPrice.toString(),
              basketProvider!.checkoutCalculationHelper.totalOriginalPrice
                  .toString(),
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ZERO,
              PsConst.ONE,
              PsConst.ZERO,
              response.paymentId.toString(),
              '',
              basketProvider!.checkoutCalculationHelper.shippingCost.toString(),
              (shippingMethodProvider!.selectedShippingName == null)
                  ? shippingMethodProvider!.defaultShippingName!
                  : shippingMethodProvider!.selectedShippingName!,
              memoController.text);

      if (_apiStatus.data != null) {
        PsProgressDialog.dismissDialog();

        if (_apiStatus.status == PsStatus.SUCCESS) {
          await basketProvider!.deleteWholeBasketList();

          Navigator.pop(context, true);
          await Navigator.pushNamed(context, RoutePaths.checkoutSuccess,
              arguments: CheckoutStatusIntentHolder(
                transactionHeader: _apiStatus.data!,
              ));
        } else {
          PsProgressDialog.dismissDialog();

          return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(
                  message: _apiStatus.message,
                );
              });
        }
      } else {
        PsProgressDialog.dismissDialog();

        return showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: _apiStatus.message,
              );
            });
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('error');
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, 'checkout3__payment_fail'),
          );
        });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('external wallet');
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message:
                Utils.getString(context, 'checkout3__payment_not_supported'),
          );
        });
  }

  dynamic payRazorNow() async {
    if (await Utils.checkInternetConnectivity()) {
      await calculateShippingCost();
      if (valueHolder.standardShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting:
                shippingMethodProvider!.selectedPrice == '0.0'
                    ? shippingMethodProvider!.defaultShippingPrice!
                    : shippingMethodProvider!.selectedPrice ?? '0.0');
      } else if (valueHolder.zoneShippingEnable == PsConst.ONE) {
        basketProvider!.checkoutCalculationHelper.calculate(
            basketList: widget.basketList,
            couponDiscountString: couponDiscountProvider!.couponDiscount,
            psValueHolder: valueHolder,
            shippingPriceStringFormatting: shippingCostProvider!
                .shippingCost.data!.shippingZone!.shippingCost!);
      }
      // Start Razor Payment
      final Razorpay _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      if (valueHolder.isRazorSupportMultiCurrency != null &&
          valueHolder.isRazorSupportMultiCurrency == PsConst.ONE) {
        isRazorSupportMultiCurrency = true;
      } else {
        isRazorSupportMultiCurrency = false;
      }
      print(
          '${Utils.getPriceTwoDecimal(basketProvider!.checkoutCalculationHelper.totalPrice.toString())}');
      final Map<String, Object> options = <String, Object>{
        'key': shopInfoProvider!.shopInfo.data!.razorKey!,
        'amount': (double.parse(Utils.getPriceTwoDecimal(basketProvider!
                    .checkoutCalculationHelper.totalPrice
                    .toString())) *
                100)
            .round(),
        'name': userProvider!.user.data!.userName!,
        'currency': isRazorSupportMultiCurrency
            ? shopInfoProvider!.shopInfo.data!.currencyShortForm!
            : valueHolder.defaultRazorCurrency!,
        'description': '',
        'prefill': <String, String>{
          'contact': userProvider!.user.data!.userPhone!,
          'email': userProvider!.user.data!.userEmail!
        }
      };

      if (await Utils.checkInternetConnectivity()) {
        _razorpay.open(options);
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  void payWithCash() {
    Navigator.pop(context);
    payCash();
  }

  Future<void> payWithPaypal() async {
    if (PsConfig.isDemo) {
      await callDemoWarningDialog(context);
    }
    Navigator.pop(context);
    payNow();
  }

  void payWithBank() {
    Navigator.pop(context);
    bankNow();
  }

  Future<void> payWithPayStack()async {
    Navigator.pop(context);
    payPayStack();
  }

  Future<void> payWithStripe() async {
    if (PsConfig.isDemo) {
      await callDemoWarningDialog(context);
    }
    Navigator.pop(context);
    payStripe();
  }

  Future<void> payWithRazor() async {
    if (PsConfig.isDemo) {
      await callDemoWarningDialog(context);
    }
    Navigator.pop(context);
    payRazorNow();
  }

  Future<void> payWithFlutterWave() async {
    if (PsConfig.isDemo) {
      await callDemoWarningDialog(context);
    }
    Navigator.pop(context);
    payFlutterWave();
  }

  void validate() {
    if (userEmailController.text == '' ||
        userEmailController.text.isEmpty) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'edit_profile__email_error'),
            );
          });
      return;
    } else if (shippingEmailController.text == '' ||
        shippingEmailController.text.isEmpty) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'warning_dialog__shipping_email'),
            );
          });
      return;
    } else if (billingEmailController.text == '' ||
        billingEmailController.text.isEmpty) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'Please Inuput Billing Email'),
            );
          });
      return;
    // } else if (userProvider?.user.data?.country?.id == null ||
    //     userProvider?.user.data?.country?.id == '') {
    //   showDialog<dynamic>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return ErrorDialog(
    //           message:
    //               Utils.getString(context, 'edit_profile__selected_country'),
    //         );
    //       });
    //   return;
    // } else if (userProvider?.user.data?.city?.id == null ||
    //     userProvider?.user.data?.city?.id == '') {
    //   showDialog<dynamic>(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return ErrorDialog(
    //           message: Utils.getString(context, 'error_dialog__select_city'),
    //         );
    //       });
    //   return;
    } else {
      callPayment();
    }
  }

  void callPayment() {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialogView(
              description:
                  Utils.getString(context, 'checkout_container__confirm_order'),
              leftButtonText:
                  Utils.getString(context, 'home__logout_dialog_cancel_button'),
              rightButtonText:
                  Utils.getString(context, 'home__logout_dialog_ok_button'),
              onAgreeTap: () async {
                if (paymentController.text ==
                    Utils.getString(context, 'checkout3__paypal')) {
                  payWithPaypal();
                  } else if (paymentController.text ==
                      Utils.getString(context, 'checkout3__pay_stack')) {
                    payWithPayStack();
                } else if (paymentController.text ==
                    Utils.getString(context, 'checkout3__stripe')) {
                  payWithStripe();
                } else if (paymentController.text ==
                    Utils.getString(context, 'checkout3__razor')) {
                  payWithRazor();
                } else if (paymentController.text ==
                    Utils.getString(context, 'checkout3__wave')) {
                  payWithFlutterWave();
                } else if (paymentController.text ==
                    Utils.getString(context, 'checkout3__bank')) {
                  payWithBank();
                } else if (paymentController.text ==
                    Utils.getString(context, 'checkout3__cod')) {
                  payWithCash();
                }
              });
        });
  }

  void updateCheckBox() {
    if (isCheckBoxSelect) {
      isCheckBoxSelect = false;
    } else {
      isCheckBoxSelect = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    userRepository = Provider.of<UserRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    couponDiscountRepo = Provider.of<CouponDiscountRepository>(context);
    transactionHeaderRepo = Provider.of<TransactionHeaderRepository>(context);
    shopInfoRepository = Provider.of<ShopInfoRepository>(context);
    basketRepository = Provider.of<BasketRepository>(context);
    tokenRepository = Provider.of<TokenRepository>(context);
    shippingCostRepository = Provider.of<ShippingCostRepository>(context);
    shippingMethodRepository = Provider.of<ShippingMethodRepository>(context);

    if (bindDataFirstTime) {
      currencySymbol = widget.basketList[0].product!.currencySymbol;
      paymentController.text = Utils.getString(context, 'checkout3__cod');
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider = UserProvider(
                  repo: userRepository!, psValueHolder: valueHolder);
              userProvider!
                  .getUserFromDB(userProvider!.psValueHolder!.loginUserId!);
              return userProvider!;
            }),
        ChangeNotifierProvider<CouponDiscountProvider>(
            lazy: false,
            create: (BuildContext context) {
              couponDiscountProvider =
                  CouponDiscountProvider(repo: couponDiscountRepo!);

              return couponDiscountProvider!;
            }),
        ChangeNotifierProvider<ShippingCostProvider>(
            lazy: false,
            create: (BuildContext context) {
              shippingCostProvider =
                  ShippingCostProvider(repo: shippingCostRepository!);

              return shippingCostProvider!;
            }),
        ChangeNotifierProvider<ShippingMethodProvider>(
            lazy: false,
            create: (BuildContext context) {
              shippingMethodProvider = ShippingMethodProvider(
                  repo: shippingMethodRepository!,
                  psValueHolder: valueHolder,
                  defaultShippingId: valueHolder.shippingId);
              shippingMethodProvider!.loadShippingMethodList();
              return shippingMethodProvider!;
            }),
        ChangeNotifierProvider<BasketProvider>(
            lazy: false,
            create: (BuildContext context) {
              basketProvider = BasketProvider(
                  repo: basketRepository!, psValueHolder: valueHolder);
              basketProvider!.loadBasketList();
              return basketProvider!;
            }),
        ChangeNotifierProvider<ShopInfoProvider>(
            lazy: false,
            create: (BuildContext context) {
              shopInfoProvider = ShopInfoProvider(
                  repo: shopInfoRepository!,
                  psValueHolder: valueHolder,
                  ownerCode: 'CheckoutContainerView');
              shopInfoProvider!.loadShopInfo();
              return shopInfoProvider!;
            }),
        ChangeNotifierProvider<TransactionHeaderProvider>(
            lazy: false,
            create: (BuildContext context) {
              transactionSubmitProvider = TransactionHeaderProvider(
                  repo: transactionHeaderRepo!, psValueHolder: valueHolder);

              return transactionSubmitProvider!;
            }),
        ChangeNotifierProvider<TokenProvider>(
            lazy: false,
            create: (BuildContext context) {
              tokenProvider = TokenProvider(repo: tokenRepository!);
              tokenProvider!.loadToken();
              return tokenProvider!;
            }),
      ],
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider _, Widget? child) {
        if (userProvider?.user != null && userProvider?.user.data != null) {
          if (bindDataFirstTime) {
            userEmailController.text = userProvider!.user.data!.userEmail!;
            userPhoneController.text = userProvider!.user.data!.userPhone!;

            /// Shipping Data
            shippingFirstNameController.text =
                userProvider!.user.data!.shippingFirstName!;
            shippingLastNameController.text =
                userProvider!.user.data!.shippingLastName!;
            shippingCompanyController.text =
                userProvider!.user.data!.shippingCompany!;
            shippingAddress1Controller.text =
                userProvider!.user.data!.shippingAddress_1!;
            shippingAddress2Controller.text =
                userProvider!.user.data!.shippingAddress_2!;
            shippingCountryController.text =
                userProvider!.user.data!.shippingCountry!;

            shippingStateController.text =
                userProvider!.user.data!.shippingState!;
            shippingCityController.text =
                userProvider!.user.data!.shippingCity!;

            shippingPostalCodeController.text =
                userProvider!.user.data!.shippingPostalCode!;
            shippingEmailController.text =
                userProvider!.user.data!.shippingEmail!;
            shippingPhoneController.text =
                userProvider!.user.data!.shippingPhone!;
            userProvider!.selectedCountry = userProvider!.user.data!.country;
            userProvider!.selectedCity = userProvider!.user.data!.city;

            /// Billing Data
            billingFirstNameController.text =
                userProvider!.user.data!.billingFirstName!;
            billingLastNameController.text =
                userProvider!.user.data!.billingLastName!;
            billingEmailController.text =
                userProvider!.user.data!.billingEmail!;
            billingPhoneController.text =
                userProvider!.user.data!.billingPhone!;
            billingCompanyController.text =
                userProvider!.user.data!.billingCompany!;
            billingAddress1Controller.text =
                userProvider!.user.data!.billingAddress_1!;
            billingAddress2Controller.text =
                userProvider!.user.data!.billingAddress_2!;
            billingCountryController.text =
                userProvider!.user.data!.billingCountry!;
            billingStateController.text =
                userProvider!.user.data!.billingState!;
            billingCityController.text = userProvider!.user.data!.billingCity!;
            billingPostalCodeController.text =
                userProvider!.user.data!.billingPostalCode!;
            calculateShippingCostTotal();
          }
          return SingleChildScrollView(
            child: Container(
              color: PsColors.coreBackgroundColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _BillingWidget(
                      user: userProvider!.user.data!,
                      userEmailController: userEmailController,
                      userPhoneController: userPhoneController,
                      updateUserData: updateUserData,
                    ),
                    const SizedBox(height: PsDimens.space2),
                    _ShippingAddress(
                      address1Controller: shippingAddress1Controller,
                      address2Controller: shippingAddress2Controller,
                      firstNameController: shippingFirstNameController,
                      lastNameController: shippingLastNameController,
                      emailController: shippingEmailController,
                      phoneController: shippingPhoneController,
                      companyController: shippingCompanyController,
                      cityController: shippingCityController,
                      countryController: shippingCountryController,
                      postalCodeController: shippingPostalCodeController,
                      stateController: shippingStateController,
                      userProvider: userProvider!,
                      updateUserData: updateUserData,
                    ),
                    _BillingAddress(
                      address1Controller: billingAddress1Controller,
                      address2Controller: billingAddress2Controller,
                      firstNameController: billingFirstNameController,
                      lastNameController: billingLastNameController,
                      emailController: billingEmailController,
                      phoneController: billingPhoneController,
                      companyController: billingCompanyController,
                      cityController: billingCityController,
                      countryController: billingCountryController,
                      postalCodeController: billingPostalCodeController,
                      stateController: billingStateController,
                      userProvider: userProvider!,
                      shippingAddress1Controller: shippingAddress1Controller,
                      shippingCompanyController: shippingCompanyController,
                      shippingLastNameController: shippingLastNameController,
                      shippingAddress2Controller: shippingAddress2Controller,
                      shippingCityController: shippingCityController,
                      shippingCountryController: shippingCountryController,
                      shippingEmailController: shippingEmailController,
                      shippingFirstNameController: shippingFirstNameController,
                      shippingPhoneController: shippingPhoneController,
                      shippingPostalCodeController:
                          shippingPostalCodeController,
                      shippingStateController: shippingStateController,
                      updateUserData: updateUserData,
                    ),
                    _OrderPaymentWidget(
                      userProvider: userProvider!,
                      paymentController: paymentController,
                    ),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'checkout3__memo'),
                        height: PsDimens.space80,
                        textAboutMe: true,
                        hintText: Utils.getString(context, 'checkout3__memo'),
                        keyboardType: TextInputType.multiline,
                        textEditingController: memoController),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                            child: PsTextFieldWidget(
                          hintText:
                              Utils.getString(context, 'checkout__coupon_code'),
                          textEditingController: couponController,
                          showTitle: false,
                        )),
                        Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: PsDimens.space8),
                          child: PSButtonWidget(
                            titleText: Utils.getString(
                                context, 'checkout__claim_button_name'),
                            onPressed: () async {
                              if (couponController.text.isNotEmpty) {
                                final CouponDiscountParameterHolder
                                    couponDiscountParameterHolder =
                                    CouponDiscountParameterHolder(
                                  couponCode: couponController.text,
                                );

                                final PsResource<CouponDiscount> _apiStatus =
                                    await couponDiscountProvider!
                                        .postCouponDiscount(
                                            couponDiscountParameterHolder
                                                .toMap());

                                if (_apiStatus.data != null &&
                                    couponController.text ==
                                        _apiStatus.data!.couponCode) {
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SuccessDialog(
                                          message: Utils.getString(context,
                                              'checkout__couponcode_add_dialog_message'),
                                        );
                                      });

                                  couponController.clear();
                                  print(_apiStatus.data!.couponAmount);
                                  setState(() {
                                    couponDiscountProvider!.couponDiscount =
                                        _apiStatus.data!.couponAmount!;
                                  });
                                } else {
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ErrorDialog(
                                          message: _apiStatus.message,
                                        );
                                      });
                                }
                              } else {
                                showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return WarningDialog(
                                        message: Utils.getString(context,
                                            'checkout__warning_dialog_message'),
                                        onPressed: () {},
                                      );
                                    });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          activeColor: PsColors.mainColor,
                          value: isCheckBoxSelect,
                          onChanged: (bool? value) {
                            setState(() {
                              updateCheckBox();
                            });
                          },
                        ),
                        Expanded(
                          child: InkWell(
                            child: Text(
                              Utils.getString(
                                  context, 'checkout3__agree_policy'),
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 2,
                            ),
                            onTap: () {
                              setState(() {
                                updateCheckBox();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PsDimens.space24),
                    _CheckoutButtonWidget(
                      basketList: widget.basketList,
                      isCheckBoxSelect: isCheckBoxSelect,
                      onTap: validate,
                      currencySymbol: currencySymbol!,
                      basketTotalPrice:
                          basketProvider!.checkoutCalculationHelper.totalPrice,
                    )
                  ]),
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }
}

class _BillingWidget extends StatefulWidget {
  const _BillingWidget({
    Key? key,
    required this.user,
    required this.userEmailController,
    required this.userPhoneController,
    required this.updateUserData,
  }) : super(key: key);

  final User user;
  final TextEditingController userEmailController;
  final TextEditingController userPhoneController;
  final Function() updateUserData;

  @override
  __BillingWidgetViewState createState() => __BillingWidgetViewState();
}

class __BillingWidgetViewState extends State<_BillingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final dynamic result = await Navigator.pushNamed(
            context, RoutePaths.billingTo,
            arguments: BillingToIntentHolder(
                userEmail: widget.userEmailController.text,
                userPhoneNo: widget.userPhoneController.text));
        if (result != null && result is BillingToCallBackHolder) {
          setState(() {
            widget.userEmailController.text = result.userEmail;
            widget.userPhoneController.text = result.userPhoneNo;
          });
          widget.updateUserData();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'checkout_one_page__billing_to'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    widget.userEmailController.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: PsDimens.space4,
                  ),
                  Text(
                    widget.userPhoneController.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Text(
                Utils.getString(context, 'checkout_one_page__edit'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillingAddress extends StatefulWidget {
  const _BillingAddress({
    Key? key,
    required this.address1Controller,
    required this.address2Controller,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.companyController,
    required this.cityController,
    required this.countryController,
    required this.postalCodeController,
    required this.stateController,
    required this.userProvider,
    required this.shippingAddress1Controller,
    required this.shippingAddress2Controller,
    required this.shippingCityController,
    required this.shippingCompanyController,
    required this.shippingCountryController,
    required this.shippingEmailController,
    required this.shippingFirstNameController,
    required this.shippingLastNameController,
    required this.shippingPhoneController,
    required this.shippingPostalCodeController,
    required this.shippingStateController,
    required this.updateUserData,
  }) : super(key: key);
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController companyController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController countryController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final TextEditingController shippingFirstNameController;
  final TextEditingController shippingLastNameController;
  final TextEditingController shippingEmailController;
  final TextEditingController shippingPhoneController;
  final TextEditingController shippingCompanyController;
  final TextEditingController shippingAddress1Controller;
  final TextEditingController shippingAddress2Controller;
  final TextEditingController shippingCountryController;
  final TextEditingController shippingStateController;
  final TextEditingController shippingCityController;
  final TextEditingController shippingPostalCodeController;
  final UserProvider userProvider;
  final Function() updateUserData;
  @override
  State<_BillingAddress> createState() => __BillingAddressState();
}

class __BillingAddressState extends State<_BillingAddress> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final dynamic result =
            await Navigator.pushNamed(context, RoutePaths.billingAddress,
                arguments: AddressIntentHolder(
                  firstName: widget.firstNameController.text,
                  lastName: widget.lastNameController.text,
                  email: widget.emailController.text,
                  phone: widget.phoneController.text,
                  address1: widget.address1Controller.text,
                  address2: widget.address2Controller.text,
                  company: widget.companyController.text,
                  city: widget.cityController.text,
                  country: widget.countryController.text,
                  postalCode: widget.postalCodeController.text,
                  state: widget.stateController.text,
                  userProvider: widget.userProvider,
                  shippingAddress1: widget.shippingAddress1Controller.text,
                  shippingAddress2: widget.shippingAddress2Controller.text,
                  shippingCity: widget.shippingCityController.text,
                  shippingCompany: widget.shippingCompanyController.text,
                  shippingCountry: widget.shippingCountryController.text,
                  shippingFirstName: widget.shippingFirstNameController.text,
                  shippingLastName: widget.shippingLastNameController.text,
                  shippingPostalCode: widget.shippingPostalCodeController.text,
                  shippingState: widget.shippingStateController.text,
                  shippingPhone: widget.shippingPhoneController.text,
                  shippingEmail: widget.shippingEmailController.text,
                ));
        if (result != null && result is AddressCallBackHolder) {
          setState(() {
            widget.firstNameController.text = result.firstName;
            widget.lastNameController.text = result.lastName;
            widget.emailController.text = result.email;
            widget.phoneController.text = result.phone;
            widget.address1Controller.text = result.address1;
            widget.address2Controller.text = result.address2;
            widget.companyController.text = result.company;
            widget.cityController.text = result.city;
            widget.countryController.text = result.country;
            widget.postalCodeController.text = result.postalCode;
            widget.stateController.text = result.state;
            widget.userProvider.useShippingAddressAsBillingAddress =
                result.userProvider.useShippingAddressAsBillingAddress;
          });
          widget.updateUserData();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(
                        context, 'checkout_one_page__billing_address'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    'Tap to See Billing Address Details',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: PsDimens.space4,
                  ),
                  // Text(
                  //   widget.userPhoneController.text,
                  //   style: Theme.of(context).textTheme.bodyLarge,
                  // ),
                ],
              ),
              Text(
                Utils.getString(context, 'checkout_one_page__edit'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShippingAddress extends StatefulWidget {
  const _ShippingAddress({
    Key? key,
    required this.address1Controller,
    required this.address2Controller,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.companyController,
    required this.cityController,
    required this.countryController,
    required this.postalCodeController,
    required this.stateController,
    required this.userProvider,
    required this.updateUserData,
  }) : super(key: key);
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController companyController;
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController countryController;
  final TextEditingController stateController;
  final TextEditingController cityController;
  final TextEditingController postalCodeController;
  final UserProvider userProvider;
  final Function() updateUserData;
  @override
  State<_ShippingAddress> createState() => __ShippingAddressState();
}

class __ShippingAddressState extends State<_ShippingAddress> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final dynamic result =
            await Navigator.pushNamed(context, RoutePaths.shippingAddress,
                arguments: AddressIntentHolder(
                  firstName: widget.firstNameController.text,
                  lastName: widget.lastNameController.text,
                  email: widget.emailController.text,
                  phone: widget.phoneController.text,
                  address1: widget.address1Controller.text,
                  address2: widget.address2Controller.text,
                  company: widget.companyController.text,
                  city: widget.cityController.text,
                  country: widget.countryController.text,
                  postalCode: widget.postalCodeController.text,
                  state: widget.stateController.text,
                  userProvider: widget.userProvider,
                ));
        if (result != null && result is AddressCallBackHolder) {
          setState(() {
            widget.firstNameController.text = result.firstName;
            widget.lastNameController.text = result.lastName;
            widget.emailController.text = result.email;
            widget.phoneController.text = result.phone;
            widget.address1Controller.text = result.address1;
            widget.address2Controller.text = result.address2;
            widget.companyController.text = result.company;
            widget.cityController.text = result.city;
            widget.countryController.text = result.country;
            widget.postalCodeController.text = result.postalCode;
            widget.stateController.text = result.state;
            widget.updateUserData();
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(
                        context, 'checkout_one_page__shipping_address'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    'Tap to See Shipping Address Details',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: PsDimens.space4,
                  ),
                  // Text(
                  //   widget.userPhoneController.text,
                  //   style: Theme.of(context).textTheme.bodyLarge,
                  // ),
                ],
              ),
              Text(
                Utils.getString(context, 'checkout_one_page__edit'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderPaymentWidget extends StatefulWidget {
  const _OrderPaymentWidget({
    Key? key,
    required this.userProvider,
    required this.paymentController,
  }) : super(key: key);

  final UserProvider userProvider;
  final TextEditingController paymentController;

  @override
  State<_OrderPaymentWidget> createState() => _OrderPaymentWidgetState();
}

class _OrderPaymentWidgetState extends State<_OrderPaymentWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.userProvider.isClickWeeklyButton &&
        widget.userProvider.isClickPickUpButton) {
      setState(() {
        widget.paymentController.text =
            Utils.getString(context, 'checkout3__pick_up');
        widget.userProvider.isCash = true;
      });
    } else if (widget.userProvider.isClickWeeklyButton &&
        widget.userProvider.isClickDeliveryButton) {
      setState(() {
        widget.paymentController.text =
            Utils.getString(context, 'checkout3__cod');
        widget.userProvider.isCash = true;
      });
    }
    return InkWell(
      onTap: () async {
        if (widget.userProvider.isClickPickUpButton) {
          widget.userProvider.isCash = false;
        }
        final dynamic result = await Navigator.pushNamed(
          context,
          RoutePaths.paymentMethod,
          arguments: PaymentIntentHolder(userProvider: widget.userProvider),
        );
        if (result != null && result is PaymentCallBackHolder) {
          setState(() {
            widget.userProvider.isCash = result.isCash;
            if (result.isCash && widget.userProvider.isClickPickUpButton) {
              widget.paymentController.text =
                  Utils.getString(context, 'checkout3__pick_up');
            } else if (result.isCash &&
                widget.userProvider.isClickDeliveryButton) {
              widget.paymentController.text =
                  Utils.getString(context, 'checkout3__cod');
            } else {
              widget.paymentController.text =
                  Utils.getString(context, result.payment);
            }
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(PsDimens.space12),
        child: Ink(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(
                        context, 'checkout_one_page__payment_method'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                  Text(
                    widget.paymentController.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: PsDimens.space8,
                  ),
                ],
              ),
              Text(
                Utils.getString(context, 'checkout_one_page__edit'),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: PsColors.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutButtonWidget extends StatelessWidget {
  const _CheckoutButtonWidget({
    Key? key,
    required this.basketList,
    required this.isCheckBoxSelect,
    required this.onTap,
    required this.basketTotalPrice,
    required this.currencySymbol,
  }) : super(key: key);

  final List<Basket> basketList;
  final bool isCheckBoxSelect;
  final Function onTap;
  final double basketTotalPrice;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);

    return Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.all(PsDimens.space8),
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          border: Border.all(color: PsColors.mainLightShadowColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(PsDimens.space12),
              topRight: Radius.circular(PsDimens.space12)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: PsColors.mainShadowColor,
                offset: const Offset(1.1, 1.1),
                blurRadius: 7.0),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: PsDimens.space8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  Utils.getString(context, 'whatsapp__view_order'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${Utils.getString(context, 'checkout__total')} ${Utils.getPriceFormat(basketTotalPrice.toString(), psValueHolder)} $currencySymbol',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: PsDimens.space8),
            Card(
              elevation: 0,
              color: PsColors.mainColor,
              shape: const BeveledRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(PsDimens.space8))),
              child: InkWell(
                onTap: () async {
                  if (isCheckBoxSelect) {
                    onTap();
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return WarningDialog(
                            message: Utils.getString(context,
                                'checkout_container__agree_term_and_con'),
                            onPressed: () {},
                          );
                        });
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: const EdgeInsets.only(
                        left: PsDimens.space4, right: PsDimens.space4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                        PsColors.mainColor,
                        PsColors.mainDarkColor,
                      ]),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(PsDimens.space12)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: PsColors.mainColorWithBlack.withOpacity(0.6),
                            offset: const Offset(0, 4),
                            blurRadius: 8.0,
                            spreadRadius: 3.0),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Utils.getString(
                              context, 'basket_list__checkout_button_name'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: PsColors.white),
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(height: PsDimens.space8),
          ],
        ));
  }
}
