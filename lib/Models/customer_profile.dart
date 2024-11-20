class CustomerProfile {
  int? id;
  DateTime createDate;
  String exhibition;
  String salesman;
  String guest;
  String company;
  String name;
  String contact;
  String remarks;
  String? businessCardImagePath;

  CustomerProfile({
    this.id,
    required this.createDate,
    this.exhibition = '',
    this.salesman = '',
    this.guest = '',
    this.company = '',
    this.name = '',
    this.contact = '',
    this.remarks = '',
    this.businessCardImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'createDate': createDate.toIso8601String(),
      'exhibition': exhibition,
      'salesman': salesman,
      'guest': guest,
      'company': company,
      'name': name,
      'contact': contact,
      'remarks': remarks,
      'businessCardImagePath': businessCardImagePath,
    };
  }
}
