import 'package:flutter/material.dart';

class MyBets extends StatefulWidget {
  @override
  _MyBetsState createState() => _MyBetsState();
}

class _MyBetsState extends State<MyBets>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              title: Text("My Bets"),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(
                    kToolbarHeight + kToolbarHeight + kToolbarHeight + 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.168,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 12.0,
                                  top: 6.0,
                                  bottom: 12.0,
                                  right: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.arrow_drop_up,
                                            size: 36.0,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "Earned",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                              color: Color(0xFFF909090),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        "रू 2000",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 12.0,
                                  top: 6.0,
                                  bottom: 12.0,
                                  left: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: Card(
                                elevation: 2.0,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.arrow_drop_down,
                                            size: 36.0,
                                            color: Colors.red[600],
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "Loosed",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                              color: Color(0xFFF909090),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 6.0,
                                      ),
                                      Text(
                                        "रू 2000",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              "Past Matches",
                              style: TextStyle(
                                fontSize: 16.0,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "Running",
                              style: TextStyle(
                                fontSize: 16.0,
                                letterSpacing: .2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            ListView.builder(
              itemCount: 20,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://static.wikia.nocookie.net/logopedia/images/e/eb/Mumbai_Indians_logo.svg/revision/latest/scale-to-width-down/200?cb=20140518170822'),
                  ),
                  title: Center(child: Text('MI vs CSK'),),
                  subtitle: Center(child: Text('Mi Won The Match')),
                  trailing: CircleAvatar(
                    backgroundImage: NetworkImage('https://www.chennaisuperkings.com/CSK_NEW/images/logo.png'),
                  ),
                );
              },
            ),
            ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://static.wikia.nocookie.net/logopedia/images/e/eb/Mumbai_Indians_logo.svg/revision/latest/scale-to-width-down/200?cb=20140518170822'),
                  ),
                  title: Center(child: Text('MI vs CSK'),),
                  subtitle: Center(child: Text('Bet Now!')),
                  trailing: CircleAvatar(
                    backgroundImage: NetworkImage('https://www.chennaisuperkings.com/CSK_NEW/images/logo.png'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
