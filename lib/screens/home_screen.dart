import 'package:flutter/material.dart';
import 'package:as_projeto/services/character_service.dart';
import 'package:as_projeto/models/character.dart';
import 'package:as_projeto/widgets/character_card.dart';
import 'package:as_projeto/widgets/app_search_bar.dart';
import 'package:as_projeto/screens/card_detail_screen.dart';
import 'package:as_projeto/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _service = CharacterService();
  var _firebaseService = FirebaseService();
  late Future<List<Character>> _charactersFuture;
  var _allCharacters = <Character>[];
  var _filteredCharacters = <Character>[];

  @override
  void initState() {
    super.initState();
    _charactersFuture = _loadCharacters();
  }

  Future<List<Character>> _loadCharacters() async {
    var data = await _service.getCharacter();
    _allCharacters = data;
    _filteredCharacters = data;
    return data;
  }

  Future<void> _refresh() async {
    setState(() {
      _charactersFuture = _loadCharacters();
    });
    await _charactersFuture;
  }

  void _filterCharacters(String query) {
    setState(() {
      var normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) {
        _filteredCharacters = _allCharacters;
      } else {
        _filteredCharacters = _allCharacters
            .where((c) => c.name.toLowerCase().contains(normalized))
            .toList();
      }
    });
  }

  // Função para realizar logout do Firebase
  // Após o logout, o StreamBuilder no main.dart detecta automaticamente
  // a mudança de estado e redireciona o usuário para a tela de login
  void _handleLogout() async {
    await _firebaseService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Magic: The Gathering Cartas',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        // Botão de logout no AppBar
        // Ao clicar, chama _handleLogout() que realiza o logout do Firebase
        // O redirecionamento para a tela de login é automático via StreamBuilder no main.dart
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 8, 8, 8),),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: AppSearchBar(onChanged: _filterCharacters),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Character>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return _ErrorState(onRetry: _refresh);
                }
                var list = _filteredCharacters;
                if (list.isEmpty) {
                  return const _EmptyState();
                }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refresh,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              var isWide = constraints.maxWidth >= 700;
                              if (isWide) {
                                return Align(
                                  alignment: Alignment.topCenter,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 1200),
                                    child: GridView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 280,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 0.75,
                                      ),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        var character = list[index];
                                        return CharacterCard(
                                          character: character,
                                          compact: true,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => CardDetailScreen(character: character),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return Align(
                                alignment: Alignment.topCenter,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 640),
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      var character = list[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: CharacterCard(
                                          character: character,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => CardDetailScreen(character: character),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
              },
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Nenhum resultado encontrado'),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final onRetry;
  _ErrorState({required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Erro ao carregar os dados'),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
