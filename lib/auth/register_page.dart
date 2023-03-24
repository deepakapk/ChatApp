import 'package:chat_app/auth/login_page.dart';
import 'package:chat_app/helper/herlper_function.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';


class RegisterPage extends StatefulWidget
{
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState()=> _RegisterPage();
}

class _RegisterPage extends State<RegisterPage>
{
  final formkey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthSerive authSerive = AuthSerive();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading?Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,)):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 50),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Groupie", style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text('Create your account now to chat and explore!', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                Image.asset('assets/images/register.png'),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person_2,color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val)
                  {
                    setState(() {
                      name = val;
                    });
                  },
                  validator: (val){
                    if(val!.isNotEmpty) {
                      return null;
                    }
                    else
                      {
                        return 'Name cannot be empty!';
                      }
                  },

                ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val)
                  {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,),

                  ),
                  validator: (val){
                    if(val!.length < 6){
                      return "Password must be at least 6 characters";
                    }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val)
                  {
                    setState(() {
                      password = val;
                    });
                  },

                ),
                const SizedBox(height: 20,),
                SizedBox(

                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: ()=>register(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        child: const Text('Register',style: TextStyle(fontSize: 16),)
                    )
                ),
                const SizedBox(height: 10,),
                Text.rich(
                    TextSpan(
                        text: "Already have an account ",
                        style: const TextStyle(color: Colors.black, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                              text: "Login Now!",
                              style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()..onTap = (){
                                nextScreen(context, const LoginPage());
                              }),

                        ]
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  register() async{
    if(formkey.currentState!.validate())
      {
        setState(() {
          _isLoading = true;
        });
        await authSerive.registerUserWithEmailandPassword(name, email, password).then((value) async{
          if(value == true)
          {
            //saving the shared preference state
            await HelperFunctions.saveUserLoggedInStatus(true);
            await HelperFunctions.saveUserNameSf(name);
            await HelperFunctions.saveUserEmailSf(email);
            nextScreenReplace(context, HomePage());
          }

          else
          {
            showSnackbar(context, Colors.red , value);

            setState(() {
              _isLoading = false;
            });
          }
        });
      }
  }

}