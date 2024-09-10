import 'package:laundry/model/LSAddressModel.dart';
import 'package:laundry/model/LSCartModel.dart';

class LSOrder {
  static LSOrder? _instance;

  int id;
  String? clientID;
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
      : id = 0,
        address = null,
        pickUpDate = DateTime.now(),
        deliveryDate = DateTime.now(),
        paymentMethod = null,
        confirmationTimestamp = DateTime.now(),
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
    _instance ??= LSOrder._internal();
    return _instance!;
  }

  static void removeOrder(LSOrder order) {
    OrderHistory.remove(order);
  }

  // Static method to generate a unique order ID


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
    pickUpDate = dateTime;
  }

  void setDeliveryDate(DateTime dateTime) {
    deliveryDate = dateTime;
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
  }

  void setdeliveryType(String method) {
    deliveryType = method;
  }

  void setClientID(String clientID) {
    this.clientID = clientID;
  }

  void confirmOrder() {
    confirmationTimestamp = DateTime.now();
    isConfirmed = true;
  }

  void setCartItems(List<LSCartModel> items) {
    cartItems = items;
    totalPrice = items.fold(0.0, (sum, item) => sum + item.productPrice * item.quantity.value);
  }

  void addPrice(double price) {
    totalPrice += price;
  }

  static set instance(LSOrder value) {
    _instance = value;
  }

  @override
  String toString() {
    return 'LSOrder{id: $id, clientID: $clientID, address: $address, pickUpDate: $pickUpDate, deliveryDate: $deliveryDate, paymentMethod: $paymentMethod, confirmationTimestamp: $confirmationTimestamp, cartItems: $cartItems, totalPrice: $totalPrice}';
  }
}
