class Answer {
  final String questionTitle;
  final String answerTitle;

  Answer({
    required this.questionTitle,
    required this.answerTitle,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionTitle: json['questionTitle'],
      answerTitle: json['answerTitle'],
    );
  }
}

class DetailApplication {
  final String username;
  final String userSurname;
  final int applicationId;
  final DateTime applicationDate;
  final String categoryTitle;
  final String categoryDescription;
  final List<Answer> answers;

  DetailApplication({
    required this.username,
    required this.userSurname,
    required this.applicationId,
    required this.applicationDate,
    required this.categoryTitle,
    required this.categoryDescription,
    required this.answers,
  });

  factory DetailApplication.fromJson(Map<String, dynamic> json) {
    var answersFromJson = json['answers'] as List;
    List<Answer> answersList =
        answersFromJson.map((answer) => Answer.fromJson(answer)).toList();

    return DetailApplication(
      username: json['username'],
      userSurname: json['userSurname'],
      applicationId: json['applicationId'],
      applicationDate: DateTime.parse(json['applicationDate']),
      categoryTitle: json['categoryTitle'],
      categoryDescription: json['categoryDescription'],
      answers: answersList,
    );
  }
}
