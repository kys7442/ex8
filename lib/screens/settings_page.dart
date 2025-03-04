import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '매일 1장(Chapter)를 읽어나가자는 컨셉의 앱 입니다. 앱을 통해 얻어진 모든 수익(세금제한 후)은 모두 어려운 이웃이나 필요한 곳에 기부하고자 합니다. 매일 1장씩 성경읽기를 통해 완독을 경험하시고 하나님의 살아 움직이는 삶을 경험해 보세요.',
          ),
        ),
      ),
    );
  }
}
