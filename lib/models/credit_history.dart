class CreditHistory {
  int clinicId;
  int credit;
  int addCredit;
  DateTime dateAdded;
  int? previousCredit;

  CreditHistory({
    required this.clinicId,
    required this.credit,
    required this.addCredit,
    required this.dateAdded,
    this.previousCredit,
  });

  factory CreditHistory.fromJson(Map<String, dynamic> json) {
    return CreditHistory(
      clinicId: json['clinicId'],
      credit: json['credit'],
      addCredit: json['add_credit'],
      dateAdded: DateTime.parse(json['date_added']),
      previousCredit: json['previous_credit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicId': clinicId,
      'credit': credit,
      'add_credit': addCredit,
      'date_added': dateAdded.toIso8601String(),
      'previous_credit': previousCredit,
    };
  }
}
