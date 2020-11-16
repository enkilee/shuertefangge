import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "舒尔特方格",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int count;
  int nextNum;
  int curNum;
  int secondsPassed;
  int millPassed;
  List<int> data = List<int>();
  AnimationController controller;
  Animation<Color> animation;
  Timer timer;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    init(16);
  }

  void init(int count) {
    timer?.cancel();
    this.count = count;
    nextNum = 0;
    curNum = 0;
    secondsPassed = 0;
    millPassed = 0;
    animation = ColorTween(
      begin: Colors.white,
      end: Colors.purple,
    ).animate(controller);
    data = List.generate(count, (index) => index + 1)..shuffle();
  }

  void startTick() {
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      ++millPassed;
      if (millPassed == 10) {
        millPassed = 0;
        ++secondsPassed;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("舒尔特方格"),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            Expanded(
              child: GridView.count(
                crossAxisCount: count == 16 ? 4 : 5,
                children: List.generate(count, (index) {
                  return InkWell(
                    onTap: () async {
                      if (nextNum == 0 && (timer == null || !timer.isActive)) {
                        startTick();
                      }
                      curNum = data[index];
                      if (nextNum + 1 == curNum) {
                        ++nextNum;
                        animation = ColorTween(
                          begin: Colors.white,
                          end: Colors.purple,
                        ).animate(controller)
                          ..addListener(() {
                            setState(() {});
                          });
                      } else {
                        animation = ColorTween(
                          begin: Colors.white,
                          end: Colors.red,
                        ).animate(controller)
                          ..addListener(() {
                            setState(() {});
                          });
                      }
                      await controller.forward();
                      await controller.reverse();
                      if (nextNum == count) {
                        nextNum++;
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('恭喜'),
                        ));
                        timer.cancel();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: curNum == data[index]
                            ? animation.value
                            : Colors.white,
                      ),
                      child: Text(
                        '${data[index]}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text('$secondsPassed.$millPassed'),
            FlatButton(
              color: Colors.blue,
              child: Text(
                '重来',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                init(count);
                setState(() {});
              },
            ),
            FlatButton(
              color: Colors.blue,
              child: Text(
                '16格子',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                init(16);
                setState(() {});
              },
            ),
            FlatButton(
              color: Colors.blue,
              child: Text(
                '25格子',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                init(25);
                setState(() {});
              },
            )
          ],
        );
      }),
    );
  }
