part of 'pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-kyls15gex83xgz5e.us.auth0.com', 'DQBYRNAseJL4FpWriBhUrlqU54HumA0l');
  }

  Future<void> _logout() async {
    try {
      await auth0.webAuthentication(scheme: 'smartnote').logout(useHTTPS: true);
      setState(() {
        _credentials = null;
      });

      // Navigate to the login or welcome screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainView()), // Replace LoginPage with your login screen
        );
      }
    } catch (e) {
      print('Logout failed: $e'); // Handle any errors during logout
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.user.nickname != null)
                        Text(
                          'Hi ${widget.user.nickname!}', // Use widget.user for StatefulWidget properties
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const Text(
                        '06 Tasks remaining',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(), // Adds space between the columns
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: _logout,
                        child: const Text("Log out"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}