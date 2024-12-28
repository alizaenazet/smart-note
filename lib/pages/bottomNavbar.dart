part of 'pages.dart';

class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;
  final dynamic user;
  final List<Note> notes;

  const BottomNavBarWidget({
    Key? key,
    required this.currentIndex,
    required this.onItemTapped,
    required this.user,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        onItemTapped(index);
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(user: user),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CompletedTask(user: user, notes: notes),
            ),
          );
        }
      },
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_rounded),
          label: 'Completed Tasks',
        ),
      ],
    );
  }
}

