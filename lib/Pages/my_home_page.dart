import 'package:customer_selections/Models/customer_profile.dart';
import 'package:customer_selections/Pages/customer_profile_form.dart';
import 'package:customer_selections/Pages/scan_item_page.dart';
import 'package:customer_selections/Services/export_service.dart';
import 'package:customer_selections/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ExportService exportService = ExportService();
  var selectedIndex = 0;

  void _exportAppState(MyAppState appState, BuildContext context) async {
      CustomerProfile customerProfile = appState.customerProfile;
      List<String> itemCodes = appState.itemCodes;
      bool success = await exportService.exportExcelToShare(customerProfile, itemCodes);
      if (!mounted) return; // Check if the widget is still mounted 
      _showSnackBar(context, success);
  }

  void _showSnackBar(BuildContext context, bool success) { 
    final snackBar = SnackBar( 
      content: Text(success ? 'Export to Excel successful!' : 'Export to Excel failed!'), 
      ); 
    ScaffoldMessenger.of(context).showSnackBar(snackBar); 
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CustomerProfileForm();
      case 1:
        page = ScanItemPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }


    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    items: [
                      
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_box),
                        label: 'Profile',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.list),
                        label: 'Selections',
                      )
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                )
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.account_box),
                        label: Text('Profile'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.list),
                        label: Text('Selections'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton( 
        onPressed: () => _exportAppState(appState, context), 
        tooltip: 'Export to Excel', 
        child: Icon(Icons.upload_file), 
      ),
    );
  }
}