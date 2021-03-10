// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookChaptersResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


BookChaptersBean _$BookChaptersBeanFromJson(Map<String, dynamic> json) {
  return BookChaptersBean(
      json['currentcy'] as int,
      json['order'] as int,
      json['partsize'] as int,
      json['time'] as int,
      json['totalpage'] as int,
      json['unreadble'] as bool,
      json['chapterCover'] as String,
      json['id'] as String,
      json['link'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$BookChaptersBeanToJson(BookChaptersBean instance) =>
    <String, dynamic>{
      'currentcy': instance.currentcy,
      'order': instance.order,
      'partsize': instance.partsize,
      'time': instance.time,
      'totalpage': instance.totalpage,
      'unreadble': instance.unreadble,
      'chapterCover': instance.chapterCover,
      'id': instance.id,
      'link': instance.link,
      'title': instance.title
    };
