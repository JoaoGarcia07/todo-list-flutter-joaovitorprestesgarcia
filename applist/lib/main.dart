import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senac List',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          surface: const Color(0xFFFBF8FF),
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}


class Tarefa {
  String titulo;
  bool concluida;

  Tarefa({required this.titulo, this.concluida = false});
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Tarefa> _tarefas = [];
  
  final TextEditingController _controller = TextEditingController();

  int get _concluidas => _tarefas.where((t) => t.concluida).length;

  void _adicionarTarefa() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() { 
        _tarefas.add(Tarefa(titulo: _controller.text.trim()));
        _controller.clear();
      });
    }
  }

  void _alternarTarefa(int index) {
    setState(() {
      _tarefas[index].concluida = !_tarefas[index].concluida;
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Senac Tarefas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD0BCFF), 
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFEADDFF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Progresso", 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "$_concluidas / ${_tarefas.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Color(0xFF6750A4)
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(15),
              shadowColor: Colors.black26,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'O que precisa ser feito?',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_task, color: Color(0xFF6750A4)),
                    onPressed: _adicionarTarefa,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: _tarefas.isEmpty
                ? const Center(
                    child: Text(
                      "Nenhuma tarefa por enquanto! ✨", 
                      style: TextStyle(color: Colors.black38),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: _tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = _tarefas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        color: tarefa.concluida 
                            ? const Color(0xFFF3F3F3) 
                            : const Color(0xFFE0F2F1), 
                        child: ListTile(
                          leading: Checkbox( 
                            value: tarefa.concluida,
                            onChanged: (_) => _alternarTarefa(index),
                          ),
                          title: Text(
                            tarefa.titulo,
                            style: TextStyle(
                              decoration: tarefa.concluida 
                                  ? TextDecoration.lineThrough 
                                  : TextDecoration.none,
                              color: tarefa.concluida ? Colors.grey : Colors.black87,
                            ),
                          ),
                          trailing: IconButton( 
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _removerTarefa(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}