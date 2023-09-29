import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // form key
  final _formKey = GlobalKey<FormState>();

  //firebase
  final _auth = FirebaseAuth.instance;

  //editting controllers
  final userNameController = new TextEditingController();
  final emailAddressController = new TextEditingController();
  final residentialAddressController = new TextEditingController();
  final phoneNumberController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //userName field
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$'); //entering minimum value 3
        if (value!.isEmpty) {
          return ("User Name Is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid User Name (Min. 3 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        userNameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailAddressController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //reg exression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter valid Email");
        }
        return null;
      },
      onSaved: (value) {
        emailAddressController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //residentialAddress field
    final residentialAddressField = TextFormField(
      autofocus: false,
      controller: residentialAddressController,
      keyboardType: TextInputType.streetAddress,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$'); //entering minimum value 3
        if (value!.isEmpty) {
          return ("Residential Address Is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Address (Min. 3 Characters)");
        }
        return null;
      },
      onSaved: (value) {
        residentialAddressController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.pin_drop),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Residential Address",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //phoneNo field
    final phoneNumberField = TextFormField(
      autofocus: false,
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{10,}$'); //entering minimum value 10
        if (value!.isEmpty) {
          return ("Mobile Number Is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Mobile Number (Min. 10 Characters)");
        }
      },
      onSaved: (value) {
        phoneNumberController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.phone),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Mobile Number",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //Password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$'); //entering minimum value 6
        if (value!.isEmpty) {
          return ("Password Is Required");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Characters)");
        }
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    //ConfirmPAssword field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return "Password Don't Match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    ///signup button
    final signUpButton = Material(
      elevation: 5,
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailAddressController.text, passwordController.text);
        },
        child: const Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 130,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    userNameField,
                    const SizedBox(
                      height: 20,
                    ),
                    emailField,
                    const SizedBox(
                      height: 20,
                    ),
                    residentialAddressField,
                    const SizedBox(
                      height: 20,
                    ),
                    phoneNumberField,
                    const SizedBox(
                      height: 20,
                    ),
                    passwordField,
                    const SizedBox(
                      height: 20,
                    ),
                    confirmPasswordField,
                    const SizedBox(
                      height: 40,
                    ),
                    signUpButton,
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.redAccent),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailToFirestore() async {
    //calling firebase
    //calling user model
    // sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writting all the values
    userModel.emailAddress = user!.email;
    userModel.uid = user.uid;
    userModel.userName = userNameController.text;
    userModel.residentialAddress = residentialAddressController.text;
    userModel.phoneNumber = phoneNumberController.text;
    userModel.password = passwordController.text;

    //creating new collection in firestore
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully !");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
        (route) => false);
  }
}
