import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smd_project/features/groups/data/models/group_model.dart';
import 'package:smd_project/features/groups/presentation/pages/group_details_page.dart';

class GroupLoader extends StatelessWidget {
  final String rawGroupId;

  const GroupLoader({super.key, required this.rawGroupId});

  @override
  Widget build(BuildContext context) {
    final groupId = rawGroupId.replaceAll(RegExp(r'[\[\]#]'), '');
    print("Raw Group id: $rawGroupId");
    print("Cleaned Group id: $groupId");

    return FutureBuilder<GroupModel>(
      future: FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get()
          .then((doc) {
        if (!doc.exists) {
          throw Exception('Group not found');
        }
        return GroupModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Group not found')),
          );
        }
        return GroupDetailsPage(group: snapshot.data!);
      },
    );
  }
}
