// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookSource _$BookSourceFromJson(Map<String, dynamic> json) => BookSource(
      bookSourceUrl: json['bookSourceUrl'] as String?,
      bookSourceName: json['bookSourceName'] as String?,
      bookSourceGroup: json['bookSourceGroup'] as String?,
      bookSourceType: json['bookSourceType'] as int? ?? 0,
      bookUrlPattern: json['bookUrlPattern'] as String?,
      customOrder: json['customOrder'] as int? ?? 0,
      enabled: json['enabled'] as bool? ?? true,
      enabledExplore: json['enabledExplore'] as bool? ?? true,
      concurrentRate: json['concurrentRate'] as String?,
      header: json['header'] as String?,
      loginUrl: json['loginUrl'] as String?,
      loginUi: json['loginUi'] as String?,
      loginCheckJs: json['loginCheckJs'] as String?,
      bookSourceComment: json['bookSourceComment'] as String?,
      lastUpdateTime: json['lastUpdateTime'] as int? ?? 0,
      respondTime: json['respondTime'] as int? ?? 180000,
      weight: json['weight'] as int? ?? 0,
      exploreUrl: json['exploreUrl'] as String?,
      ruleExplore: json['ruleExplore'] == null
          ? null
          : ExploreRule.fromJson(json['ruleExplore'] as Map<String, dynamic>),
      searchUrl: json['searchUrl'] as String?,
      ruleSearch: json['ruleSearch'] == null
          ? null
          : SearchRule.fromJson(json['ruleSearch'] as Map<String, dynamic>),
      ruleBookInfo: json['ruleBookInfo'] == null
          ? null
          : BookInfoRule.fromJson(json['ruleBookInfo'] as Map<String, dynamic>),
      ruleToc: json['ruleToc'] == null
          ? null
          : TocRule.fromJson(json['ruleToc'] as Map<String, dynamic>),
      ruleContent: json['ruleContent'] == null
          ? null
          : ContentRule.fromJson(json['ruleContent'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BookSourceToJson(BookSource instance) =>
    <String, dynamic>{
      'bookSourceUrl': instance.bookSourceUrl,
      'bookSourceName': instance.bookSourceName,
      'bookSourceGroup': instance.bookSourceGroup,
      'bookSourceType': instance.bookSourceType,
      'bookUrlPattern': instance.bookUrlPattern,
      'customOrder': instance.customOrder,
      'enabled': instance.enabled,
      'enabledExplore': instance.enabledExplore,
      'concurrentRate': instance.concurrentRate,
      'header': instance.header,
      'loginUrl': instance.loginUrl,
      'loginUi': instance.loginUi,
      'loginCheckJs': instance.loginCheckJs,
      'bookSourceComment': instance.bookSourceComment,
      'lastUpdateTime': instance.lastUpdateTime,
      'respondTime': instance.respondTime,
      'weight': instance.weight,
      'exploreUrl': instance.exploreUrl,
      'ruleExplore': instance.ruleExplore?.toJson(),
      'searchUrl': instance.searchUrl,
      'ruleSearch': instance.ruleSearch?.toJson(),
      'ruleBookInfo': instance.ruleBookInfo?.toJson(),
      'ruleToc': instance.ruleToc?.toJson(),
      'ruleContent': instance.ruleContent?.toJson(),
    };

ExploreRule _$ExploreRuleFromJson(Map<String, dynamic> json) => ExploreRule(
      bookList: json['bookList'] as String?,
      name: json['name'] as String?,
      author: json['author'] as String?,
      intro: json['intro'] as String?,
      kind: json['kind'] as String?,
      lastChapter: json['lastChapter'] as String?,
      updateTime: json['updateTime'] as String?,
      bookUrl: json['bookUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      wordCount: json['wordCount'] as String?,
    );

Map<String, dynamic> _$ExploreRuleToJson(ExploreRule instance) =>
    <String, dynamic>{
      'bookList': instance.bookList,
      'name': instance.name,
      'author': instance.author,
      'intro': instance.intro,
      'kind': instance.kind,
      'lastChapter': instance.lastChapter,
      'updateTime': instance.updateTime,
      'bookUrl': instance.bookUrl,
      'coverUrl': instance.coverUrl,
      'wordCount': instance.wordCount,
    };

SearchRule _$SearchRuleFromJson(Map<String, dynamic> json) => SearchRule(
      checkKeyWord: json['checkKeyWord'] as String?,
      bookList: json['bookList'] as String?,
      name: json['name'] as String?,
      author: json['author'] as String?,
      intro: json['intro'] as String?,
      kind: json['kind'] as String?,
      lastChapter: json['lastChapter'] as String?,
      updateTime: json['updateTime'] as String?,
      bookUrl: json['bookUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      wordCount: json['wordCount'] as String?,
    );

Map<String, dynamic> _$SearchRuleToJson(SearchRule instance) =>
    <String, dynamic>{
      'bookList': instance.bookList,
      'name': instance.name,
      'author': instance.author,
      'intro': instance.intro,
      'kind': instance.kind,
      'lastChapter': instance.lastChapter,
      'updateTime': instance.updateTime,
      'bookUrl': instance.bookUrl,
      'coverUrl': instance.coverUrl,
      'wordCount': instance.wordCount,
      'checkKeyWord': instance.checkKeyWord,
    };

BookInfoRule _$BookInfoRuleFromJson(Map<String, dynamic> json) => BookInfoRule(
      init: json['init'] as String?,
      name: json['name'] as String?,
      author: json['author'] as String?,
      intro: json['intro'] as String?,
      kind: json['kind'] as String?,
      lastChapter: json['lastChapter'] as String?,
      updateTime: json['updateTime'] as String?,
      coverUrl: json['coverUrl'] as String?,
      tocUrl: json['tocUrl'] as String?,
      wordCount: json['wordCount'] as String?,
      canReName: json['canReName'] as String?,
    );

Map<String, dynamic> _$BookInfoRuleToJson(BookInfoRule instance) =>
    <String, dynamic>{
      'init': instance.init,
      'name': instance.name,
      'author': instance.author,
      'intro': instance.intro,
      'kind': instance.kind,
      'lastChapter': instance.lastChapter,
      'updateTime': instance.updateTime,
      'coverUrl': instance.coverUrl,
      'tocUrl': instance.tocUrl,
      'wordCount': instance.wordCount,
      'canReName': instance.canReName,
    };

TocRule _$TocRuleFromJson(Map<String, dynamic> json) => TocRule(
      chapterList: json['chapterList'] as String?,
      chapterName: json['chapterName'] as String?,
      chapterUrl: json['chapterUrl'] as String?,
      isVolume: json['isVolume'] as String?,
      isVip: json['isVip'] as String?,
      isPay: json['isPay'] as String?,
      updateTime: json['updateTime'] as String?,
      nextTocUrl: json['nextTocUrl'] as String?,
    );

Map<String, dynamic> _$TocRuleToJson(TocRule instance) => <String, dynamic>{
      'chapterList': instance.chapterList,
      'chapterName': instance.chapterName,
      'chapterUrl': instance.chapterUrl,
      'isVolume': instance.isVolume,
      'isVip': instance.isVip,
      'isPay': instance.isPay,
      'updateTime': instance.updateTime,
      'nextTocUrl': instance.nextTocUrl,
    };

ContentRule _$ContentRuleFromJson(Map<String, dynamic> json) => ContentRule(
      content: json['content'] as String?,
      nextContentUrl: json['nextContentUrl'] as String?,
      webJs: json['webJs'] as String?,
      sourceRegex: json['sourceRegex'] as String?,
      replaceRegex: json['replaceRegex'] as String?,
      imageStyle: json['imageStyle'] as String?,
      payAction: json['payAction'] as String?,
    );

Map<String, dynamic> _$ContentRuleToJson(ContentRule instance) =>
    <String, dynamic>{
      'content': instance.content,
      'nextContentUrl': instance.nextContentUrl,
      'webJs': instance.webJs,
      'sourceRegex': instance.sourceRegex,
      'replaceRegex': instance.replaceRegex,
      'imageStyle': instance.imageStyle,
      'payAction': instance.payAction,
    };
