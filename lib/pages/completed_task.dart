part of 'pages.dart';

class CompletedTask extends StatefulWidget {
  final String userId;
  final List<Note> notes;
  const CompletedTask({super.key, required this.userId, required this.notes});

  @override
  State<CompletedTask> createState() => _CompletedTaskState();
}

class _CompletedTaskState extends State<CompletedTask> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> completedTasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompletedTasks();
  }

  void _fetchCompletedTasks() {
    final List<Task> allCompletedTasks = [];
    for (var note in widget.notes) {
      allCompletedTasks.addAll(note.getCompletedTasks());
    }

    setState(() {
      completedTasks = allCompletedTasks;
      isLoading = false;
    });
  }

  List<Task> _getTasksForDay(DateTime day) {
    // Filter
    final notesForDay = widget.notes
        .where((note) => isSameDay(DateTime.parse(note.updatedAt!), day))
        .toList();

    final tasksForDay = <Task>[];
    for (var note in notesForDay) {
      tasksForDay.addAll(note.getCompletedTasks());
    }
    return tasksForDay;
  }

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay =
        _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
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
                          title: Text(task.description, style: content1),
                        )),
                  ] else
                    Text(
                      'No completed tasks for the selected date.',
                      style: content1,
                    ),
                ],
              ),
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
