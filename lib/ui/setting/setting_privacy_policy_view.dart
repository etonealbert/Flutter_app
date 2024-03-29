// import 'package:flutterstore/constant/ps_dimens.dart';
// import 'package:flutterstore/provider/about_app/about_app_provider.dart';
// import 'package:flutterstore/ui/common/base/ps_widget_with_appbar.dart';
// import 'package:flutterstore/utils/utils.dart';
// import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SettingPrivacyPolicyView extends StatefulWidget {
//   const SettingPrivacyPolicyView({@required this.checkPolicyType});
//   final int checkPolicyType;
//   @override
//   _SettingPrivacyPolicyViewState createState() {
//     return _SettingPrivacyPolicyViewState();
//   }
// }

// class _SettingPrivacyPolicyViewState extends State<SettingPrivacyPolicyView>
//     with SingleTickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();

//   AboutAppProvider _aboutAppProvider;

//   AnimationController animationController;
//   Animation<double> animation;

//   @override
//   void dispose() {
//     animationController.dispose();
//     animation = null;
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _aboutAppProvider.nextAboutUsList();
//       }
//     });

//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..addListener(() => setState(() {}));

//     animation = Tween<double>(
//       begin: 0.0,
//       end: 10.0,
//     ).animate(animationController);
//   }

//   AboutAppRepository repo1;
//   PsValueHolder valueHolder;
//   @override
//   Widget build(BuildContext context) {
//     repo1 = Provider.of<AboutUsRepository>(context);
//     valueHolder = Provider.of<PsValueHolder>(context);
//     return PsWidgetWithAppBar<AboutUsProvider>(
//         appBarTitle: widget.checkPolicyType == 1
//             ? Utils.getString(context, 'privacy_policy__toolbar_name')
//             : widget.checkPolicyType == 2
//                 ? Utils.getString(context, 'terms_and_condition__toolbar_name')
//                 : widget.checkPolicyType == 3
//                     ? Utils.getString(context, 'refund_policy__toolbar_name')
//                     : '',
//         initProvider: () {
//           return AboutUsProvider(
//             repo: repo1,
//             psValueHolder: valueHolder,
//           );
//         },
//         onProviderReady: (AboutUsProvider provider) {
//           provider.loadAboutUsList();
//           _aboutUsProvider = provider;
//         },
//         builder:
//             (BuildContext context, AboutUsProvider provider, Widget child) {
//           if (provider.aboutUsList != null &&
//               provider.aboutUsList.data != null &&
//               provider.aboutUsList.data.isNotEmpty) {
//             return Padding(
//               padding: const EdgeInsets.all(PsDimens.space10),
//               child: SingleChildScrollView(
//                 child: Text(
//                   provider.aboutUsList.data[0].privacypolicy,
//                   style: Theme.of(context).textTheme.bodyLarge,
//                 ),
//               ),
//             );
//           } else {
//             return Container();
//           }
//         });
//   }
// }
