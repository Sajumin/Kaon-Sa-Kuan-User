import 'package:flutter/material.dart';
import '../../widgets/modal_confirm.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

@override
  State<AddRestaurantPage> createState() => _AddRestaurantPage();
}

class _AddRestaurantPage extends State<AddRestaurantPage> {
  static const Color warmTangerine = Color(0xFFF47B42);

  //final RestaurantController _restaurantController = RestaurantController();

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
                  onPressed: () {},
                  child: const Text(
                    'Click to Add Photo',
                    style: TextStyle(
                        fontFamily: 'Afacad',
                        color: warmTangerine,
                        fontSize: 16),
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
                child: const Icon(Icons.image_outlined,
                    size: 50, color: Colors.black),
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
                     builder: (_) => AdminConfirmModal(
                            icon: Icons.restaurant_rounded,
                            iconColor: kApproveGreen,
                            iconBgColor: kApproveGreenBg,

                            title: 'Submit Restaurant?',
                            message:
                                'Are you sure you want to submit this restaurant for review?',

                            confirmLabel: 'Yes, submit it.',
                            confirmColor: kApproveGreen,
                            confirmBgColor: kApproveGreenBg,

                            onConfirm: () {
                              Navigator.pop(context);

                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Frontend preview only'),
                              //   ),
                              // );

                              // Show success popup
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF4CAF50),
                                        size: 60,
                                      ),
                                      const SizedBox(height: 12),
                                      const Text(
                                        'Request Sent!',
                                        style: TextStyle(
                                          fontFamily: 'Afacad',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Your restaurant has been submitted for admin review!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Afacad',
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context); // close success dialog
                                          Navigator.pop(context); // go back to previous page
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFF47B42),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Got it!',
                                          style: TextStyle(
                                            fontFamily: 'Afacad',
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              print('Restaurant Name: ${_nameController.text}');
                              print('Description: ${_descriptionController.text}');
                              print('Location: ${_locationController.text}');
                              print('Selected Tags: $_selectedTags');
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