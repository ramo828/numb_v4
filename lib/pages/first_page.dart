import 'package:dots_indicator/dots_indicator.dart';
import 'package:number_seller/helper.dart';
import 'package:number_seller/pages/login_page.dart';
import 'package:number_seller/pages/number_/background/work_functions.dart';
import 'package:number_seller/pages/work_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

int pageCount = 3;
int position = 0;

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<bool>(
        future: getBoolValue('logIn'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Gösterilecek bir yüklenme animasyonu
          } else {
            bool logInValue = snapshot.data ?? false;
            if (!logInValue) {
              return const helloApp();
            } else {
              return const home_page();
            }
          }
        },
      ),
    );
  }
}

class qarsilama_widget extends StatelessWidget {
  const qarsilama_widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: Text(
              qarsilama,
              style: const TextStyle(
                fontFamily: 'Handwriting',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WelcomeWidget extends StatelessWidget {
  final String title;
  final String content;
  final int imageCount;
  final bool nextButtonStatus;

  const WelcomeWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.imageCount,
    this.nextButtonStatus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            Image(
              image: AssetImage('assets/welcome/$imageCount.png'),
              width: 350,
              height: 350,
            ).animate().fade(duration: 1000.ms).fadeIn(),
            Padding(
              padding: const EdgeInsets.only(
                left: 50,
                top: 5,
                bottom: 10,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Handwriting',
                  fontSize: 40,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Center(
                child: Text(
                  content,
                  style: const TextStyle(
                    fontFamily: 'Lobster',
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (nextButtonStatus)
              Padding(
                padding: const EdgeInsets.only(left: 250),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    FontAwesomeIcons.arrowRight,
                  ),
                ),
              )
            else
              const Center(),
          ],
        ),
      ],
    );
  }
}

class helloApp extends StatefulWidget {
  const helloApp({super.key});

  @override
  State<helloApp> createState() => _helloAppState();
}

class _helloAppState extends State<helloApp> {
  @override
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                position = page;
              });
            },
            children: [
              // qarsilama_widget(),
              WelcomeWidget(
                title: title1,
                content: content1,
                imageCount: 1,
                nextButtonStatus: false,
              ),
              WelcomeWidget(
                title: title2,
                content: content2,
                imageCount: 2,
                nextButtonStatus: false,
              ),
              WelcomeWidget(
                title: title3,
                content: content3,
                imageCount: 3,
                nextButtonStatus: true,
              ),
            ],
          ),
        ),
        DotsIndicator(
          dotsCount: pageCount,
          position: position,
          decorator: const DotsDecorator(
            color: Colors.grey,
            activeColor: Colors.blue,
          ),
        ),
      ],
    );
  }
}
