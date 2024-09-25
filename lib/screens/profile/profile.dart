import 'package:chat/screens/profile/EditOrofileScreen.dart';
import 'package:chat/screens/profile/list_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<DocumentSnapshot>? _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<DocumentSnapshot> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    }
    throw Exception('User not logged in');
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.lato(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Text("Error loading data");
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      const SizedBox(height: 45),
                      
                      SizedBox(
                        width: 130,
                        height: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: userData["image_url"] != null
                              ? Image.network(userData["image_url"])
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        userData['username'] ?? "Loading...",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        userData['email'] ?? "Loading...",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      _userDataFuture = _fetchUserData();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  "Edit Profile",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              ListTitle(
                endIcon: true,
                ontap: () {},
                leadingIcon: LineAwesomeIcons.cog_solid,
                leadingIconColor: Colors.blueAccent,
                trailingIcon: LineAwesomeIcons.angle_right_solid,
                trailingIconColor: Colors.grey,
                title: "Setting",
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 10),
              ListTitle(
                endIcon: true,
                ontap: () {},
                leadingIcon: LineAwesomeIcons.wallet_solid,
                leadingIconColor: Colors.blueAccent,
                trailingIcon: LineAwesomeIcons.angle_right_solid,
                trailingIconColor: Colors.grey,
                title: "Billing Details",
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 10),
              ListTitle(
                endIcon: true,
                ontap: () {},
                leadingIcon: LineAwesomeIcons.user_check_solid,
                leadingIconColor: Colors.blueAccent,
                trailingIcon: LineAwesomeIcons.angle_right_solid,
                trailingIconColor: Colors.grey,
                title: "User Management",
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 10),
              ListTitle(
                endIcon: true,
                ontap: () {},
                leadingIcon: LineAwesomeIcons.info_solid,
                leadingIconColor: Colors.blueAccent,
                trailingIcon: LineAwesomeIcons.angle_right_solid,
                trailingIconColor: Colors.grey,
                title: "Information",
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
              ),
              const SizedBox(height: 10),
              const Divider(),
              ListTitle(
                endIcon: false,
                ontap: () {
                  _showLogoutDialog();
                },
                leadingIcon: LineAwesomeIcons.info_solid,
                leadingIconColor: Colors.blueAccent,
                trailingIcon: LineAwesomeIcons.angle_right_solid,
                trailingIconColor: Colors.grey,
                title: "Logout",
                backgroundColor: Colors.blueAccent.withOpacity(0.1),
                titleStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
