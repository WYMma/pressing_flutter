import '../utils/LSImages.dart';

class LSServiceModel {
  String? img;
  String? title;
  String? subTitle;
  String? location;
  String? rating;
  String? status;
  String? orderNo;
  String? amount;
  String? couponCode;
  int? qty;
  double? distance;
  String? date;
  bool? isSelected;

  LSServiceModel({
    this.img,
    this.title,
    this.subTitle,
    this.rating,
    this.location,
    this.status,
    this.orderNo,
    this.amount,
    this.qty,
    this.couponCode,
    this.distance,
    this.date,
    this.isSelected,
  });
}

List<LSServiceModel> getTopServiceList() {
  List<LSServiceModel> list = [];

  list.add(LSServiceModel(title: 'Laver & Plier', img: LSWashingClothes));
  list.add(LSServiceModel(title: 'Lavage & Repassage', img: LSSweatshirt));
  list.add(LSServiceModel(title: 'Dry Clean', img: LSSuit));
  list.add(LSServiceModel(title: 'Nettoyage à Sec', img: LSWashingMachine));

  return list;
}

List<LSServiceModel> getNearByServiceList() {
  List<LSServiceModel> list = [];

  list.add(LSServiceModel(title: 'Dhobee Laundry', rating: '5', location: '1810,Camino Real ,New-york', img: LSList1));
  list.add(LSServiceModel(title: 'My Laundry', rating: '4.5', location: '1810,Camino Real ,New-york', img: LSList2));
  list.add(LSServiceModel(title: 'Quick Laundry', rating: '2', location: '1810,Camino Real ,New-york', img: LSList3));
  list.add(LSServiceModel(title: 'Your Laundry', rating: '3', location: '1810,Camino Real ,New-york', img: LSList4));
  return list;
}

List<LSServiceModel> gwtPriceList() {
  List<LSServiceModel> list = [];
  list.add(LSServiceModel(title: 'Laundry', amount: '5', location: '1810,Camino Real ,New-york', img: LSLaundry));
  list.add(LSServiceModel(title: 'Dress', amount: '10', location: '1810,Camino Real ,New-york', img: LSDress));
  list.add(LSServiceModel(title: 'Iron', amount: '5', location: '1810,Camino Real ,New-york', img: LSIron));
  list.add(LSServiceModel(title: 'Sweatshirt', amount: '10', location: '1810,Camino Real ,New-york', img: LSSweatshirt));
  list.add(LSServiceModel(title: 'Sari', amount: '50', location: '1810,Camino Real ,New-york', img: LSSari));
  list.add(LSServiceModel(title: 'Jacket', amount: '20', location: '1810,Camino Real ,New-york', img: LSJacket));

  return list;
}

List<LSServiceModel> getOfferList() {
  List<LSServiceModel> list = [];

  list.add(LSServiceModel(title: 'For a Limited time', rating: '5', subTitle: 'Get 50% off', img: LSWashingClothes));
  list.add(LSServiceModel(title: 'For a Limited time', rating: '4.5', subTitle: 'Get 50% off', img: LSWashService));
  list.add(LSServiceModel(title: 'For a Limited time', rating: '2', subTitle: 'Get 50% off', img: LSSweatshirt));
  list.add(LSServiceModel(title: 'For a Limited time', rating: '3', subTitle: 'Get 50% off', img: LSWashingMachine));
  return list;
}
