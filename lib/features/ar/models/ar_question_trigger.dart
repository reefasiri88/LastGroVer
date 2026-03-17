class ArQuestionTrigger {
  ArQuestionTrigger({
    required this.id,
    required this.stop,
    this.isTriggered = false,
    this.isAnswered = false,
  });

  final String id;
  final double stop;
  bool isTriggered;
  bool isAnswered;
}