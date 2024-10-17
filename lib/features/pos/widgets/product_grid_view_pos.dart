import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/model/products_model.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class ProductsGridView extends StatefulWidget {
  final int crossAxisCount;
  final double titleSize;
  final double priceSize;
  final double aspectRatioHeight;
  final List<ProductDatum> productsAndService;

  const ProductsGridView({
    super.key,
    required this.crossAxisCount,
    required this.priceSize,
    required this.titleSize,
    required this.aspectRatioHeight,
    required this.productsAndService,
  });

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context, pos, child) {
        // Filter products based on selected category and search text
        final filteredProducts = widget.productsAndService.where((product) {
          final matchesCategory = pos.categorySelectedId == 0
              ? true
              : product.category_id == pos.categorySelectedId.toString();
          final matchesSearch = product.name!.toLowerCase().contains(_searchText);
          return matchesCategory && matchesSearch;
        }).toList();

        return Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                       suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear,size: 15,),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchText = '';
                                });
                              },
                            )
                          : null,
                    
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: widget.crossAxisCount,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5 / widget.aspectRatioHeight,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index]; // Access the correct list
                    return GestureDetector(
                      onTap: () {
                        pos.addProductToCart(product); // Add the selected product to the cart
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.posScreenYellowBar,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                            ),
                            product.image != null
                                ? Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(product.image!),
                                        ),
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                    ),
                                  )
                                : Container(
                                    height: 75,
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Text(
                                      product.name!,
                                      style: mainSubHeadingStyle().copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: widget.titleSize,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                            product.image == null
                                ? Container(
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20, top: 0),
                                    padding: const EdgeInsets.all(15),
                                    decoration: const BoxDecoration(
                                      color:
                                          AppColors.posScreenContainerBackground,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                    ),
                                    child: Text(
                                      'Qr ${product.price}',
                                      style: mainSubHeadingStyle().copyWith(
                                        color:
                                            AppColors.posScreenSelectedTextColor,
                                        fontSize: widget.priceSize,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 15, 10, 15),
                                          decoration: const BoxDecoration(
                                            color: AppColors
                                                .posScreenContainerBackground,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6)),
                                          ),
                                          child: Text(
                                            'Qr ${product.price}',
                                            style:
                                                mainSubHeadingStyle().copyWith(
                                                    color: AppColors
                                                        .posScreenSelectedTextColor,
                                                    fontSize: widget.priceSize),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            product.name!,
                                            style: mainSubHeadingStyle().copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            verticalSpaceSmall,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
