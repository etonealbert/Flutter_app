import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/provider/user/user_provider.dart';
import 'package:flutterstore/viewobject/holder/address_callback_holder.dart';

import '../../../config/ps_colors.dart';
import '../../../constant/ps_dimens.dart';
import '../../../constant/route_paths.dart';
import '../../../utils/utils.dart';
import '../../../viewobject/shipping_city.dart';
import '../../../viewobject/shipping_country.dart';
import '../../common/dialog/error_dialog.dart';
import '../../common/dialog/warning_dialog_view.dart';
import '../../common/ps_dropdown_base_with_controller_widget.dart';
import '../../common/ps_textfield_widget.dart';

class BillingAddressView extends StatefulWidget {
  const BillingAddressView({
    Key? key,
    required this.userEmail,
    required this.userPhoneNo,
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.address2,
    required this.companyName,
    required this.country,
    required this.state,
    required this.city,
    required this.postalCode,
    required this.shippingAddress1,
    required this.shippingAddress2,
    required this.shippingCity,
    required this.shippingCompany,
    required this.shippingCountry,
    required this.shippingEmail,
    required this.shippingFirstName,
    required this.shippingLastName,
    required this.shippingPhone,
    required this.shippingPostalCode,
    required this.shippingState,
    required this.userProvider,
  }) : super(key: key);

  final String userEmail;
  final String userPhoneNo;
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String companyName;
  final String country;
  final String state;
  final String city;
  final String postalCode;
  final String shippingFirstName;
  final String shippingLastName;
  final String shippingPhone;
  final String shippingEmail;
  final String shippingCompany;
  final String shippingAddress1;
  final String shippingAddress2;
  final String shippingCountry;
  final String shippingState;
  final String shippingCity;
  final String shippingPostalCode;
  final UserProvider userProvider;

  @override
  @override
  __BillingAddressViewState createState() => __BillingAddressViewState();
}

class __BillingAddressViewState extends State<BillingAddressView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  bool isBindDataFirstTime = true;
  String? countryId;

  @override
  Widget build(BuildContext context) {
    if (isBindDataFirstTime) {
      emailController.text = widget.userEmail;
      phoneController.text = widget.userPhoneNo;
      firstNameController.text = widget.firstName;
      lastNameController.text = widget.lastName;
      address1Controller.text = widget.address1;
      address2Controller.text = widget.address2;
      companyController.text = widget.companyName;
      countryController.text = widget.country;
      stateController.text = widget.state;
      cityController.text = widget.city;
      postalCodeController.text = widget.postalCode;
      isBindDataFirstTime = false;
    }

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
            actions: <Widget>[
              InkWell(
                  child: Ink(
                    child: Center(
                      child: Text(
                        Utils.getString(context, 'checkout_one_page__done'),
                        textAlign: TextAlign.justify,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold)
                            .copyWith(color: PsColors.mainColor),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (emailController.text == '' ||
                        emailController.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message:
                                  Utils.getString(context, 'Please Inuput Billing Email'),
                            );
                          });
                    } else if (phoneController.text == '' ||
                        phoneController.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'Please input billing phone number'),
                            );
                          });
                    } else if (address1Controller.text == '' ||
                        address1Controller.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'warning_dialog__billing_address'),
                            );
                          });
                    } else if (countryController.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'edit_profile__selected_country'),
                            );
                          });
                      return;
                    } else if (countryController.text.isNotEmpty &&
                        cityController.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ErrorDialog(
                              message: Utils.getString(
                                  context, 'error_dialog__select_city'),
                            );
                          });
                      return;
                    } else {
                      Navigator.pop(
                          context,
                          AddressCallBackHolder(
                            email: emailController.text,
                            phone: phoneController.text,
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            address1: address1Controller.text,
                            address2: address2Controller.text,
                            company: companyController.text,
                            city: cityController.text,
                            state: stateController.text,
                            country: countryController.text,
                            postalCode: postalCodeController.text,
                            userProvider: widget.userProvider,
                          ));
                    }
                  }),
              const SizedBox(
                width: PsDimens.space16,
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
            color: PsColors.coreBackgroundColor,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              const _BillingAddressTextWidget(),
              const SizedBox(
                height: PsDimens.space16,
              ),
              Row(
                children: <Widget>[
                  Switch(
                    value:
                        widget.userProvider.useShippingAddressAsBillingAddress,
                    onChanged: (bool isOn) {
                      print(isOn);
                      setState(() {
                        widget.userProvider.useShippingAddressAsBillingAddress =
                            isOn;

                        firstNameController.text = widget.shippingFirstName;
                        lastNameController.text = widget.shippingLastName;
                        emailController.text = widget.shippingEmail;
                        phoneController.text = widget.shippingPhone;
                        companyController.text = widget.shippingCompany;
                        address1Controller.text = widget.shippingAddress1;
                        address2Controller.text = widget.shippingAddress1;
                        countryController.text = widget.shippingCountry;
                        stateController.text = widget.shippingState;
                        cityController.text = widget.shippingCity;
                        postalCodeController.text = widget.shippingPostalCode;
                      });
                    },
                    activeTrackColor: PsColors.mainColor,
                    activeColor: PsColors.mainDarkColor,
                  ),
                  Text(Utils.getString(
                      context, 'checkout1__same_billing_address')),
                ],
              ),
              const SizedBox(
                height: PsDimens.space16,
              ),
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'edit_profile__first_name'),
                  textAboutMe: false,
                  hintText:
                      Utils.getString(context, 'edit_profile__first_name'),
                  textEditingController: firstNameController),
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'edit_profile__last_name'),
                  textAboutMe: false,
                  hintText: Utils.getString(context, 'edit_profile__last_name'),
                  textEditingController: lastNameController),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__email'),
                  textAboutMe: false,
                  hintText: Utils.getString(context, 'edit_profile__email'),
                  textEditingController: emailController,
                  isMandatory: true),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__phone'),
                  textAboutMe: false,
                  phoneInputType: true,
                  hintText: Utils.getString(context, 'edit_profile__phone'),
                  textEditingController: phoneController),
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'edit_profile__company_name'),
                  textAboutMe: false,
                  hintText:
                      Utils.getString(context, 'edit_profile__company_name'),
                  textEditingController: companyController),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__address1'),
                  height: PsDimens.space120,
                  textAboutMe: true,
                  hintText: Utils.getString(context, 'edit_profile__address1'),
                  keyboardType: TextInputType.multiline,
                  textEditingController: address1Controller,
                  isMandatory: true),
              PsTextFieldWidget(
                  titleText: Utils.getString(context, 'edit_profile__address2'),
                  height: PsDimens.space120,
                  textAboutMe: true,
                  hintText: Utils.getString(context, 'edit_profile__address2'),
                  keyboardType: TextInputType.multiline,
                  textEditingController: address2Controller),
              PsDropdownBaseWithControllerWidget(
                  title: Utils.getString(context, 'edit_profile__country_name'),
                  textEditingController: countryController,
                  isMandatory: true,
                  onTap: () async {
                    final dynamic result = await Navigator.pushNamed(
                        context, RoutePaths.countryList);

                    if (result != null && result is ShippingCountry) {
                      setState(() {
                        countryId = result.id;
                        countryController.text = result.name!;
                        cityController.text = '';
                        widget.userProvider.selectedCountry = result;
                        widget.userProvider.selectedCity = null;
                      });
                    }
                  }),
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'edit_profile__state_name'),
                  textAboutMe: false,
                  hintText:
                      Utils.getString(context, 'edit_profile__state_name'),
                  textEditingController: stateController),
              PsDropdownBaseWithControllerWidget(
                  title: Utils.getString(context, 'edit_profile__city_name'),
                  textEditingController: cityController,
                  isMandatory: true,
                  onTap: () async {
                    if (countryController.text.isEmpty) {
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return WarningDialog(
                              message: Utils.getString(
                                  context, 'edit_profile__selected_country'),
                              onPressed: () {},
                            );
                          });
                    } else {
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.cityList,
                          arguments: countryId ??
                              widget.userProvider.user.data!.country!.id);

                      if (result != null && result is ShippingCity) {
                        setState(() {
                          cityController.text = result.name!;
                          widget.userProvider.selectedCity = result;
                        });
                      }
                    }
                  }),
              PsTextFieldWidget(
                  titleText:
                      Utils.getString(context, 'edit_profile__postal_code'),
                  textAboutMe: false,
                  hintText:
                      Utils.getString(context, 'edit_profile__postal_code'),
                  textEditingController: postalCodeController),
              const SizedBox(
                height: PsDimens.space20,
              ),
            ]),
          ),
        ));
  }
}

class _BillingAddressTextWidget extends StatelessWidget {
  const _BillingAddressTextWidget();

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
            Utils.getString(context, 'checkout_one_page__billing_address'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
