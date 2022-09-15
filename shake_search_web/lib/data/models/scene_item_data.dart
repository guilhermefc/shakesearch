import 'dart:convert';

import 'package:shake_search/domain/entities/scene_item.dart';

class SceneItemData extends SceneItem {
  const SceneItemData({
    required super.text,
    required super.sceneName,
    required super.actName,
  });

  factory SceneItemData.fromMap(Map<String, dynamic> map) {
    return SceneItemData(
      text: map['Text'] as String,
      sceneName: map['Scene'] as String,
      actName: map['Act'] as String,
    );
  }

  factory SceneItemData.fromJson(String source) =>
      SceneItemData.fromMap(json.decode(source) as Map<String, dynamic>);
}
