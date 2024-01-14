import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Cart',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  bool isInCart;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.isInCart = false,
  });
}

final List<Product> products = [
  Product(
    id: 'p1',
    name: 'Macbook Pro M1',
    image:
        'https://fastly.picsum.photos/id/2/5000/3333.jpg?hmac=_KDkqQVttXw_nM-RyJfLImIbafFrqLsuGO5YuHqD-qQ',
    price: 1100,
  ),
  Product(
    id: 'p2',
    name: 'Macbook Air M2',
    image:
        'https://fastly.picsum.photos/id/1/5000/3333.jpg?hmac=Asv2DU3rA_5D1xSe22xZK47WEAN0wjWeFOhzd13ujW4',
    price: 1000,
  ),
  Product(
    id: 'p3',
    name: 'Macbook Air M1',
    image:
        'https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU',
    price: 800,
  ),
  Product(
    id: 'p4',
    name: 'iPhone 5C',
    image:
        'https://fastly.picsum.photos/id/3/5000/3333.jpg?hmac=GDjZ2uNWE3V59PkdDaOzTOuV3tPWWxJSf4fNcxu4S2g',
    price: 800,
  ),
  Product(
    id: 'p5',
    name: 'Macbook Air M1',
    image:
        'https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU',
    price: 800,
  ),
  Product(
    id: 'p6',
    name: 'NotRolex Watch w/ 25Hrs',
    image:
        'https://fastly.picsum.photos/id/4/5000/3333.jpg?hmac=ghf06FdmgiD0-G4c9DdNM8RnBIN7BO0-ZGEw47khHP4',
    price: 1800,
  ),
  Product(
    id: 'p7',
    name: 'Another Macbook M6',
    image:
        'https://fastly.picsum.photos/id/5/5000/3334.jpg?hmac=R_jZuyT1jbcfBlpKFxAb0Q3lof9oJ0kREaxsYV3MgCc',
    price: 10,
  ),
  Product(
    id: 'p8',
    name: 'Too Many Apple Macbook 6',
    image:
        'https://fastly.picsum.photos/id/6/5000/3333.jpg?hmac=pq9FRpg2xkAQ7J9JTrBtyFcp9-qvlu8ycAi7bUHlL7I',
    price: 8000,
  ),
  Product(
    id: 'p9',
    name: 'Cool Leather Bag',
    image:
        'https://fastly.picsum.photos/id/7/4728/3168.jpg?hmac=c5B5tfYFM9blHHMhuu4UKmhnbZoJqrzNOP9xjkV4w3o',
    price: 80,
  ),
  Product(
    id: 'p10',
    name: 'Cute White Heels',
    image:
        'https://fastly.picsum.photos/id/21/3008/2008.jpg?hmac=T8DSVNvP-QldCew7WD4jj_S3mWwxZPqdF0CNPksSko4',
    price: 600,
  ),
];

class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    if (!_items.contains(product)) {
      product.isInCart = true;
      _items.add(product);
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    if (_items.contains(product)) {
      product.isInCart = false;
      _items.remove(product);
      notifyListeners();
    }
  }

  void clearCart() {
    for (var product in products) {
      product.isInCart = false;
    }
    _items.clear();
    notifyListeners();
  }

  double totalAmt() {
    double tot = 0;
    for (var product in products) {
      tot = tot + product.price;
    }
    return tot;
  }
}

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(30.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.image),
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
                trailing: IconButton(
                  icon: product.isInCart
                      ? const Icon(Icons.remove_circle)
                      : const Icon(Icons.add_circle),
                  onPressed: () {
                    if (product.isInCart) {
                      cart.removeProduct(product);
                    } else {
                      cart.addProduct(product);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final product = cart.items[index];
                    return ListTile(
                      leading: Image.network(product.image),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle),
                        onPressed: () {
                          cart.removeProduct(product);
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Text('BUY'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).clearCart();
            },
          ),
        ],
      ),
    );
  }
}
