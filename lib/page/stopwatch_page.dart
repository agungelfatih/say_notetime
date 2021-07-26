import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:say_notetime/theme/theme.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final _stopWatchTimer = StopWatchTimer();
  final _isHours = true;
  final _scrollController = ScrollController();
  bool _isRunning = false;

  @override
  void dispose() {
    super.dispose();
    _stopWatchTimer.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  text: '\nSTOPWATCH',
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
      body: SafeArea(
        child: SingleChildScrollView(
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
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    resetButton(),
                    SizedBox(width: 10,),
                    lapButton(),
                    SizedBox(width: 10,),
                    startPauseButton(),
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
                        return Container();
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
              ],

            ),
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
      icon: Icon(Icons.outlined_flag_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget startPauseButton() {
    return IconButton(
      onPressed: () {
        _isRunning? _stopWatchTimer.onExecute.add(StopWatchExecute.stop)
            : _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        setState(() {
          _isRunning = !_isRunning;
        });
      },
      icon: _isRunning?  const Icon(Icons.pause_circle_outline_rounded)
          : const Icon(Icons.play_circle_outline_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }

  Widget resetButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isRunning = false;
        });
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      },
      icon: Icon(Icons.restart_alt_rounded),
      iconSize: 40,
      color: darkestGrey,
    );
  }
}
