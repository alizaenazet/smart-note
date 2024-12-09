part of 'pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key, required this.user}) : super(key: key);

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (user.nickname!= null) Text(user.nickname!),
        if (user.email != null) Text(user.email!)
      ],
    );
  }
}