import 'package:ai_music_player/models/radio.dart';
import 'package:ai_music_player/utils/ai_util.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:ai_music_player/models/radio.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MyRadio> radios;
  MyRadio _selectedRadio;
  Color _selectedColor;
  bool _isPlaying=false;

  final AudioPlayer _audioPlayer= AudioPlayer();



  @override
  void initState() {
    super.initState();
    fetchRadios();
    _audioPlayer.onPlayerStateChanged.listen((event){
      if(event== AudioPlayerState.PLAYING){
        _isPlaying = true;
      }
      else{
        _isPlaying = false;
      }
      setState(() {


      });
    });
  }

  fetchRadios() async {
    final radioJson = await rootBundle.loadString("assets/radio.json");
    radios = MyRadioList.fromJson(radioJson).radios;
    print(radios);
    setState(() {});
  }
_playMusic(String url){
    _audioPlayer.play(url);
    _selectedRadio= radios.firstWhere((element) => element.url == url);
    print("selectedrRadio.name");
    setState(() {

    });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Stack(
        children: [
          VxAnimatedBox()
              .size(context.screenWidth, context.screenHeight)
              .withGradient(
                LinearGradient(colors: [
                  AiColors.primaryColor1,
                  AiColors.primaryColor2,
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              )
              .make(),
          AppBar(
            title: "AI Music Player".text.xl4.bold.white.make().shimmer(
                  primaryColor: Vx.purple300,
                  secondaryColor: Colors.white,
                ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ).h(100.0).p16(),
          VxSwiper.builder(
              itemCount: radios.length,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              itemBuilder: (context, index) {
                final rad = radios[index];

                return VxBox(
                        child: ZStack([
                          Positioned(
                             top:0.0,
                            right:0.0,
                            child: VxBox(
                              child: rad.category.text.uppercase.white.make().p16()
                            )
                             .height(45)
                            .black
                            .alignCenter
                            .withRounded(value: 10)
                                .make()
                          ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: VStack(
                      [
                        rad.name.text.white.bold.xl4.make(),
                        5.heightBox,
                        rad.tagline.text.white.semiBold.sm.make()
                      ],
                      crossAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: [
                        Icon(CupertinoIcons.play_circle, color: Colors.white),
                        10.heightBox,
                        "Double tap to play".text.gray300.make(),
                      ].vStack()),
                ])).clip(Clip
                    .antiAlias)
                    .bgImage(DecorationImage(
                        image: NetworkImage(rad.image),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.darken)))
                    .border(color: Colors.black, width: 5.0)
                    .withRounded(value: 60.0)
                    .make()
                    .onInkDoubleTap(() {
                      _playMusic(rad.url);

                })
                    .p16()
                    .centered();
              }
              ).centered(),
          Align(
            alignment: Alignment.bottomCenter,
            child: [
              if(_isPlaying)

                  "Playing Now -${_selectedRadio.name} FM".text.makeCentered(),
              Icon(
             _isPlaying? CupertinoIcons.stop_circle:CupertinoIcons.play_circle,
              color: Colors.white ,
              size: 50,
            ).onInkTap(() {
              if(_isPlaying)
                {
                  _audioPlayer.stop();
                }else{
                _playMusic(_selectedRadio.url);
              }
              }
              )
            ].vStack(),
          ).pOnly(bottom: context.percentHeight*12)
        ],
        fit: StackFit.expand,
      ),
    );
  }
}

