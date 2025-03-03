import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant/domain/bloc/blocs.dart';
import 'package:restaurant/presentation/components/components.dart';
import 'package:restaurant/presentation/screens/admin/admin_home_screen.dart';
import 'package:restaurant/presentation/screens/client/client_home_screen.dart';
import 'package:restaurant/presentation/screens/delivery/delivery_home_screen.dart';
import 'package:restaurant/presentation/themes/colors_frave.dart';

import '../partner/partner_home_screen.dart';

class SelectRoleScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    final authBloc = BlocProvider.of<AuthBloc>(context).state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TextCustom(text: 'Med-X ', fontSize: 25, color: ColorsFrave.primaryColor, fontWeight: FontWeight.w500 ),
                  TextCustom(text: 'Logistics', fontSize: 25, color: ColorsFrave.secundaryColor, fontWeight: FontWeight.w500 ),
                ],
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'How do you want to continue?', color: ColorsFrave.secundaryColor, fontSize: 25,),
              const SizedBox(height: 30.0),
              ( authBloc.user!.rolId == 1) 
                ? _BtnRol(
                svg: 'Assets/svg/restaurante.svg',
                text: 'Med-X Admin',
                color1: ColorsFrave.primaryColor.withOpacity(.2),
                color2: Colors.greenAccent.withOpacity(.1),
                onPressed: () => Navigator.pushAndRemoveUntil(context, routeFrave(page: AdminHomeScreen()), (route) => false),
              ) : const SizedBox(),
              (authBloc.user!.rolId == 1 || authBloc.user!.rolId == 3 )
                ? _BtnRol(
                svg: 'Assets/svg/bussiness-man.svg',
                text: 'Customer',
                color1: Color(0xffFE6488).withOpacity(.2),
                color2: Colors.amber.withOpacity(.1),
                onPressed: () => Navigator.pushReplacement(context, routeFrave(page: ClientHomeScreen())),
              ) : const SizedBox() ,
              (authBloc.user!.rolId == 1 || authBloc.user!.rolId == 4 )
                  ? _BtnRol(
                svg: 'Assets/svg/bussiness-man.svg',
                text: 'Delivery Partner',
                color1: Color(0xffFE6488).withOpacity(.2),
                color2: Colors.amber.withOpacity(.1),
                onPressed: () => Navigator.pushReplacement(context, routeFrave(page: PartnerHomeScreen())),
              ) : const SizedBox() ,
              (authBloc.user!.rolId == 1 || authBloc.user!.rolId == 3 ) 
                ? _BtnRol(
                svg: 'Assets/svg/delivery-bike.svg',
                text: 'Delivery',
                color1: Color(0xff8956FF).withOpacity(.2),
                color2: Colors.purpleAccent.withOpacity(.1),
                onPressed: () => Navigator.pushAndRemoveUntil(context, routeFrave(page: DeliveryHomeScreen()), (route) => false),
              ) : const SizedBox()
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _BtnRol extends StatelessWidget {
  
  final String svg;
  final String text;
  final Color color1;
  final Color color2;
  final VoidCallback? onPressed;

  const _BtnRol({ required this.svg, required this.text, required this.color1, required this.color2, this.onPressed });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onPressed,
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              colors: [
                color1,
                color2
              ]
            ),                  
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset( svg, height: 100,),
                TextCustom(text: text, fontSize: 20, color: ColorsFrave.secundaryColor )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

