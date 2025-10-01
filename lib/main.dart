import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FadingTextAnimation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  const FadingTextAnimation({super.key});

  @override
  State<FadingTextAnimation> createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isTextVisible = true;
  final TextEditingController _textController =
      TextEditingController(text: 'Hello, Flutter!');

  bool _isImageVisible = true; 
  bool _isRotated = false; 
  bool _frameOn = true; 

  double _durationSeconds = 1.0;
  Curve _selectedCurve = Curves.easeInOut;

  final Map<String, Curve> _curvesMap = {
    'easeInOut': Curves.easeInOut,
    'linear': Curves.linear,
    'easeIn': Curves.easeIn,
    'easeOut': Curves.easeOut,
    'bounceIn': Curves.bounceIn,
    'elasticOut': Curves.elasticOut,
  };

  final String _imageUrl =
      'https://flutter.dev/images/catalog-widget-placeholder.png';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _toggleTextVisibility() {
    setState(() {
      _isTextVisible = !_isTextVisible;
    });
  }

  void _toggleImageVisibility() {
    setState(() {
      _isImageVisible = !_isImageVisible;
    });
  }

  void _toggleRotation() {
    setState(() {
      _isRotated = !_isRotated;
    });
  }

  void _toggleFrame(bool value) {
    setState(() {
      _frameOn = value;
    });
  }

  void _setCurve(String key) {
    setState(() {
      _selectedCurve = _curvesMap[key] ?? Curves.easeInOut;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Duration animationDuration =
        Duration(milliseconds: (_durationSeconds * 1000).round());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Text & Image Playground'),
        actions: [
          IconButton(
            tooltip: 'Toggle text visibility',
            icon: const Icon(Icons.text_fields),
            onPressed: _toggleTextVisibility,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _isTextVisible ? 1.0 : 0.0,
              duration: animationDuration,
              curve: _selectedCurve,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  _textController.text,
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Text content',
                        hintText: 'Type new text and press Update',
                      ),
                      onSubmitted: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Update Text'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _toggleTextVisibility,
                          icon: const Icon(Icons.visibility),
                          label: const Text('Toggle Text'),
                        ),
                        const Spacer(),
                        Text('Duration: ${_durationSeconds.toStringAsFixed(2)}s'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text('Rounded image (frame ${_frameOn ? "ON" : "OFF"})'),
            const SizedBox(height: 8),
            AnimatedOpacity(
              opacity: _isImageVisible ? 1.0 : 0.0,
              duration: animationDuration,
              curve: _selectedCurve,
              child: AnimatedRotation(
                turns: _isRotated ? 1.0 : 0.0,
                duration: animationDuration,
                curve: _selectedCurve,
                child: Container(
                  decoration: BoxDecoration(
                    border: _frameOn
                        ? Border.all(color: Colors.blueAccent, width: 4)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Frame'),
                        const SizedBox(width: 8),
                        Switch(
                          value: _frameOn,
                          onChanged: _toggleFrame,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _toggleImageVisibility,
                          child: const Text('Toggle Image Fade'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _toggleRotation,
                          child: const Text('Toggle Rotate'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Rotate animation:'),
                        const SizedBox(width: 8),
                        Text(_isRotated ? '1 turn' : '0 turns'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Duration'),
                        Expanded(
                          child: Slider(
                            min: 0.1,
                            max: 3.0,
                            divisions: 29,
                            value: _durationSeconds,
                            onChanged: (v) {
                              setState(() {
                                _durationSeconds = v;
                              });
                            },
                          ),
                        ),
                        Text('${_durationSeconds.toStringAsFixed(2)}s'),
                      ],
                    ),

                    Row(
                      children: [
                        const Text('Curve:'),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _curvesMap.entries
                              .firstWhere((e) => e.value == _selectedCurve,
                                  orElse: () => _curvesMap.entries.first)
                              .key,
                          items: _curvesMap.keys
                              .map(
                                (k) => DropdownMenuItem<String>(
                                  value: k,
                                  child: Text(k),
                                ),
                              )
                              .toList(),
                          onChanged: (selected) {
                            if (selected != null) _setCurve(selected);
                          },
                        ),
                        const Spacer(),
                        Text('Selected: ${_curvesMap.entries.firstWhere((e) => e.value == _selectedCurve).key}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              margin: const EdgeInsets.only(bottom: 24),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text('Extra interactive demo'),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _isTextVisible = !_isTextVisible;
                              _isImageVisible = !_isImageVisible;
                            });
                          },
                          icon: const Icon(Icons.flip),
                          label: const Text('Flip Both'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _durationSeconds = 0.25;
                            });
                          },
                          icon: const Icon(Icons.speed),
                          label: const Text('Quick Pulse'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try changing things to see the effects.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Toggle text',
        onPressed: _toggleTextVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
