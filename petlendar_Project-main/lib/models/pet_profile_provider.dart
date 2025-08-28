// lib/models/pet_profile_provider.dart
import 'package:flutter/material.dart';
import 'pet_profile.dart';

class PetProfileProvider extends ChangeNotifier {
  final List<PetProfile> _profiles = [];
  PetProfile? _selectedProfile;
  int? _selectedIndex;

  List<PetProfile> get profiles => _profiles;
  PetProfile? get selectedProfile => _selectedProfile;
  int? get selectedIndex => _selectedIndex;

  void addProfile(PetProfile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  void updateProfile(int index, PetProfile profile) {
    if (index >= 0 && index < _profiles.length) {
      _profiles[index] = profile;
      if (_selectedProfile != null && _selectedIndex == index) {
        _selectedProfile = profile; // 선택된 프로필 정보도 업데이트
      }
      notifyListeners();
    }
  }

  void deleteProfile(int index) {
    if (index >= 0 && index < _profiles.length) {
      _profiles.removeAt(index);
      _selectedProfile = null; // 프로필 삭제 시 선택 상태 초기화
      _selectedIndex = null;
      notifyListeners();
    }
  }

  void selectProfile(int index) {
    if (index >= 0 && index < _profiles.length) {
      _selectedProfile = _profiles[index];
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedProfile = null;
    _selectedIndex = null;
    notifyListeners();
  }
}