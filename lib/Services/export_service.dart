import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

import 'package:customer_selections/Models/customer_profile.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {

  Future<bool> exportExcelToLocal(CustomerProfile profile, List<String> itemCodes) async {
    try {
      Excel excel = generateExcelFile(itemCodes, profile);
      
      // Call function save() to download the file
      if (kIsWeb) {
        // Running on the web
        excel.save(fileName: 'customer_selection_${profile.company}_${profile.name}.xlsx');
        print('Exported data to Excel on desktop');
      } else {
        // Running on Android/iOS
        // Get the Downloads directory 
        Directory? downloadsDir;
        if (Platform.isAndroid) { 
          downloadsDir = await getExternalStorageDirectory(); 
        } else if (Platform.isIOS) {
          downloadsDir = await getApplicationDocumentsDirectory(); 
        } 
        
        if (downloadsDir == null) {
          print('Error accessing Downloads directory'); 
          return false; 
        }
        var fileBytes = excel.save();
        String outputPath = '${downloadsDir.path}/customer_selection_${profile.company}_${profile.name}.xlsx';
        File(outputPath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        print('Exported data to Excel at $outputPath');
      }
      return true;
    } catch (e) {
      print('Error exporting excel: $e'); 
      return false;
    }
  }

  Future<bool> exportExcelToShare(CustomerProfile profile, List<String> itemCodes) async {
    try {
      Excel excel = generateExcelFile(itemCodes, profile);
      String outputPath;
      // Encode the Excel file in memory 
      var fileBytes = excel.encode(); 
      
      // Call function save() to download the file
      if (kIsWeb) {
        // Running on the web
        outputPath = 'customer_selection_${profile.company}_${profile.name}.xlsx';
        print('Export data to Excel on desktop');
      } else {
        // Running on Android/iOS
        // Get the temporary directory 
        Directory tempDir = await getTemporaryDirectory(); 
        outputPath = '${tempDir.path}/customer_selection_${profile.company}_${profile.name}.xlsx';
        
      }
      // Save the file to the temporary directory 
      File tempFile = File(outputPath); 
      tempFile.writeAsBytesSync(fileBytes!);
      // Share the file 
      final result = await Share.shareXFiles([XFile(tempFile.path)], subject: 'customer_selection_${profile.company}_${profile.name}');
      if (result.status == ShareResultStatus.success) {
        print('Share excel file success');
      }
      return true;
    } catch (e) {
      print('Error exporting and sharing excel: $e'); 
      return false;
    }
  }

  Excel generateExcelFile(List<String> itemCodes, CustomerProfile profile) {
    var excel = Excel.createExcel();
    
    // Create Selection List sheet
    Sheet selectionSheet = excel['Selection List'];
    List<String> selectionHeaders = ['Customer Code', 'Customer', 'Contact Person', 'Item Code'];
    selectionSheet.appendRow(selectionHeaders);
    
    for (var itemCode in itemCodes) {
      List<String> selectionData = ['', profile.company, profile.name, itemCode];
      selectionSheet.appendRow(selectionData);
    }
    
    // Create Customer Comments sheet
    Sheet commentsSheet = excel['Customer Comments'];
    List<String> commentsHeaders = ['Customer Code', 'Customer', 'Contact Person', 'Contact', 'Comments'];
    commentsSheet.appendRow(commentsHeaders);
    
    
      List<String> commentsData = [
        '', profile.company, profile.name, profile.contact, profile.remarks
      ];
      commentsSheet.appendRow(commentsData);
    return excel;
  }

  // Save business card image to worksheet 
}
