import 'dart:async';

class Doctor {
  final String name;
  final String speciality;
  final String location;
  final String practiceSchedule;

  Doctor({
    required this.name,
    required this.speciality,
    required this.location,
    required this.practiceSchedule,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    try {
      return Doctor(
        name: json['name']?.toString() ?? 'Unknown Doctor',
        speciality: json['speciality']?.toString() ?? json['specialty']?.toString() ?? 'General',
        location: json['location']?.toString() ?? 'Unknown Location',
        practiceSchedule: json['practice_schedule']?.toString() ?? 
                         json['practiceSchedule']?.toString() ?? 
                         'Schedule not available',
      );
    } catch (e) {
      print('Error parsing Doctor from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'speciality': speciality,
      'location': location,
      'practice_schedule': practiceSchedule,
    };
  }

  @override
  String toString() {
    return 'Doctor(name: $name, speciality: $speciality, location: $location, schedule: $practiceSchedule)';
  }
}

class DiagnosisResult {
  final String result;
  final List<Doctor> relatedDoctors;
  final String? confidence;
  final String? additionalInfo;

  DiagnosisResult({
    required this.result,
    required this.relatedDoctors,
    this.confidence,
    this.additionalInfo,
  });

  factory DiagnosisResult.fromJson(Map<String, dynamic> json) {
    try {
      print('Parsing DiagnosisResult from JSON: $json');
      
      List<Doctor> doctors = [];
      
      // Handle different possible key names for doctors
      final doctorsData = json['related_doctors'] ?? 
                         json['relatedDoctors'] ?? 
                         json['doctors'] ?? 
                         [];
      
      if (doctorsData != null && doctorsData is List) {
        for (var doctorJson in doctorsData) {
          try {
            if (doctorJson is Map<String, dynamic>) {
              doctors.add(Doctor.fromJson(doctorJson));
            }
          } catch (e) {
            print('Error parsing individual doctor: $e');
            print('Doctor data: $doctorJson');
            // Continue with other doctors instead of failing completely
          }
        }
      }

      return DiagnosisResult(
        result: json['result']?.toString() ?? 
               json['diagnosis']?.toString() ?? 
               'No diagnosis result',
        relatedDoctors: doctors,
        confidence: json['confidence']?.toString(),
        additionalInfo: json['additional_info']?.toString() ?? 
                       json['additionalInfo']?.toString(),
      );
    } catch (e) {
      print('Error parsing DiagnosisResult from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'related_doctors': relatedDoctors.map((d) => d.toJson()).toList(),
      'confidence': confidence,
      'additional_info': additionalInfo,
    };
  }

  // Method untuk timeout dengan error handling yang lebih baik
  static Future<DiagnosisResult?> fromJsonWithTimeout(
    Future<Map<String, dynamic>> jsonFuture, {
    Duration timeout = const Duration(seconds: 120),
  }) async {
    try {
      final json = await jsonFuture.timeout(timeout);
      return DiagnosisResult.fromJson(json);
    } on TimeoutException catch (e) {
      print(' Timeout saat parsing DiagnosisResult: $e');
      return null;
    } on FormatException catch (e) {
      print(' Format error saat parsing DiagnosisResult: $e');
      return null;
    } catch (e, stackTrace) {
      print(' Error saat parsing DiagnosisResult: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  @override
  String toString() {
    return 'DiagnosisResult(result: $result, doctors: ${relatedDoctors.length}, confidence: $confidence)';
  }

  // Helper method to check if result is valid
  bool get isValid {
    return result.isNotEmpty && result != 'No diagnosis result';
  }

  // Helper method to get formatted result
  String get formattedResult {
    if (confidence != null) {
      return '$result (Confidence: $confidence)';
    }
    return result;
  }
}