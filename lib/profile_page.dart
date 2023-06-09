import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    const url = 'https://dummyjson.com/users';
    final response = await http.get(Uri.parse(url));
    final body = response.body;
    final json = jsonDecode(body);
    final users = json['users'];
    final firstUser = users.isNotEmpty ? users[0] : null;
    setState(() {
      userData = firstUser ?? {};
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = userData['username'] ?? 'username';
    final firstName = userData['firstName'] ?? 'Name';
    final lastName = userData['lastName'] ?? 'Surname';
    final age = userData['age'] ?? 'age';
    final email = userData['email'] ?? 'your@email.com';
    final image = userData['image'] ?? '';
    final gender = userData['gender'] ?? 'gender';
    final address = userData['address'] ?? {};
    final addressLine = address['address'] ?? 'address';
    final city = address['city'] ?? 'City';
    const linePadding = 10;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
            Align(
              alignment: Alignment.topCenter,
              child: _buildProfileImage(image, firstName, lastName, username),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text('About you',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(linePadding.toDouble()),
                        child: Text(
                          '$age yo $gender',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(linePadding.toDouble()),
                        child: Text(
                          'email me: $email',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(linePadding.toDouble()),
                        child: Text(
                          '$addressLine',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(linePadding.toDouble()),
                        child: Text(
                          '$city',
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(
      String imageUrl, String firstName, String lastName, String username) {
    return Column(
      children: [
        Container(
          width: 120.0,
          height: 120.0,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 2),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  const CircularProgressIndicator(),
            ),
          ),
        ),
        Text('$firstName $lastName',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        Text('@$username',
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            )),
      ],
    );
  }
}