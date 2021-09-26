part of 'pokemon_bloc.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object> get props => [];
}

class PokemonLoadInProgress extends PokemonState {}

class PokemonLoadSuccess extends PokemonState {
  const PokemonLoadSuccess(
    this.pokemons,
  );

  final List<Pokemon> pokemons;

  @override
  List<Object> get props => [pokemons];
}

class PokemonLoadFailure extends PokemonState {}
