import 'package:flutter/material.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/validation.dart';
import 'package:football_app/widgets/team_info.dart';

class BetDialogContent extends StatefulWidget {
  const BetDialogContent({
    super.key,
    required this.bet,
  });

  final Bet bet;

  @override
  State<BetDialogContent> createState() => _BetDialogContentState();
}

class _BetDialogContentState extends State<BetDialogContent> {
  final formKey = GlobalKey<FormState>();
  final homeTeamController = TextEditingController();
  final awayTeamController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TeamInfo(
                  team: widget.bet.fixture!.homeTeam,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BetTextField(controller: homeTeamController),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              ":",
                              style: TextStyle(fontSize: FontSize.title),
                            ),
                          ),
                          BetTextField(controller: awayTeamController)
                        ],
                      ),
                    ],
                  ),
                ),
                TeamInfo(
                  team: widget.bet.fixture!.awayTeam,
                ),
              ],
            ),
            const SizedBox(
              height: AppSize.s50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSize.s20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  getButton(
                    context,
                    () => Navigator.pop(context),
                    "Cancel",
                  ),
                  const SizedBox(width: AppSize.s5),
                  getButton(
                    context,
                    () {
                      final isValid = formKey.currentState!.validate();
                      if (!isValid) return;
                      Navigator.pop(
                        context,
                        {
                          "home": int.parse(homeTeamController.text),
                          "away": int.parse(awayTeamController.text),
                        },
                      );
                    },
                    "Confirm",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton getButton(
    BuildContext context,
    Function()? onPressed,
    String text,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class BetTextField extends StatelessWidget {
  const BetTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.s40,
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: TextInputType.number,
        validator: Validation.validateBet,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(AppSize.s10),
          ),
        ),
      ),
    );
  }
}
