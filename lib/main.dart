import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'addProvider.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "舒尔特方格",
      home: AllParent(),
    );
  }
}

class AllParent extends StatefulWidget {
  AllParent({Key key}) : super(key: key);

  @override
  _AllParentState createState() => _AllParentState();
}

class _AllParentState extends State<AllParent> {
  var table = AnimContainer();
  var timer = CountTimer();

  reset() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("舒尔特方格"),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MainProvider(),
          )
        ],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 420,
              child: table,
            ),
            timer
          ],
        ),
      ),
    );
  }
}

class CountTimer extends StatefulWidget {
  CountTimer({Key key}) : super(key: key);

  @override
  _CountTimerState createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  Timer time;
  double totalTime = 0;
  bool ifStarted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    return SizedBox(
        height: 150,
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Text(
                "${provider.totalTime.toStringAsFixed(1)}",
                style: TextStyle(fontSize: 20),
              ),
            )),
            Container(
                child: Flexible(
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.changeCount();
                },
                child: Text(
                  provider.count == 16 ? "25格" : "16格",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
            Container(
                child: Flexible(
              flex: 2,
              child: MaterialButton(
                // padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                splashColor: Colors.transparent,
                color: Colors.blueAccent,
                onPressed: () {
                  provider.resetValue();
                },
                child: Text(
                  "换一题",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )),
          ],
        ));
  }
}

class AnimContainer extends StatefulWidget {
  AnimContainer({Key key}) : super(key: key);

  @override
  _AnimContainerState createState() => _AnimContainerState();
}

class _AnimContainerState extends State<AnimContainer>
    with TickerProviderStateMixin {
  List<int> data = List<int>();
  List<int> curSel = List<int>();

  List<Animation<Color>> animation;
  List<AnimationController> controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = List<Animation<Color>>();
    controller = List<AnimationController>();
    curSel = List<int>();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    int count = provider.count;
    for (int i = 0; i < count; i++) {
      controller.add(AnimationController(
          duration: const Duration(milliseconds: 500), vsync: this));
      animation.add(ColorTween(
        begin: Colors.white,
        end: Colors.purpleAccent,
      ).animate(controller[i])
        ..addListener(() {
          setState(() {});
        }));
    }
    provider.animations = animation;
    provider.controllers = controller;
    return GridView.count(
      crossAxisCount: sqrt(count).round(),
      children: List.generate(
          count,
          (i) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: provider.animations[i].value,
                  border: Border.all(width: 1)),
              child: Container(
                  child: FlatButton(
                padding: EdgeInsets.all(count == 25 ? 10 : 20),
                child: Text(
                  "${provider.data[i]}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  provider.tapCell(i);
                },
              )))).toList(),
    );
  }
}

/*
class ShuerteCell extends StatefulWidget {
  ShuerteCell({Key key,this.context}):super(key:key);
  final BuildContext context;
  @override
  _ShuerteCellState createState() => _ShuerteCellState();
}

class _ShuerteCellState extends State<ShuerteCell> with TickerProviderStateMixin{
  int count;
  List<int> data=List<int>();
  List<int> curSel=List<int>();
  List<AnimationController> controllers=List<AnimationController>();
  List<Animation<Color>> animations=List<Animation<Color>>();
  MainProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    provider=Provider.of<MainProvider>(context);
    count=provider.count;
    List.generate(count, (index){
      controllers.add(AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ));
      animations.add(ColorTween(begin:Colors.white,end:Colors.purpleAccent)
          .animate(controllers[index])
      ..addListener(() {
        setState(() {
      });}));
    });
    data=provider.data;
    provider.controllers=controllers;
    provider.animations=animations;

    return Scaffold(
      appBar: AppBar(title: Text("舒尔特方格"),),
      body:Column(
        children: [
          Expanded(
            flex: 6,
            child: GridView.count(
              crossAxisCount: 4,
              children:
                List.generate(count, (index)
                {
                  return Container(
                    alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        color: provider.animations[index].value,
                      ),
                      child: FlatButton(
                        onPressed: (){
                          provider.tapCell(index);
                        },
                        child: Text("${provider.data[index]}",
                        style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                })
            ),
          ),
        ],
      ),
    );
  }

  //正确：从白色到紫色再返回
  //错误：从白到红再返回
  void tapCell(i)
  {
    int lastSel = curSel.length>0?curSel.last:0;

    //正确：从白色到紫色再返回
    if(data[i]-1==lastSel)
      {
      animations[i]=     ColorTween(
                begin:Colors.white,
                end:Colors.purpleAccent)
                .animate(controllers[i])..addListener(() {
              setState(() {
              });
            });
      curSel.add(data[i]);
      }
    else
      //错误：从白到红再返回
      {
        animations[i]=     ColorTween(
            begin:Colors.white,
            end:Colors.red)
            .animate(controllers[i])..addListener(() {
          setState(() {
          });
        });
      }
    controllers[i].forward(from:0).then((_)=>controllers[i].reverse());
  }

}*/
