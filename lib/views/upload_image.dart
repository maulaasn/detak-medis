import 'dart:io';
import 'package:detak_medis/data/api/predict/predict_api.dart';
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
  bool _isLoading = false;
  String _queryText = '';
  dynamic _diagnosisResult; // Menyimpan hasil diagnosis
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _queryController = TextEditingController();

  void _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
          // Reset hasil diagnosis ketika gambar baru dipilih
          _diagnosisResult = null;
        });
      }
    } catch (e) {
      _showErrorDialog('Gagal memilih gambar: ${e.toString()}');
    }
  }

  void _confirmRemoveImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Hapus gambar ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _removeImage();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _diagnosisResult = null; // Reset hasil diagnosis
    });
  }

  void _sendDiagnosis() async {
    // Validasi input - hanya gambar yang wajib
    if (_selectedImage == null) {
      _showErrorDialog('Silakan pilih gambar terlebih dahulu');
      return;
    } else if (_queryController.text.trim().isEmpty) {
      _showErrorDialog('Silakan isi keluhan terlebih dahulu');
      return;
    }

    // Cek apakah file gambar masih ada
    final imageFile = File(_selectedImage!.path);
    if (!await imageFile.exists()) {
      _showErrorDialog('File gambar tidak ditemukan');
      return;
    }

    setState(() {
      _isLoading = true;
      _diagnosisResult = null; // Reset hasil sebelumnya
    });

    try {
      print('Mengirim diagnosis...');
      print('Image path: ${_selectedImage!.path}');
      print('Query: $_queryText');

      final result = await PredictApi.sendDiagnosis(
        imageFile: imageFile,
        query: _queryText.trim(),
      );

      print('Response received: $result');

      if (mounted) {
        setState(() {
          _isLoading = false;
          _diagnosisResult = result; // Simpan hasil diagnosis
        });

        if (result == null) {
          _showErrorDialog('Tidak ada respons dari server');
        }
      }
    } catch (e) {
      print('Error sending diagnosis: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog('Terjadi kesalahan: ${e.toString()}');
      }
    }
  }

  void _resetDiagnosis() {
    setState(() {
      _diagnosisResult = null;
      _queryController.clear();
      _queryText = '';
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Gagal'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  // Fungsi untuk mengecek apakah button bisa diklik
  bool _canSendDiagnosis() {
    return _queryController.text.trim().isNotEmpty &&
        !_isLoading &&
        _diagnosisResult == null;
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _selectedImage?.name;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diagnosis Penyakit'),
        backgroundColor: wMainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header untuk section keluhan
              const Text(
                'Keluhan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  labelText: 'Keluhan (Opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  hintText: 'Contoh: Saya merasa sakit kepala dan demam...',
                  // helperText:
                  //     'Tambahkan keluhan untuk hasil diagnosis yang lebih baik',
                ),
                maxLines: 3,
                enabled: !_isLoading,
                onChanged: (value) {
                  setState(() {
                    _queryText = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Header untuk upload gambar
              Row(
                children: [
                  const Text(
                    'Unggah Gambar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              //upload image section
              GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: DottedBorderBox(
                  child:
                      _selectedImage == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text('Upload Gambar', style: greyTextStyle),
                            ],
                          )
                          : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  width: double.infinity,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      height: 180,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onPressed:
                                        _isLoading ? null : _confirmRemoveImage,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade500),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.yellow.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Opsional : Upload gambar ctscan atau foto untuk hasil diagnosis yang lebih akurat.',
                        maxLines: 2,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (fileName != null)
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text('Uploaded: $fileName')),
                  ],
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSendDiagnosis() ? _sendDiagnosis : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: wMainColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isLoading
                          ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Memproses...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )
                          : const Text(
                            'Kirim Diagnosis',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                ),
              ),

              //  hasil diagnosis di bawah button
              if (_diagnosisResult != null) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade200),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hasil Diagnosis',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: _resetDiagnosis,
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Diagnosis Ulang',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _diagnosisResult.result != null
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                _diagnosisResult.result!
                                    .replaceAll(r'\n', '\n')
                                    .split('\n')
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map<Widget>(
                                      (entry) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                entry.value.trim(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                          )
                          : const Text(
                            'Tidak ada hasil',
                            style: TextStyle(fontSize: 14),
                          ),
                      const SizedBox(height: 16),
                      if (_diagnosisResult.relatedDoctors != null &&
                          _diagnosisResult.relatedDoctors.isNotEmpty) ...[
                        const Text(
                          'Dokter Terkait:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._diagnosisResult.relatedDoctors.map(
                          (doctor) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: wThirdColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '👨‍⚕️ ${doctor.name ?? 'Nama tidak tersedia'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Spesialis: ${doctor.speciality ?? 'Tidak tersedia'}',
                                ),
                                Text(
                                  doctor.location ?? 'Lokasi tidak tersedia',
                                ),
                                Text(
                                  doctor.practiceSchedule ??
                                      'Jadwal tidak tersedia',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
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
    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 1.5,
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(18),
      child: Container(
        height: 180,
        width: double.infinity,
        child: Center(child: child),
      ),
    );
  }
}
