import 'package:crmapp/customerList.dart';
import 'package:flutter/material.dart';
import 'addcustomer.dart';
import 'broadcast.dart';
import 'stats.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Disable back button
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to ShopMitra', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: [
            _buildTile(
              title: 'Add Customer',
              onPressed: () {
                // Handle add customer action
                Navigator.push(context,MaterialPageRoute(builder: (context) =>AddCustomer()));
              },
              icon: Icons.person_add,
            ),
            _buildTile(
              title: 'View All Customers',
              onPressed: () {
                // Handle view all customers action
                Navigator.push(context,MaterialPageRoute(builder: (context) =>CustomerList()));
              },
              icon: Icons.view_list,
            ),
            _buildTile(
              title: 'New Message to All Customers',
              onPressed: () {
                // Handle new message to all customers action
                Navigator.push(context,MaterialPageRoute(builder:(context) => BroadcastScreen()));
              },
              icon: Icons.message,
            ),
            _buildTile(
              title: 'My Shop Rating and Busy Status',
              onPressed: () {
                // Handle my shop rating and busy status action
                Navigator.push(context,MaterialPageRoute(builder:(context) => StatsScreen()));
              },
              icon: Icons.shop,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({required String title, required VoidCallback onPressed, required IconData icon}) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 60.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
