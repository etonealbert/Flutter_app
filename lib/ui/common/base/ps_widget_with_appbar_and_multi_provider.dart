import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/utils/utils.dart';

class PsWidgetWithAppBarAndMultiProvider extends StatefulWidget {
  const PsWidgetWithAppBarAndMultiProvider(
      {Key? key,
      this.child,
      required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget? child;
  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarAndMultiProviderState createState() =>
      _PsWidgetWithAppBarAndMultiProviderState();
}

class _PsWidgetWithAppBarAndMultiProviderState
    extends State<PsWidgetWithAppBarAndMultiProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
          ), 
          iconTheme: IconThemeData(color: PsColors.mainColorWithWhite),
          title: Text(widget.appBarTitle,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: PsColors.mainColorWithWhite)),
          actions: widget.actions,
          flexibleSpace: Container(
            height: 200,
          ),
          elevation: 0,
        ),
        body: widget.child);
  }
}
