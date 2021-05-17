import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:naariAndroid/class/MusicInfo.dart';
import 'package:naariAndroid/class/music%20card.dart';
import 'package:naariAndroid/class/music%20card2.dart';
import 'package:naariAndroid/constants/constants.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:io';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

const Color activeColor = Color(0xFFEFEFEF);
const Color inactiveColor = Colors.white;
AudioPlayer player;

enum Play {
  repeat,
  repeatOne,
  none,
}

class MusicPlayer extends StatefulWidget {
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

  List<SongInfo> songs;
  List<MusicInfo> podcasts;
  int currentIndex = 0;
  bool isPlaying = false;
  bool loading = true;
  bool loadbar = false;
  bool loadingPodcasts = true;
  bool playingLocal = true;
  bool shuffle = false;
  Play repeatStyle = Play.repeat;

  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';

  void changeCurrentIndex(int ci) {
    setState(() {
      currentIndex = ci;
    });
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    String time = duration.inMinutes.toString() + ":";
    int seconds = duration.inSeconds % 60;
    if (seconds <= 9)
      time += '0' + seconds.toString();
    else
      time += seconds.toString();
    return time;
  }

  @override
  void dispose() {
    super.dispose();
    player.stop();
    player.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    getTracks();
    getPodcastsmusic();
    player = new AudioPlayer();
    podcasts = [];
  }

  void getPodcastsmusic() {
    CollectionReference music =
    FirebaseFirestore.instance.collection('Podcasts');
    music.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        String url = result.data()['URL'];
        String artist = result.data()['Artist'];
        String title = result.data()['Name'];
        MusicInfo tm = new MusicInfo(title: title, url: url, artist: artist);
        podcasts.add(tm);
      });
      setState(() {
        loadingPodcasts = false;
      });
    });
  }

  void getTracks() async {
    songs = await FlutterAudioQuery().getSongs();
    setState(() {
      songs = songs;
    });
  }

  void updateLocal(int ci) {
    setSong(ci, true);
  }

  void updatePodcasts(int ci) {
    setSong(ci, false);
  }

  void setSong(int ci, bool local) async {
    int len = local ? songs.length : podcasts.length;
    SongInfo songInfo;
    MusicInfo podcast;
    if (local)
      songInfo = songs[ci];
    else
      podcast = podcasts[ci];
    if (player != null) player.dispose();
    player = new AudioPlayer();
    await player.setUrl(local ? songInfo.uri : podcast.url);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      playingLocal = local;
      currentIndex = ci;
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
      if (repeatStyle != Play.none || shuffle) isPlaying = false;
      loadbar = true;
      changeStatus();
    });
    player.positionStream.listen((duration) {
      if (duration.inMilliseconds.toDouble() >= maximumValue) {
        if (shuffle) {
          var rng = new Random();
          setState(() {
            currentIndex = rng.nextInt(len - 1);
          });
          setSong(currentIndex, local);
        } else {
          switch (repeatStyle) {
            case Play.repeatOne:
              {
                setSong(currentIndex, local);
              }
              break;

            case Play.repeat:
              {
                setState(() {
                  currentIndex = (currentIndex + 1) % len;
                });
                setSong(currentIndex, local);
              }
              break;

            default:
              {
                setSong(currentIndex, local);
              }
              break;
          }
        }
      } else
        currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeRepeatStyle() {
    setState(() {
      shuffle = false;
    });
    if (repeatStyle == Play.none)
      setState(() {
        repeatStyle = Play.repeat;
      });
    else if (repeatStyle == Play.repeat)
      setState(() {
        repeatStyle = Play.repeatOne;
      });
    else
      setState(() {
        repeatStyle = Play.none;
      });
  }

  void changeTrack(bool isNext) {
    int len = playingLocal ? songs.length : podcasts.length;
    if (isNext) {
      currentIndex = (currentIndex + 1) % len;
    } else {
      currentIndex = (currentIndex - 1) % len;
    }
    changeCurrentIndex(currentIndex);
    setSong(currentIndex, playingLocal);
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 100),
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            height: query.height,
            decoration: infoContainer,
            child: Center(
              child: Text("PODCASTS", style: headingStyle),
            ),
          ),
        ),
        body: ContainedTabBarView(
          tabs: [ AutoSizeText('PODCASTS'), AutoSizeText('PLAYING')],
          tabBarProperties: TabBarProperties(
              innerPadding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              indicator: ContainerTabIndicator(
                radius: BorderRadius.circular(16.0),
                color: Color(0xFFEFEFEF),
                borderWidth: 0.0,
                borderColor: Colors.transparent,
              ),
              labelColor: Color(0xFF1E7777),
              labelStyle: TextStyle(
                fontSize: 14 ,
                color: Color(0xFF1E7777),
                letterSpacing: 3,
                fontWeight: FontWeight.w700 ,
              ),
              // headingStyle.copyWith(
              //     fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 3),
              unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              unselectedLabelColor: Color(0xFF8CC4C4)),
          views: [
            /*
            Container(
              //padding: EdgeInsets.only(bottom: query.height * 0.1),
              color: activeColor,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 13,
                      child: Container(
                          margin: EdgeInsets.only(top: query.width * 0.05, bottom : loadbar && playingLocal ? 0: query.height*0.095),
                          color: activeColor,
                          child: FutureBuilder(
                            future: FlutterAudioQuery()
                                .getSongs(sortType: SongSortType.RECENT_YEAR),
                            builder: (context, snapshot) {
                              if (snapshot.hasData || songs != null) {
                                if (songs == null) songs = snapshot.data;
                                return Container(
                                  child: songs.length != 0
                                      ? ListView.builder(
                                    padding:
                                    EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: songs.length,
                                    itemBuilder: (context, i) {
                                      return MusicCard(
                                        songInfo: songs[i],
                                        ci: i,
                                        update: updateLocal,
                                      );
                                    },
                                  )
                                      : Center(
                                    child: AutoSizeText(
                                      "No music found locally",
                                      style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 1,
                                        color: Color(0xFF1E7777),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.all(0),
                                  padding: EdgeInsets.all(0),
                                );
                              }
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.4,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                          )),
                    ),
                    loadbar && playingLocal
                        ? Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: query.width * 0.05,
                              right: query.width * 0.05,
                          bottom: query.height*0.09),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 14.0,
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                          ),
                          //margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: (songs[currentIndex].albumArtwork ==
                                    null)
                                    ? Image(
                                    image: AssetImage(
                                        "assets/images/noalbum.png"),
                                    fit: BoxFit.fitHeight)
                                    : Image.file(
                                    File(songs[currentIndex].albumArtwork)),
                              ),
                              SizedBox(
                                width: query.width * (1 / 23),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SingleChildScrollView(
                                      child: Text(
                                        "${processName(songs[currentIndex].displayName)}        ",
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
                                      child: Text(songs[currentIndex].artist,
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
                                width: query.width * (1 / 10),
                                height: query.width * (1 / 10),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF193833),
                                          Color(0xFF609394)
                                        ]),
                                    borderRadius: BorderRadius.circular(
                                        query.width * (1 / 20))),
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    changeStatus();
                                  },
                                  child: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                    size: query.width * (1 / 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                        : Container()
                  ],
                ),
              ),
            ),
            */

            // Podcasts Tab
            Container(
              color: activeColor,
              padding: EdgeInsets.only(top: query.height * 0.02, bottom : query.height*0.095),
              child: loadingPodcasts
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
                  : Container(
                color: activeColor,
                child: podcasts.length != 0
                    ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: podcasts.length,
                  itemBuilder: (context, i) {
                    return MusicCard2(
                      musicInfo: podcasts[i],
                      ci: i,
                      update: updatePodcasts,
                    );
                  },
                )
                    : Center(
                  child: AutoSizeText(
                    "Podcasts will appear here!",
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 1,
                      color: Color(0xFF1E7777),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            //Playing Tab
            Center(
              child: Container(
                padding: EdgeInsets.only(top: query.height * 0.03),
                color: activeColor,
                child: loadbar
                    ? Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        margin: EdgeInsets.only(bottom: query.height*0.02),
                        color: activeColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Container(
                                child: playingLocal
                                    ? (songs[currentIndex].albumArtwork ==
                                    null ||
                                    playingLocal)
                                    ? Image(
                                    image: AssetImage(
                                        "assets/images/thumbnail.jpg"),
                                    fit: BoxFit.fitWidth)
                                    : Image.file(File(
                                    songs[currentIndex].albumArtwork))
                                    : Image(
                                    image: AssetImage(
                                        "assets/images/thumbnail.jpg"),
                                    //fit: BoxFit.fitWidth
                                ),
                                margin: EdgeInsets.only(
                                    left: query.width * 0.14,
                                    right: query.width * 0.14,
                                  bottom: query.height * 0.01,
                                ),
                              ),
                            ),
                            Expanded(
                              flex : 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: AutoSizeText(
                                          playingLocal
                                              ? "${processName(songs[currentIndex].displayName)}"
                                              : podcasts[currentIndex].title,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 21,
                                            letterSpacing: 2,
                                            color: Color(0xFF1E7777),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                    child: Center(
                                      child: SingleChildScrollView(
                                        child: Text(
                                            playingLocal
                                                ? songs[currentIndex].artist
                                                : podcasts[currentIndex].artist,
                                            style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 2,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.only(bottom : query.height*0.095),
                        width: query.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            )
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(children: [
                              Container(
                                  width: query.width * 0.85,
                                  margin: EdgeInsets.only(
                                      top: query.height * 0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentTime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          color: Color(0xFF1E7777),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        endTime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          color: Color(0xFF1E7777),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                width: query.width * 0.9,
                                height: 10,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                    trackHeight: 3,
                                  ),
                                  child: Slider(
                                    inactiveColor: Colors.black12,
                                    activeColor: Color(0xFF1E7777),
                                    min: minimumValue,
                                    max: maximumValue,
                                    value: currentValue,
                                    onChanged: (value) {
                                      currentValue = value;
                                      player.seek(Duration(
                                          milliseconds:
                                          currentValue.round()));
                                    },
                                  ),
                                ),
                              ),
                            ]),
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: query.height * 0.005),
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      child: Icon(Icons.shuffle,
                                          color: shuffle
                                              ? Color(0xFF1E7777)
                                              : Colors.black,
                                          size: 28),
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        setState(() {
                                          shuffle = !shuffle;
                                          if (shuffle)
                                            repeatStyle = Play.none;
                                        });
                                      },
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width: query.width * 0.45,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 13.0,
                                            spreadRadius: -13,
                                            offset: Offset(0, 10),
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Icon(Icons.skip_previous,
                                                color: Color(0xFF1E7777),
                                                size: 29),
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              changeTrack(false);
                                            },
                                          ),
                                          Container(
                                            width: query.width * (1 / 7),
                                            height: query.width * (1 / 7),
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    begin:
                                                    Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter,
                                                    colors: [
                                                      Color(0xFF193833),
                                                      Color(0xFF609394)
                                                    ]),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    query.width *
                                                        (1 / 3.5))),
                                            child: FlatButton(
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                changeStatus();
                                              },
                                              child: Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,
                                                size:
                                                query.width * (1 / 10),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            child: Icon(Icons.skip_next,
                                                color: Color(0xFF1E7777),
                                                size: 29),
                                            behavior:
                                            HitTestBehavior.translucent,
                                            onTap: () {
                                              changeTrack(true);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                          repeatStyle == Play.repeatOne
                                              ? Icons.repeat_one
                                              : Icons.repeat,
                                          color: repeatStyle == Play.none
                                              ? Colors.black
                                              : Color(0xFF1E7777),
                                          size: 28),
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        changeRepeatStyle();
                                      },
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
                    : Container(
                  padding: EdgeInsets.only(bottom: query.height*0.15),
                  child: Center(
                    child: AutoSizeText(
                      "Play something!",
                      style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 3,
                        color: Color(0xFF1E7777),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ignore: camel_case_types
class kTextStyleLocal extends StatelessWidget {
  final bool isActive;
  final String label;

  kTextStyleLocal({Key key, this.isActive, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      label,
      maxLines: 1,
      minFontSize: 1,
      style: TextStyle(
        fontSize: isActive ? 13 : 10,
        color: Color(0xFF1E7777),
        letterSpacing: 5,
        fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
      ),
    );
  }
}

