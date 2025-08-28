import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pet_profile.dart';
import 'pet_profile_provider.dart';
import 'profile_edit_page.dart';

class ProfileViewPage extends StatefulWidget {
  final int index;
  final PetProfile profile;

  const ProfileViewPage({
    super.key,
    required this.index,
    required this.profile,
  });

  @override
  State<ProfileViewPage> createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  late PetProfile profile;

  @override
  void initState() {
    super.initState();
    profile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProfileProvider>(context);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double backgroundHeight = screenHeight * 0.5;
    final double profileRadius = 70;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            provider.clearSelection();
          },
        ),
        // 여기에 있던 'title' 속성을 삭제합니다.
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updatedProfile = await Navigator.push<PetProfile>(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileEditPage(profile: profile),
                ),
              );
              if (updatedProfile != null) {
                provider.updateProfile(widget.index, updatedProfile);
                setState(() {
                  profile = updatedProfile;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context, provider, widget.index),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              height: backgroundHeight,
              width: double.infinity,
              child: profile.backgroundImagePath.isNotEmpty
                  ? Image.file(
                      File(profile.backgroundImagePath),
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey[300]),
            ),
            Positioned(
              top: backgroundHeight - profileRadius,
              left: screenWidth / 2 - profileRadius,
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: profileRadius,
                        backgroundImage: profile.profileImagePath.isNotEmpty
                            ? FileImage(File(profile.profileImagePath))
                            : null,
                        child: profile.profileImagePath.isEmpty
                            ? const Icon(Icons.pets, size: 50)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          profile.gender == 'male' ? Icons.male : Icons.female,
                          color: profile.gender == 'male' ? Colors.blue : Colors.pink,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: backgroundHeight + profileRadius + 32,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "나이: ${profile.age}살",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.memo,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, PetProfileProvider provider, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("프로필 삭제"),
        content: const Text("정말 삭제하시겠습니까?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              provider.deleteProfile(index);
              Navigator.pop(context);
            },
            child: const Text("삭제", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}