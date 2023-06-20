import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/utils/utils.dart';

import 'history_list_view.dart';

class HistoryListContainerView extends StatefulWidget {
  @override
  _HistoryListContainerViewState createState() =>
      _HistoryListContainerViewState();
}

class _HistoryListContainerViewState extends State<HistoryListContainerView>
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
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ), 
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: PsColors.mainColorWithWhite),
          title: Text(
            Utils.getString(context, 'history_list__title'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: PsColors.mainColorWithWhite),
          ),
          elevation: 0,
        ),
        body: HistoryListView(
          animationController: animationController!,
        ),
      ),
    );
  }
}
