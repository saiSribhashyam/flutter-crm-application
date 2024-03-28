import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String _searchQuery = '';
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    // Get the email of the currently logged-in user
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by mobile number',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: CustomerListView(
              searchQuery: _searchQuery,
              userEmail: _userEmail,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomerListView extends StatelessWidget {
  final String searchQuery;
  final String userEmail;

  CustomerListView({
    required this.searchQuery,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Customer')
          .where('email', isEqualTo: userEmail) // Filter by user's email
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final customers = snapshot.data!.docs.where((customer) {
            // Filter customers based on search query
            final customerData =
                customer.data() as Map<String, dynamic>;
            final mobile = customerData['mobile'].toString();
            return mobile.contains(searchQuery);
          }).toList();
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer =
                  customers[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    customer['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Frame Model : ${customer['frame_model']}',
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Left Eye: ${customer['left_eye_power']}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Right Eye: ${customer['right_eye_power']}',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          // Handle call action
                          _launchUrl('tel:+91${customer['mobile']}');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          // Handle message action
                          _launchUrl('sms:+91${customer['mobile']}');
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<void> _launchUrl(String s) async {
  if (!await canLaunch(s)) {
    print(s);
    throw Exception('Could not find mobile number');
  } else {
    await launch(s);
  }
}
