class RedemptionStatusResponse {
  final List<RedemptionStatus> data;

  RedemptionStatusResponse({required this.data});

  factory RedemptionStatusResponse.fromJson(Map<String, dynamic> json) {
    return RedemptionStatusResponse(
      data: (json['data'] as List)
          .map((item) => RedemptionStatus.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class RedemptionStatus {
  final String packageId;
  final bool voucherRedeemed;
  final bool prepaidCardRedeemed;

  RedemptionStatus({
    required this.packageId,
    required this.voucherRedeemed,
    required this.prepaidCardRedeemed,
  });

  factory RedemptionStatus.fromJson(Map<String, dynamic> json) {
    return RedemptionStatus(
      packageId: json['package_id'],
      voucherRedeemed: json['voucher_redeemed'],
      prepaidCardRedeemed: json['prepaid_card_redeemed'],
    );
  }

  Map<String, dynamic> toJson() => {
        'package_id': packageId,
        'voucher_redeemed': voucherRedeemed.toString(),
        'prepaid_card_redeemed': prepaidCardRedeemed.toString(),
      };
}
