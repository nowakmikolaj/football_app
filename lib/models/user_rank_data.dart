import 'package:football_app/models/bet.dart';

class UserRankData implements Comparable<UserRankData> {
  final String userId;
  late int placedBets;
  late int settledBets;
  late int totalPoints;
  late num average;

  UserRankData({
    required this.userId,
    required List<Bet> bets,
  }) {
    placedBets = bets.length;
    settledBets = bets.where((element) => element.points != null).length;
    totalPoints = bets
        .map((e) => e.points ?? 0)
        .reduce((value, element) => value + element);
    average = totalPoints / settledBets;
  }

  @override
  int compareTo(UserRankData other) {
    return average.compareTo(other.average);
  }
}
