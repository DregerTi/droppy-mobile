import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  const Tabs({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<Tab> tabs;

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: widget.tabs,
    );
  }
}
