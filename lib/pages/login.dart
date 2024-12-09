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
    appBar: AppBar(
      title: const Text('Smart Note'),
      backgroundColor: const Color.fromARGB(255, 178, 168, 210),
    ),
    body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center( // Wraps the Column to center it vertically and horizontally
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers children vertically
          children: <Widget>[
            const Text(
              "Smart Note",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "This productive tool is designed to help you better manage your task project-wise conveniently using auto generated To-Do list",
              textAlign: TextAlign.center, // Optional for better text alignment
            ),
            if (_credentials == null)
              ElevatedButton(
                onPressed: () async {
                  final credentials = await auth0.webAuthentication(scheme: 'smartnote').login(useHTTPS: true);
                  setState(() {
                    _credentials = credentials;
                  });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(user:_credentials!.user), // Replace with your target page
                      ),
                    );
                },
                child: const Text("Let's Start"),
              )
          ],
        ),
      ),
    ),
  );
}
}