import '../utils/LSImages.dart';

class LSWalkThroughModel {
  String? img;
  String? title;
  String? backgroundImg;

  LSWalkThroughModel({this.img, this.title, this.backgroundImg});
}

List lsWalkThroughList = [
  LSWalkThroughModel(img: LSWalk1, title: 'Choisissez vos vêtements', backgroundImg: LSBgWalk1),
  LSWalkThroughModel(img: LSWalk2, title: 'Planifier le ramassage', backgroundImg: LSBgWalk2),
  LSWalkThroughModel(img: LSWalk4, title: 'Meilleures services de pressing', backgroundImg: LSBgWalk3),
  LSWalkThroughModel(img: LSWalk3, title: 'Livraison à temps', backgroundImg: LSBgWalk4),
  LSWalkThroughModel(img: LSWalk5, title: 'Payez plus tard et soyez satisfait', backgroundImg: LSBgWalk5),
];
