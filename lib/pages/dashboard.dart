part of 'pages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int ongoingTasksCount = 0;
  List<Note> notes = [];
  Credentials? _credentials;
  late NoteService _noteService;
  int _selectedIndex = 0;
  String? userId; // Will store the user's ID

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-kyls15gex83xgz5e.us.auth0.com',
        'DQBYRNAseJL4FpWriBhUrlqU54HumA0l');
    _noteService = NoteService();
    _fetchNotes();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // Navigate to CompletedTask
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompletedTask(user: widget.user, notes: notes),
        ),
      );
    }
  }

  Future<void> _fetchNotes() async {
    if (userId != null) {
      try {
        final fetchedNotes = await _noteService.fetchNotes(userId!);
        setState(() {
          notes =
              fetchedNotes.map((noteJson) => Note.fromJson(noteJson)).toList();
          ongoingTasksCount = notes.length;
        });
      } catch (e) {
        print("Error fetching notes: $e");
      }
    }
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
          MaterialPageRoute(
              builder: (context) =>
                  const MainView()), // Replace LoginPage with your login screen
        );
      }
    } catch (e) {
      print('Logout failed: $e'); // Handle any errors during logout
    }
  }

  List<Note> get ongoingNotes {
    return notes
        .where((note) => note.tasks.any((task) => task.isFinished == false))
        .toList();
  }

  List<Note> get completedNotes {
    return notes
        .where((note) => note.tasks.any((task) => task.isFinished == true))
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailNote(user: widget.user),
                              ),
                            );
                          },
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
                          icon: ImageIcon(
                            AssetImage('assets/images/Create.png'),
                            size: 35,
                          ),
                          label: Text(
                            'Create Note',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 30),
                        Text(
                          'Ongoing Task',
                          style: title,
                        ),
                        SizedBox(height: 20),
                        ongoingNotes.isNotEmpty
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
                        completedNotes.isNotEmpty
                            ? Column(
                                children: completedNotes.take(5).map((note) {
                                  return _NoteCard(
                                    note: note,
                                  );
                                }).toList(),
                              )
                            : Center(child: Text('No completed tasks')),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_rounded),
            label: 'Completed Tasks',
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final Note note;

  const _NoteCard({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: note.isComplete
            ? Colors.green[50]!
            : Colors.blue[50]!, // Color based on task completion
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            Icons.note,
            size: 60,
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  note.updatedAt,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${note.tasks.where((task) => task.isFinished).length} / ${note.tasks.length} tasks completed',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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
