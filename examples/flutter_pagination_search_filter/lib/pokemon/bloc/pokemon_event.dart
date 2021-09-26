part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class PokemonFetchStarted extends PokemonEvent {
  const PokemonFetchStarted({
    this.offset,
    this.query = '',
  });

  final int? offset;
  final String query;

  @override
  List<Object?> get props => [offset];
}

class PokemonFetchRefresh extends PokemonEvent {}
