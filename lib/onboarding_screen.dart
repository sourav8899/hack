import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack/bottom.dart';
import 'package:hack/intropage4.dart';
import 'package:hack/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'intropage1.dart';
import 'intropage2.dart';
import 'intropage3.dart';
import 'homepage1.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  //controller
  PageController _controller = PageController();
  bool onlast = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onlast = (index == 3);
              });
            },
            children: [intropage1(), intropage2(), intropage3(), intropage4()],
          ),
          Container(
              alignment: Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(3);
                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 211, 237, 211),
                        border: Border.all(
                            color: Color.fromARGB(255, 211, 237, 211),
                            width: 10),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Skip",
                          style: GoogleFonts.notoSansMono(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                  ),
                  onlast
                      ? GestureDetector(
                          onTap: () async {
                            final k = await SharedPreferences.getInstance();


                            if (name != "") {
                              await SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                              await Future.delayed(
                                  const Duration(milliseconds: 100), () {});
                              final pref =
                                  await SharedPreferences.getInstance();
                              pref.setBool('showHome', true);

                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return Bottom();
                              }));
                            }
                            ;
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border:
                                  Border.all(color: Colors.green, width: 10),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Lets Go!",
                                style: GoogleFonts.notoSansMono(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 211, 237, 211),
                              border: Border.all(
                                  color: Color.fromARGB(255, 211, 237, 211),
                                  width: 10),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "next",
                                style: GoogleFonts.notoSansMono(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                ],
              ))
        ],
      ),
    );
  }
}
