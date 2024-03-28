import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> addUser({
    required String name,
    required String businessName,
    required String email,
    required String phno,
  }) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(email).set({
        'bname': businessName,
        'email': email,
        'name': name,
        'phno': phno,
      });
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> addCustomer({
    required String name,
    required String mobile,
    required String city,
    required String email,
    required String left,
    required String right,
    required String frame,
    required String description,
  }) async {
    try {
      CollectionReference customers = FirebaseFirestore.instance.collection('Customer');
      QuerySnapshot querySnapshot = await customers.where('mobile', isEqualTo: mobile).get();
      
      if (querySnapshot.docs.isNotEmpty) {
        await customers.doc(querySnapshot.docs[0].id).update({
          'name': name,
          'mobile': mobile,
          'city': city,
          'email': email,
          'left_eye_power': left,
          'right_eye_power': right,
          'frame_model': frame,
          'description': description,
          'insertedon': DateTime.now(),
        });
        return 'updated';
      } else {
        await customers.add({
          'name': name,
          'mobile': mobile,
          'city': city,
          'email': email,
          'left_eye_power': left,
          'right_eye_power': right,
          'frame_model': frame,
          'description': description,
          'insertedon': DateTime.now(),
        });
        return 'success';
      }
    } catch (e) {
      return e.toString();
    }
  }
}
