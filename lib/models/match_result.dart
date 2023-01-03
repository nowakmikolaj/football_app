import 'package:football_app/models/score.dart';

class MatchResult {
  Score? halfTime;
  Score? fullTime;
  Score? extraTime;
  Score? penalty;

  MatchResult({
    this.halfTime,
    this.fullTime,
    this.extraTime,
    this.penalty,
  });
}
