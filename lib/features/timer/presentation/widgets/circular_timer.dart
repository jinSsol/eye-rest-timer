import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/timer_state.dart';

/// 물컵 스타일 타이머 위젯 - 물이 차오르는 효과
class CircularTimer extends StatefulWidget {
  final TimerState timerState;
  final double size;

  const CircularTimer({
    super.key,
    required this.timerState,
    this.size = 280,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 외곽 장식 (컵 테두리)
          Container(
            width: widget.size + 20,
            height: widget.size + 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _getDecorationColors(),
              ),
            ),
          ),
          // 내부 배경 (컵 내부)
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              boxShadow: [
                BoxShadow(
                  color: _getWaterColors()[0].withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // 물 채우기 효과
          ClipOval(
            child: SizedBox(
              width: widget.size - 16,
              height: widget.size - 16,
              child: AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(widget.size - 16, widget.size - 16),
                    painter: _WaterFillPainter(
                      progress: widget.timerState.progress,
                      waveAnimation: _waveController.value,
                      colors: _getWaterColors(),
                      isDark: isDark,
                    ),
                  );
                },
              ),
            ),
          ),
          // 컵 하이라이트 (유리 반사 효과)
          Positioned(
            left: widget.size * 0.15,
            top: widget.size * 0.15,
            child: Container(
              width: widget.size * 0.15,
              height: widget.size * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          // 중앙 컨텐츠
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상태 이모지
              Text(
                _getStatusEmoji(),
                style: TextStyle(fontSize: widget.size * 0.12),
              ),
              const SizedBox(height: 8),
              // 시간 표시
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
                      .withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.timerState.formattedTime,
                  style: TextStyle(
                    fontSize: widget.size * 0.18,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // 상태 텍스트
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: _getWaterColors()[0].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: widget.size * 0.05,
                    fontWeight: FontWeight.w600,
                    color: _getWaterColors()[0],
                  ),
                ),
              ),
            ],
          ),
          // 물방울 장식
          if (widget.timerState.progress > 0.1) ...[
            Positioned(
              right: widget.size * 0.2,
              top: widget.size * 0.25,
              child: _buildBubble(8),
            ),
            Positioned(
              right: widget.size * 0.28,
              top: widget.size * 0.4,
              child: _buildBubble(5),
            ),
            Positioned(
              left: widget.size * 0.25,
              top: widget.size * 0.35,
              child: _buildBubble(6),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBubble(double size) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        final offset = math.sin(_waveController.value * 2 * math.pi) * 3;
        return Transform.translate(
          offset: Offset(0, offset),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.6),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getDecorationColors() {
    switch (widget.timerState.status) {
      case TimerStatus.running:
        return [AppColors.primaryLight.withOpacity(0.5), AppColors.skyBlue.withOpacity(0.5)];
      case TimerStatus.paused:
        return [AppColors.peach.withOpacity(0.5), AppColors.warning.withOpacity(0.5)];
      case TimerStatus.resting:
        return [AppColors.accent.withOpacity(0.5), AppColors.lavender.withOpacity(0.5)];
      case TimerStatus.idle:
        return [AppColors.primaryLight.withOpacity(0.3), AppColors.skyBlue.withOpacity(0.3)];
    }
  }

  List<Color> _getWaterColors() {
    switch (widget.timerState.status) {
      case TimerStatus.running:
        return [AppColors.skyBlue, AppColors.blue];
      case TimerStatus.paused:
        return [AppColors.peach, AppColors.warning];
      case TimerStatus.resting:
        return [AppColors.lavender, AppColors.accent];
      case TimerStatus.idle:
        return [AppColors.skyBlue.withOpacity(0.5), AppColors.blue.withOpacity(0.5)];
    }
  }

  String _getStatusEmoji() {
    switch (widget.timerState.status) {
      case TimerStatus.running:
        return '💧';
      case TimerStatus.paused:
        return '☕';
      case TimerStatus.resting:
        return '🌊';
      case TimerStatus.idle:
        return '💦';
    }
  }

  String _getStatusText() {
    switch (widget.timerState.status) {
      case TimerStatus.running:
        return '집중 중!';
      case TimerStatus.paused:
        return '잠시 멈춤';
      case TimerStatus.resting:
        return '휴식 중~';
      case TimerStatus.idle:
        return '시작해볼까요?';
    }
  }
}

class _WaterFillPainter extends CustomPainter {
  final double progress;
  final double waveAnimation;
  final List<Color> colors;
  final bool isDark;

  _WaterFillPainter({
    required this.progress,
    required this.waveAnimation,
    required this.colors,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final width = size.width;
    final height = size.height;

    // 물의 높이 (progress에 따라)
    final waterHeight = height * progress;
    final waterTop = height - waterHeight;

    // 물결 효과를 위한 패스
    final wavePath = Path();

    // 시작점
    wavePath.moveTo(0, height);
    wavePath.lineTo(0, waterTop);

    // 물결 그리기 (사인파)
    final waveHeight = 8.0; // 물결 높이
    final waveLength = width / 2; // 물결 길이

    for (double x = 0; x <= width; x++) {
      final waveOffset = waveAnimation * 2 * math.pi;
      final y = waterTop +
          math.sin((x / waveLength) * 2 * math.pi + waveOffset) * waveHeight +
          math.sin((x / waveLength) * 4 * math.pi + waveOffset * 1.5) * (waveHeight / 2);
      wavePath.lineTo(x, y);
    }

    wavePath.lineTo(width, height);
    wavePath.close();

    // 그라데이션 페인트
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[0].withOpacity(0.7),
          colors[1].withOpacity(0.9),
        ],
      ).createShader(Rect.fromLTWH(0, waterTop, width, waterHeight));

    canvas.drawPath(wavePath, paint);

    // 두 번째 물결 레이어 (깊이감을 위해)
    final wavePath2 = Path();
    wavePath2.moveTo(0, height);
    wavePath2.lineTo(0, waterTop + 10);

    for (double x = 0; x <= width; x++) {
      final waveOffset = waveAnimation * 2 * math.pi + math.pi;
      final y = waterTop + 10 +
          math.sin((x / waveLength) * 2 * math.pi + waveOffset) * (waveHeight * 0.6);
      wavePath2.lineTo(x, y);
    }

    wavePath2.lineTo(width, height);
    wavePath2.close();

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colors[0].withOpacity(0.4),
          colors[1].withOpacity(0.6),
        ],
      ).createShader(Rect.fromLTWH(0, waterTop, width, waterHeight));

    canvas.drawPath(wavePath2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WaterFillPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.waveAnimation != waveAnimation ||
        oldDelegate.colors != colors;
  }
}
