import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fullName = '';
  String phoneNumber = '';
  String address = '';
  bool isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String phone = currentUser.phoneNumber ?? '';
        print("Current user's phone number: $phone");

        // Attempt to fetch user data by phone number
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(phone).get();

        if (userDoc.exists) {
          setState(() {
            fullName = userDoc['fullName'] ?? 'Not available';
            phoneNumber = userDoc['phoneNumber'] ?? 'Not available';
            address = userDoc['address'] ?? 'Not available';
          });
        } else {
          // Fallback query if doc(phone) doesn't work
          QuerySnapshot querySnapshot = await _firestore
              .collection('users')
              .where('phoneNumber', isEqualTo: phone)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            var userDoc = querySnapshot.docs.first;
            setState(() {
              fullName = userDoc['fullName'] ?? 'Not available';
              phoneNumber = userDoc['phoneNumber'] ?? 'Not available';
              address = userDoc['address'] ?? 'Not available';
            });
          } else {
            print("No matching user found in Firestore.");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User data not found.')),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login'); // Adjust route as needed
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 20),
            Image.asset('assets/images/ganeshji.png', width: 275),
            const SizedBox(height: 30),
            _buildInfoTile(Icons.person, fullName),
            const SizedBox(height: 10),
            _buildInfoTile(Icons.phone, phoneNumber),
            const SizedBox(height: 10),
            _buildInfoTile(Icons.pin_drop_outlined, address),
            const SizedBox(height: 50),
            Image.asset('assets/images/logo2.png', width: 275),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String value) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.21),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          value,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
