
class UserMediaContainer {
  String? userId;
  String? moduleId;
  List<UserMedia>? userMedia;

  UserMediaContainer({this.userId, this.moduleId, this.userMedia});

  factory UserMediaContainer.fromJson(Map<String, dynamic> json) => UserMediaContainer(
        userId: json['user_id'] as String?,
        moduleId: json['module_id'] as String?,
        userMedia: (json['user_media'] as List<dynamic>?)
            ?.map((v) => UserMedia.fromJson(v as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'module_id': moduleId,
        if (userMedia != null)
          'user_media': userMedia!.map((v) => v.toJson()).toList(),
      };
}

class UserMedia {
  String? title;
  String? description;
  String? mediaType;
  String? mediaPath;
  String? nediaUrl;
  String? mediaSize;
  String? mediaLength;
  String? createdTimestamp;
  String? updatedTimestamp;
  String? deletedTimestamp;
  String? modifyBy;

  UserMedia({
    this.title,
    this.description,
    this.mediaType,
    this.mediaPath,
    this.nediaUrl,
    this.mediaSize,
    this.mediaLength,
    this.createdTimestamp,
    this.updatedTimestamp,
    this.deletedTimestamp,
    this.modifyBy,
  });

  factory UserMedia.fromJson(Map<String, dynamic> json) => UserMedia(
        title: json['title'] as String?,
        description: json['description'] as String?,
        mediaType: json['media_type'] as String?,
        mediaPath: json['media_path'] as String?,
        nediaUrl: json['nedia_url'] as String?,
        mediaSize: json['media_size'] as String?,
        mediaLength: json['media_length'] as String?,
        createdTimestamp: json['created_timestamp'] as String?,
        updatedTimestamp: json['updated_timestamp'] as String?,
        deletedTimestamp: json['deleted_timestamp'] as String?,
        modifyBy: json['modify_by'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'media_type': mediaType,
        'media_path': mediaPath,
        'nedia_url': nediaUrl,
        'media_size': mediaSize,
        'media_length': mediaLength,
        'created_timestamp': createdTimestamp,
        'updated_timestamp': updatedTimestamp,
        'deleted_timestamp': deletedTimestamp,
        'modify_by': modifyBy,
      };
}
