import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_minder/data/database/database_helper.dart';
import 'package:money_minder/models/add_transactions_data.dart';
import 'package:money_minder/models/category_list.dart';
import 'package:money_minder/models/pie_chart_data.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/ui/widgets/expenses_category_grid.dart';

class AddingData extends StatefulWidget {
  const AddingData({super.key});

  @override
  State<AddingData> createState() => _AddingDataState();
}

class _AddingDataState extends State<AddingData> {
  final List<AddingPieChartData> pieChartData = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  Color selectedColor = ColorsPalette.secondaryColor;
  CategoryData? selectedCategory;
  List<AddTransactionsData> transactions = [];
  List<CategoryData> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    List<CategoryData> loadedCategories = await dbHelper.getCategories2();
    setState(() {
      categories = loadedCategories;
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    valueController.dispose();
    super.dispose();
  }

  @override




  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration:  const BoxDecoration(
          color: ColorsPalette.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorsPalette.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child:  TabBar(
                indicator:  CustomTabIndicator(),
                tabs: [
                  Tab(
                      icon: Icon(Icons.money_off, color: ColorsPalette.textPrimary),
                      text: 'Expenses'),
                  Tab(
                      icon: Icon(Icons.attach_money, color: ColorsPalette.textPrimary),
                      text: 'Income'),
                ],
              ),
            ),
             
            Expanded(
              child: TabBarView(
                children: [
                  ExpensesCategoryGrid(categories: categories),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text("Income"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter();
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint()
      ..color = ColorsPalette.primaryDark
      ..style = PaintingStyle.fill;

    final double indicatorHeight = 4.0;
    final double indicatorWidth = configuration.size!.width * 0.7;
    final double dx = offset.dx + (configuration.size!.width - indicatorWidth) / 2;
    final double dy = offset.dy + configuration.size!.height - indicatorHeight;

    final Rect rect = Rect.fromLTWH(dx, dy, indicatorWidth, indicatorHeight);
    final RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(2));

    canvas.drawRRect(rRect, paint);
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:money_minder/data/database/database_helper.dart';
// import 'package:money_minder/models/add_transactions_data.dart';
// import 'package:money_minder/models/category_list.dart';
// import 'package:money_minder/models/pie_chart_data.dart';
// import 'package:money_minder/res/colors/color_palette.dart';
// import 'package:money_minder/ui/widgets/custome_Tran_add_app_bar.dart';
// import 'package:money_minder/ui/widgets/expenses_category_grid.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
// class AddingData extends StatefulWidget {
//   const AddingData({super.key});
//
//   @override
//   State<AddingData> createState() => _AddingDataState();
// }
//
// class _AddingDataState extends State<AddingData> {
//   final List<AddingPieChartData> pieChartData = [];
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController valueController = TextEditingController();
//   late final TextEditingController tabController;
//   Color selectedColor = ColorsPalette.secondaryColor;
//   CategoryData? selectedCategory;
//   List<AddTransactionsData> transactions = [];
//   List<CategoryData> categories = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }
//
//   Future<void> _loadCategories() async {
//     DatabaseHelper dbHelper = DatabaseHelper();
//     List<CategoryData> loadedCategories = await dbHelper.getCategories2();
//
//     categories.addAll(loadedCategories);
//     // setState(() {
//     //   categories = loadedCategories;
//     //   for(var cat in categories){
//     //
//     //     print("Categories length ************************************************${cat.id}");
//     //
//     //     print("Categories length ************************************************${cat.name}");
//     //     print("Categories length ************************************************${cat.icon}");
//     //
//     //
//     //
//     //
//     //   }
//     // });
//   }
//
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     titleController.dispose();
//     valueController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//           appBar:  const CustomTransactionAppBar(),
//           body: TabBarView(
//             children: [
//               ExpensesCategoryGrid(categories: categories),
//
//               const Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text("Income"),
//                   ],
//                 ),
//               ),
//             ],
//           )),
//     );
//   }
//
//
// }
//
//
