import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _dailyCustomerAverage = 0;
  int _customersVisitedToday = 0;
  String _commonModel = '';

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    // Calculate average daily customers
    QuerySnapshot dailyCustomersSnapshot =
        await FirebaseFirestore.instance.collection('Customer').get();
    int totalCustomers = dailyCustomersSnapshot.docs.length;
    DateTime now = DateTime.now();
    int totalDays = now.day;
    setState(() {
      _dailyCustomerAverage = (totalCustomers / totalDays).round();
    });

    // Calculate number of customers visited today
    QuerySnapshot customersVisitedTodaySnapshot = await FirebaseFirestore.instance
        .collection('Customer')
        .where('insertedon', isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .get();
    setState(() {
      _customersVisitedToday = customersVisitedTodaySnapshot.docs.length;
    });

    // Find commonly used model
    QuerySnapshot modelsSnapshot = await FirebaseFirestore.instance.collection('Customer').get();
    Map<String, int> modelCount = {};
    modelsSnapshot.docs.forEach((doc) {
      String? model = (doc.data() as Map<String, dynamic>?)?['frame_model']; // Nullable access with null-aware operator

      if (model != null) {
        modelCount[model] = (modelCount[model] ?? 0) + 1;
      }
    });
    MapEntry<String, int>? mostCommonModel = modelCount.entries.reduceOrNull((a, b) => a.value > b.value ? a : b);
    if (mostCommonModel != null) {
      setState(() {
        _commonModel = mostCommonModel.key;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Daily Customers: $_dailyCustomerAverage',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Customers Visited Today: $_customersVisitedToday',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Commonly Used Model: $_commonModel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? reduceOrNull(T Function(T, T) combine) {
    if (isEmpty) return null;
    return reduce(combine);
  }
}
