import 'package:edu_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Edu y Ale app',
      debugShowCheckedModeBanner: false,
      initialRoute: MainRoutes.splash,
      getPages: MainPages.pages,

      supportedLocales: const [
        Locale('en', ''), // English, no country code
        Locale('es', ''), // Spanish, no country code
      ],
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', ''),
     
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xFFfec90b),

          primaryContainer: Color(0xffffffff),
          secondary: Color(0xffffffff),
          secondaryContainer: Color(0xfff6f6f6),
          tertiary: Color.fromARGB(255, 0, 0, 0),

          tertiaryContainer: Color(0xffa1a1a1),
          appBarColor: Color(0xfff6f6f6),
          error: Color(0xffb00020),
        ),
        surfaceTint: const Color(0xffffffff),
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useMaterial3Typography: true,
          useM2StyleDividerInM3: true,
          elevatedButtonSchemeColor: SchemeColor.onPrimary,
          elevatedButtonSecondarySchemeColor: SchemeColor.primary,
          elevatedButtonElevation: 2,
          inputDecoratorSchemeColor: SchemeColor.onPrimary,
          inputDecoratorBorderSchemeColor: SchemeColor.onSecondary,
          inputCursorSchemeColor: SchemeColor.onPrimaryContainer,
          inputSelectionSchemeColor: SchemeColor.onPrimaryContainer,
          inputDecoratorIsFilled: false,
          inputDecoratorRadius: 10.0,
          inputSelectionHandleSchemeColor: SchemeColor.primary,

          // defaultRadius: 16.0,
          // inputDecoratorSchemeColor: SchemeColor.secondaryContainer,
          // inputDecoratorIsFilled: true,
          // inputDecoratorContentPadding: EdgeInsetsDirectional.fromSTEB(
          //   16,
          //   20,
          //   16,
          //   12,
          // ),
          // inputDecoratorBorderSchemeColor: SchemeColor.primary,
          // inputDecoratorBorderType: FlexInputBorderType.outline,
          // inputDecoratorFocusedBorderWidth: 1.0,
          // inputCursorSchemeColor: SchemeColor.secondary,
          // inputSelectionSchemeColor: SchemeColor.secondary,
          // inputSelectionHandleSchemeColor: SchemeColor.secondary,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          keepPrimary: true,
          keepSecondary: true,
          keepTertiary: true,
          keepPrimaryContainer: true,
          keepSecondaryContainer: true,
          keepTertiaryContainer: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
        // fontFamily: 'SF Pro Display',
      ),
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: Color(0xff9fc9ff),
          primaryContainer: Color(0xff00325b),
          secondary: Color(0xffffb59d),
          secondaryContainer: Color(0xff872100),
          tertiary: Color(0xff86d2e1),
          tertiaryContainer: Color(0xff004e59),
          appBarColor: Color(0xff872100),
          error: Color(0xffcf6679),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          useMaterial3Typography: true,
          useM2StyleDividerInM3: true,
          inputDecoratorIsFilled: false,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
        fontFamily: GoogleFonts.poppins().fontFamily,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      ),
      // If you do not have a themeMode switch, uncomment this line
      // to let the device system mode control the theme mode:
      themeMode: ThemeMode.light,
      // Este builder dara los valores por defecto del text y bold
      // para evitar los desbordes en la aplicación
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            boldText: false,
            textScaler: const TextScaler.linear(1.0),
            //textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
