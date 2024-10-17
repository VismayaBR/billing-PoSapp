import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/widgets/counter_widget.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import '../../../helper/text_style.dart';
import '../../../helper/ui_helper.dart';
import '../../../features/pos/view_model/pos_screen_view_model.dart';
import '../../../features/pos/model/products_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final TextEditingController countController = TextEditingController();

  int count = 1;
  @override
  Widget build(BuildContext context) {
    // Extracting the product data
    final productData = widget.product['data'];
    final ProductDatum productDatum =
        ProductDatum.fromMap(productData); // Convert to ProductDatum

    return Scaffold(
      appBar: AppBar(
        title: Text(
          productData['name'] ?? 'Product Details',
          style: mainSubHeadingStyle().copyWith(
            color: AppColors.backgroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: AppColors.posScreenColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Image.network(
                productData['featured_image_path'] ?? '',
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/placeholder.png'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${productData['name'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Code: ${productData['code'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Brand: ${productData['brand_name'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Category: ${productData['category_name'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Unit: ${productData['unit_name'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Price: Qr ${productData['price'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('MRP: Qr ${productData['mrp'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text(
                    'Wholesale Price: Qr ${productData['wholesale_price'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Cost: Qr ${productData['cost'] ?? 'N/A'}'),
                SizedBox(height: 8),
                Text('Threshold: ${productData['threshold'] ?? 'N/A'}'),
                CounterTextField(
                  controller: countController,
                  onCounteClick: (p0) {
                  productDatum.quantity = p0;
                    print(p0);
                  },
                )
              ],
            ),
            Consumer<PosScreenViewModel>(
              builder: (context, pos, child) {
                return InkWell(
                  onTap: () {
                    pos.addProductToCart(
                        productDatum);
                        Navigator.pop(context); // Pass ProductDatum instance
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${productData['name']} added to cart!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.posScreenColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: AppColors.posScreenColor, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: AppColors.backgroundColor,
                        ),
                        horizontalSpaceSmall,
                        Text(
                          'Add to Cart',
                          style: mainSubHeadingStyle().copyWith(
                            color: AppColors.backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
