import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppConstants {
  static const Duration textFadeSlowDuration = Duration(seconds: 2);
  static const Duration textFadeFastDuration = Duration(milliseconds: 800);
  static const Duration imageFadeDuration = Duration(seconds: 3);
  static const Duration imageRotationDuration = Duration(seconds: 2);
  static const Duration manualToggleDuration = Duration(seconds: 1);
  
  static const double titleFontSize = 24.0;
  static const double primaryTextFontSize = 32.0;
  static const double secondaryTextFontSize = 28.0;
  static const double descriptionFontSize = 16.0;
  static const double instructionFontSize = 14.0;
  static const double smallTextFontSize = 12.0;
  
  static const double imageSize = 100.0;
  static const double iconSize = 50.0;
  static const double pageIndicatorSize = 8.0;
  static const double frameWidth = 3.0;
  static const double borderRadius = 8.0;
  static const double imageBorderRadius = 12.0;
  
  static const EdgeInsets containerPadding = EdgeInsets.all(16.0);
  static const EdgeInsets framePadding = EdgeInsets.all(16.0);
  static const EdgeInsets imageFramePadding = EdgeInsets.all(8.0);
  
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: titleFontSize,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle descriptionTextStyle = TextStyle(
    fontSize: descriptionFontSize,
    color: Colors.grey,
  );
  
  static const TextStyle instructionTextStyle = TextStyle(
    fontSize: instructionFontSize,
    color: Colors.grey,
  );
  
  static const TextStyle smallTextStyle = TextStyle(
    fontSize: smallTextFontSize,
    color: Colors.grey,
  );
}

class FrameContainer extends StatelessWidget {
  final bool showFrame;
  final Color frameColor;
  final double borderRadius;
  final EdgeInsets? padding;
  final Widget child;

  const FrameContainer({
    super.key,
    required this.showFrame,
    required this.frameColor,
    required this.child,
    this.borderRadius = AppConstants.borderRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: showFrame
          ? BoxDecoration(
              border: Border.all(color: frameColor, width: AppConstants.frameWidth),
              borderRadius: BorderRadius.circular(borderRadius),
            )
          : null,
      padding: showFrame ? (padding ?? AppConstants.framePadding) : null,
      child: child,
    );
  }
}

class AnimatedTextContainer extends StatelessWidget {
  final Animation<double> animation;
  final bool isVisible;
  final String text;
  final Color textColor;
  final double fontSize;
  final Duration toggleDuration;
  final Curve curve;
  final VoidCallback onTap;

  const AnimatedTextContainer({
    super.key,
    required this.animation,
    required this.isVisible,
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.onTap,
    this.toggleDuration = AppConstants.manualToggleDuration,
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: isVisible ? animation.value : 0.0,
            duration: toggleDuration,
            curve: curve,
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ColorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class ColorProvider extends ChangeNotifier {
  Color _textColor = Colors.blue;

  Color get textColor => _textColor;

  void changeColor(Color color) {
    _textColor = color;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Fading Text Animation',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showFrame = false;
  bool _showImageFrame = false;

  void _showColorPicker() {
    final colorProvider = Provider.of<ColorProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: colorProvider.textColor,
              onColorChanged: (color) {
                colorProvider.changeColor(color);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text Animation'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: _showColorPicker,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: AppConstants.pageIndicatorSize,
                      width: AppConstants.pageIndicatorSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: AppConstants.pageIndicatorSize,
                      width: AppConstants.pageIndicatorSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == 1
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SwitchListTile(
                  title: const Text('Show Text Frame'),
                  value: _showFrame,
                  onChanged: (bool value) {
                    setState(() {
                      _showFrame = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Image Frame'),
                  value: _showImageFrame,
                  onChanged: (bool value) {
                    setState(() {
                      _showImageFrame = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                FadingTextScreen1(showFrame: _showFrame, showImageFrame: _showImageFrame),
                FadingTextScreen2(showFrame: _showFrame, showImageFrame: _showImageFrame),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FadingTextScreen1 extends StatefulWidget {
  final bool showFrame;
  final bool showImageFrame;
  const FadingTextScreen1({super.key, required this.showFrame, required this.showImageFrame});

  @override
  State<FadingTextScreen1> createState() => _FadingTextScreen1State();
}

class _FadingTextScreen1State extends State<FadingTextScreen1>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _imageAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _imageFadeAnimation;
  bool _isVisible = true;
  bool _imageVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.textFadeSlowDuration,
      vsync: this,
    );

    _imageAnimationController = AnimationController(
      duration: AppConstants.imageFadeDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _imageFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageAnimationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat(reverse: true);
    _imageAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void toggleImageVisibility() {
    setState(() {
      _imageVisible = !_imageVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Animation 1',
                style: AppConstants.titleTextStyle,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: toggleVisibility,
                child: Container(
                  decoration: widget.showFrame
                      ? BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  )
                      : null,
                  padding: widget.showFrame ? const EdgeInsets.all(16) : null,
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return AnimatedOpacity(
                        opacity: _isVisible ? _fadeAnimation.value : 0.0,
                        duration: AppConstants.manualToggleDuration,
                        curve: Curves.easeInOut,
                        child: Text(
                          'Hello, Flutter!',
                          style: TextStyle(
                            fontSize: AppConstants.primaryTextFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorProvider.textColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Duration: 2 seconds (Auto + Manual)',
                style: AppConstants.descriptionTextStyle,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap text to toggle visibility',
                style: AppConstants.instructionTextStyle,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: toggleImageVisibility,
                child: Container(
                  decoration: widget.showImageFrame
                      ? BoxDecoration(
                    border: Border.all(color: Colors.purple, width: 3),
                    borderRadius: BorderRadius.circular(12),
                  )
                      : null,
                  padding: widget.showImageFrame ? const EdgeInsets.all(8) : null,
                  child: AnimatedBuilder(
                    animation: _imageFadeAnimation,
                    builder: (context, child) {
                      return AnimatedOpacity(
                        opacity: _imageVisible ? _imageFadeAnimation.value : 0.0,
                        duration: AppConstants.manualToggleDuration,
                        curve: Curves.easeInOut,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppConstants.imageBorderRadius),
                          child: Container(
                            width: AppConstants.imageSize,
                            height: AppConstants.imageSize,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.flutter_dash,
                                size: AppConstants.iconSize,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Fading Image (3s) - Tap to toggle',
                style: AppConstants.smallTextStyle,
              ),
              const SizedBox(height: 20),
              const Text(
                'Swipe left for Animation 2 →',
                style: AppConstants.instructionTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}

class FadingTextScreen2 extends StatefulWidget {
  final bool showFrame;
  final bool showImageFrame;
  const FadingTextScreen2({super.key, required this.showFrame, required this.showImageFrame});

  @override
  State<FadingTextScreen2> createState() => _FadingTextScreen2State();
}

class _FadingTextScreen2State extends State<FadingTextScreen2>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.textFadeFastDuration,
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: AppConstants.imageRotationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _animationController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Animation 2',
                style: AppConstants.titleTextStyle,
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: toggleVisibility,
                child: Container(
                  decoration: widget.showFrame
                      ? BoxDecoration(
                    border: Border.all(color: Colors.green, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  )
                      : null,
                  padding: widget.showFrame ? const EdgeInsets.all(16) : null,
                  child: AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return AnimatedOpacity(
                        opacity: _isVisible ? _fadeAnimation.value : 0.0,
                        duration: AppConstants.textFadeFastDuration,
                        curve: Curves.bounceInOut,
                        child: Text(
                          'Welcome to Flutter!',
                          style: TextStyle(
                            fontSize: AppConstants.secondaryTextFontSize,
                            fontWeight: FontWeight.bold,
                            color: colorProvider.textColor,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Duration: 0.8 seconds (Bounce)',
                style: AppConstants.descriptionTextStyle,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap text to toggle visibility',
                style: AppConstants.instructionTextStyle,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: widget.showImageFrame
                    ? BoxDecoration(
                  border: Border.all(color: Colors.orange, width: 3),
                  borderRadius: BorderRadius.circular(12),
                )
                    : null,
                padding: widget.showImageFrame ? const EdgeInsets.all(8) : null,
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2.0 * math.pi,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppConstants.imageBorderRadius),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange, Colors.red],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.refresh,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Rotating Image (2s)',
                style: AppConstants.smallTextStyle,
              ),
              const SizedBox(height: 20),
              const Text(
                '← Swipe right for Animation 1',
                style: AppConstants.instructionTextStyle,
              ),
            ],
          ),
        );
      },
    );
  }
}