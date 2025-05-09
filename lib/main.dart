import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoScreen(),
    ),
  );
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> todos = [];  // 빈 리스트로 초기화
  final _controller = TextEditingController();

  void _showBottomSheet({int? index}) {
    if (index != null) _controller.text = todos[index]['text'];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, 
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '할일',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '할일을 입력하세요',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 140), // 간격을 늘림
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE), // 진한 파란색/보라색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {
                      if (index == null) {
                        todos.add({
                          'text': _controller.text,
                          'checked': false,
                        });
                      } else {
                        todos[index]['text'] = _controller.text;
                      }
                    });
                    _controller.clear();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  '저장',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('TODO 리스트', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Divider(height: 1, color: Color.fromARGB(80, 158, 158, 158)),
        ),
      ),
      body: todos.isEmpty 
          ? const Center(
              child: Text(
                '할 일을 추가해보세요!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(32),
              itemCount: todos.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x1A7990F8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: todos[index]['checked'],
                          onChanged: (value) => setState(
                            () => todos[index]['checked'] = value!,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          side: const BorderSide(color: Colors.black),
                          fillColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: Text(
                          todos[index]['text'],
                          style: const TextStyle(fontSize: 16),
                          maxLines: 3,  // 여러 줄 표시 가능하도록 설정
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showBottomSheet(index: index),
                            child: const Text(
                              '수정  ',
                              style: TextStyle(
                                color: Color.fromARGB(255, 38, 0, 255),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => todos.removeAt(index)),
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                color: Color.fromARGB(255, 38, 0, 255),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 4, 0, 255),
        onPressed: () => _showBottomSheet(),
        shape: const CircleBorder(), // 완전 동그란 모양으로 설정
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}