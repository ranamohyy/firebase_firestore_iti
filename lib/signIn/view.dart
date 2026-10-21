import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_system_iti/auth_cubit/auth_cubit.dart';

import '../register/view.dart';
import '../verify_screen.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Sign In',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Color(0xffFF5E00),
            ),
          ),

          /// back button
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xffFF5E00),
            ),
          ),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: const Text('Login Success '),
                ),
              );
            }
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content:  Text(state.msg),
                ),
              );
            }
            if (state is EmailNoVerified) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content:  Text("You should verify your email first"),
                ),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<AuthCubit>(),
                    child: const VerifyScreen(),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is LoginLoading;
            ///=======cubit================
            final cubit= context.read<AuthCubit>();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/images/auth.png'),

                    Text(
                      'Enter Your Email And\nPassword to access your account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff6D3805),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: cubit.emailLoginControl,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF3F3F3),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFF5E00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F3)),
                        ),
                        hintText: 'Email',
                      ),
                    ),

                    SizedBox(height: 20),

                    TextFormField(
                      controller: cubit.passwordLoginControl,
                      decoration: InputDecoration(
                        fillColor: Color(0xffF3F3F3),
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffFF5E00)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffF3F3F3)),
                        ),
                        hintText: 'Password',
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Forget Password',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xffFF5E00),
                      ),
                    ),

                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        cubit.login();

                        ///push replament ===> cannot bak
                        ///push ===> can back to screen
                        //
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(builder: (context) => HomeNav()),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromHeight(50),
                        backgroundColor: Color(0xffFF5E00),
                      ),
                      child:
                      isLoading?
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,

                            ),
                          ):
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff6D3805),
                          ),
                        ),

                        SizedBox(width: 6),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(
                                context,
                              ).push(MaterialPageRoute(builder: (context) =>
                                  SignUp())),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffFF5E00),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
