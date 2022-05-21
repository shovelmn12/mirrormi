import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:loading_animation_widget/loading_animation_widget.dart';

// List<CameraDescription> _cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'MirrorMe',
        locale: Locale('he', 'IL'),
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final _controller = PageController();

  // final _camera = CameraController(
  //   _cameras[0],
  //   ResolutionPreset.max,
  // );

  @override
  void initState() {
    // _camera.initialize().then((_) {
    //   if (!mounted) {
    //     return;
    //   }
    //
    //   setState(() {});
    // }).catchError((Object e) {
    //   if (e is CameraException) {
    //     switch (e.code) {
    //       case 'CameraAccessDenied':
    //         print('User denied camera access.');
    //         break;
    //       default:
    //         print('Handle other errors.');
    //         break;
    //     }
    //   }
    // });

    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    // if (!_camera.value.isInitialized) {
    //   return;
    // }

    // if (state == AppLifecycleState.inactive) {
    // _camera.dispose();
    // } else if (state == AppLifecycleState.resumed) {
    // onNewCameraSelected(_camera.description);
    // }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => BottomNavigationBar(
                  currentIndex: _controller.page?.round() ?? 0,
                  onTap: (index) => _controller.animateToPage(
                    index,
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    curve: Curves.easeInOut,
                  ),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.analytics_outlined),
                      label: 'אנליטיקה',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_outlined),
                      label: 'צט',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings_accessibility_outlined),
                      label: 'הגדרות',
                    ),
                  ],
                )),
        body: SafeArea(
          child: Stack(
            children: [
              // Opacity(
              //   opacity: .2,
              //   child: CameraPreview(_camera),
              // ),
              PageView.builder(
                controller: _controller,
                itemCount: 2,
                onPageChanged: (index) => _controller.animateToPage(
                  index,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  curve: Curves.easeInOut,
                ),
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const AnalyzerPage();

                    case 1:
                      return const ChatPage();
                  }

                  return Text('$index');
                },
              ),
            ],
          ),
        ),
      );
}

class AnalyzerPage extends StatefulWidget {
  const AnalyzerPage({Key? key}) : super(key: key);

  @override
  State<AnalyzerPage> createState() => _AnalyzerPageState();
}

class _AnalyzerPageState extends State<AnalyzerPage> {
  bool _isLoading = false;
  bool _doneAnalyzing = false;

  @override
  Widget build(BuildContext context) => Center(
        child: _doneAnalyzing
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text.rich(
                      TextSpan(
                        text: 'התוכן שהוכנס כולל',
                        children: [
                          TextSpan(
                            text: ' איום ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(בעזיבה),',
                          ),
                          TextSpan(
                            text: ' רגישות יתר ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(בעזיבה),',
                          ),
                          TextSpan(
                            text: ' רגישות יתר ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(בגלל כלים לא עוזבים),',
                          ),
                          TextSpan(
                            text: ' הקטנה\\התעמרות ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(את רק מקלקלת),',
                          ),
                          TextSpan(
                            text: ' התקרבנות ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(הוא רק מטפח),',
                          ),
                          TextSpan(
                            text: ' ושליטה ',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          TextSpan(
                            text: '(ציווי להתאפסות).',
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _isLoading = false;
                      _doneAnalyzing = false;
                    }),
                    child: const Text('סרוק קובץ נוסף'),
                  ),
                ],
              )
            : _isLoading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('שניה אחת, מימי מעבדת את הנתונים'),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator(),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final file = await FilePicker.platform.pickFiles();

                      // if (file?.files.isEmpty ?? true) {
                      //   return;
                      // }

                      setState(() => _isLoading = true);

                      await Future.delayed(const Duration(seconds: 2));

                      setState(() => _doneAnalyzing = true);
                    },
                    child: const Text('ייבא'),
                  ),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Chat(
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
