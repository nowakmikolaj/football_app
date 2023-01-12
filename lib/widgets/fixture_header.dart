// ignore: must_be_immutable
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/models/fixture.dart';
import 'package:football_app/models/score.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/widgets/bet_dialog_content.dart';
import 'package:football_app/widgets/bet_info.dart';

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
          widget.bet.isEmpty && widget.fixture.canPlaceBet()
              ? getBetButton()
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

  Column getBetButton() {
    return Column(
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
          onPressed: showBetDialog,
          child: const Text("Place a bet"),
        ),
      ],
    );
  }

  void showBetDialog() async {
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
  }
}
