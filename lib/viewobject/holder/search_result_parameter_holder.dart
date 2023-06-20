import '../common/ps_holder.dart';

class SearchResultParameterHolder
    extends PsHolder<SearchResultParameterHolder> {
  SearchResultParameterHolder({required this.searchTerm});

  final String searchTerm;

  @override
  SearchResultParameterHolder fromMap(dynamic dynamicData) {
    return SearchResultParameterHolder(
      searchTerm: dynamicData['searchterm'],
    );
  }

  @override
  String getParamKey() {
    return '';
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['searchterm'] = searchTerm;

    return map;
  }
}
