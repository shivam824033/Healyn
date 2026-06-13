import 'package:flutter/material.dart';

import '../../../shared/design/colors.dart';
import '../../../shared/design/motion.dart';
import '../../../shared/design/spacing.dart';
import '../../../shared/design/typography.dart';

/// Shown while [AuthStatus] is `unknown` (the token store is being read). The
/// router replaces it with /login or /home as soon as the status resolves.
///
/// The Refined Indigo brand hold: the Healyn logo card on the signature brand
/// gradient, with the wordmark and tagline beneath, a faint figure silhouette
/// bleeding off one corner, and a quiet dot grid in the other. It picks up
/// exactly where the native launch splash (`launch_background`) leaves off — the
/// same gradient and the same centred card — so boot flows in without a seam.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // A single, restrained reveal (UI_UX_GUIDELINES §7: motion confirms, never
  // delights for its own sake — a gentle fade with a touch of scale, no bounce).
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.7, curve: Curves.easeOut),
  );

  late final Animation<double> _scale = Tween(begin: 0.94, end: 1.0).animate(
    CurvedAnimation(parent: _controller, curve: HealynMotion.standardCurve),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final cardSize = (shortestSide * 0.34).clamp(116.0, 168.0);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: HealynColors.brandGradient),
        child: FadeTransition(
          opacity: _fade,
          child: Stack(
            children: [
              // Decorative figure silhouette, low-opacity, bleeding off the
              // bottom-right — a quiet echo of the brand mark.
              Positioned(
                right: -shortestSide * 0.16,
                bottom: -shortestSide * 0.06,
                child: const IgnorePointer(
                  child: Opacity(
                    opacity: 0.07,
                    child: ExcludeSemantics(
                      child: _Silhouette(),
                    ),
                  ),
                ),
              ),
              // A faint dot grid in the bottom-left, balancing the silhouette.
              const Positioned(
                left: HealynSpacing.s6,
                bottom: HealynSpacing.s8,
                child: IgnorePointer(
                  child: ExcludeSemantics(child: _DotGrid()),
                ),
              ),
              Center(
                child: ScaleTransition(
                  scale: _scale,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _LogoCard(size: cardSize),
                      const SizedBox(height: HealynSpacing.s6),
                      Image.asset(
                        'assets/branding/wordmark.png',
                        height: cardSize * 0.30,
                        fit: BoxFit.contain,
                        semanticLabel: 'Healyn',
                      ),
                      const SizedBox(height: HealynSpacing.s3),
                      Text(
                        'Care. Simple. Always.',
                        style: HealynTypography.caption.copyWith(
                          color: HealynColors.textInverse.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
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

/// The white rounded card holding the figure + heart mark — the same surface the
/// native launch splash shows, given a soft elevation here.
class _LogoCard extends StatelessWidget {
  const _LogoCard({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: HealynColors.surfaceBase,
        borderRadius: BorderRadius.circular(size * 0.26),
        boxShadow: [
          BoxShadow(
            color: HealynColors.brandPrimaryHover.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.18),
      child: Image.asset(
        'assets/branding/mark_oncard.png',
        fit: BoxFit.contain,
        semanticLabel: 'Healyn',
      ),
    );
  }
}

class _Silhouette extends StatelessWidget {
  const _Silhouette();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/figure_silhouette.png',
      height: MediaQuery.sizeOf(context).height * 0.42,
      fit: BoxFit.contain,
    );
  }
}

/// A 5×6 grid of small dots, drawn faintly to add texture without competing
/// with the centred logo.
class _DotGrid extends StatelessWidget {
  const _DotGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(72, 88),
      painter: _DotGridPainter(),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  static const _cols = 5;
  static const _rows = 6;
  static const _gap = 16.0;
  static const _radius = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = HealynColors.textInverse.withValues(alpha: 0.14);
    for (var r = 0; r < _rows; r++) {
      for (var c = 0; c < _cols; c++) {
        canvas.drawCircle(Offset(c * _gap, r * _gap), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}
