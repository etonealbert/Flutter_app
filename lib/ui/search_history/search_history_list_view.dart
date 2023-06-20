import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterstore/config/ps_colors.dart';
import 'package:flutterstore/config/ps_config.dart';
import 'package:flutterstore/constant/ps_dimens.dart';
import 'package:flutterstore/constant/route_paths.dart';
import 'package:flutterstore/provider/search_history/search_history_provider.dart';
import 'package:flutterstore/repository/search_history_repository.dart';
import 'package:flutterstore/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterstore/ui/common/ps_search_textfield_widget.dart';
import 'package:flutterstore/ui/search_history/search_history_list_item.dart';
import 'package:flutterstore/utils/utils.dart';
import 'package:flutterstore/viewobject/common/ps_value_holder.dart';
import 'package:flutterstore/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterstore/viewobject/search_history.dart';
import 'package:provider/provider.dart';

class SearchHistoryListView extends StatefulWidget {

  @override
  _SearchHistoryListViewState createState() => _SearchHistoryListViewState();
}

class _SearchHistoryListViewState extends State<SearchHistoryListView> 
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }
    
  final TextEditingController userInputItemNameTextEditingController =
      TextEditingController();
  final ProductParameterHolder productParameterHolder =
      ProductParameterHolder().getLatestParameterHolder();
  PsValueHolder? psValueHolder;
  SearchHistory? searchHistory;

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  SearchHistoryProvider? provider;
  SearchHistoryRepository? searchHistoryRepository;
  
  @override
  Widget build(BuildContext context) {
    searchHistoryRepository = Provider.of<SearchHistoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

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
    final Widget _searchTextFieldWidget = PsSearchTextFieldWidget(
       hintText:
            Utils.getString(context, 'search_history__app_bar_search'),
      textEditingController:
          userInputItemNameTextEditingController,
      psValueHolder: psValueHolder,
      height: 40,
      textInputAction: TextInputAction.search,
    );
    return WillPopScope(
      onWillPop: _requestPop,
      child: ChangeNotifierProvider<SearchHistoryProvider>(
          lazy: false,
          create: (BuildContext context) {
            provider = SearchHistoryProvider(repo: searchHistoryRepository!);
            provider!.loadSearchHistoryList();
            return provider!;
          },
       child: Consumer<SearchHistoryProvider>(builder: (BuildContext context,
            SearchHistoryProvider provider, Widget? child) {    
          return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle (
                  statusBarIconBrightness : Utils.getBrightnessForAppBar(context)
                ),
            titleSpacing: 0,
            iconTheme: Theme.of(context)
                .iconTheme
                .copyWith(color: PsColors.mainColorWithWhite),
            title: _searchTextFieldWidget,
            actions: <Widget>[
              Padding(padding: const EdgeInsets.only(right: PsDimens.space8),
                child: IconButton(
                  icon: Icon(Icons.search,
                    color: PsColors.mainColor,
                    size: 26),
                    onPressed: () {
                      productParameterHolder.searchTerm = 
                        userInputItemNameTextEditingController.text;
                      Navigator.pushNamed(
                          context, RoutePaths.searchItemList,
                          arguments: productParameterHolder);
                    },
                  ),
                ),
              ],
            ),
            body: RefreshIndicator(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                  //  shrinkWrap: true,
                    slivers: <Widget>[
                      SliverGrid(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 160.0, 
                            childAspectRatio: 3.0),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (provider.historyList.data != null ||
                                provider.historyList.data!.isEmpty) {   
                              return SearchHistoryListItem(
                                  searchHistory: provider.historyList.data![index],
                                  onTap: () {
                                    productParameterHolder.searchTerm = 
                                      provider.historyList.data![index].searchTeam;
                                    Navigator.pushNamed(
                                        context, RoutePaths.searchItemList,
                                        arguments: productParameterHolder);
                                  },
                                  onDeleteTap: () {
                                  showDialog<dynamic>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmDialogView(
                                          description: Utils.getString(context,
                                              'search_history__confirm_dialog_description'),
                                          leftButtonText: Utils.getString(context,
                                              'app_info__cancel_button_name'),
                                          rightButtonText: Utils.getString(
                                              context,
                                              'dialog__ok'),
                                          onAgreeTap: () async {
                                            Navigator.of(context).pop();
                                            productParameterHolder.searchTerm = 
                                              provider.historyList.data![index].searchTeam;
                                            searchHistory = SearchHistory(
                                              searchTeam: productParameterHolder.searchTerm);
                                            provider.deleteSearchHistory(searchHistory!);

                                          });
                                    });
                                  },
                                );
                            } else {
                                return null;
                            }
                          },
                          childCount: provider.historyList.data!.length,
                        ),
                      ),
                    ]),
              ),
                  onRefresh: () {
                    return provider.resetSearchHistoryList();
                },
              ),
          );
        })
      ),
    );
  }
}