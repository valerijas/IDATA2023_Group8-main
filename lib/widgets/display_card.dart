import 'package:flutter/material.dart';
import 'package:user_manuals_app/data/products.dart';
import 'package:user_manuals_app/model/category.dart';
import 'package:user_manuals_app/model/manufacture.dart';
import 'package:user_manuals_app/model/product.dart';
import 'package:user_manuals_app/screens/product_screen.dart';
import 'package:user_manuals_app/screens/products.dart';
import 'package:user_manuals_app/util/database_manager.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(8)),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: InkWell(
          onTap: () {
            if (item is Product) {
              // Navigate to the product page
              _selectProduct(context, item);
            } else if (item is Manufacture) {
              _selectManufacturer(context, item);
            } else if (item is Category) {
              _selectCategory(context, item);
            }
          },
          child: Stack(
            children: [
              if (item is Product) ...{
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              } else ...{
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              },
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 44),
                  child: Column(
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectProduct(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProductScreen(item: product),
      ),
    );
  }

  void _selectManufacturer(BuildContext context, Manufacture manufacturer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DisplayManufacturer(manufacturer: manufacturer),
      ),
    );
  }

  void _selectCategory(BuildContext context, Category category) async {
    List<Product> filteredProducts =
        await DatabaseManager().getProductsByCategory(category.type);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProductsScreen(
          products: filteredProducts,
          pageTitle: category.title,
          image: category.imageUrl,
        ),
      ),
    );
  }
}

class DisplayManufacturer extends StatelessWidget {
  const DisplayManufacturer({
    super.key,
    required this.manufacturer,
  });

  final Manufacture manufacturer;

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products
        .where((product) => product.manufacture.id == manufacturer.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(manufacturer.title),
      ),
      body: ProductsScreen(
        products: filteredProducts,
        pageTitle: manufacturer.title,
        image: manufacturer.imageUrl,
      ),
    );
  }
}
