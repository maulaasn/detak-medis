import 'package:detak_medis/ui/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:detak_medis/ui/theme.dart';
import 'package:detak_medis/views/auth/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true;
    });
    
    // Simulasi proses login
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      // Implementasi logika login sebenarnya
      String email = _emailController.text;
      String password = _passwordController.text;
      
      print('Email/Username: $email');
      print('Password: $password');
      
      // Navigasi ke halaman berikutnya
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => const BottomNavbar(),
      ));
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
              vertical: defaultMargin * 1.5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Logo atau Icon (optional)
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: defaultMargin * 2),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: wMainColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 40,
                      color: wMainColor,
                    ),
                  ),
                ),
                
                // Judul dan Subtitle
                Text(
                  'Welcome to Detak Medis',
                  style: blackTextStyle.copyWith(
                    fontSize: 28,
                    fontWeight: bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please login to continue',
                  style: greyTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: light,
                  ),
                ),
                SizedBox(height: defaultMargin * 2),
                
                // Form Input
                Text(
                  'Email or username',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter email or username',
                      hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: blackTextStyle.copyWith(fontWeight: regular),
                  ),
                ),
                SizedBox(height: defaultMargin),
                
                Text(
                  'Password',
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: 'At least 8 characters',
                      hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: blackTextStyle.copyWith(fontWeight: regular),
                  ),
                ),
                
                // Lupa Password
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.only(top: 8),
                  child: TextButton(
                    onPressed: () {
                      // Aksi lupa password
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot Password?',
                      style: blackTextStyle.copyWith(
                        fontSize: 13,
                        fontWeight: medium,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: defaultMargin * 2),
                
                // Tombol Login
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: wMainColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 56),
                    disabledBackgroundColor: wMainColor.withOpacity(0.6),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'LOGIN',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                ),
                SizedBox(height: defaultMargin * 1.5),
                
                // Opsi Register
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: greyTextStyle.copyWith(fontWeight: regular),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: wMainColor,
                            fontWeight: semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
