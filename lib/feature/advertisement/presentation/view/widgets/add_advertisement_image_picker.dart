import 'dart:io';
import 'package:dinereserve/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AddAdvertisementImagePicker extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTap;

  const AddAdvertisementImagePicker({
    super.key,
    required this.selectedImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor.withAlpha(26),
            style: BorderStyle.solid,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(selectedImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withAlpha(26),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: AppColors.primaryColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Tap to upload image",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "High quality recommended",
                    style: TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
