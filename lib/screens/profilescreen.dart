import 'package:bandhanmitra/screens/loginscreen.dart';
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
        String phoneNumber = currentUser.phoneNumber ?? '';

        if (phoneNumber.isNotEmpty) {
          if (phoneNumber.startsWith('+91')) {
            phoneNumber = phoneNumber.substring(3);
          }

          DocumentSnapshot userDoc = await _firestore.collection('users').doc(phoneNumber).get();

          if (userDoc.exists) {
            setState(() {
              fullName = userDoc['fullName'] ?? 'Not available';
              this.phoneNumber = userDoc['phoneNumber'] ?? 'Not available';
              address = userDoc['address'] ?? 'Not available';
            });
          } else {
            _showErrorDialog("No user data found for this phone number.");
          }
        } else {
          _showErrorDialog("Phone number is not available.");
        }
      } else {
        _showErrorDialog("User is not logged in.");
      }
    } catch (e) {
      _showErrorDialog("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.of(context).pushReplacementNamed(PhoneLoginScreen() as String); // Navigates to login screen
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
