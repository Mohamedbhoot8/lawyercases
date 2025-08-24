// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lawyer_cases_app/service.dart/db_helper.dart';
import 'package:lawyer_cases_app/screens/Homepage.dart';
import 'package:lawyer_cases_app/widget.dart/customAppBar.dart';

class LawyerSetupScreen extends StatefulWidget {
  const LawyerSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LawyerSetupScreenState createState() => _LawyerSetupScreenState();
}

class _LawyerSetupScreenState extends State<LawyerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  String? imagePath;
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  void _saveLawyer() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      int response = await DBHelper().insertlayer('''
                        INSERT INTO  lawyer (name , email , phone , imagePath) VALUES 
                         ("${_nameController.text}" , "${_emailController.text}" , "${_phoneController.text}" , "$imagePath")
                                        ''');
      setState(() => _isLoading = false);
      if (response > 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: Customappbar(
          title: 'بيانات المحامي',
          textcolor: isDark ? Colors.black : Colors.white,
          backgcolor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_2_rounded),
                        labelText: "الاسم",
                      ),
                      validator: (val) => val!.isEmpty ? "ادخل الاسم" : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "البريد الالكتروني"),
                      validator: (val) =>
                          val!.isEmpty ? "ادخل البريد الالكتروني" : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                        textDirection: TextDirection.rtl,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: "رقم الهاتف المحمول "),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          } else if (val.length != 11) {
                            return 'يجب أن يكون الرقم مكون من 11 أرقام';
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imagePath != null
                          ? FileImage(File(imagePath!))
                          : null,
                      child: imagePath == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _saveLawyer,
                          child: const Text("حفظ البيانات"),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
