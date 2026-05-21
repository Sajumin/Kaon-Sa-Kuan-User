import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaon_sa_kuan/data/controllers/restaurant_controller.dart';
import 'package:kaon_sa_kuan/services/cloudinary_service.dart';
import 'package:kaon_sa_kuan/widgets/user/modal_confirm.dart';
import 'package:kaon_sa_kuan/widgets/user/user_success_modal.dart';
import 'package:kaon_sa_kuan/utils/constants/restaurant_tags.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPage();
}

class _AddRestaurantPage extends State<AddRestaurantPage> {
  static const Color warmTangerine = Color(0xFFF47B42);
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final RestaurantController _restaurantController = RestaurantController();

  File? _selectedImage;
  String _imageUrl = '';
  bool _isUploadingImage = false;

  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _averageMinCostController =
      TextEditingController();
  final TextEditingController _averageMaxCostController =
      TextEditingController();
  final TextEditingController _facebookPageController = TextEditingController();

  String? _selectedLocation;
  String? _selectedFoodCategory;
  String _openTime = '06:00';
  String _closeTime = '20:00';

  final Set<String> _selectedFoodTypes = {};
  final Set<String> _selectedBudgetTags = {};
  final Set<String> _selectedMealTags = {};

  Future<void> _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (pickedImage == null) return;

      setState(() {
        _selectedImage = File(pickedImage.path);
        _isUploadingImage = true;
      });

      final uploadedUrl = await _cloudinaryService.uploadImage(_selectedImage!);

      if (!mounted) return;

      setState(() {
        _imageUrl = uploadedUrl ?? '';
        _isUploadingImage = false;
      });

      if (uploadedUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed. Try again.')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isUploadingImage = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _averageMinCostController.dispose();
    _averageMaxCostController.dispose();
    _facebookPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: warmTangerine,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Restaurant',
          style: TextStyle(
            fontFamily: 'Afacad',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: warmTangerine, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                "What's the place called?",
                controller: _nameController,
              ),

              _buildTextField(
                'What should people know about it?',
                controller: _descriptionController,
                maxLines: 5,
              ),

              _buildDropdown(
                label: 'Where is it located?',
                value: _selectedLocation,
                options: RestaurantOptions.locations,
                onChanged: (value) =>
                    setState(() => _selectedLocation = value!),
              ),
              _buildDropdown(
                label: 'What kind of place is it?',
                value: _selectedFoodCategory,
                options: RestaurantOptions.foodCategories,
                onChanged: (value) =>
                    setState(() => _selectedFoodCategory = value!),
              ),
              _buildTextField(
                'Cheapest meal here',
                controller: _averageMinCostController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                'Priciest meal here',
                controller: _averageMaxCostController,
                keyboardType: TextInputType.number,
              ),
              _buildTimeButton(
                label: 'They open at',
                value: _openTime,
                onPicked: (value) => setState(() => _openTime = value),
              ),
              _buildTimeButton(
                label: 'They close at',
                value: _closeTime,
                onPicked: (value) => setState(() => _closeTime = value),
              ),
              _buildCheckboxGroup(
                title: 'What food do they serve?',
                options: RestaurantOptions.foodTypes,
                selected: _selectedFoodTypes,
              ),
              _buildCheckboxGroup(
                title: 'What budget fits them?',
                options: RestaurantOptions.budgetTags,
                selected: _selectedBudgetTags,
              ),
              _buildCheckboxGroup(
                title: 'When are they good for?',
                options: RestaurantOptions.mealTags,
                selected: _selectedMealTags,
              ),

              _buildTextField(
                'Facebook page or account',
                controller: _facebookPageController,
              ),

              // Add Photo Button
              Center(
                child: TextButton.icon(
                  onPressed: _isUploadingImage ? null : _pickImage,
                  icon: const Icon(
                    Icons.add_photo_alternate_outlined,
                    color: warmTangerine,
                  ),
                  label: Text(
                    _isUploadingImage
                        ? 'Uploading photo...'
                        : 'Click to Add Photo',
                    style: const TextStyle(
                      fontFamily: 'Afacad',
                      color: warmTangerine,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              // Photo Placeholder
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: warmTangerine.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _isUploadingImage
                    ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: warmTangerine),
                        SizedBox(height: 12),
                        Text(
                          'Uploading photo...',
                          style: TextStyle(
                            fontFamily: 'Afacad',
                            color: warmTangerine,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  : _selectedImage != null
                    ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImage = null;
                                _imageUrl = '';
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 50,
                        color: Colors.black26,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No photo added yet',
                        style: TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.black38,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Submit Button
              Center(
                child: Container(
                  width: 200,
                  height: 45,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => UserConfirmModal(
                          icon: Icons.restaurant_rounded,
                          iconColor: kApproveGreen,
                          iconBgColor: kApproveGreenBg,
                          title: 'Submit Restaurant?',
                          message:
                              'Are you sure you want to submit this restaurant for review?',
                          confirmLabel: 'Yes, submit it.',
                          confirmColor: kApproveGreen,
                          confirmBgColor: kApproveGreenBg,
                          onConfirm: () async {
                            Navigator.pop(context);

                            final averageMinCost = int.tryParse(
                                _averageMinCostController.text.trim());
                            final averageMaxCost = int.tryParse(
                                _averageMaxCostController.text.trim());

                            if (averageMinCost == null ||
                                averageMaxCost == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please enter valid meal prices.')),
                              );
                              return;
                            }

                            if (averageMaxCost < averageMinCost) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Priciest meal should be higher than cheapest meal.')),
                              );
                              return;
                            }

                            if (_selectedLocation == null ||
                                _selectedFoodCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please select a location and food category.'),
                                ),
                              );
                              return;
                            }

                            if (_selectedFoodTypes.isEmpty ||
                                _selectedBudgetTags.isEmpty ||
                                _selectedMealTags.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please choose food, budget, and meal tags.')),
                              );
                              return;
                            }

                            if (_isUploadingImage) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please wait for the image to finish uploading.')),
                              );
                              return;
                            }

                            if (_selectedImage != null && _imageUrl.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Image upload failed. Please choose the photo again.')),
                              );
                              return;
                            }

                            try {
                              await _restaurantController.addRestaurant(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                location: _selectedLocation!,
                                foodCategory: _selectedFoodCategory!,
                                foodType: _selectedFoodTypes.toList(),
                                averageCostMin: averageMinCost,
                                averageCostMax: averageMaxCost,
                                budgetTags: _selectedBudgetTags.toList(),
                                openTime: _openTime,
                                closeTime: _closeTime,
                                mealTags: _selectedMealTags.toList(),
                                facebookPage: _facebookPageController.text,
                                imageUrl: _imageUrl,
                              );

                              if (!mounted) return;

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) => UserSuccessModal(
                                  title: 'Request Sent!',
                                  message:
                                      'Your restaurant has been submitted for admin review!',
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to submit restaurant: $e')),
                              );
                            }
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warmTangerine,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Submit Restaurant',
                      style: TextStyle(
                          fontFamily: 'Afacad',
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _fieldTextStyle => const TextStyle(
        fontFamily: 'Afacad',
        fontSize: 16,
        color: Colors.black87,
      );

  TextStyle get _fieldHintStyle => TextStyle(
        fontFamily: 'Afacad',
        color: warmTangerine.withOpacity(0.5),
        fontStyle: FontStyle.italic,
      );

  InputBorder get _fieldBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: warmTangerine),
        borderRadius: BorderRadius.circular(8),
      );

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: _fieldHintStyle,
      floatingLabelStyle: const TextStyle(
        fontFamily: 'Afacad',
        color: warmTangerine,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      enabledBorder: _fieldBorder,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: warmTangerine, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _formatTimeForUser(String value) {
    final time = _timeFromValue(value);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  TimeOfDay _timeFromValue(String value) {
    final parts = value.split(':');

    if (parts.length != 2) {
      return TimeOfDay.now();
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return TimeOfDay.now();
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: _fieldTextStyle,
        decoration: _fieldDecoration(hint),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: _fieldDecoration(label),
        style: _fieldTextStyle,
        dropdownColor: Colors.white,
        iconEnabledColor: warmTangerine,
        hint: Text(
          label, // ← shows as placeholder when value is null
          style: _fieldHintStyle,
        ),
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option,
                child: Text(option, style: _fieldTextStyle),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckboxGroup({
    required String title,
    required List<String> options,
    required Set<String> selected,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: warmTangerine),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _fieldHintStyle),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selected.contains(option);

              return FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'Afacad',
                    color: isSelected ? warmTangerine : Colors.black87,
                  ),
                ),
                selected: isSelected,
                selectedColor: warmTangerine.withOpacity(0.15),
                checkmarkColor: warmTangerine,
                side: BorderSide(color: warmTangerine.withOpacity(0.6)),
                backgroundColor: Colors.white,
                onSelected: (value) {
                  setState(() {
                    value ? selected.add(option) : selected.remove(option);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton({
    required String label,
    required String value,
    required ValueChanged<String> onPicked,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: _timeFromValue(value),
            helpText: label,
            cancelText: 'Cancel',
            confirmText: 'OK',
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: false,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: warmTangerine,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: Colors.black87,
                    ),
                    timePickerTheme: TimePickerThemeData(
                      backgroundColor: Colors.white,
                      hourMinuteColor: warmTangerine.withOpacity(0.18),
                      hourMinuteTextColor: Colors.black87,
                      dialHandColor: warmTangerine,
                      dialBackgroundColor: warmTangerine.withOpacity(0.10),
                      entryModeIconColor: warmTangerine,
                    ),
                  ),
                  child: child!,
                ),
              );
            },
          );

          if (picked == null) return;

          final hour = picked.hour.toString().padLeft(2, '0');
          final minute = picked.minute.toString().padLeft(2, '0');
          onPicked('$hour:$minute');
        },
        child: InputDecorator(
          decoration: _fieldDecoration(label),
          child: Text(_formatTimeForUser(value), style: _fieldTextStyle),
        ),
      ),
    );
  }
}
