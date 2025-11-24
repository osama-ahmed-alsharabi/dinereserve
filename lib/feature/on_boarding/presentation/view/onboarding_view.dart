import 'package:dinereserve/core/router/app_router_const.dart';
import 'package:dinereserve/core/utils/app_asset.dart';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:dinereserve/core/utils/app_text_style.dart';
import 'package:dinereserve/feature/on_boarding/data/model/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentPage = 0;

  List<OnboardingModel> onBoardingModelList = [
    OnboardingModel(
      image: AppAsset.imagesFirstOnboardingImage,
      title: "Discover the Best Restaurants Around You",
      subtitle:
          "Have you ever felt frustrated when looking for a special meal outside home, but got lost among dozens of options in food apps? Or when visiting a new city and wanting to try authentic dishes without falling into tourist traps? Discovering the best restaurants around you is like an enjoyable exploration journey, not just searching for food, but for a complete experience that refreshes the soul and excites the senses.",
    ),
    OnboardingModel(
      image: AppAsset.imagesSecondOnboardingImage,
      title: "Reserve Your Table in 3 Clicks",
      subtitle:
          "Goodbye to waiting.. Hello to simplicity!"
          "- Order and pay through the app in advance.\n- Get exclusive offers for your reservations.\n- Plan family gatherings or romantic trips smoothly.",
    ),
    OnboardingModel(
      image: AppAsset.imagesThirdOnboardingImage,
      title: "Enjoy Exclusive Offers and Trusted Reviews",
      subtitle:
          "Enjoy a unique shopping experience that combines exclusive packages specially provided for you, and the reassurance from genuine and trusted customer reviews. Get the best offers while making your decisions with great confidence. Make every purchase combine excellence and savings.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });

    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < onBoardingModelList.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    context.goNamed(AppRouterConst.registerViewRouteName);
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Widget _buildAnimatedContent(Widget child) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(scale: _scaleAnimation, child: child),
      ),
    );
  }

  Widget _buildCurvedTopContainer(Widget child) {
    return ClipPath(
      clipper: CurvedTopClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Image Section with Curved Bottom
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: onBoardingModelList.length,
                itemBuilder: (context, index) {
                  return _buildCurvedTopContainer(
                    AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }

                        return Transform.scale(
                          scale: value,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: screenHeight * 0.02,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Image.asset(
                        onBoardingModelList[index].image,
                        fit: BoxFit.contain,
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.4,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Content Section
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // Title with animation
                    _buildAnimatedContent(
                      SizedBox(
                        child: Text(
                          onBoardingModelList[_currentPage].title,
                          style: context.textStyle.text16Regular.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Subtitle with animation - FIXED: Removed Expanded from here
                    _buildAnimatedContent(
                      SizedBox(
                        child: SingleChildScrollView(
                          child: Text(
                            onBoardingModelList[_currentPage].subtitle,
                            style: context.textStyle.text12Regular.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                    Spacer(),

                    // Skip/Get Started Button
                    _buildAnimatedContent(
                      SizedBox(
                        width: screenWidth * 0.6,
                        child: ElevatedButton(
                          onPressed: _skipOnboarding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                          child: Text(
                            _currentPage == onBoardingModelList.length - 1
                                ? "Get Started"
                                : "Skip",
                            style: context.textStyle.text20Mediam.copyWith(
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Navigation Controls
                    _buildAnimatedContent(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Previous button
                          IconButton(
                            onPressed: _currentPage > 0 ? _previousPage : null,
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: _currentPage > 0
                                  ? Colors.white
                                  : Colors.white54,
                              size: screenWidth * 0.05,
                            ),
                          ),

                          // Page indicators
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onBoardingModelList.length,
                              (index) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: EdgeInsets.all(screenWidth * 0.01),
                                  width: _currentPage == index
                                      ? screenWidth * 0.05
                                      : screenWidth * 0.025,
                                  height: screenWidth * 0.025,
                                  decoration: BoxDecoration(
                                    color: _currentPage == index
                                        ? Colors.white
                                        : Colors.white54,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Next button
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: IconButton(
                              onPressed: _nextPage,
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: screenWidth * 0.05,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from bottom-left
    path.lineTo(0, size.height - 30);

    // Create curved bottom
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 30,
    );

    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 60,
      size.width,
      size.height - 30,
    );

    // Complete the path
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
