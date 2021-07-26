import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:say_notetime/theme/theme.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/services.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late bool isEnd;
  final _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
  );
  final _isHours = true;
  final _scrollController = ScrollController();
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode = FocusNode();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Y O U R',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Akrobat',
                  fontWeight: FontWeight.bold,
                  color: darkestGrey
              ),
              children: [
                TextSpan(
                  text: '\nTIMER',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: grey
                  ),
                )
              ]
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snapshot){
                    final value = snapshot.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value!, hours: _isHours);
                    return Container(
                      width:320,
                      child: Text(
                        displayTime,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 50,
                          fontFamily: 'Montserrat Bold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  resetButton(),
                  SizedBox(width: 10,),
                  lapButton(),
                  SizedBox(width: 10,),
                  pauseButton(),
                  startButton(),
                ],
              ),
              Container(
                height: 200,
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    if (value!.isEmpty) {
                    }
                    Future.delayed(const Duration(milliseconds: 100), (){
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeOut
                      );
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        final data = value[index];
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '#${index + 1} - ${data.displayTime}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            const Divider(height: 2,)
                          ],
                        );

                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                width: 100,
                child: TextField(
                    style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Montserrat Bold',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: "00", labelText: 'Hours',
                      hintStyle: TextStyle(color: ligthGrey),
                      labelStyle: TextStyle(
                          color: darkGrey,
                          fontSize: 20,
                          fontFamily: 'Montserrat'
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ligthGrey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ligthGrey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: grey),
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          value = "0";
                        }
                        _hours = (int.parse(value));
                      });
                    }
                ),
              ),
                  const SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: TextField(
                        style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'Montserrat Bold',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: "00", labelText: 'Minutes',
                          hintStyle: TextStyle(color: ligthGrey),
                          labelStyle: TextStyle(
                              color: darkGrey,
                              fontSize: 20,
                              fontFamily: 'Montserrat'
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ligthGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ligthGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              value = "0";
                            }
                            _minutes = (int.parse(value));
                          });
                        }
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: TextField(
                        style: const TextStyle(
                          fontSize: 25,
                          fontFamily: 'Montserrat Bold',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          hintText: "00", labelText: 'Seconds',
                          hintStyle: TextStyle(color: ligthGrey),
                          labelStyle: TextStyle(
                              color: darkGrey,
                              fontSize: 20,
                              fontFamily: 'Montserrat'
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ligthGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ligthGrey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey),
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              value = "0";
                            }
                            _seconds = (int.parse(value));
                          });
                        }
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: darkestGrey,
                      ),
                      onPressed: () {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                        _stopWatchTimer.clearPresetTime();
                        _stopWatchTimer.setPresetHoursTime(_hours);
                        _stopWatchTimer.setPresetMinuteTime(_minutes);
                        _stopWatchTimer.setPresetSecondTime(_seconds);
                      },
                      child: const Text(
                        'Set Timer'
                      ),

                    )
                  ),
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
  Widget lapButton() {
    return IconButton(
      onPressed: () {
        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
      },
      icon: const Icon(Icons.outlined_flag_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget startButton() {
    return IconButton(
      onPressed: () {
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      },
      icon: const Icon(Icons.play_circle_outline_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget pauseButton() {
    return IconButton(
      onPressed: () {
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      },
      icon: const Icon(Icons.pause_circle_outline_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget resetButton() {
    return IconButton(
      onPressed: () async {
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      },
      icon: Icon(Icons.restart_alt_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget inputTimerField ({required String type, required int typeState}) {
    return Container(
      width: 100,
      child: TextField(
          style: const TextStyle(
            fontSize: 25,
            fontFamily: 'Montserrat Bold',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "00", labelText: type,
            hintStyle: TextStyle(color: ligthGrey),
            labelStyle: TextStyle(
                color: darkGrey,
                fontSize: 20,
                fontFamily: 'Montserrat'
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ligthGrey),
                borderRadius: BorderRadius.circular(10)
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey),
                borderRadius: BorderRadius.circular(10)
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: ligthGrey),
                borderRadius: BorderRadius.circular(10)
            ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: grey),
                borderRadius: BorderRadius.circular(10)
            ),
          ),
          onChanged: (value) async {
            setState(() async {
              if (value.isEmpty) {
                value = "0";
              }
              typeState = (int.parse(value));
            });
          }
      ),
    );
  }


}
