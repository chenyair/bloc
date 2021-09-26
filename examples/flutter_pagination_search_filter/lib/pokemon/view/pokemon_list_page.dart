import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pagination_search_filter/pokemon/bloc/pokemon_bloc.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({Key? key}) : super(key: key);

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_fetchMorePokemons);

    context.read<PokemonBloc>().add(const PokemonFetchStarted());
  }

  void _fetchMorePokemons() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      context.read<PokemonBloc>().add(const PokemonFetchStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon List'),
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PokemonLoadSuccess) {
            return Column(
              children: [
                TextFormField(onChanged: (value) {
                  context
                      .read<PokemonBloc>()
                      .add(PokemonFetchStarted(query: value));
                }),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final pokemonBloc = context.read<PokemonBloc>()
                        ..add(PokemonFetchRefresh());
                      // TODO:
                    },
                    child: ListView.builder(
                      controller: _controller,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.pokemons[index].name),
                        );
                      },
                      itemCount: state.pokemons.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return const Text('Error');
        },
      ),
    );
  }
}
