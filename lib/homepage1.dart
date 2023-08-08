import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack/category_card.dart';
import 'package:hack/column.dart';
import 'package:hack/onboarding_screen.dart';
import 'package:hack/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  List imagelist = [
    {"id": 1, "image_path": 'assets/images/3.jpg'},
    {"id": 2, "image_path": 'assets/images/12.jpg'},
    {"id": 3, "image_path": 'assets/images/1.jpg'},
  ];
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello,",
                        style: GoogleFonts.notoSansMono(
                            textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.greenAccent[700],
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(1.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 197, 229, 204),
                            ),
                          ],
                        ))),
                    Text(name,
                        style: GoogleFonts.notoSansMono(
                            textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.greenAccent[700],
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2.0, 3.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 197, 229, 204),
                            ),
                          ],
                        )))
                  ],
                ),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(15)),
                    child: InkWell(
                        onTap: () async {
                          final pref = await SharedPreferences.getInstance();
                          pref.setBool('showHome', false);

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return onBoardingScreen();
                          }));
                        },
                        child: Icon(Icons.logout)))
              ],
            ),
          ),
          Stack(
            children: [
              InkWell(
                onTap: () {
                  print("current index");
                },
                child: CarouselSlider(
                    items: imagelist
                        .map((item) => Padding(
                              padding: EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  item['image_path'],
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                ),
                              ),
                            ))
                        .toList(),
                    carouselController: carouselController,
                    options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        autoPlay: true,
                        aspectRatio: 1.3,
                        viewportFraction: 0.95,
                        onPageChanged: ((index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }))),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text("Let's Recycle",
                style: GoogleFonts.notoSansMono(
                    textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 3.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 197, 229, 204),
                          ),
                        ],
                        color: Colors.greenAccent[700]))),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Text("Click to know more->",
                style: GoogleFonts.notoSansMono(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2.0, 3.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(255, 197, 229, 204),
                          ),
                        ],
                        color: Colors.greenAccent[700]))),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                            text:
                                "Organic waste is any material that is biodegradable and comes from either a plant or an animal. Biodegradable waste is organic material that can be broken into carbon dioxide, methane or simple organic molecules.",
                            iconimage: "assets/images/oragnic.jpeg",
                            cat: "Organic waste");
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "Organic waste",
                    iconImage: "assets/images/4.png",
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                          text:
                              "E-waste is any electrical or electronic equipment that's been discarded. This includes working and broken items that are thrown in the garbage or donated to a charity reseller like Goodwill. Often, if the item goes unsold in the store, it will be thrown away.",
                          iconimage: "assets/images/electronic.jpg",
                          cat: "E-Waste",
                        );
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "Electronic Waste",
                    iconImage: "assets/images/5.png",
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                          text:
                              "The extremely detrimental impact of fast fashion waste on the environment is no news. Besides being responsible for nearly 10% of global carbon emissions, the clothing industry is also infamously known for the amount of resources it wastes and the millions of clothes ending up in landfills every day.",
                          iconimage: "assets/images/batteries.jpg",
                          cat: "Batteries ",
                        );
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "Batteries",
                    iconImage: "assets/images/6.png",
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                            text:
                                "The total amount of waste batteries is more, and it inevitably pollutes the environment. Among them, cadmium, mercury, zinc, lead and chromium are hazardous wastes. These heavy metals will enter the soil, change the soil acidity and alkalinity, affect the growth of crops, and accumulate in the body of crops.",
                            iconimage: "assets/images/cloths.jpg",
                            cat: "Clothes");
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "cloths",
                    iconImage: "assets/images/7.png",
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                            text:
                                "Waste glass is another waste material that is produced in large quantities and is difficult to eliminate. It is known that most of the waste glass is collected, especially container glasses, remelted, and used to produce new glass.",
                            iconimage: "assets/images/glass.jpg",
                            cat: "Glass");
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "glass",
                    iconImage: "assets/images/9.png",
                  ),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.green[50],
                      context: context,
                      builder: (context) {
                        return Mycol(
                            text:
                                "Medical waste should be segregated, packaged, and labeled properly before disposal. Depending on the type of waste, it can be treated through methods such as incineration, autoclaving, or chemical treatment.",
                            iconimage: "assets/images/medical.jpeg",
                            cat: "Medical waste");
                      },
                    );
                  },
                  child: Category_card(
                    categoryname: "Medical Waste",
                    iconImage: "assets/images/10.png",
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
