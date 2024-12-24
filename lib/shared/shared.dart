import 'package:flutter_dotenv/flutter_dotenv.dart';

class Const {
  static const String smartNoteBaseUrl =
      "https://d82387aa-a20d-4b18-8e8e-a2a610107ecd.mock.pstmn.io";
  static final String OPENAI_API_KEY = dotenv.get('OPENAI_API_KEY');
  static final String OPENAI_PROJECT_ID = dotenv.get('PROJECT_ID');
  static final String OpenAI_Organization_ID =
      dotenv.get('OpenAI-Organization');
}
