// import 'package:flutter/material.dart';
//
// // 👇 Import all screens here
// import '../screens/login_screen.dart';
// import '../screens/signup_screen.dart';
// import '../screens/forgot_password_screen.dart';
// import '../screens/about_app_screen.dart';
// import '../screens/splash_screen.dart';
//
// import '../screens/users/user_home_screen.dart';
// import '../screens/users/turf_detail_screen.dart';
// import '../screens/users/booking_screen.dart';
// import '../screens/users/order_summary_screen.dart';
// import '../screens/users/payment_screen.dart';
// import '../screens/users/payment_success_screen.dart';
// import '../screens/users/booking_confirmation_screen.dart';
// import '../screens/users/my_bookings_screen.dart';
// import '../screens/users/user_profile_screen.dart';
//
// import '../screens/owners/owner_dashboard_screen.dart';
// import '../screens/owners/add_turf_screen.dart';
// import '../screens/owners/my_turf_list_screen.dart';
// import '../screens/owners/edit_turf_screen.dart';
// import '../screens/owners/view_bookings_screen.dart';
// import '../screens/owners/slot_management_screen.dart';
// import '../screens/owners/owner_profile_screen.dart';
//
// class AppRoutes {
//   static const String splash = '/';
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String forgotPassword = '/forgot-password';
//   static const String aboutApp = '/about';
//
//   // USER ROUTES
//   static const String userHome = '/user/home';
//   static const String turfDetail = '/user/turf-detail';
//   static const String booking = '/user/booking';
//   static const String orderSummary = '/user/order-summary';
//   static const String payment = '/user/payment';
//   static const String paymentSuccess = '/user/payment-success';
//   static const String bookingConfirmation = '/user/booking-confirmation';
//   static const String myBookings = '/user/my-bookings';
//   static const String userProfile = '/user/profile';
//
//   // OWNER ROUTES
//   static const String ownerDashboard = '/owner/dashboard';
//   static const String addTurf = '/owner/add-turf';
//   static const String myTurfList = '/owner/my-turfs';
//   static const String editTurf = '/owner/edit-turf';
//   static const String viewBookings = '/owner/bookings';
//   static const String slotManagement = '/owner/slot-management';
//   static const String ownerProfile = '/owner/profile';
//
//   static Map<String, WidgetBuilder> routes = {
//     splash: (context) => const SplashScreen(),
//     login: (context) => const LoginScreen(),
//     signup: (context) => const SignupScreen(),
//     forgotPassword: (context) => const ForgotPasswordScreen(),
//     aboutApp: (context) => const AboutAppScreen(),
//
//     // User Screens
//     userHome: (context) => const UserHomeScreen(),
//     turfDetail: (context) => const TurfDetailScreen(),
//     booking: (context) => const BookingScreen(),
//     orderSummary: (context) => const OrderSummaryScreen(),
//     payment: (context) => const PaymentScreen(),
//     paymentSuccess: (context) => const PaymentSuccessScreen(),
//     bookingConfirmation: (context) => const BookingConfirmationScreen(),
//     myBookings: (context) => const MyBookingsScreen(),
//     userProfile: (context) => const UserProfileScreen(),
//
//     // Owner Screens
//     ownerDashboard: (context) => const OwnerDashboardScreen(),
//     addTurf: (context) => const AddTurfScreen(),
//     myTurfList: (context) => const MyTurfListScreen(),
//     editTurf: (context) => const EditTurfScreen(),
//     viewBookings: (context) => const ViewBookingsScreen(),
//     slotManagement: (context) => const SlotManagementScreen(),
//     ownerProfile: (context) => const OwnerProfileScreen(),
//   };
// }


import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
// import '../screens/user/user_home_screen.dart';
// import '../screens/owner/owner_dashboard_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const SplashScreen(),
    '/login': (context) => const LoginScreen(),
    '/signup': (context) => const SignupScreen(),
    // '/user/home': (context) => const UserHomeScreen(),
    // '/owner/dashboard': (context) => const OwnerDashboardScreen(),
  };
}
