import 'package:flutterstore/provider/shop_info/shop_info_provider.dart';
import 'package:flutterstore/viewobject/basket.dart';

class CheckoutIntentHolder {
  const CheckoutIntentHolder({
    required this.basketList,
    this.shopInfoProvider,
  });
  final List<Basket> basketList;
  final ShopInfoProvider? shopInfoProvider;
}
