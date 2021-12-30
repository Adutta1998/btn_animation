import 'package:button_animation/slider_recorder.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("object");
    return Scaffold(
      appBar: AppBar(
        title: Text('HomePAge'),
      ),
      body: SliderRecorder(
        dragStartIcon: Icon(Icons.mic),
        dragEndIcon: Icon(Icons.pedal_bike),
        paddingHorizontal: 8,
        trackColor: Colors.grey.shade100,
      ),
    );
  }
}
