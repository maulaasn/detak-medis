import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/controller/edit_profile_controller.dart';

class EditForm extends StatefulWidget {
  // ignore: use_super_parameters
  const EditForm({Key? key}) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  late EditProfileController controller;

  @override
  void initState() {
    super.initState();
    controller = EditProfileController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: blackTextStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), // Tinggi garis
          child: Container(
            height: 1.0,
            color: Colors.grey.shade300, // Warna garis bawah
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder<String?>(
            valueListenable: controller.currentlyEditing,
            builder: (context, editingField, _) {
              return ListView(
                children: [
                  _buildEditableTile(
                    title: 'Name',
                    value: controller.nameController.text,
                    isEditing: editingField == 'Name',
                    onEdit: controller.handleEditName,
                    onSave: () => controller.saveEdit('Name'),
                  ),

                  _buildEditableTile(
                    title: 'Email',
                    value: controller.emailController.text,
                    isEditing: editingField == 'Email',
                    onEdit: controller.handleEditEmail,
                    onSave: () => controller.saveEdit('Email'),
                  ),
                  _buildEditableTile(
                    title: 'Password',
                    value: '••••••••',
                    isEditing: editingField == 'Password',
                    onEdit: controller.handleEditPassword,
                    onSave: () => controller.saveEdit('Password'),
                    isPassword: true,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditableTile({
    required String title,
    required String value,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          title: Text(
            title,
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle:
              isEditing
                  ? null
                  : Text(
                    value,
                    style: blackTextStyle.copyWith(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 251, 255),
              border: Border.all(color: wMainColor, width: 0.5),
              borderRadius: BorderRadius.circular(100),
            ),
            child: IconButton(
              icon: Icon(Icons.edit_outlined, color: wMainColor),
              onPressed: onEdit,
            ),
          ),
        ),
        if (isEditing) ...[
          TextField(
            controller: controller.tempEditController,
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: 'Enter your $title',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              labelText: title,
              labelStyle: blackTextStyle.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: controller.cancelEditing,
                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 240, 240),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 240, 255, 240),
                  side: const BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        Divider(height: 0, thickness: 0.5, color: Colors.grey[300]),
      ],
    );
  }
}
