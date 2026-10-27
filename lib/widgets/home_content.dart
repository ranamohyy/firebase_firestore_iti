import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/add_student_screen/add_student_screen.dart';
import 'package:student_system_iti/dialogs/delete_dialog.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

import '../dialogs/edit_dialog.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(
            context,
          ).push<bool>(MaterialPageRoute(builder: (_) => AddStudentScreen()));

          ///===============check on return type-----------------------------------------
          if (!context.mounted) return;
          if (result == true) {
            await context.read<HomeCubit>().getStudentsFromServer();

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Student added success "),
              ),
            );

          }
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('All Students'),
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          ///----------------failure--------------
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.msg)),
            );
          }

          ///-----------edit students success---------------
          if (state is UpdateStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Student edit success"),
              ),
            );
          }

          ///--------------delete student success------------
          if (state is DeleteStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text("Student deleted success "),
              ),
            );
          }
        },
        builder: (context, state) {
          print("============current state===${state}==========");

          ///--------handle loading----------------------
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          ///--------body must only view in case of success getting data--------------------------------------
          if (state is GetStudentSuccess) {
            ///-------------------------empty----------------------------------------
            if (state.students.isEmpty) {
              return Center(child: Text("No Students yet"));
            }

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.students.length,

              itemBuilder: (context, index) {
                final student = state.students[index];

                return ListTile(
                  title: Text("Name ${student['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Age   ${student['age']}"),
                      Text("Grade   ${student['grade']}"),
                    ],
                  ),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      final cubit = BlocProvider.of<HomeCubit>(context);
                      if (value == 'edit') {
                        final updated = await showEditDialog(
                          context: context,
                          cubit: cubit,
                          id: student.id,
                          student: student.data(),
                        );
                        if (updated == true) {
                          await cubit.getStudentsFromServer();
                        }
                      }

                      if (value == 'delete') {
                        if (!context.mounted) return;
                        final deleted = await showDeleteStudentDialog(
                          context: context,
                          cubit: cubit,
                          id: student.id,
                        );

                        ///----------------------------------------------------

                        if (deleted == true) {
                          await cubit.getStudentsFromServer();
                        }
                      }
                    },

                    itemBuilder: (_) => [
                      PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
