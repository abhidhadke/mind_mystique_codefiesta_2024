import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    super.key,
    required this.visibleBool,
    required AnimationController controller, required this.asset,
  }) : _controller = controller;

  final bool visibleBool;
  final AnimationController _controller;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibleBool,
      child: Center(
        child: Lottie.asset(asset,
          repeat: false,
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller.duration = composition.duration;
          },
        ),
      ),
    );
  }
}
