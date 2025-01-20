import 'dart:math';

const int highText = 0xFFD50000;
const int highTemp = 0xFFD32F2F;
const int moderateText = 0xFFffC400;
const int moderateTemp = 0xFFFF9800;
const int normalText = 0xFF69F0AE;
const int normalTemp = 0xFF66BB6A;
const int lightBlueHumidity = 0xFF2196F3;
const int darkBlueMoisture = 0xFF3F51B5;

class ApiDataModel {
  final Channel channel;
  final List<Feeds> feeds;

  ApiDataModel({required this.channel, required this.feeds});

  factory ApiDataModel.fromJson(Map<String, dynamic> json) {
    return ApiDataModel(
      channel: Channel.fromJson(json['channel']),
      feeds: (json['feeds'] as List).map((v) => Feeds.fromJson(v)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel.toJson(),
      'feeds': feeds.map((v) => v.toJson()).toList(),
    };
  }
}

class Channel {
  final int id;
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final String field1;
  final String field2;
  final String field3;
  final String createdAt;
  final String updatedAt;
  final int lastEntryId;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.field1,
    required this.field2,
    required this.field3,
    required this.createdAt,
    required this.updatedAt,
    required this.lastEntryId,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      field1: json['field1'],
      field2: json['field2'],
      field3: json['field3'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      lastEntryId: json['last_entry_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'field1': field1,
      'field2': field2,
      'field3': field3,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_entry_id': lastEntryId,
    };
  }
}

class Feeds {
  final String createdAt;
  final int entryId;
  final String field1;
  final String field2;
  final String field3;

  Feeds({
    required this.createdAt,
    required this.entryId,
    required this.field1,
    required this.field2,
    required this.field3,
  });

  factory Feeds.fromJson(Map<String, dynamic> json) {
    return Feeds(
      createdAt: json['created_at'],
      entryId: json['entry_id'],
      field1: json['field1'],
      field2: json['field2'],
      field3: json['field3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'entry_id': entryId,
      'field1': field1,
      'field2': field2,
      'field3': field3,
    };
  }
}

class Conditions {
  late final String? icon;
  late final String? name;
  late final dynamic value; // Use dynamic if the type can vary
  late final String? subText;
  late final int? color; // Assuming color is an int
  late final int? subColor; // Assuming subColor is also an int

  Conditions({
    this.icon,
    this.name,
    this.value,
    this.subText,
    this.color,
    this.subColor,
  });
}