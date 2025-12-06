import 'package:flutter/material.dart';
import 'package:as_projeto/models/character.dart';

class CardDetailScreen extends StatelessWidget {
  final Character character;
  const CardDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.name,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    clipBehavior: Clip.antiAlias,
                    child: AspectRatio(
                      aspectRatio: 0.72,
                      child: Container(
                        color: theme.colorScheme.surface,
                        alignment: Alignment.center,
                        child: character.imageUrl.isEmpty
                            ? const Icon(Icons.image_not_supported, size: 64)
                            : Image.network(
                                character.imageUrl,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: Chip(
                      label: Text(
                        character.type,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
