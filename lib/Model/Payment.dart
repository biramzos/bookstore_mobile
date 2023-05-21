class Payment {
  final int? id;
  final int? basketId;
  final double? cost;
  final int? creditId;
  final String? status;
  Payment(
      this.id,
      this.basketId,
      this.cost,
      this.creditId,
      this.status
      );

  Payment.fromJson(dynamic data):
        id = data['id'],
        basketId = data['basket'],
        cost = data['cost'],
        creditId = data['credit'],
        status = data['status'];

  Map toJson() => {
    "id": id,
    "basket": basketId,
    "cost": cost,
    "credit": creditId,
    "status": status
  };
}