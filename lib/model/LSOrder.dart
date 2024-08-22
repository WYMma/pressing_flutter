import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/model/LSCartModel.dart';
import 'package:laundry/utils/LSContstants.dart';

class LSOrder {
  static LSOrder? _instance;
  static int _nextId = 0;

  String id;
  String? userID;
  LSAddressModel? address;
  DateTime pickUpDate;
  DateTime deliveryDate;
  String? paymentMethod;
  String deliveryType;
  DateTime confirmationTimestamp;
  String? status;
  String? cartID;
  List<LSCartModel> cartItems;
  double totalPrice;
  bool isConfirmed;
  bool isPickedUp;
  bool isInProgress;
  bool isShipped;
  bool isDelivered;


  static List<LSOrder> OrderHistory = [];

  // Private named constructor
  LSOrder._internal()
      : id = _generateOrderId(),
        address = null,
        pickUpDate = DateTime.now(),
        deliveryDate = DateTime.now(),
        paymentMethod = null,
        confirmationTimestamp = DateTime.now(),
        userID = user,
        cartItems = [],
        totalPrice = 0.0,
        isConfirmed = false,
        isPickedUp = false,
        isInProgress = false,
        isShipped = false,
        isDelivered = false,
        deliveryType = "Livraison Standard";

  // Factory constructor that returns the same instance or creates a new one
  factory LSOrder() {
    if (_instance == null) {
      _instance = LSOrder._internal();
    }
    return _instance!;
  }

  static void removeOrder(LSOrder order) {
    OrderHistory.remove(order);
  }

  // Static method to generate a unique order ID
  static String _generateOrderId() {
    _nextId++;
    return _nextId.toString().padLeft(8, '0');  // Pads the ID with leading zeros to ensure it is 8 digits long
  }

  // Static method to check if the instance exists
  static bool exists() {
    return _instance != null;
  }

  static void reset() {
    _instance = null;
  }

  void setAddress(LSAddressModel address) {
    this.address = address;
  }

  void setPickUpDate(DateTime dateTime) {
    this.pickUpDate = dateTime;
  }

  void setDeliveryDate(DateTime dateTime) {
    this.deliveryDate = dateTime;
  }

  void setPaymentMethod(String method) {
    this.paymentMethod = method;
  }

  void setdeliveryType(String method) {
    this.deliveryType = method;
  }

  void confirmOrder() {
    this.confirmationTimestamp = DateTime.now();
    this.isConfirmed = true;
  }

  void setCartItems(List<LSCartModel> items) {
    this.cartItems = items;
    this.totalPrice = items.fold(0.0, (sum, item) => sum + item.productPrice * item.quantity.value);
  }

  void addPrice(double price) {
    this.totalPrice += price;
  }

  static set instance(LSOrder value) {
    _instance = value;
  }

  @override
  String toString() {
    return 'LSOrder{id: $id, userID: $userID, address: $address, pickUpDate: $pickUpDate, deliveryDate: $deliveryDate, paymentMethod: $paymentMethod, confirmationTimestamp: $confirmationTimestamp, cartItems: $cartItems, totalPrice: $totalPrice}';
  }
}
