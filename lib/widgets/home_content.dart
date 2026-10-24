import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/dialogs/edit_dialog.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange, title: Text("Students")),

      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          ///------------------home failure---------------------
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.msg)),
            );
          }

          ///----------------update success--------------------
          if (state is UpdateStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.green, content: Text("updated")),
            );
          }
        },
        builder: (context, state) {
          ///====================handle loading==============================
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          ///================================================================

          if (state is GetStudentsSuccess) {
            ///-----------handle empty state---------------------------------------
            if (state.students.isEmpty) {
              return Center(child: Text("No Students yet"));
            }

            ///================================================================

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                final student = state.students[index];

                return ListTile(
                  title: Text("Name  ${student['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AGE  ${student['age']}'),

                      Text("GRADE  ${student['grade']}"),
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

                      if (value == 'delete') {}
                    },

                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'edit', child: Text("Edit")),
                      PopupMenuItem(value: 'delete', child: Text("Delete")),
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
