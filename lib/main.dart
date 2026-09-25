import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const ExploraEcApp());
}

/// Colors lifted from the "ExploraEC Design System" generated in Stitch.
class ExploraEcColors {
  static const primary = Color(0xFF006948);
  static const primaryContainer = Color(0xFF00855D);
  static const primaryFixed = Color(0xFF85F8C4);
  static const secondary = Color(0xFF006A61);
  static const secondaryFixed = Color(0xFF89F5E7);
  static const tertiaryContainer = Color(0xFFA36700);
  static const onSurface = Color(0xFF131B2E);
  static const onSurfaceVariant = Color(0xFF3D4A42);
  static const surface = Color(0xFFFAF8FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainer = Color(0xFFEAEDFF);
  static const surfaceContainerHighest = Color(0xFFDAE2FD);
  static const outline = Color(0xFF6D7A72);
  static const outlineVariant = Color(0xFFBCCAC0);
}

class ExploraEcApp extends StatelessWidget {
  const ExploraEcApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();
    return MaterialApp(
      title: 'ExploraEC',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ExploraEcColors.surface,
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ExploraEcColors.primary,
          primary: ExploraEcColors.primary,
          secondary: ExploraEcColors.secondary,
          surface: ExploraEcColors.surface,
        ),
      ),
      home: const BienvenidaScreen(),
    );
  }
}

class BienvenidaScreen extends StatefulWidget {
  const BienvenidaScreen({super.key});

  @override
  State<BienvenidaScreen> createState() => _BienvenidaScreenState();
}

class _BienvenidaScreenState extends State<BienvenidaScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1, milliseconds: 200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ExploraEcColors.surface,
      body: Stack(
        children: [
          // Ambient nature aurora background glows.
          const Positioned(top: -120, left: 40, right: 40, height: 320, child: _GlowCircle(color: ExploraEcColors.secondaryFixed, opacity: 0.30)),
          const Positioned(top: 220, right: -90, width: 260, height: 260, child: _GlowCircle(color: ExploraEcColors.primaryFixed, opacity: 0.25)),
          const Positioned(bottom: 40, left: -100, width: 300, height: 300, child: _GlowCircle(color: ExploraEcColors.surfaceContainerHighest, opacity: 0.6)),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const Spacer(),
                      _buildHero(),
                      const Spacer(),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Pill(
          background: ExploraEcColors.surfaceContainerLowest.withValues(alpha: 0.8),
          borderColor: ExploraEcColors.outlineVariant.withValues(alpha: 0.3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_outlined, size: 16, color: ExploraEcColors.primary),
              const SizedBox(width: 4),
              Text(
                'ECUADOR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: ExploraEcColors.primary,
                ),
              ),
            ],
          ),
        ),
        _Pill(
          background: ExploraEcColors.surfaceContainer.withValues(alpha: 0.7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: Tween(begin: 0.4, end: 1.0).animate(_pulseController),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: ExploraEcColors.primary, shape: BoxShape.circle),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'En vivo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ExploraEcColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Column(
      children: [
        // Prominent map/compass icon cluster.
        SizedBox(
          width: 176,
          height: 176,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const _GlowCircle(color: ExploraEcColors.secondaryFixed, opacity: 0.4),
              Container(
                width: 144,
                height: 144,
                decoration: BoxDecoration(
                  color: ExploraEcColors.surfaceContainerLowest.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
                  boxShadow: [
                    BoxShadow(
                      color: ExploraEcColors.secondary.withValues(alpha: 0.15),
                      blurRadius: 30,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.travel_explore, size: 72, color: ExploraEcColors.primary),
              ),
              Positioned(
                bottom: -8,
                right: 4,
                child: _Pill(
                  background: ExploraEcColors.surfaceContainerLowest.withValues(alpha: 0.95),
                  borderColor: ExploraEcColors.outlineVariant.withValues(alpha: 0.3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.near_me, size: 14, color: ExploraEcColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        'GPS Activo',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ExploraEcColors.onSurface),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'ExploraEC',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: ExploraEcColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Descubre los mejores lugares cerca de ti',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: ExploraEcColors.onSurfaceVariant, height: 1.4),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _CategoryChip(icon: Icons.terrain, label: 'Rutas naturales', iconColor: ExploraEcColors.primary),
            _CategoryChip(icon: Icons.visibility_outlined, label: 'Miradores', iconColor: ExploraEcColors.secondary),
            _CategoryChip(icon: Icons.restaurant, label: 'Gastronomía local', iconColor: ExploraEcColors.tertiaryContainer),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ExploraEcColors.primary, ExploraEcColors.primaryContainer],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: ExploraEcColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  // TODO: navegar al flujo principal de exploración.
                },
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Empezar',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            // TODO: navegar a inicio de sesión.
          },
          style: TextButton.styleFrom(foregroundColor: ExploraEcColors.onSurfaceVariant),
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: ExploraEcColors.onSurfaceVariant),
              children: [
                const TextSpan(text: '¿Ya tienes una cuenta? '),
                TextSpan(
                  text: 'Iniciar sesión',
                  style: TextStyle(fontWeight: FontWeight.w700, color: ExploraEcColors.primary, decoration: TextDecoration.underline),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco_outlined, size: 12, color: ExploraEcColors.outline),
            const SizedBox(width: 4),
            Text(
              'Turismo responsable y sostenible',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ExploraEcColors.outline),
            ),
          ],
        ),
      ],
    );
  }
}

/// Soft blurred circle used for the ambient background glows.
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.opacity});

  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: DecoratedBox(
        decoration: BoxDecoration(color: color.withValues(alpha: opacity), shape: BoxShape.circle),
      ),
    );
  }
}

/// Small rounded "glass" pill used for badges and chips.
class _Pill extends StatelessWidget {
  const _Pill({required this.child, required this.background, this.borderColor});

  final Widget child;
  final Color background;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: borderColor != null ? Border.all(color: borderColor!) : null,
      ),
      child: child,
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.icon, required this.label, required this.iconColor});

  final IconData icon;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return _Pill(
      background: ExploraEcColors.surfaceContainerLowest.withValues(alpha: 0.8),
      borderColor: ExploraEcColors.outlineVariant.withValues(alpha: 0.3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ExploraEcColors.onSurface)),
        ],
      ),
    );
  }
}
