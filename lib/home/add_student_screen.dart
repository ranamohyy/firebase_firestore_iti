import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/home/controller/home_cubit.dart';
import 'package:student_system_iti/home/home_view.dart';

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Add Your Data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Color(0xffFF5E00),
            ),
          ),
          leading: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xffFF5E00),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is AddStudentSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: const Text('Your Data added Success '),
                    ),
                  );
                }
                if (state is HomeFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.msg),
                    ),
                  );
                }
              },
              builder: (context, state) {
                final cubit = context.read<HomeCubit>();
                if (state is HomeLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Please Enter Your Data',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6D3805),
                      ),
                    ),
                    SizedBox(height: 20),

                    ///============name control========================
                    TextFormField(
                      controller: cubit.nameControl,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF3F3F3),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFF5E00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F3)),
                        ),
                        hintText: 'name',
                      ),
                    ),

                    SizedBox(height: 20),

                    ///============age control========================
                    TextFormField(
                      controller: cubit.ageControl,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF3F3F3),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFF5E00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F3)),
                        ),
                        hintText: 'age',
                      ),
                    ),
                    SizedBox(height: 20),

                    ///============grade control========================
                    TextFormField(
                      controller: cubit.gradeControl,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF3F3F3),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFF5E00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F3)),
                        ),
                        hintText: 'Enter Your Grade',
                      ),
                    ),

                    SizedBox(height: 20),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        cubit.addStudentToServer();
                        Future.delayed(Duration(seconds: 3));
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomeView()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(50),
                        backgroundColor: Color(0xffFF5E00),
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
