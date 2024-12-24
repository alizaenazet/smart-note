part of 'pages.dart';
// Adjust the path as necessary

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int ongoingTasksCount = 0;
  int _selectedIndex = 0;
  late Auth0 auth0;
  DashboardViewModel dashboardViewModel = DashboardViewModel();
  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-kyls15gex83xgz5e.us.auth0.com',
        'DQBYRNAseJL4FpWriBhUrlqU54HumA0l');

    // TODO: CHANGE USER ID BY AUTH0 ID
    dashboardViewModel.getUserNotes("USER_001 ");
    super.initState();
  }

  Future<void> _logout() async {
    try {
      await auth0.webAuthentication(scheme: 'smartnote').logout(useHTTPS: true);

      // Navigate to the login or welcome screen
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MainView()), // Replace LoginPage with your login screen
        );
      }
    } catch (e) {
      print('Logout failed: $e'); // Handle any errors during logout
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Note> get ongoingNotes {
    if (dashboardViewModel.notes.status != Status.completed) {
      return [];
    }

    if (dashboardViewModel.notes.status == Status.completed &&
        dashboardViewModel.notes.data == []) {
      return [];
    }

    return dashboardViewModel.notes.data!
        .where((note) => note.isCompleted == false)
        .toList();
  }

  List<Note> get completedNotes {
    if (dashboardViewModel.notes.status != Status.completed) {
      return [];
    }

    if (dashboardViewModel.notes.status == Status.completed &&
        dashboardViewModel.notes.data == []) {
      return [];
    }

    return dashboardViewModel.notes.data!
        .where((note) => note.isCompleted == true)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.user.nickname != null)
                                  Text(
                                    'Hi ${widget.user.nickname!}',
                                    style: title,
                                  ),
                                Text(
                                  '$ongoingTasksCount tasks ongoing',
                                  style: content1,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _logout();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(8),
                                backgroundColor: primaryColor,
                              ),
                              child: ImageIcon(
                                AssetImage('assets/images/Logout.png'),
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          icon: const ImageIcon(
                            AssetImage('assets/images/Create.png'),
                            size: 35,
                          ),
                          label: const Text(
                            'Create Note',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Ongoing Tasks',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        dashboardViewModel.notes.status != Status.completed
                            ? Center(child: CircularProgressIndicator())
                            : ongoingNotes.isNotEmpty
                                ? Column(
                                    children: ongoingNotes.map((note) {
                                      return _NoteCard(
                                        note: note,
                                      );
                                    }).toList(),
                                  )
                                : Center(child: Text('No ongoing tasks')),
                        SizedBox(height: 30),
                        Text(
                          'Completed Tasks',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        dashboardViewModel.notes.status != Status.completed
                            ? Center(child: CircularProgressIndicator())
                            : ongoingNotes.isNotEmpty
                                ? Column(
                                    children: completedNotes.map((note) {
                                      return _NoteCard(
                                        note: note,
                                      );
                                    }).toList(),
                                  )
                                : Center(child: Text('No ongoing tasks')),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNote(
              note: note,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue[50]!,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              note.getIcon,
              size: 60,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    note.content!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    note.updatedAt!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
