import 'package:flutter/material.dart';

// Імітація отримання інформації про користувача.
Future<String> getUser() async {
  await Future<void>.delayed(const Duration(seconds: 1));

  return 'Катерина Парейко \nkatiapar07@gmail.com';
}

// Імітація отримання списку товарів.
Future<List<String>> getProducts() async {
  await Future<void>.delayed(const Duration(seconds: 2));

  return [
    'Навушники — 1200 грн',
    'Клавіатура — 1800 грн',
    'Миша — 750 грн',
  ];
}

// Імітація отримання історії замовлень.
Future<List<String>> getOrders() async {
  await Future<void>.delayed(const Duration(seconds: 1));

  return [
    '№101: Навушники, 1 шт. — 1200 грн',
    '№102: Миша, 2 шт. — 1500 грн',
  ];
}

// Тип даних, які повертають три асинхронні операції.
typedef ShopData = (
String,
List<String>,
List<String>,
);

// Одночасний запуск і очікування всіх трьох операцій.
Future<ShopData> loadShop() async {
  return await (
  getUser(),
  getProducts(),
  getOrders(),
  ).wait;
}

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatefulWidget {
  const ShopApp({super.key});

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  late Future<ShopData> data = loadShop();

  // Повторне завантаження даних.
  void reload() {
    setState(() {
      data = loadShop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Інтернет-магазин',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff4860d8),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Інтернет-магазин'),
          actions: [
            IconButton(
              onPressed: reload,
              tooltip: 'Оновити',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: FutureBuilder<ShopData>(
          future: data,
          builder: (context, snapshot) {
            // Відображення помилки.
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Не вдалося завантажити дані',
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: reload,
                      child: const Text(
                        'Спробувати ще раз',
                      ),
                    ),
                  ],
                ),
              );
            }

            // Відображення процесу завантаження.
            if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Завантаження даних...'),
                  ],
                ),
              );
            }

            // Отримання результатів асинхронних операцій.
            final (user, products, orders) = snapshot.requireData;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Вітаємо!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Дані вашого магазину'),
                const SizedBox(height: 20),

                // Інформація про користувача.
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: const Text('Користувач'),
                    subtitle: Text(user),
                    isThreeLine: true,
                  ),
                ),

                const SizedBox(height: 20),

                // Список товарів.
                const Text(
                  'Товари',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...products.map(
                      (product) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.shopping_bag_outlined,
                      ),
                      title: Text(product),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Історія замовлень.
                const Text(
                  'Історія замовлень',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ...orders.map(
                      (order) => Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.receipt_long_outlined,
                      ),
                      title: Text(order),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Демонстраційні дані',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}