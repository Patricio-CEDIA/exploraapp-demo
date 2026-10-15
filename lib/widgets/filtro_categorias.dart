import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Fila de chips para filtrar por categoría. «Todas» equivale a `null`.
class FiltroCategorias extends StatelessWidget {
  final List<String> categorias;
  final String? seleccionada;
  final ValueChanged<String?> alSeleccionar;
  const FiltroCategorias({
    super.key,
    required this.categorias,
    required this.seleccionada,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Todas'),
            selected: seleccionada == null,
            onSelected: (_) => alSeleccionar(null),
          ),
          for (final categoria in categorias) ...[
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Text(categoria),
              selected: seleccionada == categoria,
              onSelected: (_) => alSeleccionar(categoria),
            ),
          ],
        ],
      ),
    );
  }
}
