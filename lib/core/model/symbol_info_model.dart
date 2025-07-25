// infoData = [
//                     {"title": Utils.tr("company_name"), "value": response["desc"] ?? ""},
//                     {"title": Utils.tr("bist_code"), "value": response["code"] ?? ""},
//                     {
//                       "title": Utils.tr("registered_capital"),
//                       "value": GlobalManager().handleValueByLocation(response["capital"].toString())
//                     },
//                     {"title": Utils.tr("merkez_adres"), "value": response["address"] ?? ""},
//                     {"title": Utils.tr("web_adres"), "value": response["website"] ?? ""},
//                     {"title": Utils.tr("telefon_numarası"), "value": response["tel"] ?? ""},
//                     {"title": Utils.tr("fax_numarasi"), "value": response["fax"] ?? ""},
//                     {"title": Utils.tr("faaliyet_alani"), "value": response["activityArea"] ?? ""},
//                   ];

class SymbolInfoModel {
  final String? description;
  final String? code;
  final String? capital;
  final String? address;
  final String? website;
  final String? phone;
  final String? fax;
  final String? activityArea;

  SymbolInfoModel({
    this.description = '',
    this.code = '',
    this.capital = '',
    this.address = '',
    this.website = '',
    this.phone = '',
    this.fax = '',
    this.activityArea = '',
  });

  factory SymbolInfoModel.fromJson(dynamic json) {
    return SymbolInfoModel(
      description: json['desc'],
      code: json['code'],
      capital: json['capital'].toString(),
      address: json['address'],
      website: json['website'],
      phone: json['tel'],
      fax: json['fax'],
      activityArea: json['activityArea'],
    );
  }
}
