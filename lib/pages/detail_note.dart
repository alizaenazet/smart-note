part of 'pages.dart';

class DetailNote extends StatefulWidget {
  final UserProfile user;
  final String? noteId;

  const DetailNote({Key? key, required this.user, this.noteId}) : super(key: key);

  @override
  State<DetailNote> createState() => _DetailNoteState();
}

class _DetailNoteState extends State<DetailNote> {
  final NoteService _noteService = NoteService();
  List<dynamic> notes = [];
  List<Task> tasks = [];
  String _selectedStatus = 'Ongoing';
  late Note currentNote;

  final List<Map<String, dynamic>> iconCategories = [
    {'name': 'Gardening', 'icon': Icons.local_florist},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Cooking', 'icon': Icons.restaurant},
    {'name': 'Work', 'icon': Icons.work},
    {'name': 'Study', 'icon': Icons.school},
    {'name': 'Travel', 'icon': Icons.flight},
    {'name': 'Shopping', 'icon': Icons.shopping_cart},
    {'name': 'Health', 'icon': Icons.favorite},
    {'name': 'Finance', 'icon': Icons.attach_money},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.noteId != null) {
      _fetchNote(widget.noteId!);
    } else {
      _initializeNewNote();
    }
  }

  void _fetchNote(String noteId) async {
    try {
      final fetchedNotes = await _noteService.fetchNotes(widget.user.sub);
      final fetchedNote = fetchedNotes.firstWhere((note) => note['id'] == noteId);
      setState(() {
        currentNote = Note.fromJson(fetchedNote);
        tasks = currentNote.tasks;
        _selectedStatus = currentNote.isComplete ? 'Completed' : 'Ongoing';
      });
    } catch (e) {
      print("Error fetching note: $e");
    }
  }

  void _initializeNewNote() {
    setState(() {
      currentNote = Note(
        id: DateTime.now().toString(),
        title: "",
        content: "",
        updatedAt: DateTime.now().toString(),
        isComplete: false,
        tasks: [],
        icon: 'Gardening',
      );
    });
  }

  Future<void> _saveNote() async {
    try {
      currentNote.isComplete = _selectedStatus == 'Completed';

      if (widget.noteId == null) {
        // Create new note
        await _noteService.createNote(widget.user.sub, currentNote.title, currentNote.content);
      } else {
        // Update existing note
        await _noteService.editNote(
          currentNote.id,
          currentNote.title,
          currentNote.content,
        );
      }
      Navigator.pop(context); 
    } catch (e) {
      print("Error saving note: $e");
    }
  }

  Future<void> _deleteNote() async {
    try {
      await _noteService.deleteNote(currentNote.id);
      Navigator.pop(context);
    } catch (e) {
      print("Error deleting note: $e");
    }
  }

  Future<void> _createTask(String taskText) async {
    try {
      Task newTask = await _noteService.createTask(currentNote.id, taskText);
      setState(() {
        tasks.add(newTask);
      });
    } catch (e) {
      print("Error creating task: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(8),
                        backgroundColor: primaryColor,
                      ),
                      child: ImageIcon(
                        AssetImage('assets/images/ArrowLeft.png'),
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: currentNote.title),
                        style: title,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter note title',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            currentNote.title = value;
                          });
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Note'),
                              content: Text(
                                  'Are you sure you want to delete this note?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm == true) {
                          await _deleteNote();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(8),
                        backgroundColor: primaryColor,
                      ),
                      child: ImageIcon(
                        AssetImage('assets/images/Delete.png'),
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Task Status Dropdown
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Task Status',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedStatus,
                        icon: ImageIcon(
                          AssetImage('assets/images/ArrowDown.png'),
                          size: 24,
                          color: primaryColor,
                        ),
                        isExpanded: true,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue!;
                          });
                        },
                        items: <String>['Ongoing', 'Completed']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Notes Text Field
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: content2,
                    decoration: InputDecoration(
                      hintText: 'Enter your notes here...',
                      hintStyle: content2.copyWith(
                          color: primaryColor.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      currentNote.content = text;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Icon Selection
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0.8,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose Icon',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      DropdownButton<String>(
                        value: currentNote.icon,
                        icon: ImageIcon(
                          AssetImage('assets/images/ArrowDown.png'),
                          size: 24,
                          color: primaryColor,
                        ),
                        isExpanded: true,
                        elevation: 16,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        underline: Container(
                          height: 0,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            currentNote.icon = newValue!;
                          });
                        },
                        items: iconCategories.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> category) {
                          return DropdownMenuItem<String>(
                            value: category['name'],
                            child: Row(
                              children: [
                                Icon(category['icon'], color: primaryColor),
                                SizedBox(width: 10),
                                Text(category['name']),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Save and Generate buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: _saveNote,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save, size: 25, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Save',
                              style: content3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    // Generate button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          // Implement generate functionality
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageIcon(
                              AssetImage('assets/images/Generate2.png'),
                              size: 25,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Generate',
                              style: content3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // To Do List Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('To Do List', style: title),
                            SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                              padding: EdgeInsets.all(8),
                              child: ImageIcon(
                                AssetImage('assets/images/List.png'),
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Show a dialog to input a new task
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                TextEditingController taskController =
                                    TextEditingController();

                                return AlertDialog(
                                  title: Text('Add New Task'),
                                  content: TextField(
                                    controller: taskController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter task name',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (taskController.text.isNotEmpty) {
                                          await _createTask(taskController.text);
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Text('Add'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(8),
                            backgroundColor: primaryColor,
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // To Do List Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Container(
                          margin: EdgeInsets.only(bottom: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Check/Uncheck button
                              IconButton(
                                icon: Icon(
                                  task.isFinished
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: primaryColor,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    task.isFinished = !task.isFinished;
                                  });

                                  try {
                                    await _noteService.updateTask(
                                      currentNote.id,
                                      task.id,
                                      task.isFinished,
                                    );
                                    if (tasks.every((task) => task.isFinished)) {
                                      _selectedStatus = 'Completed';
                                    } else {
                                      _selectedStatus = 'Ongoing';
                                    }
                                  } catch (e) {
                                    print("Error updating task: $e");
                                  }
                                },
                              ),

                              // Task description
                              Expanded(
                                child: Text(
                                  task.text,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                              // Edit/Delete menu
                              PopupMenuButton<String>(
                                onSelected: (String value) async {
                                  if (value == 'Edit') {
                                    await _showEditTaskDialog(context, index, task.text);
                                  } else if (value == 'Delete') {
                                    bool? confirm = await _showDeleteConfirmationDialog(context);
                                    if (confirm == true) {
                                      try {
                                        await _deleteTask(currentNote.id, task.id);
                                        setState(() {
                                          tasks.removeAt(index);
                                        });
                                      } catch (e) {
                                        print("Error deleting task: $e");
                                      }
                                    }
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'Edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: primaryColor),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, color: primaryColor),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                icon: Icon(
                                  Icons.more_vert_rounded,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTask(String noteId, String taskId) async {
    try {
      await _noteService.deleteTask(noteId, taskId);
    } catch (e) {
      print("Error deleting task: $e");
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditTaskDialog(BuildContext context, int index, String currentText) async {
    TextEditingController editController = TextEditingController(text: currentText);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'Enter new task text',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  try {
                    await _noteService.updateTask(
                      currentNote.id,
                      tasks[index].id,
                      tasks[index].isFinished,
                      // editController.text,
                    );
                    setState(() {
                      tasks[index].text = editController.text;
                    });
                    Navigator.pop(context);
                  } catch (e) {
                    print("Error updating task: $e");
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

