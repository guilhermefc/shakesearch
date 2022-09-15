import 'package:equatable/equatable.dart';

class SceneItem extends Equatable {
  const SceneItem({
    required this.text,
    required this.textExtended,
    required this.sceneName,
    required this.actName,
  });

  final String text;
  final String textExtended;
  final String sceneName;
  final String actName;

  @override
  List<Object?> get props => [text, textExtended, sceneName, actName];
}
