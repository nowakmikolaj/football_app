import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:football_app/api/firestore_service.dart';
import 'package:football_app/models/bet.dart';
import 'package:football_app/screens/fixture_details_screen.dart';
import 'package:football_app/utils/actions.dart';
import 'package:football_app/utils/app_padding.dart';
import 'package:football_app/utils/app_size.dart';
import 'package:football_app/utils/assets.dart';
import 'package:football_app/utils/resources.dart';
import 'package:football_app/widgets/center_indicator.dart';
import 'package:football_app/widgets/custom_appbar.dart';
import 'package:football_app/widgets/lists/empty_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<Bet>> _bets;

  Future<void> _getBets() async {
    _bets = FirestoreService.getBetsByUser();
  }

  @override
  void initState() {
    super.initState();
    _getBets();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: CustomAppBar(
        data: Resources.profileSceenTitle,
        icon: Icons.account_circle_outlined,
        backOnTap: false,
        actions: [
          getActionSignOut(),
        ],
      ),
      body: Center(
        child: FutureBuilder(
            future: _bets,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final bets = snapshot.data ?? [];
                return bets.isNotEmpty
                    ? ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.grey[400],
                            ),
                            padding: const EdgeInsets.only(
                              top: AppPadding.p20,
                              bottom: AppPadding.p20,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey[600]
                                          : Colors.grey[400],
                                  radius: AppSize.s30,
                                  child: const SizedBox(
                                    child: Image(
                                      image: AssetImage(Assets.loginUser),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSize.s15,
                                ),
                                Text(
                                  user.email!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: FontSize.subTitle,
                                    fontWeight: FontWeights.semiBold,
                                  ),
                                ),
                                const SizedBox(height: AppSize.s10),
                                Text(
                                  "Bets placed: ${bets.length}",
                                  style: const TextStyle(
                                      fontSize: FontSize.subTitle),
                                ),
                                Text(
                                  "Total points: ${getPoints(bets)}",
                                  style: const TextStyle(
                                      fontSize: FontSize.subTitle),
                                ),
                              ],
                            ),
                          ),
                          ...List.generate(
                            bets.length,
                            (index) => GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FixtureDetailsScreen(
                                    fixture: bets[index].fixture!,
                                  ),
                                ),
                              ),
                              child: Card(
                                elevation: 3.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.all(5.0),
                                  child: FixtureHeader(
                                    fixture: bets[index].fixture!,
                                    bet: [bets[index]],
                                    isHeader: false,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : const EmptyList(
                        assetImage: Assets.noBets,
                        message: Resources.betsNotFound,
                      );
              } else {
                return const CenterIndicator();
              }
            }),
      ),
    );
  }

  int getPoints(List<Bet> bets) => bets
      .map((e) => e.points ?? 0)
      .reduce((value, element) => value + element);
}
