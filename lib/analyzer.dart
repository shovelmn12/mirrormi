import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

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
