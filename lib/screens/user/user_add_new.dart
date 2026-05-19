import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaon_sa_kuan/data/controllers/restaurant_controller.dart';
import 'package:kaon_sa_kuan/services/cloudinary_service.dart';
import 'package:kaon_sa_kuan/widgets/user/modal_confirm.dart';
import 'package:kaon_sa_kuan/widgets/user/user_success_modal.dart';

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
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceRangeController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _facebookPageController = TextEditingController();

  bool _showTags = false;
  final List<String> _tagList = [
    'Cafe',
    'Samgyupsal',
    'Buffet',
    'Fast Food',
    'Seafood',
    'Milktea',
    'Desserts',
    'Chicken',
  ];
  final Set<String> _selectedTags = {};

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
              _buildTextField('Type restaurant name...',
                  controller: _nameController),
              _buildTextField('Type Description ...',
                  controller: _descriptionController, maxLines: 5),
              _buildTextField('Type Location...',
                  controller: _locationController),
              _buildTextField('Type Price Range...',
                  controller: _priceRangeController),
              _buildTextField('Type Opening Hours...',
                  controller: _openingHoursController),
              _buildTextField('Type Facebook Page / Account',
                  controller: _facebookPageController),

              // Tags Toggle Header
              GestureDetector(
                onTap: () => setState(() => _showTags = !_showTags),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: warmTangerine),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tags',
                        style: TextStyle(
                            fontFamily: 'Afacad',
                            color: warmTangerine,
                            fontSize: 16),
                      ),
                      Icon(
                        _showTags
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable Tags Grid
              if (_showTags)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 0,
                    children: _tagList
                        .map((tag) => SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: _selectedTags.contains(tag),
                            activeColor: warmTangerine,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              tag,
                              style: const TextStyle(
                                  fontFamily: 'Afacad', fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                ),

              // Add Photo Button
              Center(
                child: TextButton(
                  onPressed: _isUploadingImage ? null : _pickImage,
                  child: Text(
                    _isUploadingImage ? 'Uploading photo...' : 'Click to Add Photo',
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
                child: _selectedImage == null
                    ? const Icon(Icons.image_outlined, size: 50, color: Colors.black)
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
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

                            if (_isUploadingImage) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please wait for the image to finish uploading.')),
                              );
                              return;
                            }

                            if (_selectedImage != null && _imageUrl.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Image upload failed. Please choose the photo again.')),
                              );
                              return;
                            }

                            try {
                              await _restaurantController.addRestaurant(
                                name: _nameController.text,
                                description: _descriptionController.text,
                                location: _locationController.text,
                                priceRange: _priceRangeController.text,
                                openingHours: _openingHoursController.text,
                                facebookPage: _facebookPageController.text,
                                tags: _selectedTags.toList(),
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
                                SnackBar(content: Text('Failed to submit restaurant: $e')),
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

  Widget _buildTextField(
      String hint, {
        int maxLines = 1,
        required TextEditingController controller,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Afacad',
            color: warmTangerine.withOpacity(0.5),
            fontStyle: FontStyle.italic,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: warmTangerine),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: warmTangerine, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
