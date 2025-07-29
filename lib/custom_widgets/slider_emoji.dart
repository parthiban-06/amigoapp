import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiSliderScreen extends StatefulWidget {
  const EmojiSliderScreen({super.key});

  @override
  State<EmojiSliderScreen> createState() => _EmojiSliderScreenState();
}

class _EmojiSliderScreenState extends State<EmojiSliderScreen>
    with SingleTickerProviderStateMixin {
  double _sliderValue = 0.5;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Extended emoji list with more variations
  final List<Map<String, dynamic>> _emojiSteps = [
    {'emoji': '🤬', 'mood': 'Furious', 'color': Colors.red[900]!},
    {'emoji': '😡', 'mood': 'Angry', 'color': Colors.red[700]!},
    {'emoji': '😤', 'mood': 'Frustrated', 'color': Colors.red[500]!},
    {'emoji': '😢', 'mood': 'Crying', 'color': Colors.red[300]!},
    {'emoji': '😞', 'mood': 'Disappointed', 'color': Colors.orange[700]!},
    {'emoji': '😕', 'mood': 'Confused', 'color': Colors.orange[500]!},
    {'emoji': '😐', 'mood': 'Neutral', 'color': Colors.yellow[600]!},
    {'emoji': '🙂', 'mood': 'Slightly Happy', 'color': Colors.lightGreen[400]!},
    {'emoji': '😊', 'mood': 'Happy', 'color': Colors.lightGreen[600]!},
    {'emoji': '😄', 'mood': 'Very Happy', 'color': Colors.green[500]!},
    {'emoji': '😍', 'mood': 'Loving it', 'color': Colors.green[700]!},
    {'emoji': '🤩', 'mood': 'Ecstatic', 'color': Colors.green[900]!},
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 1.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCurrentEmojiStep() {
    final index = (_sliderValue * (_emojiSteps.length - 1)).round();
    return _emojiSteps[index];
  }

  void _onSliderChanged(double value) {
    setState(() {
      _sliderValue = value;
    });
    _bounceController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = _getCurrentEmojiStep();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Steps'),
        elevation: 0,
      ),
      body: Row(
        children: [
          // Vertical Emoji Scale
          SizedBox(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _emojiSteps.reversed
                  .map((step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          step['emoji'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ))
                  .toList(),
            ),
          ),
          // Vertical Slider
          SizedBox(
            width: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: currentStep['color'],
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: currentStep['color'],
                  overlayColor: currentStep['color'].withValues(alpha: 0.3),
                  trackHeight: 8,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24,
                  ),
                ),
                child: Slider(
                  value: _sliderValue,
                  onChanged: _onSliderChanged,
                ),
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: currentStep['color'],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: currentStep['color'].withValues(alpha: 128),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ScaleTransition(
                    scale: _bounceAnimation,
                    child: Text(
                      currentStep['emoji'],
                      style: const TextStyle(fontSize: 80),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    currentStep['mood'],
                    key: ValueKey(currentStep['mood']),
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Step ${(_sliderValue * (_emojiSteps.length - 1)).round() + 1} of ${_emojiSteps.length}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
