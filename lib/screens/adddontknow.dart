// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lawyer_cases_app/service.dart/db_helper.dart';
import 'package:lawyer_cases_app/screens/Homepage.dart';
import 'package:lawyer_cases_app/widget.dart/customAppBar.dart';
import 'package:lawyer_cases_app/widget.dart/custom_text_feild.dart';

class Adddontknow extends StatefulWidget {
  const Adddontknow({super.key});

  @override
  State<Adddontknow> createState() => _AdddontknowState();
}

DBHelper dbHelper = DBHelper();
final _formKey = GlobalKey<FormState>();
final _accusedNameController1 = TextEditingController();
final _accusedNameController2 = TextEditingController();
final _claimController = TextEditingController();
final _rulingcontroller = TextEditingController();
final _confinementController = TextEditingController();
final _notesController = TextEditingController();

class _AdddontknowState extends State<Adddontknow> {
  Future<void> _savedontknow() async {
    if (_formKey.currentState!.validate()) {
      int response = await DBHelper().insertdontknow('''
INSERT INTO dontknow (name1 , name2 , claim , ruling ,confinement ,details) VALUES 
                         ("${_accusedNameController1.text}" , "${_accusedNameController2.text}"  , "${_claimController.text}" , "${_rulingcontroller.text}" , "${_confinementController.text}" ,"${_notesController.text}" )
''');

      if (response > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
            "تم إضافة الي مش عارف اي  بنجاح",
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
          title: 'اضافة مش عارف اي',
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
                      controller: _claimController,
                      keyboardtype: TextInputType.text,
                      labeltext: 'الدعوي',
                      prefixicon: const Icon(Icons.numbers),
                      value: (value) => value!.isEmpty ? "ادخل الدعوة" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _rulingcontroller,
                      keyboardtype: TextInputType.name,
                      labeltext: 'الحكم',
                      prefixicon: const Icon(Icons.balance),
                      value: (value) => value!.isEmpty ? "ادخل الحكم" : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFeild(
                      controller: _confinementController,
                      keyboardtype: TextInputType.name,
                      labeltext: 'الحصر',
                      prefixicon: const Icon(Icons.phone),
                      value: (value) => value!.isEmpty ? "ادخل الحكم" : null,
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
                        onPressed: _savedontknow,
                        child: const Text("حفظ مش عارف اي"),
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
