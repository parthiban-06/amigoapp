class PlacePredictions {
  final List<Prediction> predictions;
  final String status;

  PlacePredictions({required this.predictions, required this.status});

  factory PlacePredictions.fromJson(Map<String,dynamic> json) =>
      PlacePredictions.fromMap(json);

  factory PlacePredictions.fromMap(Map<String, dynamic> json) =>
      PlacePredictions(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromMap(x))),
        status: json["status"],
      );
}

class Prediction {
  final String description;
  final List<MatchedSubstring> matchedSubstrings;
  final String placeId;
  final String reference;
  final StructuredFormatting structuredFormatting;
  final List<Term> terms;
  final List<String> types;

  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  factory Prediction.fromMap(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        matchedSubstrings: List<MatchedSubstring>.from(
            json["matched_substrings"].map((x) => MatchedSubstring.fromMap(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting:
            StructuredFormatting.fromMap(json["structured_formatting"]),
        terms: List<Term>.from(json["terms"].map((x) => Term.fromMap(x))),
        types: List<String>.from(json["types"].map((x) => x)),
      );
}

class MatchedSubstring {
  final int length;
  final int offset;

  MatchedSubstring({required this.length, required this.offset});

  factory MatchedSubstring.fromMap(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
      );
}

class StructuredFormatting {
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromMap(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: List<MatchedSubstring>.from(
            json["main_text_matched_substrings"]
                .map((x) => MatchedSubstring.fromMap(x))),
        secondaryText: json["secondary_text"],
      );
}

class Term {
  final int offset;
  final String value;

  Term({required this.offset, required this.value});

  factory Term.fromMap(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
      );
}
