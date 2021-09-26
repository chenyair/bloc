import 'package:flutter_pagination_search_filter/pokemon/api/queries/queries.dart'
    as queries;
import 'package:flutter_pagination_search_filter/pokemon/models/pokemon.dart';
import 'package:graphql/client.dart';

class GetPokemonRequestFailure implements Exception {}

class PokemonApiClient {
  const PokemonApiClient({
    required GraphQLClient graphQLClient,
  }) : _graphQLClient = graphQLClient;

  factory PokemonApiClient.create() {
    final httpLink = HttpLink('https://beta.pokeapi.co/graphql/v1beta');
    final link = Link.from([httpLink]);
    return PokemonApiClient(
        graphQLClient: GraphQLClient(link: link, cache: GraphQLCache()));
  }

  final GraphQLClient _graphQLClient;

  Future<List<Pokemon>> getPokemons(String query, int limit, int offset) async {
    final result = await _graphQLClient.query(
      QueryOptions(
        document: gql(queries.getPokemons),
        variables: <String, dynamic>{
          'query': query,
          'limit': limit,
          'offset': offset
        },
      ),
    );

    if (result.hasException) throw GetPokemonRequestFailure();
    final data = result.data?['pokemon'] as List;
    return data
        .map<Pokemon>(
            (dynamic e) => Pokemon.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
