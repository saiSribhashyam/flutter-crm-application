import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BroadcastScreen extends StatefulWidget {
  @override
  _BroadcastScreenState createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  String _message = '';
  List<QueryDocumentSnapshot<Object?>> _customers = [];
  List<bool> _selectedCustomers = [];
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String loggedInUserEmail = user.email ?? '';
      QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
          .collection('Customer')
          .where('email', isEqualTo: loggedInUserEmail)
          .get();
      setState(() {
        _customers = querySnapshot.docs;
        _selectedCustomers = List.generate(_customers.length, (index) => false);
      });
    }
  }

  Future<void> _sendBroadcast() async {
    List<String> selectedMobiles = [];
    List<String> selectedNames = [];
    for (int i = 0; i < _customers.length; i++) {
      if (_selectedCustomers[i]) {
        String mobile = _customers[i]['mobile'];
        selectedMobiles.add(mobile);
        String name = _customers[i]['name'];
        selectedNames.add(name);
      }
    }

    String message = _message;

    if (selectedMobiles.isNotEmpty && message.isNotEmpty) {
      String result = await sendSMS(
        message: message,
        recipients: selectedMobiles,
        sendDirect: true,
      );
      print('Broadcast message sent: $result');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select customers and enter a message.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      _selectedCustomers = List.generate(
        _customers.length,
        (index) => _selectAll,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Broadcast Message'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your message',
              ),
              onChanged: (value) {
                setState(() {
                  _message = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: List.generate(
                _customers.length,
                (index) {
                  if (_selectedCustomers[index]) {
                    return Chip(
                      label: Text(_customers[index]['name']),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _selectedCustomers[index] = false;
                        });
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleSelectAll,
                child: Text(_selectAll ? 'Deselect All' : 'Select All'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_customers[index]['name']),
                  subtitle: Text(_customers[index]['mobile']),
                  trailing: Checkbox(
                    value: _selectedCustomers[index],
                    onChanged: (value) {
                      setState(() {
                        _selectedCustomers[index] = value!;
                        _selectAll = false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _sendBroadcast,
            child: Text('Send Broadcast'),
          ),
        ],
      ),
    );
  }
}