import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/provider/language/language_provider.dart';
import 'package:flutterstore/repository/language_repository.dart';
import 'package:flutterstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterstore/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../../viewobject/common/language.dart';
import '../../../viewobject/common/ps_value_holder.dart';
import '../item/language_list_item.dart';

class LanguageListView extends StatefulWidget {
  @override
  _LanguageListViewState createState() => _LanguageListViewState();
}

class _LanguageListViewState extends State<LanguageListView>
    with SingleTickerProviderStateMixin {
  LanguageRepository? repo1;
  late PsValueHolder _valueHolder;

  AnimationController? animationController;
  Animation<double> ?animation;
  final Set<Language> _languageList = <Language>{};


  @override
  void dispose() {
    animationController!.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    repo1 = Provider.of<LanguageRepository>(context);
    _valueHolder = Provider.of<PsValueHolder>(context);
    timeDilation = 1.0;
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

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<LanguageProvider>(
        appBarTitle:
            Utils.getString(context, 'language_selection__title') ,
        initProvider: () {
          return LanguageProvider(repo: repo1!);
        },
        onProviderReady: (LanguageProvider provider) {
          provider.getLanguageList();
          provider.getExcludedLanguageCodeList();

        },
        builder:
            (BuildContext context, LanguageProvider provider, Widget? child) {
           if (!_languageList.contains(provider.getApiDefaultLanguage())) {
            _languageList.add(provider.getApiDefaultLanguage());
          }
          for (Language language in provider.languageList) {
            if (!provider.excludedLanguageList!
                .contains(language.languageCode)) {
              _languageList.add(language);
            }
          }      
          return Padding(
            padding: const EdgeInsets.only(
                top: PsDimens.space8, bottom: PsDimens.space8),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languageList.length,
              itemBuilder: (BuildContext context, int index) {
                final int count = _languageList.length;
                return LanguageListItem(
                    language: _languageList.elementAt(index),
                    animationController: animationController!,
                    animation: Tween<double>(begin: 0.0, end: 1.0)
                        .animate(CurvedAnimation(
                      parent: animationController!,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    )),
                    onTap: () {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ConfirmDialogView(
                                description: Utils.getString(context,
                                    'home__language_dialog_description'),
                                leftButtonText: Utils.getString(
                                    context, 'app_info__cancel_button_name'),
                                rightButtonText:
                                    Utils.getString(context, 'dialog__ok'),
                                onAgreeTap: () {

                                  _valueHolder.isUserAlreadyChoose = true;
                                  provider.replaceIsUserAlreadyChoose(true);
                                  Navigator.of(context).pop();
                                  Navigator.pop(
                                      context, _languageList.elementAt(index));
                                  _languageList.clear();    
                                });
                          });
                    });
              },
            ),
          );
        },
      ),
    );
  }
}
