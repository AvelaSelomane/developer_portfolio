
import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TypingText extends StatefulWidget {
  const TypingText({super.key});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  final List<String> roles = [
    'Software Developer',
    'Flutter Developer',
    'Web Developer',
    'Problem Solver',
  ];

  Timer? _timer;
  int _roleIndex = 0;
  int _characterIndex = 0;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  void _scheduleNext() {
    final currentRole = roles[_roleIndex];

    final delay = !_deleting &&
            _characterIndex == currentRole.length
        ? 1500
        : _deleting
            ? 45
            : 90;

    _timer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;

      setState(() {
        if (_deleting) {
          _characterIndex--;

          if (_characterIndex == 0) {
            _deleting = false;
            _roleIndex = (_roleIndex + 1) % roles.length;
          }
        } else {
          if (_characterIndex < currentRole.length) {
            _characterIndex++;
          } else {
            _deleting = true;
          }
        }
      });

      _scheduleNext();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentRole = roles[_roleIndex];
    final visibleText =
        currentRole.substring(0, _characterIndex);

    return Text(
      '$visibleText|',
      style: const TextStyle(
        color: AppTheme.secondary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
