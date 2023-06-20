import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import '../../../config/ps_colors.dart';
import '../../../constant/ps_dimens.dart';
import '../../../provider/user/user_provider.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/holder/payment_callback_holder.dart';
import '../../common/ps_button_widget.dart';

class PaymentMethodView extends StatefulWidget {
  const PaymentMethodView({
    Key? key,
    required this.userProvider,
  }) : super(key: key);
  final UserProvider userProvider;
  @override
  State<PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  int selectedIndex = 0;
  final List<Payment> availablePayment = <Payment>[
    Payment(
      name: 'checkout3__paypal',
      iconData: Foundation.paypal,
    ),
    Payment(
      name: 'checkout3__pay_stack',
      iconData: Ionicons.md_cash,
    ),
    Payment(
      name: 'checkout3__stripe',
      iconData: Icons.payment,
    ),
    Payment(
      name: 'checkout3__razor',
      iconData: Icons.payment,
    ),
    Payment(
      name: 'checkout3__wave',
      iconData: Icons.payment,
    ),
    Payment(
     name: 'checkout3__bank',
     iconData: Icons.payment,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsColors.coreBackgroundColor,
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
          actions: <Widget>[
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
                    PaymentCallBackHolder(
                      isCash: widget.userProvider.isCash,
                      payment: availablePayment[selectedIndex].name,
                    ));
              },
            ),
            const SizedBox(
              width: PsDimens.space16,
            ),
          ]),
      body: SingleChildScrollView(
          child: Container(
        color: PsColors.coreBackgroundColor,
        padding: const EdgeInsets.only(
            left: PsDimens.space16, right: PsDimens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Utils.getString(context, 'checkout_one_page__payment_method'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: PsDimens.space8,
            ),
            _PaymentButtonWidget(
              isPickUp: widget.userProvider.isClickPickUpButton,
              isCash: widget.userProvider.isCash,
              isWeeklySchedule: widget.userProvider.isClickWeeklyButton,
              payWithCashPressed: () {
                setState(() {
                  widget.userProvider.isCash = true;
                });
              },
              onlinePaymentOnPressed: () {
                setState(() {
                  widget.userProvider.isCash = false;
                });
              },
            ),
            const SizedBox(
              height: PsDimens.space40,
            ),
            if (widget.userProvider.isCash)
              const SizedBox()
            else
              Text(
                Utils.getString(context, 'payment__method_pay_by'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            const SizedBox(
              height: PsDimens.space20,
            ),
            if (widget.userProvider.isCash)
              const SizedBox()
            else
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: availablePayment.length,
                itemBuilder: (BuildContext context, int index) {
                  return _PaymentCard(
                    key: UniqueKey(),
                    paymentType: availablePayment[index].name,
                    iconData: availablePayment[index].iconData,
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                },
              ),
          ],
        ),
      )),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    Key? key,
    required this.paymentType,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);
  final String paymentType;
  final IconData iconData;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: PsDimens.space120,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? PsColors.mainColor : PsColors.backgroundColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: PsDimens.space6,
                ),
                Container(
                    width: 40,
                    height: 40,
                    child: Icon(
                      iconData,
                      color: isSelected ? PsColors.white : Colors.black,
                    )),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    bottom: PsDimens.space16,
                  ),
                  child: Text(
                      Utils.getString(
                        context,
                        paymentType,
                      ),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            height: 1.1,
                            color: isSelected ? PsColors.white : Colors.black,
                          )),
                ),
              ],
            ),
          )),
    );
  }
}

class _PaymentButtonWidget extends StatefulWidget {
  const _PaymentButtonWidget({
    Key? key,
    required this.isCash,
    required this.payWithCashPressed,
    required this.onlinePaymentOnPressed,
    required this.isPickUp,
    required this.isWeeklySchedule,
  }) : super(key: key);
  final bool isCash;
  final Function payWithCashPressed;
  final Function onlinePaymentOnPressed;
  final bool isPickUp;
  final bool isWeeklySchedule;

  @override
  _PaymentButtonWidgetState createState() => _PaymentButtonWidgetState();
}

class _PaymentButtonWidgetState extends State<_PaymentButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: PsDimens.space12),
          SizedBox(
            width: double.infinity,
            height: PsDimens.space40,
            child: Container(
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                border: Border.all(color: PsColors.backgroundColor),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(PsDimens.space12),
                    topRight: Radius.circular(PsDimens.space12)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: PsColors.backgroundColor,
                    blurRadius: 10.0, // has the effect of softening the shadow
                    spreadRadius: 0, // has the effect of extending the shadow
                    offset: const Offset(
                      0.0, // horizontal, move right 10
                      0.0, // vertical, move down 10
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (widget.isPickUp)
                    Expanded(
                      child: PSButtonWidget(
                        hasShadow: true,
                        hasShape: false,
                        textColor:
                            widget.isCash ? PsColors.white : PsColors.black,
                        width: double.infinity,
                        colorData:
                            widget.isCash ? PsColors.mainColor : PsColors.white,
                        titleText:
                            Utils.getString(context, 'checkout3__pick_up'),
                        onPressed: widget.payWithCashPressed,
                      ),
                    )
                  else
                    Expanded(
                      child: PSButtonWidget(
                        hasShadow: true,
                        hasShape: false,
                        textColor:
                            widget.isCash ? PsColors.white : PsColors.black,
                        width: double.infinity,
                        colorData:
                            widget.isCash ? PsColors.mainColor : PsColors.white,
                        titleText: Utils.getString(context, 'checkout3__cod'),
                        onPressed: widget.payWithCashPressed,
                      ),
                    ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  if (widget.isWeeklySchedule)
                    const Expanded(child: SizedBox())
                  else
                    Expanded(
                      child: PSButtonWidget(
                        hasShadow: true,
                        hasShape: false,
                        width: double.infinity,
                        textColor:
                            !widget.isCash ? PsColors.white : PsColors.black,
                        colorData: !widget.isCash
                            ? PsColors.mainColor
                            : PsColors.white,
                        titleText: Utils.getString(
                            context, 'payment__method_online_payment'),
                        onPressed: widget.onlinePaymentOnPressed,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Payment {
  Payment({
    required this.name,
    required this.iconData,
  });

  final String name;
  final IconData iconData;
}
