import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueueTest extends StatefulWidget {
  const QueueTest({Key? key}) : super(key: key);

  @override
  State<QueueTest> createState() => _QueueState();
}

class _QueueState extends State<QueueTest> {
  final _formKey = GlobalKey<FormState>();
  int? _guestCount;
  bool _isLoading = false; // Loading state
  int _currentQueueNumber = 0; // Current queue number

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentQueueNumber();
  }

  void _getCurrentQueueNumber() async {
    try {
      QuerySnapshot queueSnapshot = await _firestore.collection('Queue').get();
      int currentQueueCount = queueSnapshot.docs.length;
      setState(() {
        _currentQueueNumber = currentQueueCount + 1;
      });
    } catch (e) {
      print('Error fetching current queue number: $e');
    }
  }

  void _showConfirmationDialog(
      String action, VoidCallback onConfirm, String restaurantImageUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.network(
                      restaurantImageUrl,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Text('Are you sure you want to $action the reservation?'),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      Navigator.of(context).pop();
                      onConfirm();
                      await _addToQueue();
                      setState(() {
                        _isLoading = false;
                      });
                    },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addToQueue() async {
    try {
      var now = DateTime.now();

      final user = FirebaseAuth.instance.currentUser!;
      final userDataSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(user.uid)
          .get();

      if (!userDataSnapshot.exists) {
        throw Exception("User data not found");
      }

      final userData = userDataSnapshot.data()!;
      final queueSnapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .get();

      if (queueSnapshot.docs.isEmpty) {
        await _firestore
            .collection('Queue')
            .doc("Restaurants01")
            .collection("Current_Queue")
            .add({
          'guestCount': _guestCount,
          'timestamp': now,
          'userId': user.uid,
          'username': userData['username'],
          'queueNumber': _currentQueueNumber,
        });
        await _firestore
            .collection('user')
            .doc(user.uid)
            .collection('current queue')
            .add({
          'guestCount': _guestCount,
          'timestamp': now,
          'userId': user.uid,
          'username': userData['username'],
          'queueNumber': _currentQueueNumber,
        });

        // Show SnackBar
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ScaffoldMessenger.of(context).mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reservation added to queue')),
            );
          }
        });

        // Close dialog and pop the current screen
        Navigator.pop(context);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (ScaffoldMessenger.of(context).mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("คุณมีคิวของคุณอยู่เเล้ว")),
            );
          }
        });
      }
    } catch (e) {
      // Show SnackBar for failure
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ScaffoldMessenger.of(context).mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add reservation')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Replace this with your restaurant avatar image URL
    String restaurantImageUrl =
        'https://image.posttoday.com/media/content/2018/08/03/989D15137C1C478393F3625E158EFEAF.jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Queue Reservation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20.0),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(restaurantImageUrl),
              ),
              const SizedBox(height: 25),
              Text(
                'คิวของคุณคือ: $_currentQueueNumber',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Guest Count',
                        border: OutlineInputBorder(),
                      ),
                      value: _guestCount,
                      onChanged: (value) {
                        setState(() {
                          _guestCount = value;
                        });
                      },
                      items: List.generate(10, (index) {
                        int guests = index + 1;
                        return DropdownMenuItem<int>(
                          value: guests,
                          child: Text('$guests Guests'),
                        );
                      }),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select the number of guests';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _showConfirmationDialog(
                                  'reserve', () {}, restaurantImageUrl);
                            }
                          },
                          child: const Text('จองคิว'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
