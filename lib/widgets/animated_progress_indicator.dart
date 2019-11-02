import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class AnimatedProgressIndicator extends StatelessWidget {
  const AnimatedProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: HeartbeatProgressIndicator(
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: Image(image: AssetImage('assets/ic_gdg_app.png')),
        ),
      ),
    );
  }
}