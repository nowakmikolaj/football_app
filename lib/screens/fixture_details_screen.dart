import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/bet_dialog_content.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_appbar.dart';

class FixtureDetailsScreen extends StatefulWidget {
  const FixtureDetailsScreen({super.key, required this.fixture});

  final Fixture fixture;

  @override
  State<FixtureDetailsScreen> createState() => _FixtureDetailsScreenState();
}

class _FixtureDetailsScreenState extends State<FixtureDetailsScreen> {
  late Future<List<Bet>?> _bet;

  Future<void> _getBet() async {
    _bet = FirestoreService.getBet(widget.fixture.fixtureId);
  }

  @override
  void initState() {
    super.initState();
    _getBet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        data:
            "${widget.fixture.homeTeam.name} vs ${widget.fixture.awayTeam.name}",
        icon: Icons.arrow_back_ios,
        backOnTap: true,
      ),
      body: FutureBuilder(
        future: _bet,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bet = snapshot.data ?? [];
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                FixtureHeader(
                  fixture: widget.fixture,
                  bet: bet,
                ),
              ],
            );
          } else {
            return const CenterIndicator();
          }
        },
      ),
    );
  }
}

class FixtureHeader extends StatefulWidget {
  FixtureHeader({
    super.key,
    required this.fixture,
    required this.bet,
    this.isHeader = true,
  });

  final bool isHeader;
  final Fixture fixture;
  List<Bet> bet;

  @override
  State<FixtureHeader> createState() => _FixtureHeaderState();
}

class _FixtureHeaderState extends State<FixtureHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isHeader
          ? BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey[400],
            )
          : const BoxDecoration(),
      padding: widget.isHeader
          ? const EdgeInsets.only(
              top: AppPadding.p20,
              bottom: AppPadding.p20,
            )
          : const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                fit: BoxFit.cover,
                width: AppSize.s20,
                height: AppSize.s20,
                image: NetworkImage(widget.fixture.league.logo),
              ),
              const SizedBox(
                width: AppSize.s5,
              ),
              Text(
                widget.fixture.league.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(
            height: AppSize.s10,
          ),
          Row(
            children: [
              ...widget.fixture.buildElements(),
            ],
          ),
          widget.bet.isEmpty && widget.fixture.isUpcoming()
              ? Column(
                  children: [
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        var result = await showDialog<Map<String, int>>(
                          context: context,
                          builder: (context) => Center(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                scrollable: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                contentPadding: EdgeInsets.zero,
                                content: Padding(
                                  padding: const EdgeInsets.only(
                                    top: AppSize.s20,
                                  ),
                                  child: BetDialogContent(
                                    bet: Bet(
                                      fixture: widget.fixture,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        if (result != null) {
                          final bet = Bet(
                            fixture: widget.fixture,
                            goals: Score.fromJson(result),
                            userId: FirebaseAuth.instance.currentUser!.email,
                          );

                          bet.placeBet();
                          setState(() {
                            widget.bet = [bet];
                          });
                        }
                      },
                      child: const Text("Place a bet"),
                    ),
                  ],
                )
              : widget.bet.isNotEmpty
                  ? BetInfo(
                      bet: widget.bet.first,
                      fixture: widget.fixture,
                      isHeader: widget.isHeader,
                    )
                  : Container(),
        ],
      ),
    );
  }
}

class BetInfo extends StatelessWidget {
  const BetInfo({
    Key? key,
    required this.bet,
    required this.fixture,
    required this.isHeader,
  }) : super(key: key);

  final Bet bet;
  final Fixture fixture;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSize.s20),
        Container(
          width: AppSize.s150,
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p15,
            vertical: AppPadding.p2,
          ),
          decoration: BoxDecoration(
            color: isHeader
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey
                : Colors.black38,
            borderRadius: BorderRadius.circular(AppSize.s20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your bet:\t ${bet.goals!.home} : ${bet.goals!.away}",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: FontSize.subTitle),
              ),
              fixture.isFinished()
                  ? Text(
                      "Points earned: ${bet.points ?? '?'}",
                      style: const TextStyle(
                        fontSize: FontSize.subTitle,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
