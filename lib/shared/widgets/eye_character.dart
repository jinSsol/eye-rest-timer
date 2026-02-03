import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 귀여운 눈 캐릭터 위젯
class EyeCharacter extends StatefulWidget {
  final double size;
  final bool isBlinking;
  final bool isLookingAround;
  final Color? bodyColor;

  const EyeCharacter({
    super.key,
    this.size = 200,
    this.isBlinking = true,
    this.isLookingAround = false,
    this.bodyColor,
  });

  @override
  State<EyeCharacter> createState() => _EyeCharacterState();
}

class _EyeCharacterState extends State<EyeCharacter>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _lookController;
  late Animation<double> _blinkAnimation;
  late Animation<double> _lookAnimation;

  @override
  void initState() {
    super.initState();

    // 깜빡임 애니메이션
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // 둘러보기 애니메이션
    _lookController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _lookAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _lookController, curve: Curves.easeInOut),
    );

    if (widget.isBlinking) {
      _startBlinking();
    }

    if (widget.isLookingAround) {
      _lookController.repeat(reverse: true);
    }
  }

  void _startBlinking() async {
    while (mounted && widget.isBlinking) {
      await Future.delayed(Duration(milliseconds: 2000 + math.Random().nextInt(2000)));
      if (mounted) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _lookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyColor = widget.bodyColor ?? AppColors.characterBody;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_blinkAnimation, _lookAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: _EyeCharacterPainter(
              blinkValue: _blinkAnimation.value,
              lookValue: widget.isLookingAround ? _lookAnimation.value : 0,
              bodyColor: bodyColor,
            ),
            size: Size(widget.size, widget.size),
          );
        },
      ),
    );
  }
}

class _EyeCharacterPainter extends CustomPainter {
  final double blinkValue;
  final double lookValue;
  final Color bodyColor;

  _EyeCharacterPainter({
    required this.blinkValue,
    required this.lookValue,
    required this.bodyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final bodyRadius = size.width * 0.4;

    // 몸체 그림자
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(
      center + const Offset(0, 10),
      bodyRadius,
      shadowPaint,
    );

    // 몸체
    final bodyPaint = Paint()..color = bodyColor;
    canvas.drawCircle(center, bodyRadius, bodyPaint);

    // 눈 위치 계산
    final eyeSpacing = size.width * 0.15;
    final eyeY = center.dy - size.height * 0.02;
    final eyeRadius = size.width * 0.12;

    final leftEyeCenter = Offset(center.dx - eyeSpacing, eyeY);
    final rightEyeCenter = Offset(center.dx + eyeSpacing, eyeY);

    // 눈 그리기
    _drawEye(canvas, leftEyeCenter, eyeRadius);
    _drawEye(canvas, rightEyeCenter, eyeRadius);
  }

  void _drawEye(Canvas canvas, Offset center, double radius) {
    // 눈 흰자
    final whitePaint = Paint()..color = AppColors.eyeWhite;
    final eyeHeight = radius * 2 * blinkValue;

    if (blinkValue > 0.3) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2,
          height: eyeHeight,
        ),
        whitePaint,
      );

      // 눈동자
      final pupilRadius = radius * 0.5;
      final pupilOffset = Offset(lookValue * radius * 0.3, 0);
      final pupilPaint = Paint()..color = AppColors.eyePupil;
      canvas.drawCircle(
        center + pupilOffset,
        pupilRadius,
        pupilPaint,
      );

      // 눈동자 하이라이트
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(
        center + pupilOffset + Offset(-pupilRadius * 0.3, -pupilRadius * 0.3),
        pupilRadius * 0.25,
        highlightPaint,
      );
    } else {
      // 감은 눈 (선으로 표현)
      final linePaint = Paint()
        ..color = AppColors.eyePupil
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(center.dx - radius, center.dy),
        Offset(center.dx + radius, center.dy),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _EyeCharacterPainter oldDelegate) {
    return oldDelegate.blinkValue != blinkValue ||
        oldDelegate.lookValue != lookValue ||
        oldDelegate.bodyColor != bodyColor;
  }
}

/// 두 눈만 있는 심플한 버전 (Nuny 스타일)
class SimpleEyes extends StatefulWidget {
  final double size;
  final bool isBlinking;
  final double? lookDirection; // -1.0 (왼쪽) ~ 1.0 (오른쪽)

  const SimpleEyes({
    super.key,
    this.size = 100,
    this.isBlinking = true,
    this.lookDirection,
  });

  @override
  State<SimpleEyes> createState() => _SimpleEyesState();
}

class _SimpleEyesState extends State<SimpleEyes>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.1).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    if (widget.isBlinking) {
      _startBlinking();
    }
  }

  void _startBlinking() async {
    while (mounted && widget.isBlinking) {
      await Future.delayed(Duration(milliseconds: 2500 + math.Random().nextInt(2000)));
      if (mounted) {
        await _blinkController.forward();
        await _blinkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blinkAnimation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildEye(_blinkAnimation.value),
            SizedBox(width: widget.size * 0.3),
            _buildEye(_blinkAnimation.value),
          ],
        );
      },
    );
  }

  Widget _buildEye(double openness) {
    final eyeSize = widget.size;
    final pupilOffset = (widget.lookDirection ?? 0) * eyeSize * 0.15;

    return Container(
      width: eyeSize,
      height: eyeSize * openness,
      decoration: BoxDecoration(
        color: AppColors.eyeWhite,
        borderRadius: BorderRadius.circular(eyeSize / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: openness > 0.3
          ? Center(
              child: Transform.translate(
                offset: Offset(pupilOffset, 0),
                child: Container(
                  width: eyeSize * 0.45,
                  height: eyeSize * 0.45,
                  decoration: const BoxDecoration(
                    color: AppColors.eyePupil,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: eyeSize * 0.08,
                        left: eyeSize * 0.08,
                        child: Container(
                          width: eyeSize * 0.12,
                          height: eyeSize * 0.12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
