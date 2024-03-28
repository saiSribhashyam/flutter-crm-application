import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dbservice.dart';
import 'customerList.dart';
import 'package:flutter_sms/flutter_sms.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomerForm(),
      ),
    );
  }
}

class CustomerForm extends StatefulWidget {
  const CustomerForm({Key? key}) : super(key: key);

  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _phone;
  late String _city;
  late double _leftEyePower;
  late double _rightEyePower;
  late String _frameModel;
  String _description = '';
  bool _sendThankYou = false; // New boolean variable for the checkbox state

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Instantiate the DatabaseService
      DatabaseService _databaseService = DatabaseService();
      // Call the addCustomer method from the DatabaseService
      String? result = await _databaseService.addCustomer(
        name: _name,
        mobile: _phone,
        city: _city,
        email: FirebaseAuth.instance.currentUser!.email!,
        left: _leftEyePower.toString(),
        right: _rightEyePower.toString(),
        frame: _frameModel,
        description: _description,
      );
      if (result == 'success') {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Customer added successfully.'),
            duration: Duration(seconds: 3),
          ),
        );
        // Reset the form after successful submission
        _formKey.currentState!.reset();
        if (_sendThankYou) {
          // Send the thank you message if checkbox is checked
          _sendThankYouMessage();
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $result'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Function to send thank you message
  Future<void> _sendThankYouMessage() async {
    // Implement your logic to send the thank you message here
    String message = "This is a test message!";
List<String> recipents = [_phone];

 String _result = await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
print(_result);

   
  }

  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onSaved: (value) {
              _name = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a phone number';
              }
              return null;
            },
            onSaved: (value) {
              _phone = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'City'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a city';
              }
              return null;
            },
            onSaved: (value) {
              _city = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Left Eye Power'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter left eye power';
              }
              return null;
            },
            onSaved: (value) {
              _leftEyePower = double.parse(value!);
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Right Eye Power'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter right eye power';
              }
              return null;
            },
            onSaved: (value) {
              _rightEyePower = double.parse(value!);
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Frame Model'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter frame model';
              }
              return null;
            },
            onSaved: (value) {
              _frameModel = value!;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
            onSaved: (value) {
              _description = value ?? '';
            },
          ),
          CheckboxListTile(
            title: Text('Send Thank You Message'),
            value: _sendThankYou,
            onChanged: (value) {
              setState(() {
                _sendThankYou = value!;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList()));
            },
            child: Text('Show Records'),
          ),
        ],
      ),
    );
  }
}
