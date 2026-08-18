import 'package:equatable/equatable.dart';
import 'broker_model.dart';
import 'property_model.dart';
import 'social_enums.dart';

class SocialPostModel extends Equatable {
  static const String tableName = "social_posts";

  final String? id;
  final BrokerModel? brokerId;
  final PropertyModel? propertyId;
  final SocialPlatform? platform;
  final String? pageId;
  final String? postId;
  final String? caption;
  final List<dynamic>? mediaUrls;
  final String? permalink;
  final int? viewsCount;
  final int? commentCount;
  final int? likesCount;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Backward compatibility getters
  PropertyModel? get property => propertyId;

  const SocialPostModel({
    this.id,
    this.brokerId,
    this.propertyId,
    this.platform,
    this.pageId,
    this.postId,
    this.caption,
    this.mediaUrls,
    this.permalink,
    this.viewsCount,
    this.commentCount,
    this.likesCount,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
  });

  static SocialPostModel fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return SocialPostModel(id: json?.toString());
    }

    PropertyModel? parsedProperty;
    if (json['property'] != null) {
      parsedProperty = PropertyModel.fromJson(json['property']);
    } else if (json['properties'] != null) {
      parsedProperty = PropertyModel.fromJson(json['properties']);
    } else if (json['property_id'] != null) {
      parsedProperty = PropertyModel.fromJson(json['property_id']);
    }

    return SocialPostModel(
      id: json['id']?.toString(),
      brokerId: json['broker_id'] != null
          ? BrokerModel.fromJson(json['broker_id'])
          : null,
      propertyId: parsedProperty,
      platform: json['platform'] != null
          ? SocialPlatform.fromDbValue(json['platform'].toString())
          : null,
      pageId: json['page_id']?.toString(),
      postId: json['post_id']?.toString(),
      caption: json['caption']?.toString(),
      mediaUrls: json['media_urls'] as List<dynamic>?,
      permalink: json['permalink']?.toString(),
      viewsCount: json['views_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      likesCount: json['likes_count'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())?.toLocal()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toLocal()
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())?.toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['id'] = id;
    data['broker_id'] = brokerId?.id;
    data['property_id'] = propertyId?.id;
    if (platform != null) data['platform'] = platform?.dbValue;
    if (pageId != null) data['page_id'] = pageId;
    if (postId != null) data['post_id'] = postId;
    data['caption'] = caption;
    if (mediaUrls != null) data['media_urls'] = mediaUrls;
    data['permalink'] = permalink;
    data['views_count'] = viewsCount;
    data['comment_count'] = commentCount;
    data['likes_count'] = likesCount;
    if (publishedAt != null) {
      data['published_at'] = publishedAt?.toUtc().toIso8601String();
    }
    if (createdAt != null) {
      data['created_at'] = createdAt?.toUtc().toIso8601String();
    }
    if (updatedAt != null) {
      data['updated_at'] = updatedAt?.toUtc().toIso8601String();
    }
    return data;
  }

  SocialPostModel copyWith({
    String? id,
    BrokerModel? brokerId,
    PropertyModel? propertyId,
    SocialPlatform? platform,
    String? pageId,
    String? postId,
    String? caption,
    List<dynamic>? mediaUrls,
    String? permalink,
    int? viewsCount,
    int? commentCount,
    int? likesCount,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SocialPostModel(
      id: id ?? this.id,
      brokerId: brokerId ?? this.brokerId,
      propertyId: propertyId ?? this.propertyId,
      platform: platform ?? this.platform,
      pageId: pageId ?? this.pageId,
      postId: postId ?? this.postId,
      caption: caption ?? this.caption,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      permalink: permalink ?? this.permalink,
      viewsCount: viewsCount ?? this.viewsCount,
      commentCount: commentCount ?? this.commentCount,
      likesCount: likesCount ?? this.likesCount,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        brokerId,
        propertyId,
        platform,
        pageId,
        postId,
        caption,
        mediaUrls,
        permalink,
        viewsCount,
        commentCount,
        likesCount,
        publishedAt,
        createdAt,
        updatedAt,
      ];
}
