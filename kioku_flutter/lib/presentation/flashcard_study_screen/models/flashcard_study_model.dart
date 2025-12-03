class FlashcardStudyModel {
  String? question;
  List<String>? answers;
  String? correctAnswer;

  FlashcardStudyModel({
    this.question,
    this.answers,
    this.correctAnswer,
  });

  FlashcardStudyModel.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answers = json['answers'] != null ? List<String>.from(json['answers']) : [];
    correctAnswer = json['correctAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question'] = question;
    data['answers'] = answers;
    data['correctAnswer'] = correctAnswer;
    return data;
  }
}
