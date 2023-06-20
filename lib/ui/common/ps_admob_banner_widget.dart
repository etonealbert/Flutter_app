import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../constant/ps_constants.dart';
import '../../utils/utils.dart';
import '../../viewobject/common/ps_value_holder.dart';

class PsAdMobBannerWidget extends StatefulWidget {
  const PsAdMobBannerWidget({required this.admobSize});

  final AdSize admobSize;

  @override
  _PsAdMobBannerWidgetState createState() => _PsAdMobBannerWidgetState();
}

class _PsAdMobBannerWidgetState extends State<PsAdMobBannerWidget> {
  bool showAds = false;
  bool isConnectedToInternet = false;
  int currentRetry = 0;
  int retryLimit = 1;
  late BannerAd _bannerAd;
  double height = 0;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: Utils.getBannerAdUnitId(),
      request: const AdRequest(),
      size: widget.admobSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            if (widget.admobSize == AdSize.banner) {
              height = 60;
            } else {
              height = 250;
            }
          });
          print('loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          showAds = false;
        },
        onAdOpened: (Ad ad) {
          print('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          print('$BannerAd onAdClosed.');
        },
      ),
    );
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && showAds) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    if (valueHolder.isShowAdmob != null &&
        valueHolder.isShowAdmob == PsConst.ONE) {
      showAds = true;
    } else {
      showAds = false;
    }
    if (!isConnectedToInternet && showAds) {
      print('Loading .. ads');
      checkConnection();
    }

    return Container(
      alignment: Alignment.center,
      child: showAds ? AdWidget(ad: _bannerAd) : const SizedBox(),
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
    );
  }
}
