part of 'pages.dart';

class DetailNote extends StatefulWidget {
  final Note note;

  const DetailNote({super.key, required this.note});

  @override
  State<DetailNote> createState() => _DetailNoteState(note: note);
}

class _DetailNoteState extends State<DetailNote> {
  final Note note;

  _DetailNoteState({required this.note});

  DetailNoteViewModel detailNoteViewModel = DetailNoteViewModel();

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  

  List<Task> tasks = [];
  String _selectedStatus = 'Ongoing';
  String _selectedIcon = 'Gardening';


  @override
  void initState() {
    super.initState();
    _selectedStatus = note.isComplete! ? 'Completed' : 'Ongoing';
    if (note.todoList == null) {
      note.todoList = [];
    }
    detailNoteViewModel.setNote(note);
    _notesController.text = note.content ?? '';

    refreshPage();

  }

    void refreshPage() {
      // Fetch the latest note data or update the UI state
      detailNoteViewModel.setNote(note);

      // Update the text controller with the current note content
      _notesController.text = note.content ?? '';

      // Update the selected status based on the note's completion status
      setState(() {
        _selectedStatus = note.isComplete! ? 'Completed' : 'Ongoing';
      });
    }      
  

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
                        Navigator.pop(context, true);
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
                    Flexible(
                      child: Text(
                         detailNoteViewModel.note.title ?? '',
                        style: title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                    IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          // Initialize with current note title
                          TextEditingController titleController = TextEditingController(
                            text: detailNoteViewModel.note.title ?? '',
                          );

                          return AlertDialog(
                            title: Text('Edit Title'),
                            content: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter new title',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Just close the dialog without saving
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Update the actual note title
                                  detailNoteViewModel.setNoteTitle(titleController.text);
                                  Navigator.pop(context);
                                  refreshPage();
                                },
                                child: Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
                          try {
                            String? noteId =
                                detailNoteViewModel.note.id;
                            String deleteEndpoint = 'notes/$noteId';

                            await NetworkApiServices()
                                .deleteApiResponse(deleteEndpoint);

                            // pop back to dashboard
                            Navigator.of(context).pop(true);


                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Note deleted successfully')),
                            );
                          } catch (e) {
                            print('Error deleting note: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to delete note')),
                            );
                          }
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

                // Task Status
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

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _notesController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: content2,
                    decoration: InputDecoration(
                      hintText: 'Enter your notes here...',
                      hintStyle: content2.copyWith(
                          color: primaryColor.withOpacity(0.5)),
                      border: InputBorder.none,
                    ),
                    // Initial value for editing
                    onChanged: (value) {
                      detailNoteViewModel.setNoteContent(value);
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
                        value: detailNoteViewModel.note.icon,
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
                            detailNoteViewModel.setIcon(newValue!);
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
                        onPressed: detailNoteViewModel.isLoading
                        ? null
                        : () async {
                          
                            // Persist changes to the backend or database
                            await detailNoteViewModel.saveNote(note);
                            
                            if (detailNoteViewModel.error != null) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(detailNoteViewModel.error!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Note updated successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                            
                              }
                            }
                          },
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
                          // TODO: CALL API TO GENERATE TODO LIST
                          detailNoteViewModel.generateTasks();
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
                                TextEditingController taskController = TextEditingController();

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
                                      onPressed: () {
                                        setState(() {
                                    
                                          if (taskController.text.isNotEmpty) {
                                           
                                            tasks.add(Task(
                                              todo: taskController.text,
                                              isCompleted: false,
                                            ));
                                          }else{
                                            debugPrint("Task Controller Empty");
                                            // debugPrint(tasks[3].todo);
                                          }
                                        });
                                        Navigator.pop(context);
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
                      itemCount: detailNoteViewModel.note.todoList!.length,
                      // itemCount: tasks.length,
                      itemBuilder: (context, index) {
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
                              IconButton(
                                icon: Icon(
                                  detailNoteViewModel
                                          .note.todoList![index].isCompleted!
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    detailNoteViewModel.note.todoList![index]
                                        .isCompleted = !(detailNoteViewModel
                                            .note
                                            .todoList![index]
                                            .isCompleted ??
                                        false);
                                    if (tasks.every((task) =>
                                        (task.isCompleted ?? false))) {
                                      _selectedStatus = 'Completed';
                                    } else {
                                      _selectedStatus = 'Ongoing';
                                    }
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  detailNoteViewModel
                                      .note.todoList![index].todo!,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  if (value == 'Edit') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController editController =
                                            TextEditingController(
                                          text: detailNoteViewModel
                                              .note.todoList![index].todo,
                                        );

                                        return AlertDialog(
                                          title: Text('Edit Task'),
                                          content: TextField(
                                            controller: editController,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new task name',
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Tutup dialog
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                detailNoteViewModel
                                                    .updateTask();
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (value == 'Delete') {
                                    setState(() {
                                      tasks.removeAt(index);
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
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

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
