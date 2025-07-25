class IpoCustomerInfoModel {
  String? token;
  List<CustomerInfo>? customerInfo;

  IpoCustomerInfoModel({this.token, this.customerInfo});

  factory IpoCustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return IpoCustomerInfoModel(
      token: json['token'],
      customerInfo: json['customerInfo']
          .map<CustomerInfo>(
            (dynamic element) => CustomerInfo.fromJson(element),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    if (this.customerInfo != null) {
      data['customerInfo'] = this.customerInfo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerInfo {
  String? fullName;
  String? phoneNumber;
  String? email;
  String? address;
  String? created;

  CustomerInfo({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.address,
    this.created,
  });

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    address = json['address'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['created'] = this.created;
    return data;
  }
}
