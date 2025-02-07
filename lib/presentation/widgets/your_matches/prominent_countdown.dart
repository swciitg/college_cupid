import 'dart:async';

import 'package:college_cupid/shared/globals.dart';
import 'package:college_cupid/shared/styles.dart';
import 'package:flutter/material.dart';

class ProminentCountdown extends StatefulWidget {
  final VoidCallback reset;
  const ProminentCountdown({super.key, required this.reset});

  @override
  State<ProminentCountdown> createState() => _ProminentCountdownState();
}

class _ProminentCountdownState extends State<ProminentCountdown> {
  late Timer timer;
  Duration difference = matchReleaseTime.difference(DateTime.now());
  final _firstLetters = List.generate(20, (index) => 9 - (index % 10));
  final _secondLetters = List.generate(20, (index) => 9 - (index % 10));
  int? _firstLetterIndex;
  int? _secondLetterIndex;
  var _prominent = 'Day';

  late PageController _firstLetterController;
  late PageController _secondLetterController;

  @override
  void initState() {
    _updateProminent(setControllers: true);
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (difference.inSeconds > 0) {
        difference = Duration(seconds: difference.inSeconds - 1);
        _updateProminent();
        if (!mounted) return;
        await _scrollLetters();
      } else {
        timer.cancel();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _firstLetterController.dispose();
    _secondLetterController.dispose();
    timer.cancel();
    super.dispose();
  }

  void _updateProminent({bool setControllers = false}) {
    var value = '';
    if (difference.inDays > 0) {
      _prominent = 'Day';
      value = difference.inDays.toString().padLeft(2, '0');
    } else if (difference.inHours > 0) {
      _prominent = 'Hour';
      value = difference.inHours.toString().padLeft(2, '0');
    } else if (difference.inMinutes > 0) {
      _prominent = 'Minute';
      value = difference.inMinutes.toString().padLeft(2, '0');
    } else {
      _prominent = 'Second';
      value = difference.inSeconds.toString().padLeft(2, '0');
    }
    setState(() {});
    final first = int.parse(value[0]);
    final second = int.parse(value[1]);
    _secondLetterIndex =
        _secondLetters.indexOf(second, _secondLetterIndex ?? 0);
    _firstLetterIndex = _firstLetters.indexOf(first, _firstLetterIndex ?? 0);

    if (setControllers) {
      _firstLetterController = PageController(initialPage: _firstLetterIndex!);
      _secondLetterController =
          PageController(initialPage: _secondLetterIndex!);
    }
  }

  Future<void> _scrollLetters() async {
    if (_secondLetters.length - _secondLetterIndex! < 15) {
      _secondLetters.addAll(List.generate(10, (index) => 9 - index));
      setState(() {});
    }
    _secondLetterController.animateToPage(
      _secondLetterIndex!,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.linear,
    );
    if (_firstLetters.length - _firstLetterIndex! < 15) {
      _firstLetters.addAll(List.generate(10, (index) => 9 - index));
      setState(() {});
    }
    _firstLetterController.animateToPage(
      _firstLetterIndex!,
      duration: const Duration(
        milliseconds: 300,
      ),
      curve: Curves.linear,
    );
    if (_firstLetters[_firstLetterIndex!] == 0 &&
        _secondLetters[_secondLetterIndex!] == 0 &&
        _prominent == 'Second') {
      // Wait for animation to complete
      await Future.delayed(const Duration(milliseconds: 500));
      widget.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 32) / 2;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: width,
                  width: width,
                  child: PageView.builder(
                    controller: _firstLetterController,
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _firstLetters.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: width,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _firstLetters[index].toString(),
                            style: CupidStyles.countdownStyle(width),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: width,
                  width: width,
                  child: PageView.builder(
                    reverse: true,
                    controller: _secondLetterController,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _secondLetters.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: width,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            _secondLetters[index].toString(),
                            style: CupidStyles.countdownStyle(width),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
        Text(
          "$_prominent${_firstLetters[_firstLetterIndex!] == 0 && _secondLetters[_secondLetterIndex!] <= 1 ? "" : "s"}",
          style: CupidStyles.subHeadingTextStyle,
        ),
      ],
    );
  }
}
