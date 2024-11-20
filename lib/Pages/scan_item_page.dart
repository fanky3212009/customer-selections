import 'package:customer_selections/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class ScanItemPage extends StatefulWidget {
  @override
  State<ScanItemPage> createState() => _ScanItemPageState();
}

class _ScanItemPageState extends State<ScanItemPage> {

  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    if (barcodeScanRes != '-1') { 
      // ignore: use_build_context_synchronously
      Provider.of<MyAppState>(context, listen: false).addItemCode(barcodeScanRes); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Selection List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scan Barcode'),
            ),
          ),
          ...appState.itemCodes.mapIndexed((index, code) => ListTile(
              leading: IconButton(
                icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  appState.removeItem(code);
                },
              ),
              title: Text(
                '${index+1}. $code',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
