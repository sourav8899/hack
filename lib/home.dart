import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hack/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'mao.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _prediction = [];
  List string = ['cloths', 'make', 'break', 'sake', 'take'];
  int take=0;
  bool loading = false;
  File? imageFile;
  void initState() {
    super.initState();
    loadmodel();
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: 'assets/images/g.tflite',
      labels: 'assets/images/labels3.txt',
    );
  }

  detectimage() async {
    var prediction = await Tflite.runModelOnImage(
        path: imageFile!.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      loading = true;
      _prediction = prediction!;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan images',
          style: TextStyle(color: Colors.green),
        ),
        backgroundColor: Colors.green[50],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageFile != null)
              Column(
                children: [
                  Container(
                    width: 640,
                    height: 480,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                          image: FileImage(imageFile!), fit: BoxFit.cover),
                      border: Border.all(
                          width: 8, color: Color.fromARGB(255, 154, 219, 154)),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  if (loading == true)
                    Column(children: [
                      _prediction.isNotEmpty && _prediction[0]['label'] != null
                          ? Column(
                              children: [
                                Text(
                                  "Materail type:" +
                                      _prediction[0]['label'].toString(),
                                  style: GoogleFonts.notoSansMono(
                                      textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 80, 212, 148),
                                  )),
                                ),
                               Text(string[map[_prediction[0]['label']?.toString()] ?? 0]),
 
                                Text(
                                  "Confidence:" +
                                      _prediction[0]['confidence'].toString(),
                                  style: GoogleFonts.notoSansMono(
                                      textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color.fromARGB(255, 80, 212, 148),
                                  )),
                                ),
                              ],
                            )
                          : Text(
                              "retake",
                              style: GoogleFonts.notoSansMono(
                                  textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color.fromARGB(255, 80, 212, 148),
                              )),
                            ),
                    ])
                ],
              )
            else
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset('assets/images/15.png')),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () => getImage(source: ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade50),
                      child: const Text('Capture Image',
                          style: TextStyle(fontSize: 18, color: Colors.green))),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade50),
                      onPressed: () => getImage(source: ImageSource.gallery),
                      child: const Text('Select Image',
                          style: TextStyle(fontSize: 18, color: Colors.green))),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    imageFile = null;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[50],
                    padding: EdgeInsets.only(left: 50, right: 50)),
                child: Text(
                  "reset",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 640,
        maxHeight: 480,
        imageQuality: 100 //0 - 100
        );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        detectimage();
      });
    }
  }
}
// import 'dart:convert';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   List<dynamic> _prediction = [];
//   bool loading = false;
//   File? imageFile;

//   @override
//   void initState() {
//     super.initState();
//   }

//   detectImage(File image) async {
//     setState(() {
//       loading = true;
//     });

//     final endpoint =
//         'https://us-central1-aiplatform.googleapis.com/v1/projects/360479192085/locations/us-central1/endpoints/5640402291514146816:predict';
//     final accessToken = await getAccessToken();

//     final response = await http.post(
//       Uri.parse(endpoint),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Bearer $accessToken',
//         HttpHeaders.contentTypeHeader: 'application/json',
//       },
//       body: jsonEncode({
//         'instances': [
//           {'content': base64Encode(image.readAsBytesSync())}
//         ],
//         'parameters': {
//           'confidenceThreshold': 0.5,
//           'maxPredictions': 5,
//         },
//       }),
//     );

//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       final predictions = jsonResponse['predictions'] ?? [];
//       print(predictions);

//       setState(() {
//         loading = false;
//         _prediction = predictions;
//       });
//     } else {
//       setState(() {
//         loading = false;
//         _prediction = [];
//       });
//     }
//   }

//   Future<String> getAccessToken() async {
//     // Implement your logic to retrieve the access token
//     // For example, you can use the googleapis_auth package or authenticate with the Google Cloud SDK
//     // and use the obtained access token here.
//     return 'AIzaSyCLvuYJUTkIZe-JuZNe9nNlchyfY1ksNL0';
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Scan images',
//           style: TextStyle(color: Colors.green),
//         ),
//         backgroundColor: Colors.green[50],
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (imageFile != null)
//               Column(
//                 children: [
//                   Container(
//                     width: 640,
//                     height: 480,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       image: DecorationImage(
//                         image: FileImage(imageFile!),
//                         fit: BoxFit.cover,
//                       ),
//                       border: Border.all(
//                         width: 8,
//                         color: Color.fromARGB(255, 154, 219, 154),
//                       ),
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                   ),
//                   if (loading == true)
//                     Column(
//                       children: [
//                         if (_prediction.isNotEmpty &&
//                             _prediction[0]['label'] != null)
//                           Column(
//                             children: [
//                               Text(
//                                 'Material type: ' +
//                                     _prediction[0]['label']
//                                         .toString()
//                                         .substring(2),
//                                 style: GoogleFonts.notoSansMono(
//                                   textStyle: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w800,
//                                     color: Color.fromARGB(255, 80, 212, 148),
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 'Confidence: ' +
//                                     _prediction[0]['confidence'].toString(),
//                                 style: GoogleFonts.notoSansMono(
//                                   textStyle: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w800,
//                                     color: Color.fromARGB(255, 80, 212, 148),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )
//                         else
//                           Text(
//                             're -s',
//                             style: GoogleFonts.notoSansMono(
//                               textStyle: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w800,
//                                 color: Color.fromARGB(255, 80, 212, 148),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                 ],
//               )
//             else
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.asset('assets/images/15.png'),
//               ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => getImage(source: ImageSource.camera),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade50,
//                     ),
//                     child: const Text(
//                       'Capture Image',
//                       style: TextStyle(fontSize: 18, color: Colors.green),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green.shade50,
//                     ),
//                     onPressed: () => getImage(source: ImageSource.gallery),
//                     child: const Text(
//                       'Select Image',
//                       style: TextStyle(fontSize: 18, color: Colors.green),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   imageFile = null;
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green[50],
//                 padding: EdgeInsets.only(left: 50, right: 50),
//               ),
//               child: Text(
//                 'Reset',
//                 style: TextStyle(color: Colors.green, fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void getImage({required ImageSource source}) async {
//     final file = await ImagePicker().pickImage(
//       source: source,
//       maxWidth: 640,
//       maxHeight: 480,
//       imageQuality: 100, // 0 - 100
//     );

//     if (file?.path != null) {
//       setState(() {
//         imageFile = File(file!.path);
//         detectImage(imageFile!);
//       });
//     }
//   }
// }
