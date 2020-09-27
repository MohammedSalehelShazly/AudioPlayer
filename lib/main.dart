import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/rendering.dart';
//import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioPlayerMp3(),
    );
  }
}

class AudioPlayerMp3 extends StatefulWidget {
  @override
  _AudioPlayerMp3State createState() => _AudioPlayerMp3State();
}
class _AudioPlayerMp3State extends State<AudioPlayerMp3> {
  @override

  AudioPlayer OnlineSound = AudioPlayer();
  double currentMinute = 0;
  double MinuteOfSong = 1;

  _changeMinute(mnt){
    if(int.parse(mnt) < 10) return "0"+ mnt ;
    else return mnt;


  }
  __changeCurrentMinute(mnt){

    if(int.parse(mnt) < 10) return "0"+ mnt ;
    else return mnt;
  }


  selectOutput() {
    OnlineSound.earpieceOrSpeakersToggle();
  }

  bool jump_5_Seconds = false ;
  jump(p){
    if(jump_5_Seconds ==true && p <= Duration(seconds: MinuteOfSong.toInt()-5 ) ){
      OnlineSound.seek( p + Duration(seconds: 5)) ;
    }
    else print('not juump');
  }
  bool undo_jump_5_Seconds = false ;
  undo_jump(p){
    if(undo_jump_5_Seconds ==true  &&  p >= Duration(seconds: 5) ){
      OnlineSound.seek( p - Duration(seconds: 5)) ;
    }
    /* not work !!
    else if(p < Duration(seconds: 5) ) {

      p = Duration(seconds: 0);
      print('this');
    }*/
    else print('not undo juump');
  }

  String imageSonge = 'https://i0.wp.com/watanimg.elwatannews.com/image_archive/original_lower_quality/12064021411588556626.jpg?w=696&ssl=1';
  List <String> SongLink = ['https://luan.xyz/files/audio/ambient_c_motion.mp3',];
  String songTitle = 'ambient_c_motion';
  int counter = 1;
  _changeCounter({increasment=false , decreasment=false}){
    if(increasment=true){
      counter <= SongLink.length ? counter++ : counter =1 ;
    }
    if(decreasment=true){
      counter >= 1 ? counter-- : counter = SongLink.length ;
    }
  }

  AudioPlayerState audioState = AudioPlayerState.STOPPED ;
  aduioStat(){
    OnlineSound.onPlayerStateChanged.listen((s) {
      s == AudioPlayerState.COMPLETED ? print(s) : null;
      setState(() => audioState = s);
    });
  }




  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        primary: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon:Icon(Icons.arrow_back_ios),tooltip: 'Back',
            onPressed: ()=>Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(songTitle , style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.7 /songTitle.length ),),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.queue_music),
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: (){},
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: MediaQuery.of(context).size.height /12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.skip_previous , color: Colors.white,),
                  onPressed: (){
                    setState(()=> _changeCounter(decreasment: true));
                  },
                ),
                SizedBox(width: 65,),

                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white,),
                  onPressed: (){
                    setState(()=> _changeCounter(increasment: true));
                  },
                ),


              ],
            ),
          ),
          color: Colors.red[900].withOpacity(0.4),
          shape: CircularNotchedRectangle(),
          notchMargin: 6,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: RawMaterialButton(
          constraints: BoxConstraints.expand(width: 65 , height: 65),
          fillColor: Colors.white12,
          splashColor: Colors.red,
          child:audioState==AudioPlayerState.PLAYING ? Icon(Icons.pause, size: 50, color:Colors.redAccent[700]) :    Icon(Icons.play_arrow , size: 50, color:Colors.redAccent[700]) ,
          shape: CircleBorder(),
          onPressed: () {
            if(audioState !=AudioPlayerState.PLAYING ){

              OnlineSound.play(SongLink[counter-1]);    // change index with (next Button)

              OnlineSound.onDurationChanged.listen((Duration d) {
                setState(() => MinuteOfSong = d.inSeconds.toDouble());
              });
              OnlineSound.onAudioPositionChanged.listen((Duration  p){
                setState(() => currentMinute = p.inSeconds.toDouble() );
                if(jump_5_Seconds == true){
                  jump(p);
                  setState(() => jump_5_Seconds = false);
                }
                if(undo_jump_5_Seconds == true){
                  undo_jump(p);
                  setState(() => undo_jump_5_Seconds = false);
                }
              });
              //selectOutput();
              aduioStat();
            }
            else OnlineSound.pause() ;
          } ,
        ),

        body: Container(
          decoration: BoxDecoration(color: Colors.black87,boxShadow: [BoxShadow(color: Colors.black87 , blurRadius: 15 ,spreadRadius: 15)]),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height *0.6,
                  decoration:  BoxDecoration(
                    image:  DecorationImage(
                      image:  CachedNetworkImageProvider(imageSonge),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child:  ClipRRect(
                    child: BackdropFilter(
                      filter:  ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child:  Container(
                        alignment: Alignment.center,
                        color: Colors.black26.withOpacity(0.2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.width *0.7,
                              child: CachedNetworkImage(
                                imageUrl: 'https://images.unsplash.com/photo-1519874179391-3ebc752241dd?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80', // must right link but not Appears !
                                placeholder: (context , url)=>Center(child: Container( width: 35,height: 35, child: CircularProgressIndicator())),
                                errorWidget: (context , error ,url)=>Icon(Icons.error_outline , color: Colors.red[800],size: 40,),
                                imageBuilder: (context , imageProvider) => CircularProfileAvatar(
                                  imageSonge,
                                  radius: MediaQuery.of(context).size.width *0.35,
                                  initialsText: Text(" "),
                                  cacheImage: true,
                                  elevation: 30,
                                  foregroundColor: Colors.black.withOpacity(0.1),
                                  showInitialTextAbovePicture: true,
                                ),
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.width *0.75,
                                width:MediaQuery.of(context).size.width *0.75,
                                child: SleekCircularSlider(
                                  initialValue: currentMinute,
                                  min: 0,max: MinuteOfSong,
                                  appearance: CircularSliderAppearance(
                                      counterClockwise: false,
                                      customColors: CustomSliderColors(
                                          progressBarColors: [ Colors.black , Colors.red[900] , Colors.black ]
                                      ),
                                      animationEnabled: false,
                                      customWidths: CustomSliderWidths(handlerSize: 5 , progressBarWidth: 8 , trackWidth: 2),
                                      startAngle: 0,
                                      angleRange: 180,
                                      spinnerDuration: 0
                                  ),
                                  onChangeEnd: (x){
                                    setState(() {
                                      OnlineSound.seek(Duration(seconds: x.toInt()));
                                    });
                                  },//onChangeEnd: (x)=>print(x.toInt()),
                                  innerWidget: (x)=>Text(''),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /*Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons. fast_rewind, size: 20, color:Colors.white),
                      onPressed: (){
                        setState(() => undo_jump_5_Seconds = true );
                      },
                    ),
                    Expanded(
                      child: Slider(
                        value: currentMinute,
                        min: 0,max: MinuteOfSong,
                        divisions: MinuteOfSong.toInt(),
                        activeColor: Colors.red,
                        inactiveColor: Colors.white38,
                        onChanged: (x){
                          setState(() {
                            OnlineSound.seek(Duration(seconds: x.toInt()));
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons. fast_forward, size: 20, color:Colors.white),
                      onPressed: (){
                        setState(() => jump_5_Seconds = true );
                      },
                    ),
                  ],
                ),
              ),*/

              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width /40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${_changeMinute( (MinuteOfSong~/60).toInt().toString() )}  :  ${MinuteOfSong == 1 ? '00' : _changeMinute((MinuteOfSong% 60).toInt().toString())}" ,style: TextStyle( color:Colors.white , fontSize: 15),),
                    Text(" ${__changeCurrentMinute((currentMinute~/60).toInt().toString())} : ${ __changeCurrentMinute((currentMinute.toInt()  -   ((currentMinute/60).toInt() *60 )).toString()) }",style: TextStyle( color:Colors.white , fontSize: 15)),
                  ],
                ),
              ),



            ],
          ),
        ),

      ),
    );
  }



  madeWith_CustomPainter(){
    return CustomPaint(
      painter: Sky(),
      child: Container(color: Colors.red,height: 100,width: 200,),
    );
  }
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect (
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}