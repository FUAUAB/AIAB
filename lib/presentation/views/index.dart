import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/responsive/responsive.dart';
import 'package:work_order_app/presentation/tabs/word_order_monthly_tab.dart';
import 'package:work_order_app/presentation/tabs/work_order_daily_tab.dart';
import 'package:work_order_app/presentation/tabs/work_order_weekly_tab.dart';

import '../../app_localizations.dart';
import '../styles/colors_style.dart';
import '../widgets/menus/navigation_drawer.dart';

class IndexPage extends StatefulWidget {
  @override
  _PlanningPageState createState() => _PlanningPageState();
}

class _PlanningPageState extends State<IndexPage> {
  late SharedPreferences sharedPreferences;
  DateTime timeBackPressed = DateTime.now();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('message.before.close.app.from.return.button')),
            ),
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate('planning.title'),
          ),
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: CustomColors.evenRow,
                child: TabBar(
                  isScrollable: Responsive.isMobile(context) ? true : false,
                  labelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18,
                  ),
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('planning.tab.today.title'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('planning.tab.week.title'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          'planning.tab.month.title',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    WorkOrdersDailyTab(),
                    WorkOrdersWeeklyTab(),
                    WorkOrdersMonthlyTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: NavigationDrawerWidget(),
      ),
    );
  }
}
