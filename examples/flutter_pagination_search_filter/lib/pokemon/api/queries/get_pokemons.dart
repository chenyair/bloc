const getPokemons = r'''
  query GetPokemons($query: String = "", $limit: Int!, $offset: Int!) {
    pokemon: pokemon_v2_pokemon(where: {name: {_like: $query }}, offset: $offset, limit: $limit) {
      id
      name
      height
    }
  }
''';
