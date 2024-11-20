// import 'dart:io';

import 'package:customer_selections/Models/customer_profile.dart';
import 'package:customer_selections/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class CustomerProfileForm extends StatefulWidget {
  @override
  State<CustomerProfileForm> createState() => _CustomerProfileFormState();
}

class _CustomerProfileFormState extends State<CustomerProfileForm> {
  final _formKey = GlobalKey<FormState>();
  // final ImagePicker _picker = ImagePicker(); 
  late TextEditingController? _dateController;
  CustomerProfile _tempProfile = CustomerProfile(createDate: DateTime.now());
  XFile? _businessCardImage;

  @override 
  void initState() { 
    super.initState();  // to have context
    final appState = Provider.of<MyAppState>(context, listen: false);
    // Initialize the TextEditingController with initial value if appState.customerProfile.value is not null 
    _dateController = TextEditingController( 
      text: appState.customerProfile.createDate.toString().split(' ')[0], 
    );
  }
  
  Future<void> _selectDate(BuildContext context) async { 
    final DateTime? pickedDate = await showDatePicker( 
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2101), 
    ); 
    
    if (pickedDate != null) { 
      setState(() { 
        _dateController?.text = pickedDate.toString().split(' ')[0]; // Format the date as 'YYYY-MM-DD' 
      }); 
    }
  }

  // Future<void> _pickImage(BuildContext context) async {
    // try { 
  //     final XFile? image = await showDialog<XFile?>( 
  //       context: context, 
  //       builder: (BuildContext context) { 
  //         return AlertDialog( 
  //           title: Text('Choose option'), 
  //           content: Column( 
  //             mainAxisSize: MainAxisSize.min, 
  //             children: [ 
  //               ListTile( 
  //                 leading: Icon(Icons.photo_library), 
  //                 title: Text('Gallery'), 
  //                 onTap: () async { 
  //                   final XFile? img = await _picker.pickImage(source: ImageSource.gallery); 
  //                   Navigator.of(context).pop(img); 
  //                 }, 
  //               ), 
  //               ListTile( 
  //                 leading: Icon(Icons.camera_alt), 
  //                 title: Text('Camera'), 
  //                 onTap: () async { 
  //                   final XFile? img = await _picker.pickImage(source: ImageSource.camera); 
  //                   Navigator.of(context).pop(img); 
  //                 }, 
  //               ), 
  //             ],
  //           ),
  //         ); 
  //       }, 
  //     ); 
      
  //     if (image != null) { 
  //       setState(() { 
  //         _businessCardImage = image; 
  //       }); 
  //     } 
  //   } catch (e) { 
  //     print('Error picking image: $e'); 
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Customer Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // ElevatedButton(
            //   onPressed: () => _pickImage(context), 
            //   child: Text('Upload Business Card'), 
            // ), 
            // if (_businessCardImage != null) 
            //   Image.file(File(_businessCardImage!.path)),
            // SizedBox(height: 20),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date', 
                hintText: 'YYYY-MM-DD'
              ),
              readOnly: true,
              onTap: () {
                // Below line stops keyboard from appearing
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context);
              },
              onSaved: (value) => _tempProfile.createDate = DateTime.parse(value!),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Exhibition'),
              initialValue: appState.customerProfile.exhibition,
              onSaved: (value) => _tempProfile.exhibition = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Salesman'),
              initialValue: appState.customerProfile.salesman,
              onSaved: (value) => _tempProfile.salesman = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Guest'),
              initialValue: appState.customerProfile.guest,
              onSaved: (value) => _tempProfile.guest = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Company'),
              initialValue: appState.customerProfile.company,
              onSaved: (value) => _tempProfile.company = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              initialValue: appState.customerProfile.name,
              onSaved: (value) => _tempProfile.name = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contact'),
              initialValue: appState.customerProfile.contact,
              onSaved: (value) => _tempProfile.contact = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Remarks'),
              initialValue: appState.customerProfile.remarks,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onSaved: (value) => _tempProfile.remarks = value!,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) { 
                  _formKey.currentState?.save(); 
                  _tempProfile.businessCardImagePath = _businessCardImage?.path;
                  appState.updateCustomerProfile(_tempProfile);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved'))); }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
