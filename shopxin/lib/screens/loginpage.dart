import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/HttpException.dart';
import 'package:shop_app/provider/authProvider.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.screenSize);
  final Size screenSize;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool hidePassword = true;
  bool isSignUp = false;
  int selected = 1;
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  final _passwordController = TextEditingController();
  Map<String, String> authData = {
    'email': '',
    'password': '',
    'fName': '',
    'lName': '',
  };

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.pink.shade700;
    }
    return Colors.pink;
  }

  _showError(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('An Error Occured!'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    try {
      if (isSignUp) {
        await Provider.of<AuthProvider>(context, listen: false).signup(
            authData['email']!,
            authData['password']!,
            authData['fName']!,
            authData['lName']!,
            selected);
      } else {
        await Provider.of<AuthProvider>(context, listen: false).login(
          authData['email']!,
          authData['password']!,
        );
      }
    } on HttpException catch (error) {
      _showError(error.msg);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: widget.screenSize.height,
        width: widget.screenSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    // Colors.blueAccent,
                    Colors.cyan.withOpacity(0.4),
                    Color(0xFF0D47A1),
                  ]
                : [
                    Colors.purple,
                    Colors.blue,
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 350,
                  padding: const EdgeInsets.all(8),
                  height: isSignUp
                      ? widget.screenSize.width > 960
                          ? widget.screenSize.height * 0.85
                          : widget.screenSize.height * 0.7
                      : widget.screenSize.width > 960
                          ? widget.screenSize.height * 0.6
                          : widget.screenSize.height * 0.5,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 40),
                            child: Text(
                              isSignUp ? 'Sign Up' : 'LOGIN',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ),
                          AnimatedContainer(
                            height: isSignUp ? 50 : 0,
                            duration: Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black54
                                          : Colors.grey[300],
                                      child: TextFormField(
                                        validator: isSignUp
                                            ? (value) {
                                                if (value!.isEmpty) {
                                                  return 'Invalid!';
                                                }
                                              }
                                            : null,
                                        onSaved: (newValue) {
                                          authData['fName'] =
                                              newValue.toString();
                                        },
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                            hintText: 'First Name'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black54
                                          : Colors.grey[300],
                                      child: TextFormField(
                                        validator: isSignUp
                                            ? (value) {
                                                if (value!.isEmpty) {
                                                  return 'Invalid!';
                                                }
                                              }
                                            : null,
                                        onSaved: (newValue) {
                                          authData['lName'] =
                                              newValue.toString();
                                        },
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                            hintText: 'Last Name'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (isSignUp)
                            Container(
                              height: 50,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black54
                                  : Colors.grey[300],
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: DropdownButtonFormField(
                                items: [
                                  DropdownMenuItem(
                                    child: Text('Buyer'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Seller'),
                                    value: 0,
                                  ),
                                ],
                                value: selected,
                                onChanged: isSignUp
                                    ? (value) {
                                        setState(() {
                                          selected =
                                              int.parse(value.toString());
                                        });
                                      }
                                    : null,
                                dropdownColor: Colors.grey[300],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black54
                                    : Colors.grey[300]),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    !value.contains('@') ||
                                    !value.endsWith('.com'))
                                  return 'Invalid email';
                              },
                              onSaved: (newValue) {
                                authData['email'] = newValue.toString();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                ),
                                hintText: 'Email',
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black54
                                    : Colors.grey[300]),
                            child: TextFormField(
                              obscureText: hidePassword,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.length < 6)
                                  return 'Password too short';
                              },
                              onSaved: (newValue) {
                                authData['password'] = newValue.toString();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                ),
                                focusColor: Colors.grey,
                                suffixIcon: GestureDetector(
                                    onTapDown: (details) {
                                      setState(() {
                                        hidePassword = false;
                                      });
                                    },
                                    onTapUp: (details) {
                                      setState(() {
                                        hidePassword = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.visibility,
                                      color: Colors.grey.shade600,
                                    )),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: isSignUp ? 50 : 0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black54
                                    : Colors.grey[300]),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: TextFormField(
                                obscureText: hidePassword,
                                validator: isSignUp
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                      }
                                    : null,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15),
                                  border: InputBorder.none,
                                  prefixIcon: !isSignUp
                                      ? null
                                      : Icon(
                                          Icons.lock_outline,
                                        ),
                                  focusColor: Colors.grey,
                                  suffixIcon: GestureDetector(
                                    onTapDown: (details) {
                                      setState(() {
                                        hidePassword = false;
                                      });
                                    },
                                    onTapUp: (details) {
                                      setState(() {
                                        hidePassword = true;
                                      });
                                    },
                                    child: !isSignUp
                                        ? null
                                        : Icon(
                                            Icons.visibility,
                                            color: Colors.grey.shade600,
                                          ),
                                  ),
                                  hintText: 'Confirm Password',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            height: 50,
                            child: ElevatedButton(
                              onPressed: submit,
                              child: Container(
                                child: Center(
                                  child: Text(
                                    isSignUp ? 'Sign Up' : 'LOGIN',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(getColor),
                              ),
                            ),
                          ),
                          // Flexible(
                          //   fit: FlexFit.loose,
                          //   child: SizedBox(),
                          // ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isSignUp
                                      ? 'Already a member?'
                                      : 'Not a member?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isSignUp = !isSignUp;
                                    });
                                    if (isSignUp) {
                                      _controller.forward();
                                    } else {
                                      _controller.reverse();
                                    }
                                  },
                                  child: Text(
                                    isSignUp ? ' Login' : ' Sign up now',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationStyle:
                                          TextDecorationStyle.dotted,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
}
