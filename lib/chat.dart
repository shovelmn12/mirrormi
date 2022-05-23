import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // insert more messages here, check [types.TextMessage]
  final List<types.Message> messages = const [
    types.TextMessage(
      id: 'bot-0',
      author: types.User(
        id: 'bot',
      ),
      text: '''הי, זאת מימי, אנחנו צריכות לדבר...
בחודשיים האחרונים הצטברו יותר מדי תמרורי אזהרה.
שנסקור אותם יחד?
''',
    ),
    types.TextMessage(
      id: 'bot-1',
      author: types.User(
        id: 'bot',
      ),
      text: '''
+-------+---------------------+-------------+
| תאריך | מהות ההתראה         | סוג תוכן    |
+-------+---------------------+-------------+
| 27.11 | הקטנה\התעמרות       | הודעה קולית |
+-------+---------------------+-------------+
| 29.11 | איום                | שיחה מוקלטת |
+-------+---------------------+-------------+
| 30.11 | "צדיק מעונה"        | הודעת טקסט  |
+-------+---------------------+-------------+
| 02.12 | רגישות קיצונית      | תמונה וטקסט |
+-------+---------------------+-------------+
| 03.12 | אובססיביות          | הודעה קולית |
+-------+---------------------+-------------+
| 06.12 | איום                | הודעת טקסט  |
+-------+---------------------+-------------+
| 08.12 | דו פרצופיות\הפכפכות | שיחה מוקלטת |
+-------+---------------------+-------------+
''',
    ),
    types.TextMessage(
      id: 'bot-2',
      author: types.User(
        id: 'bot',
      ),
      text: '''
המצב מתדרדר ואת עלולה להיות בסכנה!
אני ממליצה לך לפנות לגורמי טיפול מקצועיים
או לאחד מאנשי הקשר הבטוחים שהגדרת
לחצי על המספר לקישור ישיר:
פורום  מיכל סלה: 054-3122031
ישראלה ישראלי (חברה): 054-4445555
מוקד המידע והסיוע של משרד הרווחה: 118
''',
    ),
  ];

  bool _isLoading = false;
  int _message = 0;
  List<types.Message> _messages = const [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
        _messages = [
          messages[0],
        ];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          dateLocale: 'he-IL',
          l10n: const ChatL10nHe(),
          user: const types.User(
            id: 'bot',
          ),
          messages: _messages,
          onSendPressed: (text) {},
          customBottomWidget: Column(
            children: [
              if (_isLoading)
                LoadingAnimationWidget.waveDots(
                  color: Theme.of(context).colorScheme.primary,
                  size: 50,
                ),
              Input(
                onSendPressed: (text) async {
                  setState(() {
                    _messages = [
                      types.TextMessage(
                        author: const types.User(
                          id: 'user',
                        ),
                        id: '${_message++}-user',
                        text: text.text,
                      ),
                      ..._messages,
                    ];
                    _isLoading = true;
                  });

                  await Future.delayed(const Duration(milliseconds: 500));

                  setState(() {
                    _isLoading = false;
                    _messages = [
                      messages[_message],
                      ..._messages,
                    ];
                  });
                },
                onAttachmentPressed: () async {
                  final file = await FilePicker.platform.pickFiles();

                  print(file?.count);
                },
                sendButtonVisibilityMode: SendButtonVisibilityMode.editing,
              ),
            ],
          ),
        ),
      );
}

class ChatL10nHe extends ChatL10n {
  const ChatL10nHe()
      : super(
          attachmentButtonAccessibilityLabel: '',
          emptyChatPlaceholder: 'אין הודעות',
          fileButtonAccessibilityLabel: '',
          inputPlaceholder: 'כתוב הודעה',
          sendButtonAccessibilityLabel: '',
        );
}
