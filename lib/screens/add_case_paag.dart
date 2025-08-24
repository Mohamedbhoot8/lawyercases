// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lawyer_cases_app/service.dart/db_helper.dart';
import 'package:lawyer_cases_app/screens/Homepage.dart';
import 'package:lawyer_cases_app/service.dart/notification_service.dart';
import 'package:lawyer_cases_app/widget.dart/customAppBar.dart';
import 'package:lawyer_cases_app/widget.dart/custom_text_feild.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

DBHelper dbHelper = DBHelper();
final _formKey = GlobalKey<FormState>();
final _accusedNameController1 = TextEditingController();
final _accusedNameController2 = TextEditingController();
final _caseNumberController = TextEditingController();
final _courtNameController = TextEditingController();
final _clientPhoneController = TextEditingController();
final _notesController = TextEditingController();
DateTime? _selectedDate;

class _AddCasePageState extends State<AddCasePage> {
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("ar", "EG"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveCase() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      int response = await DBHelper().insertCase('''
INSERT INTO cases (name1 , name2 , date, details, case_number , court_name,client_phone) VALUES 
                         ("${_accusedNameController1.text}" , "${_accusedNameController2.text}" ,"${intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)}","${_notesController.text}" ,"${_caseNumberController.text}" , "${_courtNameController.text}" , "${_clientPhoneController.text}" )
''');

      if (response > 0) {
        if (_selectedDate!.isAfter(DateTime.now())) {
          await NotificationService.scheduleNotification(
            id: response,
            title: 'جلسة جديدة',
            body:
                'لديك جلسة للقضية رقم ${_caseNumberController.text} , الخاصة بالموكل ${_accusedNameController1.text}',
            scheduledDate: _selectedDate!.subtract(const Duration(days: 1)),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "تم إضافة القضية بنجاح",
            style: TextStyle(),
          )),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
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
          title: 'اضافة قضية',
          textcolor: isDark ? Colors.black : Colors.white,
          backgcolor: isDark ? Colors.deepPurple[700] : Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFeild(
                      controller: _accusedNameController1,
                      keyboardtype: TextInputType.name,
                      labeltext: 'اسم الموكل',
                      prefixicon: const Icon(Icons.person_2_rounded),
                      value: (value) =>
                          value!.isEmpty ? "ادخل اسم الموكل " : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _accusedNameController2,
                      keyboardtype: TextInputType.name,
                      labeltext: 'الخصم',
                      prefixicon: const Icon(Icons.person_2_rounded),
                      value: (value) =>
                          value!.isEmpty ? "ادخل اسم الخصم " : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _caseNumberController,
                      keyboardtype: TextInputType.streetAddress,
                      labeltext: 'رقم القضية',
                      prefixicon: const Icon(Icons.numbers),
                      value: (value) =>
                          value!.isEmpty ? "ادخل رقم القضية " : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _courtNameController,
                      keyboardtype: TextInputType.name,
                      labeltext: 'اسم المحكمة',
                      prefixicon: const Icon(Icons.balance),
                      value: (value) =>
                          value!.isEmpty ? "ادخل اسم المحكمة " : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                        controller: _clientPhoneController,
                        keyboardtype: TextInputType.phone,
                        labeltext: 'رقم هاتف الموكل',
                        prefixicon: const Icon(Icons.phone),
                        value: (val) {
                          if (val == null || val.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          } else if (val.length != 11) {
                            return 'يجب أن يكون الرقم مكون من 11 أرقام';
                          }
                          return null;
                        }),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            style: TextStyle(
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[800],
                            ),
                            _selectedDate == null
                                ? "اختر ميعاد الجلسة"
                                : "ميعاد الجلسة: ${intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickDate,
                          child: Text(
                            "اختيار التاريخ",
                            style: TextStyle(
                              color:
                                  isDark ? Colors.grey[300] : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _notesController,
                      labeltext: 'ملاحظات',
                      prefixicon: const Icon(Icons.note_alt_sharp),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _saveCase,
                        child: const Text("حفظ القضية"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
