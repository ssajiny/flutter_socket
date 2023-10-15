import 'package:flutter/material.dart';

class MyAnimation extends StatefulWidget {
  @override
  _MyAnimationState createState() => _MyAnimationState();
}

class _MyAnimationState extends State<MyAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );

    _animation = Tween(begin: -1.0, end: 1.0).animate(_controller);

    _animation.addListener(() {
      if (_animation.value == -1) {
        _controller.forward();
      } else if (_animation.value == 1) {
        _controller.reverse();
      }
      setState(() {});
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: 50,
              color: Colors.blue,
              child: Align(
                alignment: Alignment(0, _animation.value),
                child: const Icon(
                  Icons.star,
                  size: 50,
                  color: Colors.yellow,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.stop();
              },
              child: Text('애니메이션 다시 시작'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
