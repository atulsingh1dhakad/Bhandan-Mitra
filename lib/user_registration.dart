import 'package:bandhanmitra/mainwrapper.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRegistrationScreen extends StatefulWidget {
  final String phoneNumber; // Phone number passed from the OTP screen
  const UserRegistrationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool isChecked = false;
  bool isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _registerUser() async {
    if (fullNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        !isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and agree to the terms.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Check if user is authenticated
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Save user details to Firestore with phone number as the document ID
        await _firestore.collection('users').doc(widget.phoneNumber).set({
          'fullName': fullNameController.text,
          'address': addressController.text,
          'phoneNumber': widget.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );

        // Navigate to the main screen or another screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Mainwrapper()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not signed in. Please log in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "by creating a free account.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                // Full Name Field
                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "Full name",
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Address Field
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "Address",
                    prefixIcon: const Icon(Icons.home, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "By checking the box you agree to our Terms and Conditions.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFC4E37),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // Navigate to login screen
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Already a member? ",
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
