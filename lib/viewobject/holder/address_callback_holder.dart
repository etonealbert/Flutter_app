import 'package:flutterstore/provider/user/user_provider.dart';

class AddressCallBackHolder{

  const AddressCallBackHolder({
    required this.firstName,
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
  final UserProvider userProvider;
}