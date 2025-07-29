class RateUsRequest {
  final int rating;
  
  final String feedback;

  RateUsRequest({
    required this.rating,
   
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
    
      'feedback': feedback,
    };
  }

  factory RateUsRequest.fromJson(Map<String, dynamic> json) {
    return RateUsRequest(
      rating: json['rating'] ?? 0,
     
      feedback: json['feedback'] ?? '',
    );
  }
}
