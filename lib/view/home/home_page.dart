import 'package:flutter/material.dart';
import 'package:flutter_tensorflow_ml_project/view/camera_view/camera_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: CameraView(),
      ),
    );
  }
}
