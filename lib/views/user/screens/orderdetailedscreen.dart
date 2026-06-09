import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  String? get _imagePath {
    final img = order["image"];
    if (img == null) return null;
    final str = img.toString().trim();
    return str.isEmpty ? null : str;
  }

  @override
  Widget build(BuildContext context) {
    final status = order["status"] ?? "Pending";
    final heroTag = _imagePath ?? "order_hero_${order["id"] ?? UniqueKey()}";

    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardColor = theme.cardColor;
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF100F0F) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// TOP IMAGE SECTION
              Stack(
                children: [
                  Container(
                    height: 330,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Hero(
                        tag: heroTag,
                        child: _buildProductImage(),
                      ),
                    ),
                  ),

                  /// BACK BUTTON
                  Positioned(
                    top: 20,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: cardColor,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// PRODUCT NAME
                    Text(
                      order["name"] ?? "",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 10),

                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${order["price"] ?? "0"}",
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildStatusChip(status),
                      ],
                    ),

                    const SizedBox(height: 30),

                    
                    Row(
                      children: [
                        Expanded(
                          child: _miniCard(
                            context: context,
                            icon: Icons.shopping_bag,
                            title: "Quantity",
                            value: "${order["quantity"] ?? 1}",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _miniCard(
                            context: context,
                            icon: Icons.payments,
                            title: "Payment",
                            value: order["payment"] ?? "N/A",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.red),
                              const SizedBox(width: 10),
                              Text(
                                "Shipping Address",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            order["address"] ?? "Kinfra, Kerala",
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Timeline",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _timeline(context, "Order Placed", true),
                          _timeline(context, "Packed", true),
                          _timeline(context, "Shipped", true),
                          _timeline(context, "Delivered", status == "Completed"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: colorScheme.onSurface),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              order["time"] ?? "",
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Track Order",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    final path = _imagePath;
    if (path == null) return _imagePlaceholder();

    if (path.startsWith("http://") || path.startsWith("https://")) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            "Image not available",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case "Completed":
        bgColor = Colors.green.shade100;
        textColor = Colors.green;
        break;
      case "Cancelled":
        bgColor = Colors.red.shade100;
        textColor = Colors.red;
        break;
      default:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }

  
  Widget _miniCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.onSurface),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _timeline(BuildContext context, String title, bool active) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: active
                ? Colors.green
                : isDark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active
                  ? colorScheme.onSurface
                  : isDark
                      ? Colors.grey.shade600
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}