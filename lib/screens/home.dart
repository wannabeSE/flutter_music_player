import 'package:flutter/material.dart';
import 'package:flutter_music_player/common/ui_color.dart';


class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      selectedTab = _tabController?.index ?? 0;
      setState(() {});
    });
  }
  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: TColor.gradientBg,
        child: TabBarView(
          controller: _tabController,
          children: [
            Container(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          tabs: [
          ],
        )
      ),
    );
  }
}
