class TimeZoneInfo {
  int? dstOffset;
  int? rawOffset;
  String? status;
  String? timeZoneId;
  String? timeZoneName;

  TimeZoneInfo({
    this.dstOffset,
    this.rawOffset,
    this.status,
    this.timeZoneId,
    this.timeZoneName,
  });

  factory TimeZoneInfo.fromJson(Map<String, dynamic> json) {
    return TimeZoneInfo(
      dstOffset: json['dstOffset'] as int?,
      rawOffset: json['rawOffset'] as int?,
      status: json['status'] as String?,
      timeZoneId: json['timeZoneId'] as String?,
      timeZoneName: json['timeZoneName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dstOffset': dstOffset,
      'rawOffset': rawOffset,
      'status': status,
      'timeZoneId': timeZoneId,
      'timeZoneName': timeZoneName,
    };
  }
}
