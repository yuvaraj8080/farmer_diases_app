
import '../diseases/AppleBlackRot.dart';
import '../diseases/AppleCedarRust.dart';
import '../diseases/AppleScab.dart';
import '../diseases/CherrySourMildew.dart';
import '../diseases/CornCommonRust.dart';
import '../diseases/CornGrayLeaf.dart';
import '../diseases/GrapeBlackRot.dart';
import '../diseases/GrapeEsca.dart';
import '../diseases/GrapeLeafBlight.dart';
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
import '../diseases/TomatoSpider.dart';
import '../diseases/TomatoTarget.dart';
import '../diseases/TomatoYellow.dart';
import '../models/diseasemodel.dart';
import 'getdiseases.dart';

List<DiseasesModel> getDiseases() {
  List<DiseasesModel> list = [];

  // Create instances of DiseasesModel and add them to the list
  list.add(DiseasesModel(
    name: "Apple Black Rot",
    image: "assets/black.jpg",
    tag: AppleBlack(),
  ));

  list.add(DiseasesModel(
    name: "Apple Cedar Rust",
    image: "assets/cedar.jpg",
    tag: AppleCedarRust(),
  ));

  list.add(DiseasesModel(
    name: "Apple Scab",
    image: "assets/scab.jpg",
    tag: AppleScab(),
  ));

  list.add(DiseasesModel(
    name: "Cherry Sour Powdery Mildew",
    image: "assets/cherrysour.jpg",
    tag: CherrySour(),
  ));

  list.add(DiseasesModel(
    name: "Corn Common Rust",
    image: "assets/corn.jpg",
    tag: CornCommonRust(),
  ));

  list.add(DiseasesModel(
    name: "Corn Gray Leaf",
    image: "assets/corngray.jpeg",
    tag: CornGrayLeaf(),
  ));

  list.add(DiseasesModel(
    name: "Northern Corn Leaf Blight",
    image: "assets/ncorn.JPG",
    tag: NorthernCornLeafBlight(),
  ));

  list.add(DiseasesModel(
    name: "Grape Black Rot",
    image: "assets/grapeblack.jpg",
    tag: GrapeBlackRot(),
  ));

  list.add(DiseasesModel(
    name: "Grape Esca",
    image: "assets/esca.jpg",
    tag: GrapeEsca(),
  ));

  list.add(DiseasesModel(
    name: "Grape Leaf Blight",
    image: "assets/grapebli.jpg",
    tag: GrapeLeafBlight(),
  ));

  list.add(DiseasesModel(
    name: "Orange Citrus Greening",
    image : "assets/orange.jpg",
    tag: OrangeCitrus(),
  ));

  list.add(DiseasesModel(
    name: "Peach Bacterial Spot",
    image: "assets/peachspot1.jpg",
    tag: PeachSpot(),
  ));

  list.add(DiseasesModel(
    name: "Pepper Bacterial Spot",
    image: "assets/pepper1.jpg",
    tag: PepperBacterialSpot(),
  ));

  list.add(DiseasesModel(
    name: "Potato Early Blight",
    image: "assets/16.jpg",
    tag: PotatoEarlyBlight(),
  ));

  list.add(DiseasesModel(
    name: "Potato Late Blight",
    image: "assets/plate.jpg",
    tag: PotatoLateBlight(),
  ));

  list.add(DiseasesModel(
    name: "Squash Powdery Mildew",
    image: "assets/squash.jpg",
    tag: SquashMildew(),
  ));

  list.add(DiseasesModel(
    name: "Strawberry Leaf Scorch",
    image: "assets/straw1.jpg",
    tag: StrawberryLeafScorch(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Bacteria Spot",
    image: "assets/tomato1.png",
    tag: TomatoBacteriaSpot(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Early Blight",
    image: "assets/tlb.jpg",
    tag: TomatoEarlyBlight(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Late Blight",
    image: "assets/latetomato.jpg",
    tag: TomatoLateBlight(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Leaf Mold",
    image: "assets/mold1.jpg",
    tag: TomatoLeafMold(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Septoria Leaf Spot",
    image: "assets/tomatospot2.jpeg",
    tag: TomatoLeafSpot(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Spider Mites",
    image: "assets/spider.jpg",
    tag: TomatoSpider(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Target Spot",
    image: "assets/target2.jpg",
    tag: TomatoTarget(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Yellow Leaf Curl Virus",
    image: "assets/curl.png",
    tag: TomatoYellow(),
  ));

  list.add(DiseasesModel(
    name: "Tomato Mosaic Virus",
    image: "assets/mosaic2.jpg",
    tag: TomatoMosaic(),
  ));

  return list;
}

Future<void> fetchList() async {
  diseaseList = getDiseases();
}