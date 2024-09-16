  // import 'package:cloud_firestore/cloud_firestore.dart';
  // import 'package:flutter/material.dart';
  // import 'package:shout_out_app/services/firestore.dart';

  // class Home extends StatefulWidget {
  //   const Home({super.key});

  //   @override
  //   _HomeState createState() => _HomeState();
  // }

  // class _HomeState extends State<Home> {
  //   final GetUserService getUserService = GetUserService();

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       body: SingleChildScrollView(
  //         child: ConstrainedBox(
  //           constraints: BoxConstraints(
  //             minHeight: MediaQuery.of(context).size.height,
  //           ),
  //           child: StreamBuilder<QuerySnapshot>(
  //             stream: getUserService.getUsersStream(),
  //             builder: (context, snapshot) {
  //               if (snapshot.hasError) {
  //                 print("StreamBuilder error: ${snapshot.error}");
  //                 return Center(child: Text('Error: ${snapshot.error}'));
  //               }

  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return const Center(child: CircularProgressIndicator());
  //               }

  //               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  //                 return const Center(child: Text('No users found....'));
  //               }

  //               List<DocumentSnapshot> usersList = snapshot.data!.docs;

  //               return Column(
  //                 children: usersList.map((document) {
  //                   String userId = document.id;
  //                   Map<String, dynamic> data =
  //                       document.data() as Map<String, dynamic>;
  //                   String userName = data['name'] ?? 'Unknown';
  //                   String userStudentId = data['student_id'] ?? 'Unknown';

  // //                   return ListTile(
  // //                     title: Text(userName),
  // //                     subtitle: Text('Student Id: $userStudentId'),
  // //                   );
  // //                 }).toList(),
  // //               );
  // //             },
  // //           ),
  // //         ),
  // //       ),
  // //     );
  // //   }
  // // }
