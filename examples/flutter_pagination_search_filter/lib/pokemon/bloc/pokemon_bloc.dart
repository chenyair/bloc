import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_pagination_search_filter/pokemon/api/pokemon_api_client.dart';
import 'package:flutter_pagination_search_filter/pokemon/models/pokemon.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc(PokemonApiClient pokemonApiClient)
      : _pokemonApiClient = pokemonApiClient,
        super(PokemonLoadInProgress()) {
    on<PokemonFetchStarted>(_pokemonFetchStarted, transformer: droppable());
    on<PokemonFetchRefresh>(_pokemonFetchRefresh, transformer: droppable());
  }

  static const _itemsPerPage = 20;

  final PokemonApiClient _pokemonApiClient;
  int _lastOffset = 0;
  String _lastQuery = '';

  // Fetch Started
  Future<void> _pokemonFetchStarted(
    PokemonFetchStarted event,
    Emitter<PokemonState> emit,
  ) async {
    try {
      final newOffset = _getOffset(event);

      final newPokemons = await _pokemonApiClient.getPokemons(
        '%${event.query}%',
        _itemsPerPage,
        newOffset,
      );

      final currentState = state;
      final currentPokemonList =
          currentState is PokemonLoadSuccess && event.query == _lastQuery
              ? currentState.pokemons
              : <Pokemon>[];

      _lastOffset = newOffset;
      _lastQuery = event.query;

      emit(PokemonLoadSuccess([...currentPokemonList, ...newPokemons]));
    } on GetPokemonRequestFailure {
      emit(PokemonLoadFailure());
    }
  }

  int _getOffset(PokemonFetchStarted event) {
    final currentState = state;

    if (currentState is PokemonLoadInProgress || event.query != _lastQuery) {
      return 0;
    }

    return event.offset ?? _lastOffset + _itemsPerPage;
  }

  // Fetch Refresh
  Future<void> _pokemonFetchRefresh(
    PokemonFetchRefresh event,
    Emitter<PokemonState> emit,
  ) async {
    final pokemons = await _pokemonApiClient.getPokemons(
      '%$_lastQuery%',
      _itemsPerPage,
      0,
    );
    emit(PokemonLoadSuccess(pokemons));
  }
}
