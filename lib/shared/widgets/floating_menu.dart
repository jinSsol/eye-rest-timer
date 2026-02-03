import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 플로팅 메뉴 아이템
class FloatingMenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FloatingMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// 플로팅 확장 메뉴
class FloatingExpandMenu extends StatefulWidget {
  final List<FloatingMenuItem> items;
  final int currentIndex;

  const FloatingExpandMenu({
    super.key,
    required this.items,
    this.currentIndex = 0,
  });

  @override
  State<FloatingExpandMenu> createState() => _FloatingExpandMenuState();
}

class _FloatingExpandMenuState extends State<FloatingExpandMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // 배경 오버레이
        if (_isOpen)
          GestureDetector(
            onTap: _toggle,
            child: AnimatedOpacity(
              opacity: _isOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),

        // 메뉴 아이템들
        Positioned(
          bottom: 100,
          right: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(widget.items.length, (index) {
              final item = widget.items[index];
              final isSelected = index == widget.currentIndex;
              final reverseIndex = widget.items.length - 1 - index;

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0, 50),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        reverseIndex * 0.1,
                        0.6 + reverseIndex * 0.1,
                        curve: Curves.easeOutBack,
                      ),
                    ),
                  );

                  final opacityAnimation = Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        reverseIndex * 0.1,
                        0.5 + reverseIndex * 0.1,
                        curve: Curves.easeOut,
                      ),
                    ),
                  );

                  return Transform.translate(
                    offset: slideAnimation.value,
                    child: Opacity(
                      opacity: opacityAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MenuItem(
                          icon: item.icon,
                          label: item.label,
                          isSelected: isSelected,
                          onTap: () {
                            item.onTap();
                            _toggle();
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),

        // 메인 버튼
        Positioned(
          bottom: 24,
          right: 24,
          child: GestureDetector(
            onTap: _toggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _isOpen ? AppColors.coral : AppColors.buttonPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isOpen ? AppColors.coral : AppColors.buttonPrimary)
                        .withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: AnimatedRotation(
                turns: _isOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  _isOpen ? Icons.close : Icons.apps_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonPrimary : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.textPrimary,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
