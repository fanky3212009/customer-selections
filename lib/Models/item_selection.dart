class ItemSelection {
  final int id;
  final String itemCode;
  final String customerId;

  ItemSelection({
    required this.id,
    required this.itemCode,
    required this.customerId,
  });

  get customer => null;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemCode': itemCode,
      'customerId': customerId
    };
  }
}