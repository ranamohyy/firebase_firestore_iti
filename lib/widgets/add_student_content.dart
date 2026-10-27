import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';

class AddStudentContent extends StatelessWidget {
  const AddStudentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Add your data "),
      ),

      ///-----------------------------------------
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(backgroundColor: Colors.red, content: Text(state.msg)),
            );
          }
        },
        builder: (context, state) {
          final cubit = BlocProvider.of<HomeCubit>(context);

          ///---------------handle loading========================
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          ///---------------------------------------------------------
          return SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 20,
              children: [
                ///---------name field---------------------------------
                TextField(
                  controller: cubit.nameControl,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                ///=======================age field--------------------
                TextField(
                  controller: cubit.ageControl,
                  decoration: InputDecoration(
                    hintText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                ),

                ///-------grade field======================
                TextField(
                  controller: cubit.gradeControl,
                  decoration: InputDecoration(
                    hintText: 'Grade',
                    border: OutlineInputBorder(),
                  ),
                ),

                ElevatedButton(
                  onPressed: () async {
                    ///-------------------validate on fields---------------------------------
                    if (cubit.nameControl.text.trim().isEmpty ||
                        cubit.ageControl.text.trim().isEmpty ||
                        cubit.gradeControl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("please fill fields"),
                        ),
                      );
                      return;
                    }

                    ///---------------------------cubit method-------------------
                    await cubit.addStudentToServer();

                    ///-------------------check on state--------------------------------
                    if (!context.mounted) return;
                    if (cubit.state is AddStudentSuccess) {
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    "Add Student",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
