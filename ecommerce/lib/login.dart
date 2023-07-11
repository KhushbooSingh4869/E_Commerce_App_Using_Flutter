import 'package:ecommerce/catalog.dart';
import 'package:ecommerce/signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String loginMessage = '';
  String emailError = '';
  String passwordError = '';

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      setState(() {
        emailError = 'Email is Required';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password is Required';
      });
      return;
    }

    // Perform HTTP request to validate login credentials
    var url = "http://192.168.140.249/singup_login/login.php";
    var response = await http.post(Uri.parse(url), body: {
      'email': email,
      'password': password,
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListPage()),
    );

    if (response.statusCode == 200) {
      setState(() {
        loginMessage =
            response.body; // Success message or error message from PHP script
        if (loginMessage.contains('is not registered') ||
            loginMessage.contains('Your Password is wrong')) {
          // Clear the input fields
          emailController.clear();
          passwordController.clear();
        }
        // Navigate to the dashboard page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListPage()),
        );
      });
    } else {
      setState(() {
        loginMessage = 'Login Failed'; // Error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        // brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery
              .of(context)
              .size
              .height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Log In",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Login to your account ",
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
              ),

              Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: emailError,
                    ),
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: passwordError,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              SizedBox(height: 16),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed:
                    login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0095FF),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(loginMessage),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      ); //signup screen
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget inputFile({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black87
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0,
                  horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),

              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey,)
              )
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}

