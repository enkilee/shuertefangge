import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier
{
  int count=25;
  int totalCell=0;
  List<int> data=List<int>();
  List<int> curSel=List<int>();
  List<AnimationController> controllers=List<AnimationController>();
  List<Animation<Color>> animations=List<Animation<Color>>();
  bool ifStarted=false;
  Timer time;
  double totalTime=0;

  MainProvider()
  {
    totalCell=count;
    ifStarted=false;
    totalTime=0;
    data=List<int>();
    List.generate(totalCell, (index)
    {
      data.add(index+1);//1-16
    });
    data.shuffle();//打乱顺序
    curSel=List<int>();
  }

  resetValue()
  {
    ifStarted=false;
    if(ifStarted)
      {
        time.cancel();
      }
    totalTime=0;
    data=List<int>();
    List.generate(totalCell, (index)
     => data.add(index+1)).toList()..shuffle();

    data.shuffle();//打乱顺序
    curSel=List<int>();
    notifyListeners();
  }

  ifLastCorrect()
  {
    if(curSel.length==count && curSel.last==count)
      {
        time.cancel();
      }
  }

  tapStart()
  {
    if(!ifStarted)
      {
        time=Timer.periodic(Duration(milliseconds: 100), (_) {
          totalTime+=0.1;
          totalTime=totalTime;
          notifyListeners();
        });
        ifStarted=true;
      }
    else
      {
        time.cancel();
        ifStarted=false;
      }
    notifyListeners();
  }

  startPlay()
  {
    if(!ifStarted)
      {
        tapStart();
      }
  }

  changeCount()
  {
    if(count==16)
      {
        count=25;
      }
    else
      {
        count=16;
      }
    totalCell=count;
    curSel=List<int>();
    data=List<int>();
    List.generate(totalCell, (index)
    => data.add(index+1)).toList()..shuffle();
    data.shuffle();//打乱顺序
    time.cancel();
    ifStarted=false;
    notifyListeners();
  }

  tapCell(i)
  {
    int preValue=curSel.length>0 ? curSel.last:0;
    startPlay();
    if(data[i]-preValue!=1)
      {
        animations[i]=ColorTween(
          begin: Colors.white,
          end: Colors.red,
        ).animate(controllers[i])
          ..addListener(() {
          });
      }
    else
      {
        animations[i]=ColorTween(
          begin: Colors.white,
          end: Colors.purpleAccent,
        ).animate(controllers[i])
          ..addListener(() {});
        curSel.add(data[i]);
        curSel=curSel;
      }
    if(data[i]==totalCell && curSel.length==totalCell)
      {
        time.cancel();
        Fluttertoast.showToast(
          msg: "Congratulations!,You just using ${totalTime.toStringAsFixed(1)} seconds finished!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 25);
        notifyListeners();
        controllers[i].forward(from:0).then((_) => controllers[i].reverse());
      }
  }

  void startRecordTime() {
    time=Timer.periodic(Duration(milliseconds: 100), (_) {
      ifStarted=true;
      totalTime+=0.1;
      notifyListeners();
    });
  }

  void stopRecord()
  {
    time.cancel();
  }


}