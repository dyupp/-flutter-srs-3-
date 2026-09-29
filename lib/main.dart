import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

// Вспомогательная функция для вызова Toast
void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 3 App',
      // Задание 7: Единый ThemeData и стили
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),
      home: const MainTabScreen(),
    );
  }
}

// Задание 1 & 8: Главный экран с TabBar, Drawer и FloatingActionButton
class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  // Список для ListView (минимум 10 элементов)
  final List<Map<String, String>> _items = List.generate(
    10,
    (index) => {
      'title': 'Товар №${index + 1}',
      'subtitle': 'Описание характеристик товара №${index + 1}',
    },
  );

  // Состояние цветов элементов GridView (минимум 6 элементов)
  final List<bool> _gridToggled = List.generate(6, (_) => false);

  // Контроллер для ввода нового элемента через AlertDialog
  final TextEditingController _dialogController = TextEditingController();

  // Дополнительное задание ⭐: Диалог добавления нового элемента в список
  void _showAddItemDialog() {
    _dialogController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Добавить товар'),
        content: TextField(
          controller: _dialogController,
          decoration: const InputDecoration(
            labelText: 'Название товара',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_dialogController.text.trim().isNotEmpty) {
                setState(() {
                  _items.add({
                    'title': _dialogController.text.trim(),
                    'subtitle': 'Пользовательский товар',
                  });
                });
                Navigator.pop(ctx);
                showToast('Элемент добавлен в список');
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dialogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мое приложение'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Список'),
              Tab(icon: Icon(Icons.grid_view), text: 'Сетка'),
            ],
          ),
        ),

        // Задание 5: Боковое меню Drawer
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text('Студент Flutter'),
                accountEmail: Text('student@flutter.dev'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.teal),
                ),
                decoration: BoxDecoration(color: Colors.teal),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('🏠 Главная'),
                onTap: () {
                  Navigator.pop(context); // Закрыть Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('👤 Профиль'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('⚙️ Настройки'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.style),
                title: const Text('📦 Карточки товаров'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CardsScreen()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('🚪 Выход'),
                onTap: () {
                  Navigator.pop(context);
                  showToast('Выход из аккаунта');
                },
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // Вкладка 1: ListView (Задания 1, 2)
            ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: const Icon(Icons.shopping_bag, color: Colors.teal),
                  ),
                  title: Text(
                    item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item['subtitle']!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showToast('Вы выбрали: ${item['title']}');
                  },
                );
              },
            ),

            // Вкладка 2: GridView (Задание 3)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final isToggled = _gridToggled[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _gridToggled[index] = !_gridToggled[index];
                      });
                      showToast('Элемент №${index + 1} изменен');
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: isToggled ? Colors.green : Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Дополнительное задание ⭐: Кнопка добавления в список
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddItemDialog,
          tooltip: 'Добавить элемент',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

// Задание 4: Экран "Карточки" (минимум 4 карточки)
class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  final List<Map<String, String>> products = const [
    {
      'title': 'Смартфон',
      'desc': 'Флагманский смартфон с четким OLED-экраном.',
      'icon': 'smartphone',
      'details': 'Диагональ 6.7 дюймов, батарея 5000 mAh, камера 108 Мп.'
    },
    {
      'title': 'Ноутбук',
      'desc': 'Мощный ноутбук для разработки и игр.',
      'icon': 'laptop',
      'details': 'Процессор 16 потоков, 32 ГБ RAM, SSD 1 ТБ NVMe.'
    },
    {
      'title': 'Наушники',
      'desc': 'Беспроводные наушники с шумоподавлением.',
      'icon': 'headphones',
      'details': 'Bluetooth 5.3, активный ANC, автономность до 30 часов.'
    },
    {
      'title': 'Умные часы',
      'desc': 'Фитнес-трекер с измерением пульса и шагов.',
      'icon': 'watch',
      'details': 'Влагозащита IP68, GPS, мониторинг сна и кислорода.'
    },
  ];

  IconData _resolveIcon(String name) {
    switch (name) {
      case 'smartphone':
        return Icons.smartphone;
      case 'laptop':
        return Icons.laptop;
      case 'headphones':
        return Icons.headphones;
      default:
        return Icons.watch;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карточки товаров')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final item = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      _resolveIcon(item['icon']!),
                      size: 64,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['desc']!,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(
                              title: item['title']!,
                              details: item['details']!,
                            ),
                          ),
                        );
                      },
                      child: const Text('Подробнее'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Экран подробной информации о товаре
class DetailScreen extends StatelessWidget {
  final String title;
  final String details;

  const DetailScreen({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Подробности о $title:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              details,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Экран "Профиль"
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Студент Разработчик',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'student@flutter.dev',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Задание 6: Кнопка «Показать приветствие»
              ElevatedButton(
                onPressed: () {
                  showToast('Hello, Flutter!');
                },
                child: const Text('Показать приветствие'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Экран "Настройки"
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  double _volumeLevel = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Уведомления'),
            subtitle: const Text('Получать push-сообщения'),
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
          ),
          const SizedBox(height: 16),
          Text('Громкость: ${_volumeLevel.round()}%'),
          Slider(
            min: 0,
            max: 100,
            value: _volumeLevel,
            onChanged: (val) {
              setState(() {
                _volumeLevel = val;
              });
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              showToast('Настройки сохранены');
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}