import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/api/common/ps_status.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/basket/basket_provider.dart';
import 'package:flutterstore/provider/coupon_discount/coupon_discount_provider.dart';
import 'package:flutterstore/provider/shipping_cost/shipping_cost_provider.dart';
import 'package:flutterstore/provider/shipping_method/shipping_method_provider.dart';
import 'package:flutterstore/provider/shop_info/shop_info_provider.dart';
import 'package:flutterstore/provider/token/token_provider.dart';
import 'package:flutterstore/provider/transaction/transaction_header_provider.dart';
import 'package:flutterstore/provider/user/user_provider.dart';
import 'package:flutterstore/ui/common/dialog/error_dialog.dart';
import 'package:flutterstore/ui/common/ps_textfield_widget.dart';
import 'package:flutterstore/utils/ps_progress_dialog.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/basket.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/intent_holder/checkout_status_intent_holder.dart';
import 'package:flutterstore/viewobject/transaction_header.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Checkout3View extends StatefulWidget {
  const Checkout3View(this.updateCheckout3ViewState, this.basketList);

  final Function updateCheckout3ViewState;

  final List<Basket> basketList;

  @override
  _Checkout3ViewState createState() {
    final _Checkout3ViewState _state = _Checkout3ViewState();
    updateCheckout3ViewState(_state);
    return _state;
  }
}

class _Checkout3ViewState extends State<Checkout3View> {
  bool isCheckBoxSelect = false;
  bool isCashClicked = false;
  bool isPaypalClicked = false;
  bool isStripeClicked = false;
  bool isBankClicked = false;
  bool isRazorClicked = false;
  bool isPayStackClicked = false;
  bool isFlutterWaveClicked = false;
  bool isRazorSupportMultiCurrency = false;

  late PsValueHolder valueHolder;
  ShippingMethodProvider? shippingMethodProvider;
  CouponDiscountProvider? couponDiscountProvider;
  ShippingCostProvider? shippingCostProvider;
  BasketProvider? basketProvider;
  final TextEditingController? memoController = TextEditingController();

  void checkStatus() {
    print('Checking Status ... $isCheckBoxSelect');
  }

  dynamic callBankNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    ShippingMethodProvider shippingMethodProvider,
  ) async {
    if (await Utils.checkInternetConnectivity()) {
      if (userLoginProvider.user.data != null) {
        await PsProgressDialog.showDialog(context);
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider.postTransactionSubmit(
                userLoginProvider.user.data!,
                widget.basketList,
                '',
                couponDiscountProvider!.couponDiscount.toString(),
                basketProvider.checkoutCalculationHelper.tax.toString(),
                basketProvider.checkoutCalculationHelper.totalDiscount
                    .toString(),
                basketProvider.checkoutCalculationHelper.subTotalPrice
                    .toString(),
                basketProvider.checkoutCalculationHelper.shippingTax.toString(),
                basketProvider.checkoutCalculationHelper.totalPrice.toString(),
                basketProvider.checkoutCalculationHelper.totalOriginalPrice
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
                basketProvider.checkoutCalculationHelper.shippingCost
                    .toString(),
                (shippingMethodProvider.selectedShippingName == null)
                    ? shippingMethodProvider.defaultShippingName!
                    : shippingMethodProvider.selectedShippingName!,
                memoController!.text);

        if (_apiStatus.data != null) {
          PsProgressDialog.dismissDialog();

          await basketProvider.deleteWholeBasketList();
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

  dynamic callCardNow(
    BasketProvider basketProvider,
    UserProvider userLoginProvider,
    TransactionHeaderProvider transactionSubmitProvider,
    ShippingMethodProvider shippingMethodProvider,
  ) async {
    if (await Utils.checkInternetConnectivity()) {
      if (userLoginProvider.user.data != null) {
        await PsProgressDialog.showDialog(context);
        print(basketProvider
            .checkoutCalculationHelper.subTotalPriceFormattedString);
        final PsResource<TransactionHeader> _apiStatus =
            await transactionSubmitProvider.postTransactionSubmit(
                userLoginProvider.user.data!,
                widget.basketList,
                '',
                couponDiscountProvider!.couponDiscount.toString(),
                basketProvider.checkoutCalculationHelper.tax.toString(),
                basketProvider.checkoutCalculationHelper.totalDiscount
                    .toString(),
                basketProvider.checkoutCalculationHelper.subTotalPrice
                    .toString(),
                basketProvider.checkoutCalculationHelper.shippingTax.toString(),
                basketProvider.checkoutCalculationHelper.totalPrice.toString(),
                basketProvider.checkoutCalculationHelper.totalOriginalPrice
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
                basketProvider.checkoutCalculationHelper.shippingCost
                    .toString(),
                (shippingMethodProvider.selectedShippingName == null)
                    ? shippingMethodProvider.defaultShippingName!
                    : shippingMethodProvider.selectedShippingName!,
                memoController!.text);

        if (_apiStatus.data != null) {
          PsProgressDialog.dismissDialog();
          await basketProvider.deleteWholeBasketList();
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

  dynamic payRazorNow(
      UserProvider userProvider,
      TransactionHeaderProvider transactionSubmitProvider,
      CouponDiscountProvider couponDiscountProvider,
      PsValueHolder psValueHolder,
      BasketProvider basketProvider) async {
    if (psValueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider!.selectedPrice == '0.0'
                  ? shippingMethodProvider!.defaultShippingPrice!
                  : shippingMethodProvider!.selectedPrice ?? '0.0');
    } else if (psValueHolder.zoneShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting: shippingCostProvider!
              .shippingCost.data!.shippingZone!.shippingCost!);
    }

    final ShopInfoProvider _shopInfoProvider =
        Provider.of<ShopInfoProvider>(context, listen: false);
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
        '${Utils.getPriceTwoDecimal(basketProvider.checkoutCalculationHelper.totalPrice.toString())}');
    final Map<String, Object> options = <String, Object>{
      'key': _shopInfoProvider.shopInfo.data!.razorKey!,
      'amount': (double.parse(Utils.getPriceTwoDecimal(basketProvider
                  .checkoutCalculationHelper.totalPrice
                  .toString())) *
              100)
          .round(),
      'name': userProvider.user.data!.userName!,
      'currency': isRazorSupportMultiCurrency
          ? _shopInfoProvider.shopInfo.data!.currencyShortForm!
          : psValueHolder.defaultRazorCurrency!,
      'description': '',
      'prefill': <String, String>{
        'contact': userProvider.user.data!.userPhone!,
        'email': userProvider.user.data!.userEmail!
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
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    print('success');

    print(response);

    await PsProgressDialog.showDialog(context);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final TransactionHeaderProvider transactionSubmitProvider =
        Provider.of<TransactionHeaderProvider>(context, listen: false);
    final BasketProvider basketProvider =
        Provider.of<BasketProvider>(context, listen: false);
    if (userProvider.user.data != null) {
      final PsResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider.postTransactionSubmit(
              userProvider.user.data!,
              widget.basketList,
              '',
              couponDiscountProvider!.couponDiscount.toString(),
              basketProvider.checkoutCalculationHelper.tax.toString(),
              basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
              basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
              basketProvider.checkoutCalculationHelper.shippingTax.toString(),
              basketProvider.checkoutCalculationHelper.totalPrice.toString(),
              basketProvider.checkoutCalculationHelper.totalOriginalPrice
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
              basketProvider.checkoutCalculationHelper.shippingCost.toString(),
              (shippingMethodProvider!.selectedShippingName == null)
                  ? shippingMethodProvider!.defaultShippingName!
                  : shippingMethodProvider!.selectedShippingName!,
              memoController!.text);

      if (_apiStatus.data != null) {
        PsProgressDialog.dismissDialog();

        if (_apiStatus.status == PsStatus.SUCCESS) {
          await basketProvider.deleteWholeBasketList();

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

  dynamic payFlutterWave(
      UserProvider userProvider,
      TransactionHeaderProvider transactionSubmitProvider,
      CouponDiscountProvider couponDiscountProvider,
      PsValueHolder psValueHolder,
      BasketProvider basketProvider) async {
    if (psValueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider!.selectedPrice == '0.0'
                  ? shippingMethodProvider!.defaultShippingPrice!
                  : shippingMethodProvider!.selectedPrice ?? '0.0');
    } else if (psValueHolder.zoneShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting: shippingCostProvider!
              .shippingCost.data!.shippingZone!.shippingCost!);
    }

    final ShopInfoProvider shopInfoProvider =
        Provider.of<ShopInfoProvider>(context, listen: false);

    final String amount = Utils.getPriceTwoDecimal(
        basketProvider.checkoutCalculationHelper.totalPrice.toString());

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
        name: userProvider.user.data!.userName!,
        phoneNumber: userProvider.user.data!.userPhone!,
        email: userProvider.user.data!.userEmail!);

    final Flutterwave flutterwave = Flutterwave(
      redirectUrl: 'https://google.com' ,
      context: context,
      // style: style,
      publicKey: shopInfoProvider.shopInfo.data!.flutterWavePublishableKey!,
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
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleWavePaymentSuccess(String transactionId) async {
    // Do something when payment succeeds
    print('success');

    print(transactionId);

    await PsProgressDialog.showDialog(context);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    final TransactionHeaderProvider transactionSubmitProvider =
        Provider.of<TransactionHeaderProvider>(context, listen: false);
    final BasketProvider basketProvider =
        Provider.of<BasketProvider>(context, listen: false);
    if (userProvider.user.data != null) {
      final PsResource<TransactionHeader> _apiStatus =
          await transactionSubmitProvider.postTransactionSubmit(
              userProvider.user.data!,
              widget.basketList,
              '',
              couponDiscountProvider!.couponDiscount.toString(),
              basketProvider.checkoutCalculationHelper.tax.toString(),
              basketProvider.checkoutCalculationHelper.totalDiscount.toString(),
              basketProvider.checkoutCalculationHelper.subTotalPrice.toString(),
              basketProvider.checkoutCalculationHelper.shippingTax.toString(),
              basketProvider.checkoutCalculationHelper.totalPrice.toString(),
              basketProvider.checkoutCalculationHelper.totalOriginalPrice
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
              basketProvider.checkoutCalculationHelper.shippingCost.toString(),
              (shippingMethodProvider!.selectedShippingName == null)
                  ? shippingMethodProvider!.defaultShippingName!
                  : shippingMethodProvider!.selectedShippingName!,
              memoController!.text);

      if (_apiStatus.data != null) {
        PsProgressDialog.dismissDialog();

        if (_apiStatus.status == PsStatus.SUCCESS) {
          await basketProvider.deleteWholeBasketList();

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

  dynamic payNow(
      String clientNonce,
      UserProvider userProvider,
      TransactionHeaderProvider transactionSubmitProvider,
      CouponDiscountProvider couponDiscountProvider,
      ShippingMethodProvider shippingMethodProvider,
      ShippingCostProvider shippingCostProvider,
      PsValueHolder psValueHolder,
      BasketProvider basketProvider) async {
    final ShopInfoProvider shopInfoProvider =
        Provider.of<ShopInfoProvider>(context, listen: false);

    if (psValueHolder.standardShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting:
              shippingMethodProvider.selectedPrice == '0.0'
                  ? shippingMethodProvider.defaultShippingPrice!
                  : shippingMethodProvider.selectedPrice ?? '0.0');
    } else if (psValueHolder.zoneShippingEnable == PsConst.ONE) {
      basketProvider.checkoutCalculationHelper.calculate(
          basketList: widget.basketList,
          couponDiscountString: couponDiscountProvider.couponDiscount,
          psValueHolder: psValueHolder,
          shippingPriceStringFormatting: shippingCostProvider
              .shippingCost.data!.shippingZone!.shippingCost!);
    }

    // final BraintreePayment braintreePayment = BraintreePayment();
    // final dynamic data = await braintreePayment.showDropIn(
    //     nonce: clientNonce,
    //     amount:
    //         basketProvider.checkoutCalculationHelper.totalPriceFormattedString,
    //     enableGooglePay: true);
    // print('${Utils.getString(context, 'checkout__payment_response')} $data');

    final BraintreeDropInRequest request = BraintreeDropInRequest(
      clientToken: clientNonce,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice:
            basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        currencyCode: shopInfoProvider.shopInfo.data!.currencyShortForm!,
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: basketProvider.checkoutCalculationHelper.totalPrice.toString(),
        displayName: userProvider.user.data!.userName,
      ),
    );

    final BraintreeDropInResult? result = await BraintreeDropIn.start(request);
    if (result != null) {
      print('Nonce: ${result.paymentMethodNonce.nonce}');
    } else {
      print('Selection was canceled.');
    }

    if (await Utils.checkInternetConnectivity()) {
      // ignore: unnecessary_null_comparison
      if (result?.paymentMethodNonce.nonce != null) {
        await PsProgressDialog.showDialog(context);

        if (userProvider.user.data != null && result != null) {
          final PsResource<TransactionHeader> _apiStatus =
              await transactionSubmitProvider.postTransactionSubmit(
                  userProvider.user.data!,
                  widget.basketList,
                  result.paymentMethodNonce.nonce,
                  couponDiscountProvider.couponDiscount.toString(),
                  basketProvider.checkoutCalculationHelper.tax.toString(),
                  basketProvider.checkoutCalculationHelper.totalDiscount
                      .toString(),
                  basketProvider.checkoutCalculationHelper.subTotalPrice
                      .toString(),
                  basketProvider.checkoutCalculationHelper.shippingTax
                      .toString(),
                  basketProvider.checkoutCalculationHelper.totalPrice
                      .toString(),
                  basketProvider.checkoutCalculationHelper.totalOriginalPrice
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
                  basketProvider.checkoutCalculationHelper.shippingCost
                      .toString(),
                  (shippingMethodProvider.selectedShippingName == null)
                      ? shippingMethodProvider.defaultShippingName!
                      : shippingMethodProvider.selectedShippingName!,
                  memoController!.text);

          if (_apiStatus.data != null) {
            PsProgressDialog.dismissDialog();

            if (_apiStatus.status == PsStatus.SUCCESS) {
              await basketProvider.deleteWholeBasketList();

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
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    return Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
        TransactionHeaderProvider transactionHeaderProvider, Widget? child) {
      return Consumer<BasketProvider>(builder:
          (BuildContext context, BasketProvider basketProvider, Widget? child) {
        return Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider userProvider, Widget? child) {
          return Consumer<TokenProvider>(builder: (BuildContext context,
              TokenProvider tokenProvider, Widget? child) {
            // if (tokenProvider.tokenData != null &&
            //     tokenProvider.tokenData.data != null &&
            //     tokenProvider.tokenData.data.message != null) {
            couponDiscountProvider = Provider.of<CouponDiscountProvider>(
                context,
                listen: false); // Listen : False is important.
            shippingCostProvider = Provider.of<ShippingCostProvider>(context,
                listen: false); // Listen : False is important.
            shippingMethodProvider = Provider.of<ShippingMethodProvider>(
                context,
                listen: false); // Listen : False is important.
            basketProvider = Provider.of<BasketProvider>(context,
                listen: false); // Listen : False is important.

            return SingleChildScrollView(
              child: Container(
                color: PsColors.backgroundColor,
                padding: const EdgeInsets.only(
                  left: PsDimens.space12,
                  right: PsDimens.space12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space16,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16, right: PsDimens.space16),
                      child: Text(
                        Utils.getString(context, 'checkout3__payment_method'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(
                      height: PsDimens.space16,
                    ),
                    const Divider(
                      height: 2,
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Consumer<ShopInfoProvider>(builder: (BuildContext context,
                        ShopInfoProvider shopInfoProvider, Widget? child) {
                      if (shopInfoProvider.shopInfo.data == null) {
                        return Container();
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Visibility(
                              visible:
                                  shopInfoProvider.shopInfo.data!.codEnabled ==
                                      '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isCashClicked) {
                                      isCashClicked = true;
                                      isPaypalClicked = false;
                                      isStripeClicked = false;
                                      isBankClicked = false;
                                      isRazorClicked = false;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsCashSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.paypalEnabled ==
                                  '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isPaypalClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = true;
                                      isStripeClicked = false;
                                      isBankClicked = false;
                                      isRazorClicked = false;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsPaypalSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.stripeEnabled ==
                                  '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () async {
                                    if (!isStripeClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = false;
                                      isStripeClicked = true;
                                      isBankClicked = false;
                                      isRazorClicked = false;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsStripeSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.banktransferEnabled ==
                                  '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isBankClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = false;
                                      isStripeClicked = false;
                                      isBankClicked = true;
                                      isRazorClicked = false;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsBankSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.razorEnabled ==
                                  '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isRazorClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = false;
                                      isStripeClicked = false;
                                      isBankClicked = false;
                                      isRazorClicked = true;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsRazorSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.payStackEnabled ==
                                  PsConst.ONE,
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isPayStackClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = false;
                                      isStripeClicked = false;
                                      isBankClicked = false;
                                      isRazorClicked = false;
                                      isPayStackClicked = true;
                                      isFlutterWaveClicked = false;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsPayStackSelected(),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: shopInfoProvider
                                      .shopInfo.data!.flutterWaveEnabled ==
                                  '1',
                              child: Container(
                                width: PsDimens.space140,
                                height: PsDimens.space140,
                                padding: const EdgeInsets.all(PsDimens.space8),
                                child: InkWell(
                                  onTap: () {
                                    if (!isFlutterWaveClicked) {
                                      isCashClicked = false;
                                      isPaypalClicked = false;
                                      isStripeClicked = false;
                                      isBankClicked = false;
                                      isRazorClicked = false;
                                      isPayStackClicked = false;
                                      isFlutterWaveClicked = true;
                                    }

                                    setState(() {});
                                  },
                                  child: checkIsWaveSelected(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(
                      height: PsDimens.space12,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space16, right: PsDimens.space16),
                      child: showOrHideCashText(),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    PsTextFieldWidget(
                        titleText: Utils.getString(context, 'checkout3__memo'),
                        height: PsDimens.space80,
                        textAboutMe: true,
                        hintText: Utils.getString(context, 'checkout3__memo'),
                        keyboardType: TextInputType.multiline,
                        textEditingController: memoController!),
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
                    const SizedBox(
                      height: PsDimens.space60,
                    ),
                  ],
                ),
              ),
            );
            // } else {
            //   return Container();
            // }
          });
        });
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

  Widget checkIsCashSelected() {
    if (!isCashClicked) {
      return changeCashCardToWhite();
    } else {
      return changeCashCardToOrange();
    }
  }

  Widget changeCashCardToWhite() {
    return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                  width: 50, height: 50, child: const Icon(Icons.payment)),
              Container(
                margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                ),
                child: Text(Utils.getString(context, 'checkout3__cod'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget changeCashCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.payment,
                  color: PsColors.white,
                )),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__cod'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsPaypalSelected() {
    if (!isPaypalClicked) {
      return changePaypalCardToWhite();
    } else {
      return changePaypalCardToOrange();
    }
  }

  Widget changePaypalCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(FontAwesome5.paypal, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__paypal'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePaypalCardToWhite() {
    return Container(
        width: PsDimens.space140,
        child: Container(
          decoration: BoxDecoration(
            color: PsColors.coreBackgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: PsDimens.space4,
              ),
              Container(
                  width: 50,
                  height: 50,
                  child: const Icon(FontAwesome5.paypal)),
              Container(
                margin: const EdgeInsets.only(
                  left: PsDimens.space16,
                  right: PsDimens.space16,
                ),
                child: Text(Utils.getString(context, 'checkout3__paypal'),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(height: 1.3)),
              ),
            ],
          ),
        ));
  }

  Widget checkIsStripeSelected() {
    if (!isStripeClicked) {
      return changeStripeCardToWhite();
    } else {
      return changeStripeCardToOrange();
    }
  }

  Widget changeStripeCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeStripeCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
              ),
              child: Text(Utils.getString(context, 'checkout3__stripe'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsBankSelected() {
    if (!isBankClicked) {
      return changeBankCardToWhite();
    } else {
      return changeBankCardToOrange();
    }
  }

  Widget changeBankCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeBankCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__bank'),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsRazorSelected() {
    if (!isRazorClicked) {
      return changeRazorCardToWhite();
    } else {
      return changeRazorCardToOrange();
    }
  }

  Widget checkIsPayStackSelected() {
    if (!isPayStackClicked) {
      return changePayStackCardToWhite();
    } else {
      return changePayStackCardToOrange();
    }
  }

  Widget changeRazorCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__razor'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeRazorCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__razor'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePayStackCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(
                width: 50,
                height: 50,
                child: Icon(Icons.payment, color: PsColors.white)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__pay_stack'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePayStackCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__pay_stack'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkIsWaveSelected() {
    if (!isFlutterWaveClicked) {
      return changeWaveCardToWhite();
    } else {
      return changeWaveCardToOrange();
    }
  }

  Widget changeWaveCardToOrange() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.mainColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__wave'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3, color: PsColors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget changeWaveCardToWhite() {
    return Container(
      width: PsDimens.space140,
      child: Container(
        decoration: BoxDecoration(
          color: PsColors.coreBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: PsDimens.space4,
            ),
            Container(width: 50, height: 50, child: const Icon(Icons.payment)),
            Container(
              margin: const EdgeInsets.only(
                  left: PsDimens.space16, right: PsDimens.space16),
              child: Text(Utils.getString(context, 'checkout3__wave'),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }

  Widget? showOrHideCashText() {
    if (isCashClicked) {
      return Text(Utils.getString(context, 'checkout3__cod_message'),
          style: Theme.of(context).textTheme.bodyMedium);
    } else {
      return null;
    }
  }
}
