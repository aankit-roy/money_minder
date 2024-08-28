import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_minder/provider/general_provider.dart';
import 'package:money_minder/res/colors/color_palette.dart';
import 'package:money_minder/res/constants/text_constants.dart';
import 'package:money_minder/screens/root_page.dart';
import 'package:provider/provider.dart';




class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int counterIndex = 0;

  void _navigateToRoot(BuildContext context) {
    final loadingProvider = Provider.of<GeneralProvider>(context, listen: false);
    loadingProvider.setLoading(true); // Set loading to true when navigation starts
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const RootPage(),
      ),
    ).then((_) {
      loadingProvider.setLoading(false); // Reset loading state when done
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: InkWell(
              onTap: ()  => _navigateToRoot(context),
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page) {
              setState(() {
                counterIndex = page;
              });
            },
            controller: _pageController,
            children: [
              createPage(
                image: 'assets/images/first.png',
                title: TextConstants.titleOne,
                description: TextConstants.descriptionOne,
              ),
              createPage(
                image: 'assets/images/second.png',
                title: TextConstants.titleTwo,
                description: TextConstants.descriptionTwo,
              ),
              createPage(
                image: 'assets/images/third.png',
                title: TextConstants.titleThree,
                description: TextConstants.descriptionThree,
              ),

            ],
          ),
          Positioned(
              bottom: 85,
              left: 30,
              child: Row(
                children: _buildIndicator(),
              )),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsPalette.primaryColor,

              ),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    if(counterIndex<2) {
                      counterIndex++;

                      if (counterIndex < 3) {
                        _pageController.nextPage(duration: const Duration(
                            milliseconds: 300),
                            curve: Curves.easeIn);
                      }
                    }
                    else{
                       return _navigateToRoot(context);
                    }
                  });

                },
                icon: const Icon(Icons.arrow_forward,size: 25,color: Colors.white,),
              ),

            ),
          ),
        ],
      ),
    );
  }

  //create indicator list;
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];

    for (int i = 0; i < 3; i++) {
      if (counterIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }

}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const createPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50, right: 50, bottom: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 3,

            child: Container(

              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 35,
                  color: ColorsPalette.primaryColor,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Flexible(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


}

//create indicator decoration widget
Widget _indicator(bool isActive) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 10.0,
    width: isActive ? 20 : 8,
    margin: const EdgeInsets.only(right: 5.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      color: ColorsPalette.primaryColor,
    ),
  );
}
