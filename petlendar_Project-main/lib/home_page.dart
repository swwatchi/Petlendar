// home_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/profile_edit_page.dart';
import 'models/pet_profile.dart';
import 'models/pet_profile_provider.dart';
import 'models/profile_view_page.dart'; // 상세 페이지 위젯 임포트

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PetProfileProvider>(
      builder: (context, provider, child) {
        // provider.selectedProfile이 null이 아니면 상세 화면을 보여줍니다.
        if (provider.selectedProfile != null) {
          return _buildProfileDetail(context, provider);
        } else {
          // provider.selectedProfile이 null이면 프로필 리스트를 보여줍니다.
          return _buildProfileList(context, provider);
        }
      },
    );
  }

  Widget _buildProfileList(BuildContext context, PetProfileProvider provider) {
    if (provider.profiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 120, color: Colors.grey),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newProfile = await Navigator.push<PetProfile>(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                );
                if (newProfile != null) {
                  provider.addProfile(newProfile);
                }
              },
              child: const Text("프로필 추가"),
            ),
          ],
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = 300.0;
    final profileRadius = 50.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("홈"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () async {
                  final newProfile = await Navigator.push<PetProfile>(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditPage()),
                  );
                  if (newProfile != null) {
                    provider.addProfile(newProfile);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: provider.profiles.length,
        itemBuilder: (context, index) {
          final profile = provider.profiles[index];
          return GestureDetector(
            onTap: () {
              provider.selectProfile(index);
            },
            onLongPress: () {
              _showDeleteDialog(context, provider, index);
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
                          ? Image.file(File(profile.backgroundImagePath),
                              fit: BoxFit.cover)
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
                            backgroundImage:
                                profile.profileImagePath.isNotEmpty
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
                          Text(profile.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("나이: ${profile.age}살",
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 2),
                          Text(profile.memo,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
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

  Widget _buildProfileDetail(BuildContext context, PetProfileProvider provider) {
    if (provider.selectedProfile == null) {
      return const SizedBox();
    }
    
    // ✅ 'profile' 인자를 추가하여 `ProfileViewPage`로 전달합니다.
    return ProfileViewPage(
      index: provider.selectedIndex!,
      profile: provider.selectedProfile!,
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
              child: const Text("취소")),
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