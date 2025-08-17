import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/profile_edit_page.dart';
import 'models/pet_profile.dart';
import 'main.dart';

// 홈 화면
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PetProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("홈"),
        actions: provider.profiles.isNotEmpty
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.blue),
                      onPressed: () async {
                        final newProfile = await Navigator.push<PetProfile>(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ProfileEditPage()),
                        );
                        if (newProfile != null) {
                          provider.addProfile(newProfile);
                        }
                      },
                    ),
                  ),
                ),
              ]
            : null, // 프로필 없으면 AppBar 액션 없음
      ),
      body: provider.profiles.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 120, color: Colors.grey),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final newProfile = await Navigator.push<PetProfile>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileEditPage()),
                      );
                      if (newProfile != null) {
                        provider.addProfile(newProfile);
                      }
                    },
                    child: const Text("프로필 추가"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.profiles.length,
              itemBuilder: (context, index) {
                final profile = provider.profiles[index];
                final screenWidth = MediaQuery.of(context).size.width;
                final cardHeight = 300.0;
                final profileRadius = 50.0;

                return GestureDetector(
                  onTap: () async {
                    final updatedProfile = await Navigator.push<PetProfile>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProfileViewPage(index: index, profile: profile),
                      ),
                    );
                    if (updatedProfile != null) {
                      provider.updateProfile(index, updatedProfile);
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: cardHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            height: cardHeight * 0.5,
                            width: double.infinity,
                            child: profile.backgroundImagePath.isNotEmpty
                                ? Image.file(
                                    File(profile.backgroundImagePath),
                                    fit: BoxFit.cover,
                                  )
                                : Container(color: Colors.grey[300]),
                          ),
                          Positioned(
                            top: cardHeight * 0.5 - profileRadius,
                            left: screenWidth / 2 - profileRadius,
                            child: Stack(
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
                                    profile.gender == 'male'
                                        ? Icons.male
                                        : Icons.female,
                                    color: profile.gender == 'male'
                                        ? Colors.blue
                                        : Colors.pink,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: const TextStyle(
                                      fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "나이: ${profile.age}살",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  profile.memo,
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}


// 상세보기 페이지
class ProfileViewPage extends StatefulWidget {
  final int index;
  final PetProfile profile;

  const ProfileViewPage({super.key, required this.index, required this.profile});

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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double backgroundHeight = screenHeight * 0.5;
    final double profileRadius = 70;
    final provider = Provider.of<PetProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
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
                setState(() => profile = updatedProfile);
                provider.updateProfile(widget.index, updatedProfile);
              }
            },
          ),
        ],
      ),
      body: Stack(
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
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: backgroundHeight + profileRadius + 32),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
