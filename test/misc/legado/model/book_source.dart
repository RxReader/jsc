import 'dart:convert';
import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'book_source.g.dart';

abstract class BaseSource {
  const BaseSource({
    this.concurrentRate,
    this.header,
    this.loginUrl,
    this.loginUi,
  });

  // 并发率
  final String? concurrentRate;

  // 请求头
  final String? header;

  // 登录地址
  final String? loginUrl;

  // 登录UI
  final String? loginUi;

  Map<String, String> getHeaderMap({
    String? userAgent,
  }) {
    return <String, String>{
      HttpHeaders.userAgentHeader: userAgent ?? 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36',
      if (header?.isNotEmpty ?? false)
        ...(json.decode(header!) as Map<String, dynamic>).cast<String, String>().map((String key, String value) {
          if (value.toLowerCase().startsWith('@js:')) {

          } else if (value.toLowerCase().startsWith('<js>')) {

          }
          return MapEntry<String, String>(key, value);
        }),
    };
  }
}

@JsonSerializable(
  explicitToJson: true,
)
class BookSource extends BaseSource {
  const BookSource({
    this.bookSourceUrl,
    this.bookSourceName,
    this.bookSourceGroup,
    required this.bookSourceType,
    this.bookUrlPattern,
    required this.customOrder,
    required this.enabled,
    required this.enabledExplore,
    String? concurrentRate,
    String? header,
    String? loginUrl,
    String? loginUi,
    this.loginCheckJs,
    this.bookSourceComment,
    required this.lastUpdateTime,
    required this.respondTime,
    required this.weight,
    this.exploreUrl,
    this.ruleExplore,
    this.searchUrl,
    this.ruleSearch,
    this.ruleBookInfo,
    this.ruleToc,
    this.ruleContent,
  }) : super(
          concurrentRate: concurrentRate,
          header: header,
          loginUrl: loginUrl,
          loginUi: loginUi,
        );

  factory BookSource.fromJson(Map<String, dynamic> json) => _$BookSourceFromJson(json);

  // 地址，包括 http/https
  final String? bookSourceUrl;

  // 名称
  final String? bookSourceName;

  // 分组
  final String? bookSourceGroup;

  // 类型，0 文本（默认），1 音频, 2 图片
  @JsonKey(defaultValue: 0)
  final int bookSourceType;

  // 详情页url正则
  final String? bookUrlPattern;

  // 手动排序编号
  @JsonKey(defaultValue: 0)
  final int customOrder;

  // 是否启用
  @JsonKey(defaultValue: true)
  final bool enabled;

  // 启用发现
  @JsonKey(defaultValue: true)
  final bool enabledExplore;

  // 登录检测js
  final String? loginCheckJs;

  // 注释
  final String? bookSourceComment;

  // 最后更新时间，用于排序
  @JsonKey(defaultValue: 0)
  final int lastUpdateTime;

  // 响应时间，用于排序
  @JsonKey(defaultValue: 180000)
  final int respondTime;

  // 智能排序的权重
  @JsonKey(defaultValue: 0)
  final int weight;

  // 发现url
  final String? exploreUrl;

  // 发现规则
  final ExploreRule? ruleExplore;

  // 搜索url
  final String? searchUrl;

  // 搜索规则
  final SearchRule? ruleSearch;

  // 书籍信息页规则
  final BookInfoRule? ruleBookInfo;

  // 目录页规则
  final TocRule? ruleToc;

  // 正文页规则
  final ContentRule? ruleContent;

  Map<String, dynamic> toJson() => _$BookSourceToJson(this);
}

abstract class BookListRule {
  const BookListRule({
    this.bookList,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.bookUrl,
    this.coverUrl,
    this.wordCount,
  });

  final String? bookList;
  final String? name;
  final String? author;
  final String? intro;
  final String? kind;
  final String? lastChapter;
  final String? updateTime;
  final String? bookUrl;
  final String? coverUrl;
  final String? wordCount;
}

@JsonSerializable(
  explicitToJson: true,
)
class ExploreRule extends BookListRule {
  const ExploreRule({
    String? bookList,
    String? name,
    String? author,
    String? intro,
    String? kind,
    String? lastChapter,
    String? updateTime,
    String? bookUrl,
    String? coverUrl,
    String? wordCount,
  }) : super(
          bookList: bookList,
          name: name,
          author: author,
          intro: intro,
          kind: kind,
          lastChapter: lastChapter,
          updateTime: updateTime,
          bookUrl: bookUrl,
          coverUrl: coverUrl,
          wordCount: wordCount,
        );

  factory ExploreRule.fromJson(Map<String, dynamic> json) => _$ExploreRuleFromJson(json);

  Map<String, dynamic> toJson() => _$ExploreRuleToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class SearchRule extends BookListRule {
  const SearchRule({
    this.checkKeyWord,
    String? bookList,
    String? name,
    String? author,
    String? intro,
    String? kind,
    String? lastChapter,
    String? updateTime,
    String? bookUrl,
    String? coverUrl,
    String? wordCount,
  }) : super(
          bookList: bookList,
          name: name,
          author: author,
          intro: intro,
          kind: kind,
          lastChapter: lastChapter,
          updateTime: updateTime,
          bookUrl: bookUrl,
          coverUrl: coverUrl,
          wordCount: wordCount,
        );

  factory SearchRule.fromJson(Map<String, dynamic> json) => _$SearchRuleFromJson(json);

  // 校验关键字
  final String? checkKeyWord;

  Map<String, dynamic> toJson() => _$SearchRuleToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class BookInfoRule {
  const BookInfoRule({
    this.init,
    this.name,
    this.author,
    this.intro,
    this.kind,
    this.lastChapter,
    this.updateTime,
    this.coverUrl,
    this.tocUrl,
    this.wordCount,
    this.canReName,
  });

  factory BookInfoRule.fromJson(Map<String, dynamic> json) => _$BookInfoRuleFromJson(json);

  final String? init;
  final String? name;
  final String? author;
  final String? intro;
  final String? kind;
  final String? lastChapter;
  final String? updateTime;
  final String? coverUrl;
  final String? tocUrl;
  final String? wordCount;
  final String? canReName;

  Map<String, dynamic> toJson() => _$BookInfoRuleToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class TocRule {
  const TocRule({
    this.chapterList,
    this.chapterName,
    this.chapterUrl,
    this.isVolume,
    this.isVip,
    this.isPay,
    this.updateTime,
    this.nextTocUrl,
  });

  factory TocRule.fromJson(Map<String, dynamic> json) => _$TocRuleFromJson(json);

  final String? chapterList;
  final String? chapterName;
  final String? chapterUrl;
  final String? isVolume;
  final String? isVip;
  final String? isPay;
  final String? updateTime;
  final String? nextTocUrl;

  Map<String, dynamic> toJson() => _$TocRuleToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
)
class ContentRule {
  const ContentRule({
    this.content,
    this.nextContentUrl,
    this.webJs,
    this.sourceRegex,
    this.replaceRegex,
    this.imageStyle,
    this.payAction,
  });

  factory ContentRule.fromJson(Map<String, dynamic> json) => _$ContentRuleFromJson(json);

  final String? content;
  final String? nextContentUrl;
  final String? webJs;
  final String? sourceRegex;
  final String? replaceRegex; // 替换规则
  final String? imageStyle; // 默认大小居中,FULL最大宽度
  final String? payAction; // 购买操作,js或者包含{{js}}的url

  Map<String, dynamic> toJson() => _$ContentRuleToJson(this);
}
