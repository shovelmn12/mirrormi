import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

List<CameraDescription> _cameras = <CameraDescription>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'MirrorMe',
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
  final _camera = CameraController(
    _cameras[0],
    ResolutionPreset.max,
  );

  @override
  void initState() {
    _camera.initialize().then((_) {
      if (!mounted) {
        return;
      }

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });

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
    if (!_camera.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _camera.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // onNewCameraSelected(_camera.description);
    }
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
              Opacity(
                opacity: .2,
                child: CameraPreview(_camera),
              ),
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('הכל מצויין'),
                      Icon(Icons.face_outlined),
                    ],
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
                      Text('סורק את המידע'),
                      SizedBox(
                        height: 16,
                      ),
                      CircularProgressIndicator(),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () async {
                      final file = await FilePicker.platform.pickFiles();

                      if (file?.files.isEmpty ?? true) {
                        return;
                      }

                      setState(() => _isLoading = true);

                      await Future.delayed(const Duration(seconds: 2));

                      setState(() => _doneAnalyzing = true);
                    },
                    child: const Text('ייבא'),
                  ),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Chat(
        user: const types.User(
          id: 'user',
        ),
        messages: const [],
        onSendPressed: (text) {},
      );
}
