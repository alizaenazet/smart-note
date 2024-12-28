part of 'pages.dart';
class CompletedTask extends StatefulWidget {
  final dynamic user;
  final List<Note> notes;

  const CompletedTask({super.key, required this.user, required this.notes});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> completedTasks = [];
  bool isLoading = false;
  int _selectedIndex = 1;
  late DashboardViewModel dashboardViewModel;

  @override
  void initState() {
    super.initState();
    dashboardViewModel = DashboardViewModel();
    _fetchCompletedTasks();
  }

  Future<void> _fetchCompletedTasks() async {
    setState(() {
      isLoading = true;
    });

    try {
      await dashboardViewModel.getUserNotes("USER_001");
      final notesData = dashboardViewModel.notes.data ?? [];
      List<Task> allCompletedTasks = [];
      for (var note in notesData) {
        allCompletedTasks.addAll(note.getCompletedTasks());
      }

      setState(() {
        completedTasks = allCompletedTasks;
      });
    } catch (e) {
      print('Error fetching completed tasks: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Task> _getTasksForDay(DateTime day) {
    final tasksForDay = completedTasks.where((task) {
      for (var note in widget.notes) {
        if (note.todoList != null && note.todoList!.contains(task)) {
          final noteUpdatedAt = DateTime.parse(note.updatedAt!);
          return isSameDay(noteUpdatedAt, day);
        }
      }
      return false;
    }).toList();
    return tasksForDay;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(user: widget.user),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay =
        _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Completed Tasks',
            style: title.copyWith(color: Colors.white),
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2000, 1, 1),
                      lastDay: DateTime.utc(2100, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      eventLoader: (day) => _getTasksForDay(day),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleTextStyle: title.copyWith(color: Colors.white),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        leftChevronIcon:
                            Icon(Icons.chevron_left, color: Colors.white),
                        rightChevronIcon:
                            Icon(Icons.chevron_right, color: Colors.white),
                        titleCentered: true,
                      ),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,
                        markersAlignment: Alignment.bottomCenter,
                        weekendTextStyle: content1.copyWith(
                          color: const Color.fromARGB(255, 170, 43, 34),
                        ),
                        defaultTextStyle: content1,
                        outsideDaysVisible: false,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _selectedDay != null
                        ? '${_selectedDay!.day} ${_getMonthName(_selectedDay!.month)} ${_selectedDay!.year}'
                        : 'Tasks for Today',
                    style: title,
                  ),
                  SizedBox(height: 8),
                  if (_selectedDay != null &&
                      tasksForSelectedDay.isNotEmpty) ...[
                    ...tasksForSelectedDay.map((task) => ListTile(
                          leading:
                              Icon(Icons.check_circle, color: primaryColor),
                          title: Text(task.todo ?? '', style: content1),
                        )),
                  ] else
                    Text(
                      'No completed tasks for the selected date.',
                      style: content1,
                    ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavBarWidget(
        currentIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        user: widget.user,
        notes: widget.notes,
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
