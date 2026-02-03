import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/eye_character.dart';

/// 온보딩/사용 가이드 화면 - 귀엽고 아기자기한 스타일
class OnboardingScreen extends StatefulWidget {
  final bool isFromSettings;
  final VoidCallback? onComplete;

  const OnboardingScreen({
    super.key,
    this.isFromSettings = false,
    this.onComplete,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _floatController;
  late AnimationController _bounceController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      icon: Icons.visibility_rounded,
      title: '20-20-20 규칙',
      description: '디지털 기기 사용으로 지친 눈을 위한\n간단하고 효과적인 휴식 규칙이에요',
      detail: '20분 작업 → 6m 바라보기 → 20초 휴식',
      bgColor: const Color(0xFFE8F5E9),
      accentColor: AppColors.primary,
    ),
    OnboardingPage(
      icon: Icons.timer_rounded,
      title: '타이머로 집중!',
      description: '시작 버튼만 누르면 끝!\n배경이 예쁘게 채워지며 진행률을 보여줘요',
      detail: '시간이 되면 알아서 휴식 알림이 와요',
      bgColor: const Color(0xFFFFF8E1),
      accentColor: AppColors.yellow,
    ),
    OnboardingPage(
      icon: Icons.bar_chart_rounded,
      title: '기록을 확인해요',
      description: '오늘 얼마나 쉬었는지,\n연속으로 며칠째 달성 중인지 한눈에!',
      detail: '주간 그래프로 일주일 기록도 볼 수 있어요',
      bgColor: const Color(0xFFE3F2FD),
      accentColor: AppColors.blue,
    ),
    OnboardingPage(
      icon: Icons.tune_rounded,
      title: '나에게 딱 맞게',
      description: '집중 시간, 휴식 시간을\n내 스타일에 맞게 조절해요',
      detail: '1~60분 집중, 10~60초 휴식 설정 가능!',
      bgColor: const Color(0xFFFFEBEE),
      accentColor: AppColors.coral,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPageData = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentPageData.bgColor,
              currentPageData.bgColor.withOpacity(0.7),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // 배경 장식 요소들
            ..._buildFloatingDecorations(),

            // 메인 컨텐츠
            SafeArea(
              child: Column(
                children: [
                  // 상단 바
                  _buildTopBar(),

                  // 페이지 컨텐츠
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        return _buildPage(_pages[index], index);
                      },
                    ),
                  ),

                  // 하단 섹션
                  _buildBottomSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingDecorations() {
    return [
      // 큰 원형 장식
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            top: -50 + (_floatController.value * 20),
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pages[_currentPage].accentColor.withOpacity(0.1),
              ),
            ),
          );
        },
      ),
      // 작은 원형 장식들
      AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Positioned(
            bottom: 200 - (_floatController.value * 15),
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pages[_currentPage].accentColor.withOpacity(0.08),
              ),
            ),
          );
        },
      ),
      // 반짝이 효과들
      ..._buildSparkles(),
    ];
  }

  List<Widget> _buildSparkles() {
    final random = math.Random(42);
    return List.generate(8, (index) {
      final top = random.nextDouble() * 600 + 100;
      final left = random.nextDouble() * 300 + 20;
      final size = random.nextDouble() * 8 + 4;
      final delay = random.nextDouble();

      return AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          final opacity = (math.sin((_floatController.value + delay) * math.pi * 2) + 1) / 2;
          return Positioned(
            top: top,
            left: left,
            child: Opacity(
              opacity: opacity * 0.6,
              child: Icon(
                Icons.star_rounded,
                size: size,
                color: _pages[_currentPage].accentColor.withOpacity(0.5),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.isFromSettings)
            _buildGlassButton(
              icon: Icons.close_rounded,
              onTap: () => Navigator.of(context).pop(),
            )
          else
            const SizedBox(width: 48),
          if (!widget.isFromSettings && _currentPage < _pages.length - 1)
            GestureDetector(
              onTap: _complete,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '건너뛰기',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 20, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 캐릭터/이모지 영역
          AnimatedBuilder(
            animation: _bounceController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -8 + (_bounceController.value * 16)),
                child: child,
              );
            },
            child: _buildCharacterArea(page, index),
          ),
          const SizedBox(height: 40),

          // 글래스모피즘 카드
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: page.accentColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 타이틀
                    Text(
                      page.title,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: page.accentColor.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 설명
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 디테일 태그
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: page.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.tips_and_updates_rounded,
                            size: 16,
                            color: page.accentColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              page.detail,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: page.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterArea(OnboardingPage page, int index) {
    // 첫 페이지는 눈 캐릭터, 나머지는 아이콘
    if (index == 0) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: page.accentColor.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: const Center(
          child: SimpleEyes(
            size: 45,
            isBlinking: true,
          ),
        ),
      );
    }

    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: page.accentColor.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          page.icon,
          size: 64,
          color: page.accentColor,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: [
          // 페이지 인디케이터
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => _buildDot(index),
            ),
          ),
          const SizedBox(height: 24),

          // 버튼
          GestureDetector(
            onTap: _nextPage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _pages[_currentPage].accentColor,
                    _pages[_currentPage].accentColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _pages[_currentPage].accentColor.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _currentPage < _pages.length - 1 ? '다음으로' : '시작하기',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _currentPage < _pages.length - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    final page = _pages[_currentPage];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? page.accentColor : Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: page.accentColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final String detail;
  final Color bgColor;
  final Color accentColor;

  OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.detail,
    required this.bgColor,
    required this.accentColor,
  });
}
