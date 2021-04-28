import 'package:flutter/material.dart';
import 'package:naariAndroid/class/MusicInfo.dart';
import 'package:naariAndroid/screens/music_player.dart';
import 'dart:io';

class MusicCard2 extends StatefulWidget {
  final ValueChanged<int> update;
  MusicInfo musicInfo;
  final int ci;

  MusicCard2(
      {@required this.musicInfo, @required this.ci, @required this.update});

  @override
  _MusicCard2State createState() => _MusicCard2State();
}

class _MusicCard2State extends State<MusicCard2> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  bool scroll = false;
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  _scroll() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.linear);

    Future.delayed(const Duration(milliseconds: 2000), () {
      _toggleScrolling();
    });
  }

  _toggleScrolling() {
    setState(() {
      scroll = !scroll;
    });

    if (scroll) {
      _scroll();
    } else {
      _scrollController.animateTo(_scrollController.initialScrollOffset,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return Container(
      height: 80,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            offset: Offset(0, 14),
            spreadRadius: -13,
          )
        ],
        borderRadius: BorderRadius.circular(60),
      ),
      child: GestureDetector(
        onTapDown: (TapDownDetails) {
          _toggleScrolling();
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            splashColor: Color(0xFF1E7777).withAlpha(30),
            onTap: () {
              widget.update(widget.ci);
              // setSong(widget.musicInfo);
            },
            child: Container(
              padding: EdgeInsets.all(query.width * (1 / 23)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image(
                        image: AssetImage("assets/images/noalbum.png"),
                        fit: BoxFit.fitHeight),
                  ),
                  SizedBox(
                    width: query.width * (1 / 23),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          child: Text(
                            "${widget.musicInfo.title}        ",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 1,
                              color: Color(0xFF1E7777),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                        SingleChildScrollView(
                          child: Text(widget.musicInfo.artist,
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 2,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              )),
                          scrollDirection: Axis.horizontal,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: query.width * (1 / 23),
                  ),
                  Container(
                    width: query.width * (1 / 12),
                    height: query.width * (1 / 12),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF193833), Color(0xFF609394)]),
                        borderRadius:
                            BorderRadius.circular(query.width * (1 / 24))),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {},
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: query.width * (1 / 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
