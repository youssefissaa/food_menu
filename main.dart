import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

// MyApp
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Order App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignInPage(), // Ensure SignInPage is properly referenced
    );
  }
}

// SignInPage
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/mob/signin.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuPage(userId: data['user_id']),
          ),
        );
      } else {
        _showError(data['message']);
      }
    } else {
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: signIn, child: Text('Sign In')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// SignUpPage
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signUp() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/mob/signup.php'),
      body: {
        'username': _usernameController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Navigator.pop(context);
      } else {
        _showError(data['message']);
      }
    } else {
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}

// MenuPage
class MenuPage extends StatefulWidget {
  final String userId;
  MenuPage({required this.userId});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _sauces = [];
  int? _selectedItemIndex;
  int? _selectedSauceIndex;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchMenu();
  }

  Future<void> _fetchMenu() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/mob/get_menu.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _items = List<Map<String, dynamic>>.from(data['items']);
        _sauces = List<Map<String, dynamic>>.from(data['sauces']);
      });
    }
  }

  // Update the total price whenever the selected item or sauce changes
  void _updateTotalPrice() {
    if (_selectedItemIndex != null) {
      final selectedItem = _items[_selectedItemIndex!];
      setState(() {
        _totalPrice = selectedItem['price']; // Reset to item price
      });

      if (_selectedSauceIndex != null) {
        final selectedSauce = _sauces[_selectedSauceIndex!];
        setState(() {
          _totalPrice += selectedSauce['price']; // Add sauce price if selected
        });
      }
    } else {
      setState(() {
        _totalPrice = 0.0; // Reset if no item is selected
      });
    }
  }

  Future<void> _saveOrder() async {
    if (_selectedItemIndex == null) {
      _showError('Please select an item.');
      return;
    }

    final selectedItem = _items[_selectedItemIndex!];
    final selectedSauce = _selectedSauceIndex != null
        ? _sauces[_selectedSauceIndex!]
        : null;

    final orderDetails = selectedItem['name'] +
        (selectedSauce != null ? ' with ${selectedSauce['name']}' : '');

    final response = await http.post(
      Uri.parse('http://10.0.2.2/mob/save_order.php'),
      body: {
        'user_id': widget.userId,
        'order_details': orderDetails,
        'total_price': _totalPrice.toString(),
      },
    );

    if (response.statusCode == 200) {
      _showSuccess('Order placed successfully!');
    } else {
      _showError('Failed to save order. Please try again.');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderHistoryPage(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return RadioListTile<int>(
                  title: Text('${_items[index]['name']} - \$${_items[index]['price']}'),
                  value: index,
                  groupValue: _selectedItemIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedItemIndex = value;
                    });
                    _updateTotalPrice(); // Recalculate total price
                  },
                );
              },
            ),
          ),
          DropdownButton<int>(
            value: _selectedSauceIndex,
            hint: Text('Select a sauce'),
            items: _sauces.asMap().entries.map((entry) {
              final index = entry.key;
              final sauce = entry.value;
              return DropdownMenuItem<int>(
                value: index,
                child: Text('${sauce['name']} - \$${sauce['price']}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSauceIndex = value;
              });
              _updateTotalPrice(); // Recalculate total price
            },
          ),
          Text('Total: \$${_totalPrice.toStringAsFixed(2)}'),
          ElevatedButton(
            onPressed: _saveOrder,
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}

// OrderHistoryPage
class OrderHistoryPage extends StatelessWidget {
  final String userId;
  OrderHistoryPage({required this.userId});

  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/mob/get_orders.php'),
      body: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['orders']);
    } else {
      throw Exception('Failed to load order history.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load order history.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text(order['order_details']),
                  subtitle: Text('Total: \$${order['total_price']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
