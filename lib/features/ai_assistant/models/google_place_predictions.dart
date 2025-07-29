class PlacePredictions {
  final List<Prediction>? predictions;
  final String? status;

  PlacePredictions({this.predictions, this.status});

  factory PlacePredictions.fromMap(Map<String, dynamic> json) {
    return PlacePredictions(
      predictions: json['predictions'] != null
          ? List<Prediction>.from(
              json['predictions'].map((x) => Prediction.fromMap(x)))
          : null,
      status: json['status'],
    );
  }
}

class Prediction {
  final String? description;
  final String? placeId;
  final List<Term>? terms;

  Prediction({this.description, this.placeId, this.terms});

  factory Prediction.fromMap(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      placeId: json['place_id'],
      terms: json['terms'] != null
          ? List<Term>.from(json['terms'].map((x) => Term.fromMap(x)))
          : null,
    );
  }
}

class Term {
  final int? offset;
  final String? value;

  Term({this.offset, this.value});

  factory Term.fromMap(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }
}
