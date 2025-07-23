import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        // backgroundColor: Theme.of(
        //   context,
        // ).colorScheme.primary.withOpacity(0.08),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
              shadowColor: Colors.black12,
              elevation: 1,
            ),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Productos",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                shadowColor: Colors.black12,
                elevation: 1,
              ),
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black87,
              ),
              onPressed: () {
                // Navegar a notificaciones
              },
            ),
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return _cardProductWidget(index, context);
        },
      ),
    );
  }

 Card _cardProductWidget(int index, BuildContext context) {
  final theme = Theme.of(context);

  final productLabels = ['\$100 OFF', '', 'Launch Sale', '', ''];
  final productNames = [
    'Astro One Ultra Edition with Long Name',
    'Pixelon Edge',
    'Luma Air Pro Max Supreme',
    'iNova Flex 11',
    'Pro Vision 3000 Elite X'
  ];
  final monthlyInfo = 'As low as \$29/mo for 12 months at 0% APR with XXXX';
  final prices = ['\$399', '\$999', '\$699', '\$399', '\$499'];
  final oldPrices = ['\$499', '', '', '', ''];

  return Card(
    color: Colors.white,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    child: SizedBox(
      height: 200, 
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: double.infinity,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: theme.primaryColor,
                  size: 34,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Contenido textual
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // vertical center
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (productLabels[index].isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        productLabels[index],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  Text(
                    productNames[index],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    monthlyInfo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        prices[index],
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (oldPrices[index].isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(
                          oldPrices[index],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
