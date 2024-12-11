// ignore_for_file: prefer_collection_literals, unnecessary_new, unnecessary_this

class Money {
  String? message;
  String? moneyId;
  String? userId;
  String? moneyDetail;
  String? moneyDateTime;
  double? moneyInOut;
  int? moneyType;

  Money({
    this.message,
    this.moneyId,
    this.userId,
    this.moneyDetail,
    this.moneyDateTime,
    this.moneyInOut,
    this.moneyType,
  });

  Money.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    moneyId = json['moneyId'];
    userId = json['userId'];
    moneyDetail = json['moneyDetail'];
    moneyDateTime = json['moneyDateTime'];
    moneyInOut = json['moneyInOut'] != null
        ? double.tryParse(json['moneyInOut'].toString())
        : null;
    moneyType = json['moneyType'] != null
        ? int.tryParse(json['moneyType'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['moneyId'] = this.moneyId;
    data['userId'] = this.userId;
    data['moneyDetail'] = this.moneyDetail;
    data['moneyDateTime'] = this.moneyDateTime;
    data['moneyInOut'] = this.moneyInOut;
    data['moneyType'] = this.moneyType;
    return data;
  }
}
