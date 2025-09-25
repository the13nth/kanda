import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../constants/colors.dart';
import '../../models/user_profile.dart';
import '../../services/profile_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/customtextfield.dart';
import '../../widgets/custombtn.dart';
import '../../widgets/detailstext1.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  DateTime? _selectedDate;
  String? _profileImageUrl;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await ProfileService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _nameController.text = profile.fullName ?? '';
          _phoneController.text = profile.phone ?? '';
          _addressController.text = profile.address ?? '';
          _cityController.text = profile.city ?? '';
          _stateController.text = profile.state ?? '';
          _zipCodeController.text = profile.zipCode ?? '';
          _emergencyNameController.text = profile.emergencyContactName ?? '';
          _emergencyPhoneController.text = profile.emergencyContactPhone ?? '';
          _selectedDate = profile.dateOfBirth;
          _profileImageUrl = profile.profileImageUrl;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImageUrl = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final profile = UserProfile(
        id: AuthService.currentUser?.id ?? '',
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        dateOfBirth: _selectedDate,
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        emergencyContactName: _emergencyNameController.text.trim(),
        emergencyContactPhone: _emergencyPhoneController.text.trim(),
        profileImageUrl: _profileImageUrl,
      );

      await ProfileService.upsertUserProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        _loadUserProfile(); // Reload to get updated data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.bgColor,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.buttonColor,
                              backgroundImage: _profileImageUrl != null
                                  ? FileImage(File(_profileImageUrl!))
                                  : null,
                              child: _profileImageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: _pickImage,
                            child: const Text('Change Profile Picture'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Personal Information Section
                    const Text1(text1: 'Personal Information', size: 18),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'Phone Number',
                      icon: Icons.phone,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),

                    // Date of Birth
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.textFormFieldBorderColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                  : 'Date of Birth',
                              style: TextStyle(
                                color: _selectedDate != null
                                    ? Colors.black
                                    : Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Address Information Section
                    const Text1(text1: 'Address Information', size: 18),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'Address',
                      icon: Icons.home,
                      controller: _addressController,
                    ),
                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'City',
                            icon: Icons.location_city,
                            controller: _cityController,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomTextField(
                            label: 'State',
                            icon: Icons.map,
                            controller: _stateController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'ZIP Code',
                      icon: Icons.pin_drop,
                      controller: _zipCodeController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 30),

                    // Emergency Contact Section
                    const Text1(text1: 'Emergency Contact', size: 18),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'Emergency Contact Name',
                      icon: Icons.emergency,
                      controller: _emergencyNameController,
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      label: 'Emergency Contact Phone',
                      icon: Icons.phone,
                      controller: _emergencyPhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 40),

                    // Save Button
                    CustomButton(
                      text: _isSaving ? 'Saving...' : 'Save Profile',
                      onTap: _isSaving ? null : _saveProfile,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
