class WalletResponse {
  final int statusCode;
  final String messageKey;
  final List<WalletData> data;

  WalletResponse({
    required this.statusCode,
    required this.messageKey,
    required this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      statusCode: json['status_code'],
      messageKey: json['message_key'],
      data: (json['data'] as List)
          .map((item) => WalletData.fromJson(item))
          .toList(),
    );
  }
}

class WalletData {
  final String packageId;
  final Voucher voucher;
  final PrepaidCard prepaidCard;

  WalletData({
    required this.packageId,
    required this.voucher,
    required this.prepaidCard,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      packageId: json['package_id'],
      voucher: Voucher.fromJson(json['voucher']),
      prepaidCard: PrepaidCard.fromJson(json['prepaid_card']),
    );
  }
}

class Voucher {
  final String voucherDescription;
  final String voucherCode;
  final Balance initialBalance;
  final String expiryDate;
  bool voucherRedeemed;

  Voucher({
    required this.voucherDescription,
    required this.voucherCode,
    required this.initialBalance,
    required this.expiryDate,
    required this.voucherRedeemed,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      voucherDescription: json['voucher_description'],
      voucherCode: json['voucher_code'],
      initialBalance: Balance.fromJson(json['initial_balance']),
      expiryDate: json['expiry_date'],
      voucherRedeemed: json['voucher_redeemed'],
    );
  }
}

class PrepaidCard {
  final String provisioningToken;
  final Balance initialBalance;
  final bool prepaidCardRedeemed;

  PrepaidCard({
    required this.provisioningToken,
    required this.initialBalance,
    required this.prepaidCardRedeemed,
  });

  factory PrepaidCard.fromJson(Map<String, dynamic> json) {
    return PrepaidCard(
      provisioningToken: json['provisioning_token'],
      initialBalance: Balance.fromJson(json['initial_balance']),
      prepaidCardRedeemed: json['prepaid_card_redeemed'],
    );
  }
}

class Balance {
  final String currency;
  final String amount;

  Balance({
    required this.currency,
    required this.amount,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      currency: json['currency'],
      amount: json['amount'].toString(),
    );
  }
}
