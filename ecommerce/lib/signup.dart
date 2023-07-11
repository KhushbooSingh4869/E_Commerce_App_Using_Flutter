import 'package:ecommerce/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String registerMessage = '';
  String firstNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

  void register() async {
    String firstName = firstNameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Perform input validation (you may need to adjust the validation rules)

    if (firstName.isEmpty) {
      setState(() {
        firstNameError = 'First Name is Required';
      });
      return;
    }

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

    if (confirmPassword != password) {
      setState(() {
        confirmPasswordError = 'Confirm Password does not Match !!!!';
      });
      return;
    }
    else {
    confirmPasswordError = 'Password Matched.';
    }

    // Perform HTTP request to register the user
    var url = "http://192.168.140.249/singup_login/register.php";
    var response = await http.post(Uri.parse(url),
        body: {
      'first_name': firstName,
      'email': email,
      'password': password,
      'cpassword': confirmPassword,
    });

    if (response.statusCode == 200) {
      setState(() {
        registerMessage = response.body; // Success message from PHP script
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        registerMessage = 'Registration Failed'; // Error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        //brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height - 50,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Sign up",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Create an account, It's free ",
              style: TextStyle(fontSize: 15, color: Colors.grey[700]),
            ),

            Column(
              children: [
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    errorText: firstNameError,
                  ),
                ),
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
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: confirmPasswordError,
                  ),
                  obscureText: true,
                ),
              ],
            ),
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
                    register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0095FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Sign up",
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
            Text(registerMessage),
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
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
      SizedBox(
        height: 10,
      )
    ],
  );
}
}

