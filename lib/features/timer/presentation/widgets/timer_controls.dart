import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/timer_state.dart';
import '../providers/timer_provider.dart';

/// 귀여운 타이머 컨트롤 버튼 위젯
class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 리셋 버튼
        if (timerState.status != TimerStatus.idle) ...[
          _CuteControlButton(
            icon: Icons.refresh_rounded,
            label: '리셋',
            onPressed: timerNotifier.reset,
            backgroundColor: AppColors.peach.withOpacity(0.2),
            iconColor: AppColors.coral,
          ),
          const SizedBox(width: 20),
        ],
        // 메인 버튼
        _buildMainButton(context, timerState, timerNotifier),
      ],
    );
  }

  Widget _buildMainButton(
    BuildContext context,
    TimerState state,
    TimerNotifier notifier,
  ) {
    switch (state.status) {
      case TimerStatus.idle:
        return _CuteControlButton(
          icon: Icons.play_arrow_rounded,
          label: '시작! 🚀',
          onPressed: notifier.start,
          backgroundColor: AppColors.primary,
          iconColor: Colors.white,
          textColor: Colors.white,
          isLarge: true,
        );
      case TimerStatus.running:
        return _CuteControlButton(
          icon: Icons.pause_rounded,
          label: '잠깐! ✋',
          onPressed: notifier.pause,
          backgroundColor: AppColors.warning,
          iconColor: Colors.white,
          textColor: Colors.white,
          isLarge: true,
        );
      case TimerStatus.paused:
        return _CuteControlButton(
          icon: Icons.play_arrow_rounded,
          label: '다시! 💨',
          onPressed: notifier.resume,
          backgroundColor: AppColors.primary,
          iconColor: Colors.white,
          textColor: Colors.white,
          isLarge: true,
        );
      case TimerStatus.resting:
        return const SizedBox.shrink();
    }
  }
}

class _CuteControlButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final Color? textColor;
  final bool isLarge;

  const _CuteControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.iconColor,
    this.textColor,
    this.isLarge = false,
  });

  @override
  State<_CuteControlButton> createState() => _CuteControlButtonState();
}

class _CuteControlButtonState extends State<_CuteControlButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.isLarge ? 140.0 : 80.0;
    final iconSize = widget.isLarge ? 32.0 : 24.0;
    final fontSize = widget.isLarge ? 16.0 : 12.0;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(size / 3),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: iconSize,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: widget.textColor ?? widget.iconColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
