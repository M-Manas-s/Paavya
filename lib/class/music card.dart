import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:naariAndroid/screens/music_player.dart';
import 'dart:io';

String processName(String name)
{
  String newStr='';
  int ds=1;
  for ( int i=0; i<name.length; i++ ) {
    if (name[i] == '_')
      newStr+=' ';
    else if (name[i]!=' ')
      newStr+=name[i];
    if (name[i]==' ' && ds==1)
    {
      newStr+=' ';
      ds++;
    }
    else
      ds=1;
  }
  newStr.trim();
  return newStr.substring(0,newStr.length-4);
}

class MusicCard extends StatefulWidget {

  final ValueChanged<int> update;
  SongInfo songInfo;
  final int ci;

  MusicCard({@required this.songInfo, @required this.ci, @required this.update});

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> with TickerProviderStateMixin{
  ScrollController _scrollController = ScrollController();
  bool scroll = false;
  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  final GlobalKey<CustomTabBarViewState> key = GlobalKey<CustomTabBarViewState>();

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  _scroll() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.linear);

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
              // setSong(widget.songInfo);
            },
            child: Container(
              padding: EdgeInsets.all(query.width * (1 / 23)),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ( widget.songInfo.albumArtwork==null ) ? Image(
                        image:
                        AssetImage("assets/images/noalbum.png"),
                        fit: BoxFit.fitHeight) : Image.file( File( widget.songInfo.albumArtwork ) ),
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
                            "${processName(
                                widget.songInfo.displayName)}        ",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 2,
                              color: Color(0xFF1E7777),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          scrollDirection: Axis.horizontal,
                        ),
                        SingleChildScrollView(
                          child: Text(widget.songInfo.artist,
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
                      child: Icon(Icons.play_arrow, color: Colors.white,
                        size: query.width * (1 / 18),),
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
