import 'package:flutter/material.dart';

class FixtureScreen extends StatelessWidget {
  const FixtureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          leading: const Icon(Icons.calendar_month),
          title: const Text(
            'Fixtures',
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.3),
            tabs: const <BarTab>[
              BarTab(date: "27.10"),
              BarTab(date: "28.10"),
              BarTab(date: "29.10"),
              BarTab(date: "today"),
              BarTab(date: "31.10"),
              BarTab(date: "01.11"),
              BarTab(date: "02.11"),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: 1500,
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 13, right: 13, bottom: 13, top: 25),
                  child: Column(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BarTab extends StatelessWidget {
  const BarTab({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(date),
    );
  }
}
