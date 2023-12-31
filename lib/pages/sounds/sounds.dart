import 'package:flutter/material.dart';
import 'package:imokay/util/widgets/breathe.dart';
import 'package:imokay/util/widgets/sounds.dart';

class SoundsPage extends StatefulWidget {
  const SoundsPage({super.key});

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  //Sound Keys
  final List<GlobalKey> keys = List.generate(4, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BreathingLine(isPlaying: true),
        MainUISounds(
          soundKeys: keys,
        ),
      ],
    );
  }
}
