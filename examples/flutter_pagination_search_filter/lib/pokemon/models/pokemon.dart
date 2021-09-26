import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable(createToJson: false)
class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
    required this.height,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  final int id;
  final String name;
  final int height;

  @override
  List<Object?> get props => [id, name, height];
}
