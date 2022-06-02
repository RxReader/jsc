import '../model/book_source.dart';

class AnalyzeUrl {
  AnalyzeUrl({
    required this.url,
    this.page,
    this.baseUrl,
    this.source,
    Map<String, String>? headerMap,
  }) {
    this.headerMap = headerMap ?? source?.getHeaderMap();
  }

  final String url;
  final int? page;
  final String? baseUrl;
  final BaseSource? source;
  late final Map<String, String>? headerMap;

  Future<void> getStrResponse() async {}
}
