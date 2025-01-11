part of 'pages.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-kyls15gex83xgz5e.us.auth0.com', 'DQBYRNAseJL4FpWriBhUrlqU54HumA0l');
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
   body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/CircleBg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/SplashIcon.png',
                  width: 250,
                  height: 250,
                ),
                SizedBox(height: 20),
                Text(
                  'Smart Note',
                  style: splashTitle
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: Text(
                    'This productive tool is designed to help you better manage your task project-wise conveniently using auto-generated To-Do list!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                SizedBox(height: 50),
                if (_credentials == null)
                ElevatedButton(
                   onPressed: () async {
                  final credentials = await auth0.webAuthentication(scheme: 'smartnote').login(useHTTPS: true);

                  final userId = credentials.user.sub; 
                  setState(() {
                    _credentials = credentials;
                  });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => 
                        Dashboard(user:_credentials!.user),
                      ),
                    );
                },
                 style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Let's start",
                        style: content3,
                      ),
                   
                      Image.asset(
                        'assets/images/ArrowRight.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
