import 'package:flutter/material.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

Future<bool?> showDeleteStudentDialog({
  required BuildContext context,
  required HomeCubit cubit,
  required String id,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text("Delete Student"),

        ///----------------------------------------------
        content: Text("Are you sure you want to delete this student?"),

        ///----------------------------------------------
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () async {
              await cubit.deleteStudents(id);

              ///===========================================
              if (!dialogContext.mounted) return;

              ///----------------check on state-----------------
              if (cubit.state is DeleteStudentSuccess) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: Text("Delete"),
          ),
        ],
      );
    },
  );
}
