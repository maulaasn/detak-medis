import 'package:flutter/material.dart';

class EditProfileController {
  // Controllers for text fields
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  
  // Track editing states
  final ValueNotifier<String?> currentlyEditing = ValueNotifier<String?>(null);
  
  // Temporary controllers used during editing
  TextEditingController tempEditController = TextEditingController();

  // Constructor with default values
  EditProfileController({
    String email = 'john@example.com',
    String password = '',
    String name = 'John Doe',
  }) : 
    emailController = TextEditingController(text: email),
    passwordController = TextEditingController(text: password),
    nameController = TextEditingController(text: name);

  // Start editing a field
  void startEditing(String field, String initialValue) {
    tempEditController.text = initialValue;
    currentlyEditing.value = field;
  }
  
  // Cancel editing
  void cancelEditing() {
    currentlyEditing.value = null;
  }
  
  // Save the edited value
  void saveEdit(String field) {
    if (field == 'Email') {
      emailController.text = tempEditController.text;
    } else if (field == 'Password') {
      passwordController.text = tempEditController.text;
    } else if (field == 'Name') {
      nameController.text = tempEditController.text;
    }
    
    // Reset editing state
    currentlyEditing.value = null;
  }

  // Handler for email edit
  void handleEditEmail() {
    startEditing('Email', emailController.text);
  }

  // Handler for password edit
  void handleEditPassword() {
    startEditing('Password', ''); // Starting with empty for security
  }

  // Handler for role edit
  void handleEditName() {
    startEditing('Name', nameController.text);
  }

  // Clean up resources
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    tempEditController.dispose();
    currentlyEditing.dispose();
  }
}