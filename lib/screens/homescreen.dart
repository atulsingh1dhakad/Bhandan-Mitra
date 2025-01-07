import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String> _locationFuture;

  @override
  void initState() {
    super.initState();
    _locationFuture = _getLocation();
  }

  // Fetch the location and return the resulting address
  Future<String> _getLocation() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return 'Location services are disabled.';
      }
    }

    // Check for location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return 'Location permissions are denied.';
      }
    }

    // Get the user's current location
    locationData = await location.getLocation();
    try {
      // Use geocoding to get the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return '${placemark.locality ?? placemark.subLocality}, ${placemark.country}';
      } else {
        return 'Unable to determine location.';
      }
    } catch (e) {
      return 'Failed to get location: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        FutureBuilder<String>(
                          future: _locationFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  LinearProgressIndicator(
                                    minHeight: 5, // Smaller loading bar
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 24,
                                    color: Colors.red, // Error icon
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 24,
                                    color: Color(0xFFFC4E37), // Location pin icon
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    snapshot.data ?? 'Unknown location',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const Icon(
                      Icons.notifications_rounded,
                      size: 30,
                      color: Colors.black,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Search Bar Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for partner',
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Near You Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Near You',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add view all functionality
                      },
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Near You Card
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/sample_image.png'), // Replace with actual image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nataliya Grone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'India, Delhi',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Chartered Accountant',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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