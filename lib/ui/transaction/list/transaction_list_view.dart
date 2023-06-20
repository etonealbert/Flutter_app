import 'package:flutter/material.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/transaction/transaction_header_provider.dart';
import 'package:flutterstore/repository/transaction_header_repository.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/ui/common/ps_ui_widget.dart';
import 'package:flutterstore/ui/transaction/item/transaction_list_item.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../constant/ps_constants.dart';

class TransactionListView extends StatefulWidget {
  const TransactionListView(
      {Key? key, required this.animationController, required this.scaffoldKey})
      : super(key: key);
  final AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _TransactionListViewState createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  TransactionHeaderProvider? _transactionProvider;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _transactionProvider!.nextTransactionList();
      }
    });

    super.initState();
  }

  TransactionHeaderRepository ?repo1;
  late PsValueHolder _valueHolder;
  bool _showAds = false;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

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
    repo1 = Provider.of<TransactionHeaderRepository>(context);
    print(
        '............................Build UI Again ............................');
    return ChangeNotifierProvider<TransactionHeaderProvider>(
      lazy: false,
      create: (BuildContext context) {
        final TransactionHeaderProvider provider = TransactionHeaderProvider(
            repo: repo1!, psValueHolder: _valueHolder);
        provider.loadTransactionList(_valueHolder.loginUserId!);
        _transactionProvider = provider;
        return _transactionProvider!;
      },
      child: Consumer<TransactionHeaderProvider>(builder: (BuildContext context,
          TransactionHeaderProvider provider, Widget? child) {
        if (provider.transactionList.data != null &&
            provider.transactionList.data!.isNotEmpty) {
          return Column(
            children: <Widget>[
              const PsAdMobBannerWidget(admobSize: AdSize.banner),
              // Visibility(
              //   visible: PsConfig.showAdMob &&
              //       isSuccessfullyLoaded &&
              //       isConnectedToInternet,
              //   child: AdmobBanner(
              //     adUnitId: Utils.getBannerAdUnitId(),
              //     adSize: AdmobBannerSize.FULL_BANNER,
              //     listener: (AdmobAdEvent event, Map<String, dynamic> map) {
              //       print('BannerAd event is $event');
              //       if (event == AdmobAdEvent.loaded) {
              //         isSuccessfullyLoaded = true;
              //       } else {
              //         isSuccessfullyLoaded = false;
              //         setState(() {});
              //       }
              //     },
              //   ),
              // ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    RefreshIndicator(
                      child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  final int count =
                                      provider.transactionList.data!.length;
                                  return TransactionListItem(
                                    scaffoldKey: widget.scaffoldKey,
                                    animationController:
                                        widget.animationController,
                                    animation:
                                        Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                      CurvedAnimation(
                                        parent: widget.animationController,
                                        curve: Interval(
                                            (1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn),
                                      ),
                                    ),
                                    transaction:
                                        provider.transactionList.data![index],
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutePaths.transactionDetail,
                                          arguments: provider
                                              .transactionList.data![index]);
                                    },
                                  );
                                },
                                childCount:
                                    provider.transactionList.data!.length,
                              ),
                            ),
                          ]),
                      onRefresh: () {
                        return provider.resetTransactionList();
                      },
                    ),
                    PSProgressIndicator(provider.transactionList.status)
                  ],
                ),
              )
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }
}
