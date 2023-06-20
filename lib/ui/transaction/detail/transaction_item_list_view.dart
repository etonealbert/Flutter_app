import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/api/common/ps_resource.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/provider/transaction/transaction_detail_provider.dart';
import 'package:flutterstore/provider/transaction/transaction_header_provider.dart';
import 'package:flutterstore/repository/tansaction_detail_repository.dart';
import 'package:flutterstore/repository/transaction_header_repository.dart';
import 'package:flutterstore/ui/common/dialog/error_dialog.dart';
import 'package:flutterstore/ui/common/dialog/success_dialog.dart';
import 'package:flutterstore/ui/common/ps_button_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/transaction/detail/transaction_item_view.dart';
import 'package:flutterstore/utils/ps_progress_dialog.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/transaction_header.dart';
import 'package:provider/provider.dart';

class TransactionItemListView extends StatefulWidget {
  const TransactionItemListView({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  _TransactionItemListViewState createState() =>
      _TransactionItemListViewState();
}

class _TransactionItemListViewState extends State<TransactionItemListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionDetailRepository? repo1;
  TransactionDetailProvider? _transactionDetailProvider;
  AnimationController? animationController;
  Animation<double>? animation;
  PsValueHolder? valueHolder;

  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionDetailProvider!
            .nextTransactionDetailList(widget.transaction);
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  dynamic data;
  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    repo1 = Provider.of<TransactionDetailRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return WillPopScope(
        onWillPop: _requestPop,
        child: ChangeNotifierProvider<TransactionDetailProvider>(
          lazy: false,
          create: (BuildContext context) {
            final TransactionDetailProvider provider =
                TransactionDetailProvider(
                    repo: repo1!, psValueHolder: valueHolder);
            provider.loadTransactionDetailList(widget.transaction);
            _transactionDetailProvider = provider;
            return provider;
          },
          child: Consumer<TransactionDetailProvider>(builder:
              (BuildContext context, TransactionDetailProvider provider,
                  Widget? child) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness:
                      Utils.getBrightnessForAppBar(context),
                ),
                iconTheme: Theme.of(context)
                    .iconTheme
                    .copyWith(color: PsColors.mainColor),
                title: Text(
                  Utils.getString(context, 'transaction_detail__title'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold, color: PsColors.mainColor),
                ),
                elevation: 0,
              ),
              body: Stack(children: <Widget>[
                RefreshIndicator(
                  child: CustomScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: _TransactionNoWidget(
                              transaction: widget.transaction,
                              valueHolder: valueHolder!,
                              scaffoldKey: scaffoldKey),
                        ),
                        SliverToBoxAdapter(
                          child: _AddressWidget(
                            transaction: widget.transaction,
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (provider.transactionDetailList.data != null ||
                                  provider
                                      .transactionDetailList.data!.isNotEmpty) {
                                final int count =
                                    provider.transactionDetailList.data!.length;
                                return TransactionItemView(
                                  animationController: animationController!,
                                  animation: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                      parent: animationController!,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  ),
                                  transaction: provider
                                      .transactionDetailList.data![index],
                                );
                              } else {
                                return null;
                              }
                            },
                            childCount:
                                provider.transactionDetailList.data!.length,
                          ),
                        ),
                        if (widget.transaction.refundStatus == '1')
                          SliverToBoxAdapter(
                              child: _RefundButtonWidget(
                            transactionHeader: widget.transaction,
                          ))
                        else
                          SliverToBoxAdapter(
                            child: Container(),
                          ),
                      ]),
                  onRefresh: () {
                    return provider
                        .resetTransactionDetailList(widget.transaction);
                  },
                ),
                PSProgressIndicator(provider.transactionDetailList.status)
              ]),
            );
          }),
        ));
  }
}

class _TransactionNoWidget extends StatelessWidget {
  const _TransactionNoWidget({
    Key? key,
    required this.transaction,
    required this.valueHolder,
    this.scaffoldKey,
  }) : super(key: key);

  final TransactionHeader transaction;
  final PsValueHolder valueHolder;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );
    final Widget _contentCopyIconWidget = IconButton(
      iconSize: PsDimens.space20,
      icon: Icon(
        Icons.content_copy,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        Clipboard.setData(ClipboardData(text: transaction.transCode));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Tooltip(
            message: Utils.getString(context, 'transaction_detail__copy'),
            child: Text(
              Utils.getString(context, 'transaction_detail__copied_data'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: PsColors.mainColor),
            ),
            showDuration: const Duration(seconds: 5),
          ),
        ));
      },
    );
    return Container(
        color: PsColors.backgroundColor,
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Icon(
                          Icons.offline_pin,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Expanded(
                          child: Text(
                              '${Utils.getString(context, 'transaction_detail__trans_no')} : ${transaction.transCode}',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ),
                  _contentCopyIconWidget,
                ],
              ),
            ),
            _dividerWidget,
            if (transaction.refundStatus == '2') ...<Widget>[
              const SizedBox(
                height: PsDimens.space12,
              ),
              _RefundedStatusWidget(transaction: transaction),
              const SizedBox(
                height: PsDimens.space12,
              ),
              _dividerWidget
            ] else
              _TransactionNoTextWidget(
                transationInfoText: transaction.totalItemCount!,
                title:
                    '${Utils.getString(context, 'transaction_detail__total_item_count')} :',
              ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.totalItemAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total_item_price')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.discountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.discountAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__discount')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText: transaction.cuponDiscountAmount == '0'
                  ? '-'
                  : '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.cuponDiscountAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__coupon_discount')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.subTotalAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__sub_total')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.taxAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__tax')}(${valueHolder.overAllTaxLabel} %) :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.shippingMethodAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_cost')} :',
            ),
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.shippingAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__shipping_tax')}(${valueHolder.shippingTaxLabel} %) :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            _dividerWidget,
            _TransactionNoTextWidget(
              transationInfoText:
                  '${transaction.currencySymbol} ${Utils.getPriceFormat(transaction.balanceAmount!,valueHolder)}',
              title:
                  '${Utils.getString(context, 'transaction_detail__total')} :',
            ),
            const SizedBox(
              height: PsDimens.space12,
            ),
          ],
        ));
  }
}

class _TransactionNoTextWidget extends StatelessWidget {
  const _TransactionNoTextWidget({
    Key? key,
    required this.transationInfoText,
    this.title,
  }) : super(key: key);

  final String transationInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          top: PsDimens.space12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
          Text(
            transationInfoText ,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.normal),
          )
        ],
      ),
    );
  }
}

class _AddressWidget extends StatelessWidget {
  const _AddressWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    const Widget _dividerWidget = Divider(
      height: PsDimens.space2,
    );

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space12,
    );

    const EdgeInsets _paddingEdgeInsetWidget = EdgeInsets.all(16.0);
    return Container(
        color: PsColors.backgroundColor,
        margin: const EdgeInsets.only(top: PsDimens.space8),
        padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString(
                        context, 'transaction_detail__shipping_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingPhone!,
              title: Utils.getString(context, 'transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingEmail!,
              title: Utils.getString(context, 'transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.shippingAddress1!,
              title: Utils.getString(context, 'transaction_detail__address'),
            ),
            Padding(
              padding: _paddingEdgeInsetWidget,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.pin_drop,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  _spacingWidget,
                  Text(
                    Utils.getString(
                        context, 'transaction_detail__billing_address'),
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            _dividerWidget,
            _TextWidgetForAddress(
              addressInfoText: transaction.billingPhone!,
              title: Utils.getString(context, 'transaction_detail__phone'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingEmail!,
              title: Utils.getString(context, 'transaction_detail__email'),
            ),
            _TextWidgetForAddress(
              addressInfoText: transaction.billingAddress1!,
              title: Utils.getString(context, 'transaction_detail__address'),
            ),
            const SizedBox(
              height: PsDimens.space8,
            )
          ],
        ));
  }
}

class _TextWidgetForAddress extends StatelessWidget {
  const _TextWidgetForAddress({
    Key? key,
    required this.addressInfoText,
    this.title,
  }) : super(key: key);

  final String addressInfoText;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: PsDimens.space8),
      padding: const EdgeInsets.only(
        left: PsDimens.space12,
        right: PsDimens.space12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space16, top: PsDimens.space8),
              child: Text(
                addressInfoText,
                style: Theme.of(context).textTheme.bodyMedium,
              ))
        ],
      ),
    );
  }
}

class _RefundButtonWidget extends StatefulWidget {
  const _RefundButtonWidget({@required this.transactionHeader});

  final TransactionHeader? transactionHeader;

  @override
  __RefundButtonWidgetState createState() => __RefundButtonWidgetState();
}

class __RefundButtonWidgetState extends State<_RefundButtonWidget> {
  PsValueHolder? valueHolder;
  TransactionHeaderRepository? transactionHeaderRepo;
  TransactionHeaderProvider? _provider;

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    transactionHeaderRepo = Provider.of<TransactionHeaderRepository>(context);

    final TransactionDetailProvider transactionDetailProvider =
        Provider.of<TransactionDetailProvider>(context, listen: false);

    return ChangeNotifierProvider<TransactionHeaderProvider>(
        lazy: false,
        create: (BuildContext context) {
          final TransactionHeaderProvider provider = TransactionHeaderProvider(
              psValueHolder: valueHolder, repo: transactionHeaderRepo!);

          _provider = provider;

          return _provider!;
        },
        child: Consumer<TransactionHeaderProvider>(builder:
            (BuildContext context, TransactionHeaderProvider provider,
                Widget? child) {
          return Container(
            padding: const EdgeInsets.only(
                left: PsDimens.space18,
                right: PsDimens.space12,
                bottom: PsDimens.space24),
            child: PSButtonWidget(
              hasShadow: true,
              width: double.infinity,
              titleText: Utils.getString(context, 'refund_button_refund'),
              onPressed: () async {
                if (widget.transactionHeader!.id != '') {
                  if (await Utils.checkInternetConnectivity()) {
                    await PsProgressDialog.showDialog(context);

                    final PsResource<TransactionHeader> _transactionHeader =
                        await provider.postRefund(widget.transactionHeader!.id!);

                    // ignore: unnecessary_null_comparison
                    if (_transactionHeader != null) {
                      PsProgressDialog.dismissDialog();

                      widget.transactionHeader!.refundStatus =
                          _transactionHeader.data?.refundStatus;

                      setState(() {});

                      transactionDetailProvider
                          .resetTransactionDetailList(widget.transactionHeader!);

                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return SuccessDialog(
                                message: Utils.getString(
                                    context, 'success_dialog__refund_success'));
                          });
                    } else {
                      PsProgressDialog.dismissDialog();
                      print('Fail');
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(context, 'refund__fail'),
                            );
                          });
                    }
                  } else {
                    showDialog<dynamic>(
                        context: context,
                        builder: (BuildContext context) {
                          return ErrorDialog(
                            message: Utils.getString(
                                context, 'error_dialog__no_internet'),
                          );
                        });
                  }
                }
              },
            ),
          );
        }));
  }
}

class _RefundedStatusWidget extends StatelessWidget {
  const _RefundedStatusWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionHeader transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PsDimens.space220,
      height: PsDimens.space40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: PsColors.mainLightColor,
        borderRadius: BorderRadius.circular(PsDimens.space12),
        border: Border.all(color: PsColors.mainLightColor),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(Utils.getString(context, 'refund_status_refunded'),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: PsColors.mainColor)),
      ),
    );
  }
}
