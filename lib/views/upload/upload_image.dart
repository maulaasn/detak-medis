import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:detak_medis/ui/theme.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  XFile? _selectedImage;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    setState(() {
      _isUploading = true;
    });

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }

    await Future.delayed(const Duration(seconds: 2)); // Simulasi upload
    setState(() {
      _isUploading = false;
    });
  }

  void _confirmRemoveImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            style: TextStyle(fontSize: 20),
          ),
          content: const Text('Are you sure want to delete the image?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
              ),
              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                _removeImage();
              },
            ),
          ],
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? fileName = _selectedImage?.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        backgroundColor: wMainColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorderBox(
                child: _selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 24,
                            child: const Icon(Icons.add, color: Colors.black, size: 28),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Add File',
                            style: greyTextStyle.copyWith(fontSize: 20),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white, size: 16),
                                onPressed: _confirmRemoveImage,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),

            /// Accepted file types
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Accepted file types: PNG, JPG, JPEG',
                style: greyTextStyle.copyWith(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),

            /// Uploading / Uploaded status
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const CircularProgressIndicator(strokeWidth: 2),
                    const SizedBox(width: 12),
                    Text('Uploading...', style: greyTextStyle),
                  ],
                ),
              )
            else if (fileName != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('Uploaded: $fileName', style: blackTextStyle),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final Widget child;
  const DottedBorderBox({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: Container(
          height: 180,
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
