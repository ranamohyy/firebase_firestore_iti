import 'package:flutter/material.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

Future<bool?> showEditDialog({
  required BuildContext context,
  required HomeCubit cubit,
  required String id,
  required Map<String, dynamic> student,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      cubit.nameControl.text = student['name'].toString();
      cubit.ageControl.text = student['age'].toString();
      cubit.gradeControl.text = student['grade'].toString();

      return AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: cubit.nameControl,
                decoration: InputDecoration(hintText: 'NAME'),
              ),
              TextField(
                controller: cubit.ageControl,
                decoration: InputDecoration(hintText: 'age'),
              ),
              TextField(
                controller: cubit.gradeControl,
                decoration: InputDecoration(hintText: 'grade'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: Text("cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              ///-----------check on fields------------------------------------
              if (cubit.nameControl.text.trim().isEmpty ||
                  cubit.ageControl.text.trim().isEmpty ||
                  cubit.gradeControl.text.trim().isEmpty) {
                ScaffoldMessenger.of(
                  dialogContext,
                ).showSnackBar(SnackBar(content: Text("Please fill data")));
                return;
              }
              await cubit.updateStudent(id);

              ///-------------------check on state-------------------------------------
              if (!dialogContext.mounted) return;
              if (cubit.state is UpdateStudentSuccess) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: Text('save'),
          ),
        ],
      );
    },
  );
}
