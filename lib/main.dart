// import 'dart:math';
import 'package:collection/collection.dart';
import 'package:customer_selections/Models/customer_profile.dart';
import 'package:customer_selections/Pages/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Customer Selection',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  CustomerProfile _customerProfile = CustomerProfile(createDate: DateTime.now());
  List<String> _itemCodes = [];
  
  CustomerProfile get customerProfile => _customerProfile; 
  List<String> get itemCodes => _itemCodes;


  void updateCustomerProfile(CustomerProfile profile) {
    // if (_customerProfile.id == 0) {
    //   profile.id = Random().nextInt(100);
    // }
    _customerProfile = profile;
    print('_customerProfile createdDate: ${_customerProfile.createDate.toIso8601String()}'); 
    notifyListeners();
  }

  void addItemCode(String code) {
    itemCodes.add(code);
    notifyListeners();
  }

  void removeItem(String item) {
    itemCodes.remove(item);
    notifyListeners();
  }

  void clearItemCodes() { 
    _itemCodes.clear(); 
    notifyListeners(); 
  }
}

class SelectionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.itemCodes.isEmpty) {
      return Center(
        child: Text('No selections yet.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text('You have '
              '${appState.itemCodes.length} selections:'),
        ),
        Expanded(
          // Make better use of wide windows with a grid.
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400,
              childAspectRatio: 400 / 80,
            ),
            children: [
              ...appState.itemCodes.mapIndexed((index, item) => 
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      appState.removeItem(item);
                    },
                  ),
                  title: Text(
                    '$index. $item',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

