import 'package:flutter/material.dart';
import 'package:as_projeto/models/character.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final bool compact;
  final VoidCallback? onTap;
  const CharacterCard({super.key, required this.character, this.compact = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 0.75,
                  child: Container(
                    color: theme.colorScheme.surface,
                    alignment: Alignment.center,
                    child: Semantics(
                      label: 'Imagem de ${character.name}',
                      child: character.imageUrl.isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : Image.network(
                              character.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.broken_image));
                              },
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        character.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        character.type,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Container(
                    color: theme.colorScheme.surface,
                    alignment: Alignment.center,
                    child: Semantics(
                      label: 'Imagem de ${character.name}',
                      child: character.imageUrl.isEmpty
                          ? const Icon(Icons.image_not_supported)
                          : Image.network(
                              character.imageUrl,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.broken_image));
                              },
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          character.name,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          character.type,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
