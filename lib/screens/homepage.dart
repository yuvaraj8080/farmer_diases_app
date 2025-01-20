import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_diases_app/diseases/CherrySourMildew.dart';
import 'package:farmer_diases_app/diseases/TomatoSpider.dart';
import 'package:farmer_diases_app/screens/planthealth.dart';
import 'package:farmer_diases_app/utils/planthealththeme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

import '../diseases/AppleBlackRot.dart';
import '../diseases/AppleCedarRust.dart';
import '../diseases/AppleScab.dart';
import '../diseases/CornCommonRust.dart';
import '../diseases/CornGrayLeaf.dart';
import '../diseases/GrapeBlackRot.dart';
import '../diseases/GrapeEsca.dart';
import '../diseases/GrapeLeafBlight.dart';
import '../diseases/Healthy.dart';
import '../diseases/NorthernCornLeafBlight.dart';
import '../diseases/OrangeCitrus.dart';
import '../diseases/PeachSpot.dart';
import '../diseases/PepperBacterialSpot.dart';
import '../diseases/PotatoEarlyBlight.dart';
import '../diseases/PotatoLateBlight.dart';
import '../diseases/SquashMildew.dart';
import '../diseases/StrawberryLeafScorch.dart';
import '../diseases/TomatoBacteriaSpot.dart';
import '../diseases/TomatoEarlyBlight.dart';
import '../diseases/TomatoLateBlight.dart';
import '../diseases/TomatoLeafMold.dart';
import '../diseases/TomatoLeafSpot.dart';
import '../diseases/TomatoMosaic.dart';
import '../diseases/TomatoTarget.dart';
import '../diseases/TomatoYellow.dart';
import '../models/apimodel.dart';
import '../services/dbdata.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/itemcard.dart';
import '../utils/notificationservice.dart';
import '../utils/widgets.dart';
import 'classifieddiseases.dart';
import 'drawer.dart';
import 'moisture.dart';
import 'notifications.dart';

const String mobile = "MobileNet";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late File  image;
  late List _recognitions;
  String _model = mobile;
  late double _imageHeight;
  late double _imageWidth;
  bool dialVisible = true;
  // late ProgressDialog pr;
  late ApiDataModel dataModelApi;
  late Conditions temp, humid, moist;
  String head = "";
  late bool firsttime;
  int count = 0;

  @override
  void initState() {
    super.initState();
    // NotificationService().initialise();
    firsttime = true;
    loadModel();
    count = 0;
    checkForNotification();
  }

  Future<void> loadModel() async {
    print("DEBUG: Inside Load Model Function");
    Tflite.close();
    try {
      String? res = await Tflite.loadModel(
        model: "assets/plant_disease_model.tflite",
        labels: "assets/disease_labels.txt",
      );
      print(res);
    } on PlatformException {
      print('Failed to load model.');
      showErrorProcessing(context);
    }
  }

  void resultPage(BuildContext context, String name) {
    // Mapping disease names to their respective pages
    final diseaseRoutes = {
      "apple apple scab": () => AppleScab(),
      "apple black rot": () => AppleBlack(),
      "apple cedar apple rust": () => AppleCedarRust(),
      "cherry including sour powdery mildew": () => CherrySour(),
      "corn maize cercospora leaf spot gray leaf spot": () => CornGrayLeaf(),
      "corn maize common rust": () => CornCommonRust(),
      "corn maize northern leaf blight": () => NorthernCornLeafBlight(),
      "grape black rot": () => GrapeBlackRot(),
      "grape esca black measles": () => GrapeEsca(),
      "grape leaf blight isariopsis leaf spot": () => GrapeLeafBlight(),
      "orange haunglongbing citrus greening": () => OrangeCitrus(),
      "peach bacterial spot": () => PeachSpot(),
      "pepper bell bacterial spot": () => PepperBacterialSpot(),
      "potato early blight": () => PotatoEarlyBlight(),
      "potato late blight": () => PotatoLateBlight(),
      "squash powdery mildew": () => SquashMildew(),
      "strawberry leaf scorch": () => StrawberryLeafScorch(),
      "tomato bacterial spot": () => TomatoBacteriaSpot(),
      "tomato early blight": () => TomatoEarlyBlight(),
      "tomato late blight": () => TomatoLateBlight(),
      "tomato leaf mold": () => TomatoLeafMold(),
      "tomato septoria leaf spot": () => TomatoLeafSpot(),
      "tomato spider mites two spotted spider mite": () => TomatoSpider(),
      "tomato target spot": () => TomatoTarget(),
      "tomato tomato yellow leaf curl virus": () => TomatoYellow(),
      "tomato tomato mosaic virus": () => TomatoMosaic(),
      "apple healthy": () => Healthy(),
      "blueberry healthy": () => Healthy(),
      "cherry including sour healthy": () => Healthy(),
      "corn maize healthy": () => Healthy(),
      "grape healthy": () => Healthy(),
      "peach healthy": () => Healthy(),
      "pepper bell healthy": () => Healthy(),
      "potato healthy": () => Healthy(),
      "raspberry healthy": () => Healthy(),
      "soybean healthy": () => Healthy(),
      "strawberry healthy": () => Healthy(),
      "tomato healthy": () => Healthy(),
    };

    if (diseaseRoutes.containsKey(name)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => diseaseRoutes[name]!()),
      );
    } else {
      showErrorProcessing(context);
    }
  }

  // Uint8List imageToByteListFloat32(img.Image image, int inputSize, double mean, double std) {
  //   // Create a Float32List to hold the converted bytes
  //   var convertedBytes = Float32List(inputSize * inputSize * 3);
  //   var buffer = Float32List.view(convertedBytes.buffer);
  //   int pixelIndex = 0;
  //
  //   // Loop through each pixel in the image
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       // Get the pixel value at (j, i)
  //       var pixel = image.getPixel(j, i);
  //       // Normalize the pixel values and store them in the buffer
  //       buffer[pixelIndex++] = (img.getRed(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getGreen(pixel) - mean) / std;
  //       buffer[pixelIndex++] = (img.getBlue(pixel) - mean) / std;
  //     }
  //   }

  //   // Return the converted bytes as a Uint8List
  //   return convertedBytes.buffer.asUint8List();
  // }

  // Future<void> recognizeImage(File image) async {
  //   print("DEBUG: Inside Recognize Image Function");
  //   try {
  //     double percentage = 0.0;
  //     pr = ProgressDialog(context, type: ProgressDialogType.Normal);
  //     pr.style(
  //       message: 'Detecting Disease...',
  //       borderRadius: 10.0,
  //       backgroundColor: Colors.white,
  //       elevation: 10.0,
  //       insetAnimCurve: Curves.easeInOut,
  //       progress: 0.0,
  //       maxProgress: 100.0,
  //       progressTextStyle: TextStyle(
  //           color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  //       messageTextStyle: TextStyle(
  //           color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  //     );
  //     var labelForHighest = "";
  //     double confidence = -1.00;
  //     Uint8List bytes = image.readAsBytesSync();
  //     img.Image? oriImage = img.decodeJpg(bytes);
  //     img.Image resizedImage = img.copyResize(oriImage!, width: 299, height: 299);
  //     var recognitions = await Tflite.runModelOnBinary(
  //       binary: imageToByteListFloat32(resizedImage, 299, 0, 255.0),
  //       numResults: 3,
  //       threshold: 0.5,
  //     );
  //     setState(() {
  //       _recognitions = recognitions!;
  //     });
  //
  //     pr.show();
  //
  //     Future.delayed(Duration(seconds: 1)).then((onvalue) {
  //       percentage += 30.0;
  //       pr.update(
  //         progress: percentage,
  //         message: "Checking Confidence..",
  //         maxProgress: 100.0,
  //       );
  //
  //       Future.delayed(Duration(seconds: 1)).then((value) {
  //         percentage += 30.0;
  //         pr.update(progress: percentage, message: "Few more seconds...");
  //         Future.delayed(Duration(seconds: 2)).then((value) {
  //           percentage += 30.0;
  //           pr.update(progress: percentage, message: "Almost done..");
  //
  //           Future.delayed(Duration(seconds: 1)).then((value) {
  //             pr.hide().whenComplete(() {
  //               print(pr.isShowing());
  //             });
  //             percentage = 0.0;
  //           });
  //         });
  //       });
  //     });
  //
  //     Future.delayed(Duration(seconds: 6)).then((onValue) {
  //       if (pr.isShowing()) {
  //         pr.hide().then((isHidden) {
  //           print(isHidden);
  //         });
  //       }
  //
  //       if (_recognitions.isNotEmpty) {
  //         for (int i = 0; i < _recognitions.length; i++) {
  //           if (_recognitions[i]['confidence'] > confidence) {
  //             labelForHighest = _recognitions[i]['label'];
  //             confidence = _recognitions[i]['confidence'];
  //           }
  //         }
  //
  //         if (confidence.abs() > 0.80) {
  //           resultPage(context, labelForHighest);
  //         } else {
  //           showCustomDialogWithImage(context, labelForHighest);
  //         }
  //       } else {
  //         showErrorProcessing(context);
  //       }
  //     });
  //   } on Exception {
  //     showErrorProcessing(context);
  //   }
  // }

  void showCustomDialogWithImage(BuildContext context, var labelForHighest) {
    Dialog dialogWithImage = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0)),
          ],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              child: Image(
                  width: MediaQuery.of(context).size.width,
                  image: AssetImage('assets/widget_delete.jpg'),
                  height: 120,
                  fit: BoxFit.cover),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                  "We are not sure with the disease.\nDo you still wish to check the disease?",
                  style: secondaryTextStyle(color: Color(0xFF5A5C5E))),
            ),
            SizedBox(height: 16),
            Text('Continue?',
                style: boldTextStyle(color: Color(0xFF212121), size: 18)),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecoration(
                          color: t5DarkNavy,
                          radius: 8,
                          bgColor: Color(0xFFFFFFFF)),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.close,
                                          color: Colors.blueAccent, size: 18))),
                              TextSpan(
                                  text: "No",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: t5DarkNavy,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      Navigator.pop(context);
                    }),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecoration(bgColor: t5DarkNavy, radius: 8),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: 18))),
                              TextSpan(
                                  text: "Yes",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontFamily: fontRegular)),
                            ],
                          ),
                        ),
                      ),
                    ).onTap(() {
                      Navigator.pop(context);
                      resultPage(context, labelForHighest);
                    }),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => dialogWithImage);
  }

  Future<void> checkForNotification() async {
    int channelCount = 0;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser !.uid)
          .collection('notifications')
          .where('existence', isEqualTo: true)
          .snapshots()
          .listen((event) {
        event.docChanges.forEach((element) {
          if (element.type == DocumentChangeType.added &&
              element.doc.data()!['existence'] == true) {
            setState(() {
              count++;
            });
            updateNotification(element.doc.id);
            print(count);
          }
        });
      });
    } catch (e) {
      print("error");
    }
  }

  Future<void> predictImage(File image) async {
    print("DEBUG: Inside Predict Image Function");
    // await recognizeImage(image);
    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));
  }

  Future<void> getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    predictImage(File(pickedFile.path));
  }

  Future<void> getCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    predictImage(File(pickedFile.path));
  }

  @override
  Widget build(BuildContext context) {
    var l = MediaQuery.of(context).size.width;
    // changeStatusColor(t5DarkNavy);
    var width = MediaQuery.of(context).size.width - 50;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: t5DarkNavy,
      key: _scaffoldKey,
      drawer: Drawer(child: UserDrawer()),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: 70,
              margin: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(profileimg!),
                        radius: 25,
                      ),
                      SizedBox(width: 16),
                      text(name,
                          textColor: Colors.white,
                          fontSize: textSizeNormal,
                          fontFamily: fontMedium)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: <Widget>[
                          IconButton(
                            icon: SvgPicture.asset(
                              "assets/t5_notification_2.svg",
                              width: 25,
                              height: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                count = 0;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Notifications()));
                            },
                          ),
                          count != 0
                              ? Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                              : Positioned(
                              right: 11, top: 11, child: Container())
                        ],
                      ),
                      SizedBox(width: 7),
                      IconButton(
                        onPressed: () {
                          if (_scaffoldKey.currentState!.isDrawerOpen) {
                            _scaffoldKey.currentState!.openEndDrawer();
                          } else {
                            _scaffoldKey.currentState!.openDrawer();
                          }
                        },
                        icon: SvgPicture.asset(
                          "assets/t5_options.svg",
                          width: 25,
                          height: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Container(
                padding: EdgeInsets.only(top: 28),
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: FitnessAppTheme.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    )),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: StreamBuilder(
                      stream: Stream.periodic(Duration(seconds: 5)).asyncMap((i) =>
                          _fetchData()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('We got an Error ${snapshot.error}');
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: Container(
                                child: Theme(
                                  data: ThemeData.light(),
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 20,
                                  ),
                                ),
                              ),
                            );

                          case ConnectionState.none:
                            return Text('oops no data');

                          case ConnectionState.done:
                            return Text('We are Done');
                          default:
                            return Column(
                              children: [
                                PlantHealth(
                                  temp: temp,
                                  humid: humid,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, bottom: 5),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 10.0),
                                        child: text("Classified Diseases",
                                            fontFamily: fontMedium,
                                            fontSize: textSizeMedium),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: l - 249),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClassifiedDiseases()));
                                            },
                                            child: Text(
                                              "View All",
                                              style:
                                              TextStyle(color: Colors.blue),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 10),
                                  child: Container(
                                    height: 200,
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GrapeBlackRot()));
                                          },
                                          child: ItemCard(
                                            title: "Grape Black Rot",
                                            photo: "assets/grapeblack.jpg",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AppleCedarRust()));
                                          },
                                          child: ItemCard(
                                            title: "Apple Cedar Rust",
                                            photo: "assets/cedar.jpg",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CornGrayLeaf()));
                                          },
                                          child: ItemCard(
                                            title: "Corn Gray Leaf",
                                            photo: "assets/corngray.jpeg",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.push context,
                                            //     MaterialPageRoute(
                                            // builder: (context) =>
                                            //     TomatoLateBlight()));
                                          },
                                          child: ItemCard(
                                            title: "Tomato Late Blight",
                                            photo: "assets/tlb3.jpg",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PotatoLateBlight()));
                                          },
                                          child: ItemCard(
                                            title: "Grape Leaf Blight",
                                            photo: "assets/grapebli.jpg",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                MoistureView(
                                  moist: this.moist,
                                ),
                              ],
                            );
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_home,
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.red,
              child: Icon(
                Icons.camera,
                color: Colors.white,
              ),
              label: 'Camera',
              labelBackgroundColor: Colors.white,
              onTap: () => getCamera()),
          SpeedDialChild(
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.image,
                color: Colors.white,
              ),
              label: 'Gallery',
              labelBackgroundColor: Colors.white,
              onTap: () => getImage()),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://api.thingspeak.com/channels/1490676/feeds.json?api_key=6CLVROP39ZFUDNV7&results=1'));

    if (response.statusCode == 200) {
      dataModelApi = ApiDataModel.fromJson(json.decode(response.body));
      print(dataModelApi.feeds[0].field1);
      print("Successfully fetched and parsed Sensor Data");

      // Temperature
      double temperature = double.parse(dataModelApi.feeds[0].field1);
      if (temperature.toInt() >= 18 && temperature.toInt() <= 24) {
        temp = Conditions(
          icon: 'assets/temperature.png',
          name: 'Temperature',
          value: '${temperature.toInt()}',
          subText: 'Normal',
          color: normalTemp,
          subColor: normalText,
        );
      } else if (temperature.toInt() > 24 && temperature.toInt() <= 35) {
        temp = Conditions(
          icon: 'assets/temperature.png',
          name: 'Temperature',
          value: '${temperature.toInt()}',
          subText: 'Moderate',
          color: moderateTemp,
          subColor: moderateText,
        );
      } else if (temperature.toInt() > 35) {
        temp = Conditions(
          icon: 'assets/temperature.png',
          name: 'Temperature',
          value: '${temperature.toInt()}',
          subText: 'Critical',
          color: highTemp,
          subColor: highText,
        );
      }

      // Humidity
      double humidity = double.parse(dataModelApi.feeds[0].field2);
      if (humidity.toInt() >= 50 && humidity.toInt() <= 70) {
        humid = Conditions(
          icon: 'assets/humidity.png',
          name: 'Humidity',
          value: '${humidity.toInt()}',
          subText: 'Normal',
          color: lightBlueHumidity,
          subColor: normalText,
        );
      } else if (humidity.toInt() < 50) {
        humid = Conditions(
          icon: 'assets/humidity.png',
          name: 'Humidity',
          value: '${humidity.toInt()}',
          subText: 'Low',
          color: lightBlueHumidity,
          subColor: moderateText,
        );
      } else if (humidity.toInt() > 70) {
        humid = Conditions(
          icon: 'assets/humidity.png',
          name: 'Humidity',
          value: '${humidity.toInt()}',
          subText: 'High',
          color: lightBlueHumidity,
          subColor: highText,
        );
      }

      // Moisture
      double moisture = double.parse(dataModelApi.feeds[0].field3);
      if (moisture.toInt() >= 70 && moisture.toInt() <= 100) {
        moist = Conditions(
          icon: 'assets/drip.png',
          name: 'Moisture',
          value: '${moisture.toInt()}',
          subText: 'No Irrigation Required',
          color: darkBlueMoisture,
          subColor: normalText,
        );
        head = moist.subText!;
      } else if (moisture.toInt() >= 30 && moisture.toInt() < 70) {
        moist = Conditions(
          icon: 'assets/drip.png',
          name: 'Moisture',
          value: '${moisture.toInt()}',
          subText: 'Irrigation to Be Applied',
          color: darkBlueMoisture,
          subColor: moderateText,
        );
        head = moist.subText!;
      } else if (moisture.toInt() < 30) {
        moist = Conditions(
          icon: 'assets/drip.png',
          name: 'Moisture',
          value: '${moisture.toInt()}',
          subText: 'Critically Low Soil Moisture',
          color: darkBlueMoisture,
          subColor: highText,
        );
        head = moist.subText!;
        if (firsttime) {
          print("Moisture: " + head);
          // if (head == "Critically Low Soil Moisture") {
          //   NotificationService().instantNotification(
          //       head, "Please water the plants with more water", "alert");
          // } else if (head == "Irrigation to Be Applied") {
          //   NotificationService()
          //       .instantNotification(head, "Please water the plants", "alert");
          // } else if (head == "No Irrigation Required") {
          //   NotificationService()
          //       .instantNotification(head, "Your crop is healthy", "normal");
          // }
          firsttime = false;
        }
      }
    } else {
      throw Exception('Failed to load Sensor Data');
    }
  }
}