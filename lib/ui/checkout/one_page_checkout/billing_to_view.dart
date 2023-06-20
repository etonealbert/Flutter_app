import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/ps_colors.dart';
import '../../../constant/ps_dimens.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/holder/billing_to_callback_holder.dart';
import '../../common/ps_textfield_widget.dart';

class BillingToView extends StatefulWidget {
  const BillingToView({
    Key? key,
    required this.userEmail,
    required this.userPhoneNo,
  }) : super(key: key);

  final String userEmail;
  final String userPhoneNo;

  @override
  @override
  __BillingToViewState createState() => __BillingToViewState();
}

class __BillingToViewState extends State<BillingToView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    userEmailController.text = widget.userEmail;
    userPhoneController.text = widget.userPhoneNo;

    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Utils.getBrightnessForAppBar(context)),
            iconTheme: Theme.of(context).iconTheme.copyWith(),
            title: Text(
              '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            elevation: 0,
            actions:
                
                <Widget>[
              InkWell(
                  child: Ink(
                    child: Center(
                      child: Text(
                        Utils.getString(context, 'checkout_one_page__done'),
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            !.copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColor),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                        context,
                        BillingToCallBackHolder(
                            userEmail: userEmailController.text,
                            userPhoneNo: userPhoneController.text));
                  }),
              const SizedBox(
                width: PsDimens.space16,
              ),
            ]),
        body: Container(
          color: PsColors.coreBackgroundColor,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _BillingToTextWidget(
                    userEmailController: userEmailController,
                    userPhoneController: userPhoneController),
                PsTextFieldWidget(
                  titleText: Utils.getString(context, 'whatsapp__title_email'),
                  textAboutMe: false,
                  hintText: userEmailController.text,
                  textEditingController: userEmailController,
                ),
                PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'whatsapp__title_phone_no'),
                  textAboutMe: false,
                  hintText: userPhoneController.text,
                  textEditingController: userPhoneController,
                ),
              ]),
        ));
  }
}

class _BillingToTextWidget extends StatelessWidget {
  const _BillingToTextWidget(
      {required this.userEmailController, required this.userPhoneController});

  final TextEditingController userEmailController;
  final TextEditingController userPhoneController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          top: PsDimens.space8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            Utils.getString(context, 'checkout_one_page__billing_to'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
