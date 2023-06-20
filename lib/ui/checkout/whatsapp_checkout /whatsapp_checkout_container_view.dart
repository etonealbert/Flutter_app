import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/ui/checkout/whatsapp_checkout%20/whatsapp_checkout_view.dart';
import '../../../config/ps_config.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/basket.dart';


class WhatsappCheckoutContainerView extends StatefulWidget {
   const WhatsappCheckoutContainerView({
    Key? key,
    required this.basketList,
  }) : super(key: key);

  final List<Basket> basketList;

  @override
  _WhatsappCheckoutContainerViewState createState() =>
      _WhatsappCheckoutContainerViewState();
}

class _WhatsappCheckoutContainerViewState extends State<WhatsappCheckoutContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

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

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle (
            statusBarIconBrightness : Utils.getBrightnessForAppBar(context)
          ),
          iconTheme: Theme.of(context).iconTheme.copyWith(),
          title: Text(
            Utils.getString(context, 'checkout__app_bar_name'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          elevation: 0,
        ),
        body: WhatsappCheckoutView(
          basketList: widget.basketList,
        ),
      ),
    );
  }
}
