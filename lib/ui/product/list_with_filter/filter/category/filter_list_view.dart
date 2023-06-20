import 'package:flutter/material.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/constant/ps_constants.dart';
import 'package:flutterstore/provider/category/category_provider.dart';
import 'package:flutterstore/repository/category_repository.dart';
import 'package:flutterstore/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterstore/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/category_parameter_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'filter_expantion_tile_view.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({this.selectedData});

  final dynamic selectedData;

  @override
  State<StatefulWidget> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  final ScrollController _scrollController = ScrollController();

  final CategoryParameterHolder categoryIconList = CategoryParameterHolder();
  CategoryRepository? categoryRepository;
  late PsValueHolder _valueHolder;
  bool _showAds = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onSubCategoryClick(Map<String, String> subCategory) {
    Navigator.pop(context, subCategory);
  }

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && _showAds) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _valueHolder = Provider.of<PsValueHolder>(context);
    if (_valueHolder.isShowAdmob != null &&
        _valueHolder.isShowAdmob == PsConst.ONE) {
      _showAds = true;
    } else {
      _showAds = false;
    }
    if (!isConnectedToInternet && _showAds) {
      print('loading ads....');
      checkConnection();
    }
    categoryRepository = Provider.of<CategoryRepository>(context);
    return PsWidgetWithAppBar<CategoryProvider>(
        appBarTitle: Utils.getString(context, 'search__category'),
        initProvider: () {
          return CategoryProvider(
              repo: categoryRepository!, psValueHolder: _valueHolder);
        },
        onProviderReady: (CategoryProvider provider) {
          provider.loadAllCategoryList(categoryIconList.toMap());
        },
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list, color: PsColors.mainColor),
            onPressed: () {
              final Map<String, String> dataHolder = <String, String>{};
              dataHolder[PsConst.CATEGORY_ID] = '';
              dataHolder[PsConst.SUB_CATEGORY_ID] = '';
              onSubCategoryClick(dataHolder);
            },
          )
        ],
        builder:
            (BuildContext context, CategoryProvider provider, Widget? child) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(admobSize: AdSize.banner),
                  Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: provider.categoryList.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (provider.categoryList.data != null ||
                              provider.categoryList.data!.isEmpty) {
                            return FilterExpantionTileView(
                                selectedData: widget.selectedData,
                                category: provider.categoryList.data![index],
                                onSubCategoryClick: onSubCategoryClick);
                          } else {
                            return Container();
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
