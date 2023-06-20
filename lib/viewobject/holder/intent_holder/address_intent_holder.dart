import 'package:flutterstore/provider/user/user_provider.dart';

class AddressIntentHolder {
  const AddressIntentHolder(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.company,
      required this.address1,
      required this.address2,
      required this.country,
      required this.state,
      required this.city,
      required this.postalCode,
      required this.userProvider,
      this.shippingAddress1,
      this.shippingAddress2,
      this.shippingCity,
      this.shippingCompany,
      this.shippingCountry,
      this.shippingFirstName,
      this.shippingLastName,
      this.shippingPostalCode,
      this.shippingState,
      this.shippingPhone,
      this.shippingEmail,
      });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;
  final String address1;
  final String address2;
  final String country;
  final String state;
  final String city;
  final String postalCode;
  final String? shippingFirstName;
  final String? shippingLastName;
  final String? shippingPhone;
  final String? shippingCompany;
  final String? shippingAddress1;
  final String? shippingAddress2;
  final String? shippingCountry;
  final String? shippingState;
  final String? shippingCity;
  final String? shippingEmail;
  final String? shippingPostalCode;
  final UserProvider userProvider;
}
