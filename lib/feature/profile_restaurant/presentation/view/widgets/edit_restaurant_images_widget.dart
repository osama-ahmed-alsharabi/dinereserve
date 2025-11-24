import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditRestaurantImagesWidget extends StatefulWidget {
  final String? initialLogo;
  final List<String> initialImages;
  final Function(String?) onLogoChanged;
  final Function(List<String>) onImagesChanged;
  final Function(String) onDeleteImage;

  const EditRestaurantImagesWidget({
    super.key,
    this.initialLogo,
    required this.initialImages,
    required this.onLogoChanged,
    required this.onImagesChanged,
    required this.onDeleteImage,
  });

  @override
  State<EditRestaurantImagesWidget> createState() =>
      _EditRestaurantImagesWidgetState();
}

class _EditRestaurantImagesWidgetState
    extends State<EditRestaurantImagesWidget> {
  String? _selectedLogoPath;
  final List<String> _selectedImagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickLogo() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedLogoPath = image.path;
      });
      widget.onLogoChanged(_selectedLogoPath);
    }
  }

  Future<void> _pickTableImage() async {
    if (widget.initialImages.length + _selectedImagePaths.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only upload up to 5 images")),
      );
      return;
    }

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePaths.add(image.path);
      });
      widget.onImagesChanged(_selectedImagePaths);
    }
  }

  void _removeTableImage(int index, bool isLocal) {
    setState(() {
      if (isLocal) {
        _selectedImagePaths.removeAt(index);
        widget.onImagesChanged(_selectedImagePaths);
      } else {
        // Remove from initialImages via callback
        // The parent will update the model and rebuild this widget
        widget.onDeleteImage(widget.initialImages[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Restaurant Logo",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: _pickLogo,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: _selectedLogoPath != null
                  ? FileImage(File(_selectedLogoPath!))
                  : (widget.initialLogo != null
                        ? NetworkImage(widget.initialLogo!) as ImageProvider
                        : null),
              child: _selectedLogoPath == null && widget.initialLogo == null
                  ? const Icon(Icons.add_a_photo, size: 30, color: Colors.grey)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Table Images (Max 5)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Existing Images
              ...widget.initialImages.asMap().entries.map((entry) {
                final index = entry.key;
                final url = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => _removeTableImage(index, false),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // New Local Images
              ..._selectedImagePaths.asMap().entries.map((entry) {
                final index = entry.key;
                final path = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () => _removeTableImage(index, true),
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Add Button
              if (widget.initialImages.length + _selectedImagePaths.length < 5)
                GestureDetector(
                  onTap: _pickTableImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.add, color: Colors.grey),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
