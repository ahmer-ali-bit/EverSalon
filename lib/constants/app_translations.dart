import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/profile/language_provider.dart';

class AppTranslations {
  AppTranslations._();

  /// Returns the translated string for [key] in the current app language.
  /// Falls back to English, then to the key itself if missing.
  static String tr(BuildContext context, String key) {
    String code = 'en';
    try {
      // 🔴 FIX: Change listen: true to listen: false
      code = Provider.of<LanguageProvider>(context, listen: false).selectedCode;
    } catch (_) {
      code = 'en';
    }
    return translations[code]?[key] ?? translations['en']?[key] ?? key;
  }

  /// Whether the current language requires an RTL layout.
  static bool isRtl(BuildContext context) {
    String code = 'en';
    try {
      code = Provider.of<LanguageProvider>(context, listen: false).selectedCode;
    } catch (_) {
      code = 'en';
    }
    return code == 'ur' || code == 'ar';
  }

  static const String fallbackLocale = 'en';

  static const Map<String, Map<String, String>> translations = {
    'en': {
      // ─── Common ───
      'loading': 'Loading',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'yes': 'Yes',
      'no': 'No',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'save': 'Save',
      'continue_text': 'Continue',
      'close': 'Close',
      'done': 'Done',
      'ok': 'OK',
      'apply': 'Apply',
      'reset': 'Reset',
      'see_all': 'See All',
      'sort': 'Sort',
      'from_rs': 'From Rs.',

      // ─── Bottom Nav ───
      'nav_home': 'Home',
      'nav_explore': 'Explore',
      'nav_bookings': 'Bookings',
      'nav_favorites': 'Favorites',
      'nav_profile': 'Profile',

      // ─── Splash ───
      'splash_ever': 'Ever',
      'splash_salon': 'Salon',
      'splash_tagline': 'Book. Manage. Glow.',
      'splash_loading': 'Loading your beauty world...',

      // ─── Onboarding ───
      'onboard_discover_title': 'Discover Top Salons',
      'onboard_discover_desc':
          'Find the best salons near you with trusted reviews.',
      'onboard_booking_title': 'Easy Booking',
      'onboard_booking_desc':
          'Choose your favorite service, select time & book instantly.',
      'onboard_offers_title': 'Exciting Offers',
      'onboard_offers_desc':
          'Enjoy exclusive offers, discounts and loyalty rewards.',
      'skip': 'Skip',

      // ─── Login ───
      'login_success': 'Login Success!',
      'welcome_back': 'Welcome Back!',
      'login_to_continue': 'Login to continue',
      'email_or_phone': 'Email or Phone Number',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'login': 'Login',
      'or': 'or',
      'dont_have_account': "Don't have an account? ",
      'register': 'Register',

      // ─── Register ───
      'accept_terms_error': 'Please accept Terms & Conditions',
      'registration_success': 'Registration Success!',
      'create_account': 'Create Account',
      'sign_up_get_started': 'Sign up to get started',
      'full_name': 'Full Name',
      'confirm_password': 'Confirm Password',
      'i_agree_to': 'I agree to the ',
      'terms_conditions': 'Terms & Conditions',
      'already_have_account': 'Already have an account? ',

      // ─── Forgot Password ───
      'reset_link_sent': 'Reset link sent successfully!',
      'forgot_password_title': 'Forgot Password?',
      'forgot_password_desc':
          "Don't worry! Enter your registered email or phone number and we'll send you a reset link.",
      'send_reset_link': 'Send Reset Link',
      'remember_password': 'Remember your password? ',

      // ─── Reset Password ───
      'password_reset_success': 'Password reset successfully!',
      'reset_password': 'Reset Password',
      'create_new_password': 'Create a new password',
      'new_password': 'New Password',
      'confirm_new_password': 'Confirm New Password',
      'at_least_8_chars': 'At least 8 characters',
      'one_uppercase': 'One uppercase letter',
      'one_number': 'One number',
      'one_special_char': 'One special character',

      // ─── OTP ───
      'verify_your_number': 'Verify Your Number',
      'enter_4digit_code': 'Enter the 4-digit code we sent to',
      'resend_code_in': 'Resend code in ',
      'resend': 'Resend',
      'verify': 'Verify',
      'enter_otp_error': 'Please enter the 4-digit OTP',
      'otp_verified': 'OTP Verified Successfully!',
      'otp_resent': 'OTP resent successfully!',

      // ─── Profile ───
      'my_profile': 'My Profile',
      'edit_profile': 'Edit Profile',
      'my_bookings': 'My Bookings',
      'loyalty_points': 'Loyalty Points',
      'membership': 'Membership',
      'gift_cards': 'Gift Cards',
      'payment_methods': 'Payment Methods',
      'payment_coming_soon': 'Payment Methods - Coming Soon',
      'addresses': 'Addresses',
      'addresses_coming_soon': 'Addresses - Coming Soon',
      'notification_settings': 'Notification Settings',
      'account_settings': 'Account Settings',
      'app_theme': 'App Theme',
      'dark': 'Dark',
      'light': 'Light',
      'system': 'System',
      'language': 'Language',
      'help_support': 'Help & Support',
      'help_coming_soon': 'Help & Support - Coming Soon',
      'pts': 'Pts',
      'cards': 'Cards',

      // ─── Edit Profile ───
      'phone_number': 'Phone Number',
      'email_address': 'Email Address',
      'date_of_birth': 'Date of Birth',
      'gender': 'Gender',
      'female': 'Female',
      'male': 'Male',
      'other': 'Other',
      'address': 'Address',
      'save_changes': 'Save Changes',
      'profile_updated': 'Profile updated successfully!',

      // ─── Language Selection ───
      'select_language': 'Select Language',
      'choose_language': 'Choose your preferred language.',
      'default_lang': 'Default',

      // ─── Account Settings ───
      'change_password': 'Change Password',
      'change_password_soon': 'Change Password coming soon',
      'privacy_policy': 'Privacy Policy',
      'privacy_policy_soon': 'Privacy Policy coming soon',
      'terms_conditions_title': 'Terms & Conditions',
      'terms_conditions_soon': 'Terms & Conditions coming soon',
      'delete_account': 'Delete Account',
      'delete_account_confirm':
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
      'delete': 'Delete',
      'log_out': 'Log Out',
      'log_out_confirm': 'Are you sure you want to log out of your account?',

      // ─── Loyalty Points ───
      'available_points': 'Available Points',
      'earning_smiles': 'You are earning smiles!',
      'pts_away_from': 'pts away from',
      'you_are_pts_away': "You're {pts} pts away from {tier}",
      'how_earn_points': 'How You Earn Points',
      'view_points_history': 'View Points History',

      // ─── Loyalty History ───
      'points_history': 'Points History',
      'no_history': 'No history found.',

      // ─── Membership ───
      'my_membership': 'My Membership',
      'enjoy_benefits': 'Enjoy exclusive benefits',
      'member_since': 'Member Since',
      'member_id': 'Member ID',
      'membership_benefits': 'Membership Benefits',
      'enjoy_exclusive_benefits': 'Enjoy exclusive benefits',
      'view_membership_details': 'View Membership Details',

      // ─── Membership Details ───
      'membership_details': 'Membership Details',
      'valid_till': 'Valid Till',
      'status': 'Status',

      // ─── Gift Cards ───
      'my_gift_cards': 'My Gift Cards',
      'add_card': '+ Add Card',
      'no_gift_cards': 'No gift cards found.',
      'ever_salon': 'EVER SALON',
      'gift_card': 'GIFT CARD',
      'balance': 'Balance',
      'card_no': 'Card No.',

      // ─── Home ───
      'good_morning': 'Good Morning',
      'search_hint': 'Search salons, services...',
      'search_artists': 'Search salons, services, artists...',
      'categories': 'Categories',
      'featured_salons': 'Featured Salons',
      'explore_placeholder': 'Explore Screen (Screen 14 later)',

      // ─── Nearby Salons ───
      'nearby_salons': 'Nearby Salons',
      'view_on_map': 'View on Map',

      // ─── Featured Salons ───
      'book_now': 'Book Now',

      // ─── All Salons ───
      'all_salons': 'All Salons',
      'nearby': 'Nearby',

      // ─── Search ───
      'search': 'Search',
      'search_hint_long': 'Search salons, services, artists...',
      'recent_searches': 'Recent Searches',
      'clear_all': 'Clear All',
      'popular_searches': 'Popular Searches',
      'no_matching': 'No matching salons or services found.',

      // ─── Filters ───
      'filters': 'Filters',
      'sort_by': 'Sort By',
      'distance': 'Distance',
      'km': 'km',
      'price_range': 'Price Range',
      'rating': 'Rating',
      'apply_filters': 'Apply Filters',

      // ─── Notifications ───
      'notifications': 'Notifications',
      'no_notifications': 'No new notifications',

      // ─── Offers ───
      'offers': 'Offers',
      'no_offers': 'No offers available',
      'use_code': 'Use Code:',
      'copy': 'Copy',
      'code_copied': "Code '{code}' copied!",

      // ─── Categories Screen ───
      'search_categories': 'Search categories...',
      'no_categories': 'No categories found',

      // ─── Search Results ───
      'search_results': 'Search Results',
      'search_dots': 'Search...',
      'results_found': 'Results Found',
      'no_results': 'No results found',

      // ─── Bookings ───
      'upcoming': 'Upcoming',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'no_bookings': 'No bookings found.',
      'service': 'Service',
      'confirmed': 'Confirmed',
      'salon': 'Salon',

      // ─── Upcoming Booking ───
      'upcoming_booking': 'Upcoming Booking',
      'beautician': 'Beautician',
      'duration': 'Duration',
      'price': 'Price',
      'rs': 'Rs.',
      'mins': 'mins',
      'view_full_details': 'View Full Details',
      'booking_id_invoice': 'Booking ID, invoice & more',
      'reschedule': 'Reschedule',
      'cancel_booking': 'Cancel Booking',

      // ─── Completed Booking ───
      'how_was_experience': 'How was your experience?',
      'write_review_optional': 'Write a review (optional)',
      'submit_review': 'Submit Review',
      'review_submitted': 'Review submitted successfully!',
      'review_failed': 'Failed to submit review. Try again.',

      // ─── Booking Details ───
      'booking_details': 'Booking Details',
      'booking_id': 'Booking ID',
      'date': 'Date',
      'time': 'Time',
      'total_paid': 'Total Paid',
      'view_invoice': 'View Invoice',
      'invoice_ready': 'Invoice ready (mock download).',
      'invoice_failed': 'Failed to download invoice.',
      'qr_checkin': 'QR Check-in',
      'share_booking': 'Share Booking',

      // ─── Cancel Booking ───
      'booking_cancelled': 'Booking Cancelled',
      'booking_cancelled_desc': 'Your booking has been cancelled successfully.',
      'back_to_bookings': 'Back to My Bookings',
      'explore_salons': 'Explore Other Salons',

      // ─── Reschedule ───
      'reschedule_booking': 'Reschedule Booking',
      'select_new_date': 'Select New Date',
      'sun': 'Sun',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'select_time_slot': 'Select Time Slot',
      'confirm_reschedule': 'Confirm Reschedule',
      'reschedule_success': 'Booking rescheduled successfully!',
      'reschedule_failed': 'Reschedule failed. Try again.',

      // ─── Cancellation Reason ───
      'cancellation_reason': 'Cancellation Reason',
      'are_you_sure': 'Are you sure?',
      'cancel_booking_desc':
          'You want to cancel this booking. This action cannot be undone.',
      'select_reason': 'Select Reason',
      'additional_notes': 'Additional notes (optional)',
      'write_notes': 'Write your notes...',
      'cancellation_failed': 'Cancellation failed. Try again.',

      // ─── Booking Confirmed ───
      'booking_confirmed': 'Booking Confirmed!',
      'appointment_booked': 'Your appointment has been booked successfully.',
      'view_my_bookings': 'View My Bookings',
      'back_to_home': 'Back to Home',

      // ─── Payment ───
      'payment': 'Payment',
      'amount_to_pay': 'Amount to Pay',
      'pay': 'Pay',
      'payment_failed': 'Payment failed. Please try again.',

      // ─── QR Check-in ───
      'your_booking_qr': 'Your Booking QR',
      'qr_scan_instruction': 'Show this QR code at the salon for check-in.',
      'date_time': 'Date & Time',
      'download_qr': 'Download QR',
      'qr_saved': 'QR saved successfully!',
      'qr_download_failed': 'Failed to download QR',

      // ─── Add Notes ───
      'add_notes': 'Add Notes',
      'special_requests': 'Any special requests?',
      'notes_hint':
          'e.g. I have sensitive skin, prefer less heat on hair, etc.',
      'notes_optional':
          'Notes are optional. You can skip this step if you have no special requests.',

      // ─── Time Slots ───
      'available_time_slots': 'Available Time Slots',
      'no_time_slots': 'No time slots available',
      'selected_time': 'Selected Time',
      'please_select_time': 'Please select a time',
      'please_select_slot': 'Please select a time slot',
      'continue': 'Continue',

      // ─── Apply Coupon ───
      'apply_coupon': 'Apply Coupon',
      'have_coupon': 'Have a coupon code?',
      'enter_coupon': 'Enter coupon code',
      'available_coupons': 'Available Coupons',
      'skip_to_payment': 'Skip & Continue to Payment',
      'enter_valid_coupon': 'Please enter a valid coupon code',
      'invalid_coupon': 'Invalid coupon code',
      'coupon_applied': "Coupon '{code}' applied!",
      'code': 'Code',

      // ─── Select Date ───
      'select_date': 'Select Date',
      'selected_date': 'Selected Date',
      'select_date_first': 'Please select a date first',

      // ─── Booking Summary ───
      'booking_summary': 'Booking Summary',
      'price_details': 'Price Details',
      'subtotal': 'Subtotal',
      'service_tax': 'Service Tax (5%)',
      'total_amount': 'Total Amount',

      // ─── Salon Details ───
      'salon_name': 'Salon Name',
      'open_now': 'Open Now',
      'unisex_salon': 'Unisex Salon',
      'call': 'Call',
      'direction': 'Direction',
      'share': 'Share',
      'opening_hours': 'Opening Hours',
      'mon_sun': 'Mon - Sun',
      'show_less': 'Show Less',
      'read_more': 'Read More',
      'gallery': 'Gallery',
      'our_services': 'Our Services',
      'our_packages': 'Our Packages',
      'our_beauticians': 'Our Beauticians',
      'reviews': 'Reviews',
      'user': 'User',
      'location': 'Location',
      'address_not_available': 'Address not available',
      'book_appointment': 'Book Appointment',

      // ─── Services ───
      'select_services': 'Select Services',
      'service_name': 'Service Name',
      'items_selected': 'Item(s) Selected',
      'select_at_least_one': 'Please select at least one service',

      // ─── Service Details ───
      'duration_label': 'Duration:',
      'about_service': 'About this service',
      'service_includes': 'This service includes',
      'details_not_available': 'Details not available.',

      // ─── Packages ───
      'select_package': 'Select Package',
      'package_name': 'Package Name',
      'skip_arrow': 'Skip →',
      'no_package_selected': 'No package selected',
      'selected_label': 'Selected',
      'optional_skip': 'Optional — you may skip',
      'confirm_label': 'Confirm',

      // ─── Package Details ───
      'package_includes': 'Package Includes',

      // ─── Reviews ───
      'reviews_ratings': 'Reviews & Ratings',
      'write_review': 'Write a Review',
      'user_name': 'User Name',

      // ─── Beauticians ───
      'select_beautician': 'Select Beautician',
      'beautician_name': 'Beautician Name',
      'specialist': 'Specialist',
      'no_selection': 'No selection',
      'choose_beautician': 'Please choose a beautician',
      'select_beautician_error': 'Please select a beautician',

      // ─── Beautician Details ───
      'details': 'Details',
      'specializations': 'Specializations',
      'about': 'About',
      'no_specializations': 'No specializations listed.',

      // ─── Salon Location ───
      'salon_location': 'Salon Location',
      'open_hours_prefix': 'Open',
      'directions': 'Directions',
      'call_now': 'Call Now',

      // ─── Favorites ───
      'my_favorites': 'My Favorites',
      'no_favorites': 'No favorites found.',
    },

    'ur': {
      // ─── Common ───
      'loading': 'لوڈنگ',
      'error': 'خطا',
      'success': 'کامیاب',
      'retry': 'دوبارہ کوشش کریں',
      'yes': 'ہاں',
      'no': 'نہیں',
      'confirm': 'تصدیق',
      'cancel': 'منسوخ',
      'save': 'محفوظ کریں',
      'continue_text': 'جاری رکھیں',
      'close': 'بند کریں',
      'done': 'ہو گیا',
      'ok': 'ٹھیک ہے',
      'apply': 'لاگو کریں',
      'reset': 'ری سیٹ',
      'see_all': 'سب دیکھیں',
      'sort': 'ترتیب',
      'from_rs': 'سے',

      // ─── Bottom Nav ───
      'nav_home': 'ہوم',
      'nav_explore': 'دریافت',
      'nav_bookings': 'بکنگ',
      'nav_favorites': 'محبوبہ',
      'nav_profile': 'پروفائل',

      // ─── Splash ───
      'splash_ever': 'ایور',
      'splash_salon': 'سیلون',
      'splash_tagline': 'بک کریں۔ منظم کریں۔ چمکیں۔',
      'splash_loading': 'آپ کی خوبصورتی کی دنیا لوڈ ہو رہی ہے...',

      // ─── Onboarding ───
      'onboard_discover_title': 'بہترین سیلون دریافت کریں',
      'onboard_discover_desc':
          'قابل اعتماد جائزوں کے ساتھ اپنے قریب بہترین سیلون تلاش کریں۔',
      'onboard_booking_title': 'آسان بکنگ',
      'onboard_booking_desc':
          'اپنی پسندیدہ سروس منتخب کریں، وقت چنیں اور فوراً بک کریں۔',
      'onboard_offers_title': 'شاندار آفرز',
      'onboard_offers_desc':
          'خصوصی آفرز، رعایتیں اور لائلٹی انعامات سے لطف اندوز ہوں۔',
      'skip': 'چھوڑیں',

      // ─── Login ───
      'login_success': 'لاگ ان کامیاب!',
      'welcome_back': 'خوش آمدید!',
      'login_to_continue': 'جاری رکھنے کے لیے لاگ ان کریں',
      'email_or_phone': 'ای میل یا فون نمبر',
      'password': 'پاس ورڈ',
      'forgot_password': 'پاس ورڈ بھول گئے؟',
      'login': 'لاگ ان',
      'or': 'یا',
      'dont_have_account': 'اکاؤنٹ نہیں ہے؟ ',
      'register': 'رجسٹر',

      // ─── Register ───
      'accept_terms_error': 'براہ کرم شرائط و ضوابط قبول کریں',
      'registration_success': 'رجسٹریشن کامیاب!',
      'create_account': 'اکاؤنٹ بنائیں',
      'sign_up_get_started': 'شروع کرنے کے لیے سائن اپ کریں',
      'full_name': 'پورا نام',
      'confirm_password': 'پاس ورڈ کی تصدیق کریں',
      'i_agree_to': 'میں متفق ہوں ',
      'terms_conditions': 'شرائط و ضوابط',
      'already_have_account': 'پہلے سے اکاؤنٹ ہے؟ ',

      // ─── Forgot Password ───
      'reset_link_sent': 'ری سیٹ لنک کامیابی سے بھیج دیا گیا!',
      'forgot_password_title': 'پاس ورڈ بھول گئے؟',
      'forgot_password_desc':
          'فکر نہ کریں! اپنا رجسٹرڈ ای میل یا فون نمبر درج کریں اور ہم آپ کو ری سیٹ لنک بھیج دیں گے۔',
      'send_reset_link': 'ری سیٹ لنک بھیجیں',
      'remember_password': 'اپنا پاس ورڈ یاد ہے؟ ',

      // ─── Reset Password ───
      'password_reset_success': 'پاس ورڈ کامیابی سے ری سیٹ ہو گیا!',
      'reset_password': 'پاس ورڈ ری سیٹ کریں',
      'create_new_password': 'نئا پاس ورڈ بنائیں',
      'new_password': 'نئا پاس ورڈ',
      'confirm_new_password': 'نئے پاس ورڈ کی تصدیق کریں',
      'at_least_8_chars': 'کم از کم 8 حروف',
      'one_uppercase': 'ایک بڑا حرف',
      'one_number': 'ایک نمبر',
      'one_special_char': 'ایک خاص علامت',

      // ─── OTP ───
      'verify_your_number': 'اپنے نمبر کی تصدیق کریں',
      'enter_4digit_code': 'درج کریں 4 ہندسوں کا کوڈ جو ہم نے بھیجا ہے',
      'resend_code_in': 'کوڈ دوبارہ بھیجیں ',
      'resend': 'دوبارہ بھیجیں',
      'verify': 'تصدیق کریں',
      'enter_otp_error': 'براہ کرم 4 ہندسوں کا OTP درج کریں',
      'otp_verified': 'OTP کامیابی سے تصدیق ہو گیا!',
      'otp_resent': 'OTP دوبارہ بھیج دیا گیا!',

      // ─── Profile ───
      'my_profile': 'میری پروفائل',
      'edit_profile': 'پروفائل میں ترمیم',
      'my_bookings': 'میری بکنگز',
      'loyalty_points': 'لائلٹی پوائنٹس',
      'membership': 'ممبرشپ',
      'gift_cards': 'گفٹ کارڈز',
      'payment_methods': 'ادائیگی کے طریقے',
      'payment_coming_soon': 'ادائیگی کے طریقے - جلد آرہے ہیں',
      'addresses': 'پتے',
      'addresses_coming_soon': 'پتے - جلد آرہے ہیں',
      'notification_settings': 'اطلاعات کی ترتیبات',
      'account_settings': 'اکاؤنٹ کی ترتیبات',
      'app_theme': 'ایپ تھیم',
      'dark': 'ڈارک',
      'light': 'لائٹ',
      'system': 'سسٹم',
      'language': 'زبان',
      'help_support': 'مدد اور سپورٹ',
      'help_coming_soon': 'مدد اور سپورٹ - جلد آرہا ہے',
      'pts': 'پوائنٹس',
      'cards': 'کارڈز',

      // ─── Edit Profile ───
      'phone_number': 'فون نمبر',
      'email_address': 'ای میل ایڈریس',
      'date_of_birth': 'تاریخ پیدائش',
      'gender': 'جنس',
      'female': 'خاتون',
      'male': 'مرد',
      'other': 'دیگر',
      'address': 'پتہ',
      'save_changes': 'تبدیلیاں محفوظ کریں',
      'profile_updated': 'پروفائل کامیابی سے اپڈیٹ ہو گئی!',

      // ─── Language Selection ───
      'select_language': 'زبان منتخب کریں',
      'choose_language': 'اپنی پسندیدہ زبان منتخب کریں۔',
      'default_lang': 'ڈیفالٹ',

      // ─── Account Settings ───
      'change_password': 'پاس ورڈ تبدیل کریں',
      'change_password_soon': 'پاس ورڈ تبدیل کرنا جلد آرہا ہے',
      'privacy_policy': 'پرائیویسی پالیسی',
      'privacy_policy_soon': 'پرائیویسی پالیسی جلد آرہی ہے',
      'terms_conditions_title': 'شرائط و ضوابط',
      'terms_conditions_soon': 'شرائط و ضوابط جلد آرہے ہیں',
      'delete_account': 'اکاؤنٹ حذف کریں',
      'delete_account_confirm':
          'کیا آپ واقعی اپنا اکاؤنٹ مستقل طور پر حذف کرنا چاہتے ہیں؟ یہ عمل واپس نہیں ہو سکتا۔',
      'delete': 'حذف کریں',
      'log_out': 'لاگ آؤٹ',
      'log_out_confirm': 'کیا آپ اپنے اکاؤنٹ سے لاگ آؤٹ کرنا چاہتے ہیں؟',

      // ─── Loyalty Points ───
      'available_points': 'دستیاب پوائنٹس',
      'earning_smiles': 'آپ مسکرات کما رہے ہیں!',
      'pts_away_from': 'پوائنٹس دور',
      'you_are_pts_away': "آپ {pts} پوائنٹس دور ہیں {tier} سے",
      'how_earn_points': 'آپ پوائنٹس کیسے کمائیں',
      'view_points_history': 'پوائنٹس کی تاریخ دیکھیں',

      // ─── Loyalty History ───
      'points_history': 'پوائنٹس کی تاریخ',
      'no_history': 'کوئی تاریخ نہیں مل۔',

      // ─── Membership ───
      'my_membership': 'میری ممبرشپ',
      'enjoy_benefits': 'خصوصی فوائد سے لطف اندوز ہوں',
      'member_since': 'رکنیت از',
      'member_id': 'ممبر آئی ڈی',
      'membership_benefits': 'ممبرشپ کے فوائد',
      'enjoy_exclusive_benefits': 'خصوصی فوائد سے لطف اندوز ہوں',
      'view_membership_details': 'ممبرشپ کی تفصیلات دیکھیں',

      // ─── Membership Details ───
      'membership_details': 'ممبرشپ کی تفصیلات',
      'valid_till': 'درست تا',
      'status': 'اسٹیٹس',

      // ─── Gift Cards ───
      'my_gift_cards': 'میرے گفٹ کارڈز',
      'add_card': '+ کارڈ شامل کریں',
      'no_gift_cards': 'کوئی گفٹ کارڈ نہیں مل۔',
      'ever_salon': 'ایور سیلون',
      'gift_card': 'گفٹ کارڈ',
      'balance': 'بیلنس',
      'card_no': 'کارڈ نمبر۔',

      // ─── Home ───
      'good_morning': 'صبح بخیر',
      'search_hint': 'سیلون، خدمات تلاش کریں...',
      'search_artists': 'سیلون، خدمات، آرٹسٹ تلاش کریں...',
      'categories': 'اقسام',
      'featured_salons': 'نمایاں سیلون',
      'explore_placeholder': 'ایکسپلور اسکرین (Screen 14 later)',

      // ─── Nearby Salons ───
      'nearby_salons': 'قریبی سیلون',
      'view_on_map': 'نقشے پر دیکھیں',

      // ─── Featured Salons ───
      'book_now': 'ابھی بک کریں',

      // ─── All Salons ───
      'all_salons': 'تمام سیلون',
      'nearby': 'قریبی',

      // ─── Search ───
      'search': 'تلاش',
      'search_hint_long': 'سیلون، خدمات، آرٹسٹ تلاش کریں...',
      'recent_searches': 'حالیہ تلاشیں',
      'clear_all': 'سب صاف کریں',
      'popular_searches': 'مقبول تلاشیں',
      'no_matching': 'کوئی مماثل سیلون یا سروس نہیں ملی۔',

      // ─── Filters ───
      'filters': 'فلٹرز',
      'sort_by': 'ترتیب دیں',
      'distance': 'فاصلہ',
      'km': 'کلومیٹر',
      'price_range': 'قیمت کی حد',
      'rating': 'ریٹنگ',
      'apply_filters': 'فلٹرز لاگو کریں',

      // ─── Notifications ───
      'notifications': 'اطلاعات',
      'no_notifications': 'کوئی نئی اطلاع نہیں',

      // ─── Offers ───
      'offers': 'آفرز',
      'no_offers': 'کوئی آفر دستیاب نہیں',
      'use_code': 'کوڈ استعمال کریں:',
      'copy': 'کاپی',
      'code_copied': "کوڈ '{code}' کاپی ہو گیا!",

      // ─── Categories Screen ───
      'search_categories': 'اقسام تلاش کریں...',
      'no_categories': 'کوئی قسم نہیں ملی',

      // ─── Search Results ───
      'search_results': 'تلاش کے نتائج',
      'search_dots': 'تلاش...',
      'results_found': 'نتائج ملے',
      'no_results': 'کوئی نتائج نہیں ملے',

      // ─── Bookings ───
      'upcoming': 'آنے والی',
      'completed': 'مکمل',
      'cancelled': 'منسوخ شدہ',
      'no_bookings': 'کوئی بکنگ نہیں ملی۔',
      'service': 'سروس',
      'confirmed': 'تصدیق شدہ',
      'salon': 'سیلون',

      // ─── Upcoming Booking ───
      'upcoming_booking': 'آنے والی بکنگ',
      'beautician': 'بیوٹیشن',
      'duration': 'دورانیہ',
      'price': 'قیمت',
      'rs': 'روپے',
      'mins': 'منٹ',
      'view_full_details': 'مکمل تفصیلات دیکھیں',
      'booking_id_invoice': 'بکنگ آئی ڈی، انوائس اور مزید',
      'reschedule': 'دوبارہ طے کریں',
      'cancel_booking': 'بکنگ منسوخ کریں',

      // ─── Completed Booking ───
      'how_was_experience': 'آپ کا تجربہ کیسا رہا؟',
      'write_review_optional': 'ریویو لکھیں (اختیاری)',
      'submit_review': 'ریویو جمع کریں',
      'review_submitted': 'ریویو کامیابی سے جمع ہو گیا!',
      'review_failed': 'ریویو جمع نہیں ہو سکا۔ دوبارہ کوشش کریں۔',

      // ─── Booking Details ───
      'booking_details': 'بکنگ کی تفصیلات',
      'booking_id': 'بکنگ آئی ڈی',
      'date': 'تاریخ',
      'time': 'وقت',
      'total_paid': 'کل ادا شدہ',
      'view_invoice': 'انوائس دیکھیں',
      'invoice_ready': 'انوائس تیار ہے (مشترکہ ڈاؤن لوڈ)۔',
      'invoice_failed': 'انوائس ڈاؤن لوڈ نہیں ہو سکی۔',
      'qr_checkin': 'QR چیک اِن',
      'share_booking': 'بکنگ شیئر کریں',

      // ─── Cancel Booking ───
      'booking_cancelled': 'بکنگ منسوخ',
      'booking_cancelled_desc': 'آپ کی بکنگ کامیابی سے منسوخ ہو گئی ہے۔',
      'back_to_bookings': 'میری بکنگز پر واپس',
      'explore_salons': 'دوسرے سیلون دریافت کریں',

      // ─── Reschedule ───
      'reschedule_booking': 'بکنگ دوبارہ طے کریں',
      'select_new_date': 'نئی تاریخ منتخب کریں',
      'sun': 'اتوار',
      'mon': 'پیر',
      'tue': 'منگل',
      'wed': 'بدھ',
      'thu': 'جمعرات',
      'fri': 'جمعہ',
      'sat': 'ہفتہ',
      'select_time_slot': 'وقت کا سلاٹ منتخب کریں',
      'confirm_reschedule': 'دوبارہ طے کرنے کی تصدیق کریں',
      'reschedule_success': 'بکنگ کامیابی سے دوبارہ طے ہو گئی!',
      'reschedule_failed': 'دوبارہ طے نہیں ہو سکا۔ دوبارہ کوشش کریں۔',

      // ─── Cancellation Reason ───
      'cancellation_reason': 'منسوخی کی وجہ',
      'are_you_sure': 'کیا آپ کو یقین ہے؟',
      'cancel_booking_desc':
          'آپ یہ بکنگ منسوخ کرنا چاہتے ہیں۔ یہ عمل واپس نہیں ہو سکتا۔',
      'select_reason': 'وجہ منتخب کریں',
      'additional_notes': 'اضافی نوٹس (اختیاری)',
      'write_notes': 'اپنے نوٹس لکھیں...',
      'cancellation_failed': 'منسوخی ناکام ہو گئی۔ دوبارہ کوشش کریں۔',

      // ─── Booking Confirmed ───
      'booking_confirmed': 'بکنگ تصدیق شدہ!',
      'appointment_booked': 'آپ کی اپائنٹمنٹ کامیابی سے بک ہو گئی ہے۔',
      'view_my_bookings': 'میری بکنگز دیکھیں',
      'back_to_home': 'ہوم پر واپس',

      // ─── Payment ───
      'payment': 'ادائیگی',
      'amount_to_pay': 'ادا کرنے کی رقم',
      'pay': 'ادا کریں',
      'payment_failed': 'ادائیگی ناکام۔ براہ کرم دوبارہ کوشش کریں۔',

      // ─── QR Check-in ───
      'your_booking_qr': 'آپ کی بکنگ QR',
      'qr_scan_instruction': 'چیک اِن کے لیے سیلون میں یہ QR کوڈ دکھائیں۔',
      'date_time': 'تاریخ اور وقت',
      'download_qr': 'QR ڈاؤن لوڈ کریں',
      'qr_saved': 'QR کامیابی سے محفوظ ہو گیا!',
      'qr_download_failed': 'QR ڈاؤن لوڈ ناکام',

      // ─── Add Notes ───
      'add_notes': 'نوٹس شامل کریں',
      'special_requests': 'کوئی خصوصی درخواست؟',
      'notes_hint': 'مثلاً میری جلد حساس ہے، بالوں پر کم گرماہٹ پسند ہے۔',
      'notes_optional':
          'نوٹس اختیاری ہیں۔ اگر کوئی خصوصی درخواست نہیں تو آپ یہ مرحلہ چھوڑ سکتے ہیں۔',

      // ─── Time Slots ───
      'available_time_slots': 'دستیاب وقت کی سلاٹ',
      'no_time_slots': 'کوئی وقت سلاٹ دستیاب نہیں',
      'selected_time': 'منتخب وقت',
      'please_select_time': 'براہ کرم وقت منتخب کریں',
      'please_select_slot': 'براہ کرم وقت سلاٹ منتخب کریں',
      'continue': 'جاری رکھیں',

      // ─── Apply Coupon ───
      'apply_coupon': 'کوپن لاگو کریں',
      'have_coupon': 'کیا آپ کے پاس کوپن کوڈ ہے؟',
      'enter_coupon': 'کوپن کوڈ درج کریں',
      'available_coupons': 'دستیاب کوپن',
      'skip_to_payment': 'اسکیپ کریں اور ادائیگی پر جائیں',
      'enter_valid_coupon': 'براہ کرم درست کوپن کوڈ درج کریں',
      'invalid_coupon': 'غلط کوپن کوڈ',
      'coupon_applied': "کوپن '{code}' لاگو ہو گیا!",
      'code': 'کوڈ',

      // ─── Select Date ───
      'select_date': 'تاریخ منتخب کریں',
      'selected_date': 'منتخب تاریخ',
      'select_date_first': 'براہ کرم پہلے تاریخ منتخب کریں',

      // ─── Booking Summary ───
      'booking_summary': 'بکنگ کا خلاصہ',
      'price_details': 'قیمت کی تفصیلات',
      'subtotal': 'سب ٹوٹل',
      'service_tax': 'سروس ٹیکس (5%)',
      'total_amount': 'کل رقم',

      // ─── Salon Details ───
      'salon_name': 'سیلون کا نام',
      'open_now': 'ابھی کھلا',
      'unisex_salon': 'یونی سیکس سیلون',
      'call': 'کال کریں',
      'direction': 'راستہ',
      'share': 'شیئر کریں',
      'opening_hours': 'کھلنے کے اوقات',
      'mon_sun': 'پیر تا اتوار',
      'show_less': 'کم دکھائیں',
      'read_more': 'مزید پڑھیں',
      'gallery': 'گیلری',
      'our_services': 'ہماری خدمات',
      'our_packages': 'ہمارے پیکجز',
      'our_beauticians': 'ہمارے بیوٹیشن',
      'reviews': 'جائزے',
      'user': 'صارف',
      'location': 'مقام',
      'address_not_available': 'پتہ دستیاب نہیں',
      'book_appointment': 'اپائنٹمنٹ بک کریں',

      // ─── Services ───
      'select_services': 'خدمات منتخب کریں',
      'service_name': 'سروس کا نام',
      'items_selected': 'آئٹم منتخب',
      'select_at_least_one': 'براہ کرم کم از کم ایک سروس منتخب کریں',

      // ─── Service Details ───
      'duration_label': 'دورانیہ:',
      'about_service': 'اس سروس کے بارے میں',
      'service_includes': 'اس سروس میں شامل ہے',
      'details_not_available': 'تفصیلات دستیاب نہیں ہیں۔',

      // ─── Packages ───
      'select_package': 'پیکج منتخب کریں',
      'package_name': 'پیکج کا نام',
      'skip_arrow': 'اسکیپ →',
      'no_package_selected': 'کوئی پیکج منتخب نہیں',
      'selected_label': 'منتخب',
      'optional_skip': 'اختیاری — آپ چھوڑ سکتے ہیں',
      'confirm_label': 'تصدیق کریں',

      // ─── Package Details ───
      'package_includes': 'پیکج میں شامل ہے',

      // ─── Reviews ───
      'reviews_ratings': 'جائزے اور ریٹنگز',
      'write_review': 'ریویو لکھیں',
      'user_name': 'صارف کا نام',

      // ─── Beauticians ───
      'select_beautician': 'بیوٹیشن منتخب کریں',
      'beautician_name': 'بیوٹیشن کا نام',
      'specialist': 'ماہر',
      'no_selection': 'کوئی انتخاب نہیں',
      'choose_beautician': 'براہ کرم بیوٹیشن چنیں',
      'select_beautician_error': 'براہ کرم بیوٹیشن منتخب کریں',

      // ─── Beautician Details ───
      'details': 'تفصیلات',
      'specializations': 'مہارتیں',
      'about': 'کے بارے میں',
      'no_specializations': 'کوئی مہارت درج نہیں۔',

      // ─── Salon Location ───
      'salon_location': 'سیلون کا مقام',
      'open_hours_prefix': 'کھلا',
      'directions': 'راستہ',
      'call_now': 'اب کال کریں',

      // ─── Favorites ───
      'my_favorites': 'میرے محبوبہ',
      'no_favorites': 'کوئی محبوبہ نہیں ملی۔',
    },

    'ar': {
      // ─── Common ───
      'loading': 'جارٍ التحميل',
      'error': 'خطأ',
      'success': 'نجاح',
      'retry': 'إعادة المحاولة',
      'yes': 'نعم',
      'no': 'لا',
      'confirm': 'تأكيد',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'continue_text': 'متابعة',
      'close': 'إغلاق',
      'done': 'تم',
      'ok': 'موافق',
      'apply': 'تطبيق',
      'reset': 'إعادة تعيين',
      'see_all': 'عرض الكل',
      'sort': 'ترتيب',
      'from_rs': 'من',

      // ─── Bottom Nav ───
      'nav_home': 'الرئيسية',
      'nav_explore': 'استكشاف',
      'nav_bookings': 'الحجوزات',
      'nav_favorites': 'المفضلة',
      'nav_profile': 'الملف الشخصي',

      // ─── Splash ───
      'splash_ever': 'إيفر',
      'splash_salon': 'صالون',
      'splash_tagline': 'احجز. أدر. تتألقي.',
      'splash_loading': 'جارٍ تحميل عالم الجمال الخاص بك...',

      // ─── Onboarding ───
      'onboard_discover_title': 'اكتشفي أفضل الصالونات',
      'onboard_discover_desc':
          'اكتشفي أفضل الصالونات القريبة منك مع تقييمات موثوقة.',
      'onboard_booking_title': 'حجز سهل',
      'onboard_booking_desc': 'اختاري خدمتك المفضلة، حددي الوقت واحجزي فورًا.',
      'onboard_offers_title': 'عروض مذهلة',
      'onboard_offers_desc': 'استمتعي بعروض حصرية وخصومات ومكافآت الولاء.',
      'skip': 'تخطي',

      // ─── Login ───
      'login_success': 'تم تسجيل الدخول بنجاح!',
      'welcome_back': 'مرحبًا بعودتك!',
      'login_to_continue': 'سجلي الدخول للمتابعة',
      'email_or_phone': 'البريد الإلكتروني أو رقم الهاتف',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'login': 'تسجيل الدخول',
      'or': 'أو',
      'dont_have_account': 'ليس لديك حساب؟ ',
      'register': 'تسجيل',

      // ─── Register ───
      'accept_terms_error': 'يرجى قبول الشروط والأحكام',
      'registration_success': 'تم التسجيل بنجاح!',
      'create_account': 'إنشاء حساب',
      'sign_up_get_started': 'سجلي للبدء',
      'full_name': 'الاسم الكامل',
      'confirm_password': 'تأكيد كلمة المرور',
      'i_agree_to': 'أوافق على ',
      'terms_conditions': 'الشروط والأحكام',
      'already_have_account': 'لديك حساب بالفعل؟ ',

      // ─── Forgot Password ───
      'reset_link_sent': 'تم إرسال رابط إعادة التعيين بنجاح!',
      'forgot_password_title': 'نسيت كلمة المرور؟',
      'forgot_password_desc':
          'لا تقلقي! أدخلي بريدك الإلكتروني أو رقم هاتفك المسجل وسنرسل لك رابط إعادة التعيين.',
      'send_reset_link': 'إرسال رابط إعادة التعيين',
      'remember_password': 'تتذكرين كلمة المرور؟ ',

      // ─── Reset Password ───
      'password_reset_success': 'تمت إعادة تعيين كلمة المرور بنجاح!',
      'reset_password': 'إعادة تعيين كلمة المرور',
      'create_new_password': 'إنشاء كلمة مرور جديدة',
      'new_password': 'كلمة المرور الجديدة',
      'confirm_new_password': 'تأكيد كلمة المرور الجديدة',
      'at_least_8_chars': '8 أحرف على الأقل',
      'one_uppercase': 'حرف كبير واحد',
      'one_number': 'رقم واحد',
      'one_special_char': 'رمز خاص واحد',

      // ─── OTP ───
      'verify_your_number': 'تأكيد رقمك',
      'enter_4digit_code': 'أدخلي الرمز المكون من 4 أرقام الذي أرسلناه إلى',
      'resend_code_in': 'إعادة إرسال الرمز خلال ',
      'resend': 'إعادة إرسال',
      'verify': 'تحقق',
      'enter_otp_error': 'يرجى إدخال رمز OTP المكون من 4 أرقام',
      'otp_verified': 'تم التحقق من OTP بنجاح!',
      'otp_resent': 'تمت إعادة إرسال OTP بنجاح!',

      // ─── Profile ───
      'my_profile': 'ملفي الشخصي',
      'edit_profile': 'تعديل الملف الشخصي',
      'my_bookings': 'حجوزاتي',
      'loyalty_points': 'نقاط الولاء',
      'membership': 'العضوية',
      'gift_cards': 'بطاقات الهدايا',
      'payment_methods': 'طرق الدفع',
      'payment_coming_soon': 'طرق الدفع - قريبًا',
      'addresses': 'العناوين',
      'addresses_coming_soon': 'العناوين - قريبًا',
      'notification_settings': 'إعدادات الإشعارات',
      'account_settings': 'إعدادات الحساب',
      'app_theme': 'مظهر التطبيق',
      'dark': 'داكن',
      'light': 'فاتح',
      'system': 'النظام',
      'language': 'اللغة',
      'help_support': 'المساعدة والدعم',
      'help_coming_soon': 'المساعدة والدعم - قريبًا',
      'pts': 'نقطة',
      'cards': 'بطاقات',

      // ─── Edit Profile ───
      'phone_number': 'رقم الهاتف',
      'email_address': 'البريد الإلكتروني',
      'date_of_birth': 'تاريخ الميلاد',
      'gender': 'الجنس',
      'female': 'أنثى',
      'male': 'ذكر',
      'other': 'أخرى',
      'address': 'العنوان',
      'save_changes': 'حفظ التغييرات',
      'profile_updated': 'تم تحديث الملف الشخصي بنجاح!',

      // ─── Language Selection ───
      'select_language': 'اختر اللغة',
      'choose_language': 'اختاري لغتك المفضلة.',
      'default_lang': 'الافتراضي',

      // ─── Account Settings ───
      'change_password': 'تغيير كلمة المرور',
      'change_password_soon': 'تغيير كلمة المرور قريبًا',
      'privacy_policy': 'سياسة الخصوصية',
      'privacy_policy_soon': 'سياسة الخصوصية قريبًا',
      'terms_conditions_title': 'الشروط والأحكام',
      'terms_conditions_soon': 'الشروط والأحكام قريبًا',
      'delete_account': 'حذف الحساب',
      'delete_account_confirm':
          'هل أنت متأكد من رغبتك في حذف حسابك نهائيًا؟ لا يمكن التراجع عن هذا الإجراء.',
      'delete': 'حذف',
      'log_out': 'تسجيل الخروج',
      'log_out_confirm': 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',

      // ─── Loyalty Points ───
      'available_points': 'النقاط المتاحة',
      'earning_smiles': 'أنت تربح ابتسامات!',
      'pts_away_from': 'نقطة بعيدًا عن',
      'you_are_pts_away': "أنت على بعد {pts} نقطة عن {tier}",
      'how_earn_points': 'كيف تربح النقاط',
      'view_points_history': 'عرض سجل النقاط',

      // ─── Loyalty History ───
      'points_history': 'سجل النقاط',
      'no_history': 'لا يوجد سجل.',

      // ─── Membership ───
      'my_membership': 'عضويتي',
      'enjoy_benefits': 'استمتع بمزايا حصرية',
      'member_since': 'عضو منذ',
      'member_id': 'رقم العضوية',
      'membership_benefits': 'مزايا العضوية',
      'enjoy_exclusive_benefits': 'استمتع بالفوائد الحصرية',
      'view_membership_details': 'عرض تفاصيل العضوية',

      // ─── Membership Details ───
      'membership_details': 'تفاصيل العضوية',
      'valid_till': 'صالح حتى',
      'status': 'الحالة',

      // ─── Gift Cards ───
      'my_gift_cards': 'بطاقات الهدايا',
      'add_card': '+ إضافة بطاقة',
      'no_gift_cards': 'لا توجد بطاقات هدايا.',
      'ever_salon': 'إيفر سالون',
      'gift_card': 'بطاقة هدية',
      'balance': 'الرصيد',
      'card_no': 'رقم البطاقة.',

      // ─── Home ───
      'good_morning': 'صباح الخير',
      'search_hint': 'ابحث عن الصالونات والخدمات...',
      'search_artists': 'ابحث عن الصالونات والخدمات والفنانين...',
      'categories': 'الفئات',
      'featured_salons': 'صالونات مميزة',
      'explore_placeholder': 'شاشة الاستكشاف (Screen 14 later)',

      // ─── Nearby Salons ───
      'nearby_salons': 'الصالونات القريبة',
      'view_on_map': 'عرض على الخريطة',

      // ─── Featured Salons ───
      'book_now': 'احجز الآن',

      // ─── All Salons ───
      'all_salons': 'جميع الصالونات',
      'nearby': 'قريب',

      // ─── Search ───
      'search': 'بحث',
      'search_hint_long': 'ابحث عن الصالونات والخدمات والفنانين...',
      'recent_searches': 'عمليات البحث الأخيرة',
      'clear_all': 'مسح الكل',
      'popular_searches': 'البحث الشائع',
      'no_matching': 'لا توجد صالونات أو خدمات مطابقة.',

      // ─── Filters ───
      'filters': 'الفلاتر',
      'sort_by': 'ترتيب حسب',
      'distance': 'المسافة',
      'km': 'كم',
      'price_range': 'نطاق السعر',
      'rating': 'التقييم',
      'apply_filters': 'تطبيق الفلاتر',

      // ─── Notifications ───
      'notifications': 'الإشعارات',
      'no_notifications': 'لا توجد إشعارات جديدة',

      // ─── Offers ───
      'offers': 'العروض',
      'no_offers': 'لا توجد عروض متاحة',
      'use_code': 'استخدم الكود:',
      'copy': 'نسخ',
      'code_copied': "تم نسخ الكود '{code}'!",

      // ─── Categories Screen ───
      'search_categories': 'ابحث عن الفئات...',
      'no_categories': 'لا توجد فئات',

      // ─── Search Results ───
      'search_results': 'نتائج البحث',
      'search_dots': 'بحث...',
      'results_found': 'نتيجة',
      'no_results': 'لا توجد نتائج',

      // ─── Bookings ───
      'upcoming': 'القادمة',
      'completed': 'مكتملة',
      'cancelled': 'ملغاة',
      'no_bookings': 'لا توجد حجوزات.',
      'service': 'الخدمة',
      'confirmed': 'مؤكد',
      'salon': 'الصالون',

      // ─── Upcoming Booking ───
      'upcoming_booking': 'الحجز القادم',
      'beautician': 'خبيرة التجميل',
      'duration': 'المدة',
      'price': 'السعر',
      'rs': 'ر.س',
      'mins': 'دقيقة',
      'view_full_details': 'عرض التفاصيل الكاملة',
      'booking_id_invoice': 'رقم الحجز والفاتورة والمزيد',
      'reschedule': 'إعادة الجدولة',
      'cancel_booking': 'إلغاء الحجز',

      // ─── Completed Booking ───
      'how_was_experience': 'كيف كانت تجربتك؟',
      'write_review_optional': 'اكتب تقييمًا (اختياري)',
      'submit_review': 'إرسال التقييم',
      'review_submitted': 'تم إرسال التقييم بنجاح!',
      'review_failed': 'فشل إرسال التقييم. حاول مرة أخرى.',

      // ─── Booking Details ───
      'booking_details': 'تفاصيل الحجز',
      'booking_id': 'رقم الحجز',
      'date': 'التاريخ',
      'time': 'الوقت',
      'total_paid': 'إجمالي المدفوع',
      'view_invoice': 'عرض الفاتورة',
      'invoice_ready': 'الفاتورة جاهزة (تنزيل تجريبي).',
      'invoice_failed': 'فشل تنزيل الفاتورة.',
      'qr_checkin': 'تسجيل الدخول QR',
      'share_booking': 'مشاركة الحجز',

      // ─── Cancel Booking ───
      'booking_cancelled': 'تم إلغاء الحجز',
      'booking_cancelled_desc': 'تم إلغاء حجزك بنجاح.',
      'back_to_bookings': 'العودة إلى حجوزاتي',
      'explore_salons': 'استكشف صالونات أخرى',

      // ─── Reschedule ───
      'reschedule_booking': 'إعادة جدولة الحجز',
      'select_new_date': 'اختر تاريخًا جديدًا',
      'sun': 'الأحد',
      'mon': 'الاثنين',
      'tue': 'الثلاثاء',
      'wed': 'الأربعاء',
      'thu': 'الخميس',
      'fri': 'الجمعة',
      'sat': 'السبت',
      'select_time_slot': 'اختر وقتًا',
      'confirm_reschedule': 'تأكيد إعادة الجدولة',
      'reschedule_success': 'تمت إعادة جدولة الحجز بنجاح!',
      'reschedule_failed': 'فشلت إعادة الجدولة. حاول مرة أخرى.',

      // ─── Cancellation Reason ───
      'cancellation_reason': 'سبب الإلغاء',
      'are_you_sure': 'هل أنت متأكد؟',
      'cancel_booking_desc':
          'أنت تريد إلغاء هذا الحجز. لا يمكن التراجع عن هذا الإجراء.',
      'select_reason': 'اختر السبب',
      'additional_notes': 'ملاحظات إضافية (اختياري)',
      'write_notes': 'اكتب ملاحظاتك...',
      'cancellation_failed': 'فشل الإلغاء. حاول مرة أخرى.',

      // ─── Booking Confirmed ───
      'booking_confirmed': 'تم تأكيد الحجز!',
      'appointment_booked': 'تم حجز موعدك بنجاح.',
      'view_my_bookings': 'عرض حجوزاتي',
      'back_to_home': 'العودة إلى الرئيسية',

      // ─── Payment ───
      'payment': 'الدفع',
      'amount_to_pay': 'المبلغ المطلوب',
      'pay': 'ادفع',
      'payment_failed': 'فشل الدفع. يرجى المحاولة مرة أخرى.',

      // ─── QR Check-in ───
      'your_booking_qr': 'رمز QR لحجزك',
      'qr_scan_instruction': 'أظهر رمز QR هذا في الصالون لتسجيل الدخول.',
      'date_time': 'التاريخ والوقت',
      'download_qr': 'تنزيل QR',
      'qr_saved': 'تم حفظ QR بنجاح!',
      'qr_download_failed': 'فشل تنزيل QR',

      // ─── Add Notes ───
      'add_notes': 'إضافة ملاحظات',
      'special_requests': 'هل لديك أي طلبات خاصة؟',
      'notes_hint': 'مثال: بشرتي حساسة، أفضل حرارة أقل على الشعر، إلخ.',
      'notes_optional':
          'الملاحظات اختيارية. يمكنك تخطي هذه الخطوة إذا لم يكن لديك طلبات خاصة.',

      // ─── Time Slots ───
      'available_time_slots': 'الأوقات المتاحة',
      'no_time_slots': 'لا توجد أوقات متاحة',
      'selected_time': 'الوقت المحدد',
      'please_select_time': 'يرجى تحديد الوقت',
      'please_select_slot': 'يرجى تحديد وقت',
      'continue': 'متابعة',

      // ─── Apply Coupon ───
      'apply_coupon': 'تطبيق القسيمة',
      'have_coupon': 'هل لديك رمز قسيمة؟',
      'enter_coupon': 'أدخل رمز القسيمة',
      'available_coupons': 'القسائم المتاحة',
      'skip_to_payment': 'تخطي والمتابعة إلى الدفع',
      'enter_valid_coupon': 'يرجى إدخال رمز قسيمة صالح',
      'invalid_coupon': 'رمز قسيمة غير صالح',
      'coupon_applied': "تم تطبيق القسيمة '{code}'!",
      'code': 'الرمز',

      // ─── Select Date ───
      'select_date': 'اختر التاريخ',
      'selected_date': 'التاريخ المحدد',
      'select_date_first': 'يرجى اختيار التاريخ أولاً',

      // ─── Booking Summary ───
      'booking_summary': 'ملخص الحجز',
      'price_details': 'تفاصيل السعر',
      'subtotal': 'المجموع الفرعي',
      'service_tax': 'ضريبة الخدمة (5%)',
      'total_amount': 'المبلغ الإجمالي',

      // ─── Salon Details ───
      'salon_name': 'اسم الصالون',
      'open_now': 'مفتوح الآن',
      'unisex_salon': 'صالون مختلط',
      'call': 'اتصال',
      'direction': 'الاتجاه',
      'share': 'مشاركة',
      'opening_hours': 'ساعات العمل',
      'mon_sun': 'الاثنين - الأحد',
      'show_less': 'عرض أقل',
      'read_more': 'قراءة المزيد',
      'gallery': 'المعرض',
      'our_services': 'خدماتنا',
      'our_packages': 'باقاتنا',
      'our_beauticians': 'خبيراتنا',
      'reviews': 'التقييمات',
      'user': 'مستخدم',
      'location': 'الموقع',
      'address_not_available': 'العنوان غير متاح',
      'book_appointment': 'احجز موعدًا',

      // ─── Services ───
      'select_services': 'اختر الخدمات',
      'service_name': 'اسم الخدمة',
      'items_selected': 'العناصر المحددة',
      'select_at_least_one': 'يرجى اختيار خدمة واحدة على الأقل',

      // ─── Service Details ───
      'duration_label': 'المدة:',
      'about_service': 'حول هذه الخدمة',
      'service_includes': 'تشمل هذه الخدمة',
      'details_not_available': 'التفاصيل غير متاحة.',

      // ─── Packages ───
      'select_package': 'اختر الباقة',
      'package_name': 'اسم الباقة',
      'skip_arrow': 'تخطي ←',
      'no_package_selected': 'لم يتم اختيار أي باقة',
      'selected_label': 'محدد',
      'optional_skip': 'اختياري — يمكنك التخطي',
      'confirm_label': 'تأكيد',

      // ─── Package Details ───
      'package_includes': 'تشمل الباقة',

      // ─── Reviews ───
      'reviews_ratings': 'التقييمات والمراجعات',
      'write_review': 'اكتب تقييمًا',
      'user_name': 'اسم المستخدم',

      // ─── Beauticians ───
      'select_beautician': 'اختر خبيرة التجميل',
      'beautician_name': 'اسم خبيرة التجميل',
      'specialist': 'متخصصة',
      'no_selection': 'لا يوجد اختيار',
      'choose_beautician': 'يرجى اختيار خبيرة تجميل',
      'select_beautician_error': 'يرجى تحديد خبيرة التجميل',

      // ─── Beautician Details ───
      'details': 'التفاصيل',
      'specializations': 'التخصصات',
      'about': 'حول',
      'no_specializations': 'لا توجد تخصصات مدرجة.',

      // ─── Salon Location ───
      'salon_location': 'موقع الصالون',
      'open_hours_prefix': 'مفتوح',
      'directions': 'الاتجاهات',
      'call_now': 'اتصل الآن',

      // ─── Favorites ───
      'my_favorites': 'المفضلة',
      'no_favorites': 'لا توجد عناصر مفضلة.',
    },

    'hi': {
      // ─── Common ───
      'loading': 'लोड हो रहा है',
      'error': 'त्रुटि',
      'success': 'सफल',
      'retry': 'पुनः प्रयास करें',
      'yes': 'हाँ',
      'no': 'नहीं',
      'confirm': 'पुष्टि करें',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'continue_text': 'जारी रखें',
      'close': 'बंद करें',
      'done': 'हो गया',
      'ok': 'ठीक है',
      'apply': 'लागू करें',
      'reset': 'रीसेट',
      'see_all': 'सभी देखें',
      'sort': 'क्रमबद्ध',
      'from_rs': 'से',

      // ─── Bottom Nav ───
      'nav_home': 'होम',
      'nav_explore': 'एक्सप्लोर',
      'nav_bookings': 'बुकिंग',
      'nav_favorites': 'पसंदीदा',
      'nav_profile': 'प्रोफ़ाइल',

      // ─── Splash ───
      'splash_ever': 'एवर',
      'splash_salon': 'सैलून',
      'splash_tagline': 'बुक करें। प्रबंधित करें। चमकें।',
      'splash_loading': 'आपकी सुंदरता की दुनिया लोड हो रही है...',

      // ─── Onboarding ───
      'onboard_discover_title': 'शीर्ष सैलून खोजें',
      'onboard_discover_desc':
          'विश्वसनीय समीक्षाओं के साथ अपने पास के सर्वश्रेष्ठ सैलून खोजें।',
      'onboard_booking_title': 'आसान बुकिंग',
      'onboard_booking_desc':
          'अपनी पसंदीदा सेवा चुनें, समय चुनें और तुरंत बुक करें।',
      'onboard_offers_title': 'शानदार ऑफर',
      'onboard_offers_desc':
          'विशेष ऑफर, छूट और लॉयल्टी पुरस्कारों का आनंद लें।',
      'skip': 'छोड़ें',

      // ─── Login ───
      'login_success': 'लॉगिन सफल!',
      'welcome_back': 'वापसी पर स्वागत है!',
      'login_to_continue': 'जारी रखने के लिए लॉगिन करें',
      'email_or_phone': 'ईमेल या फ़ोन नंबर',
      'password': 'पासवर्ड',
      'forgot_password': 'पासवर्ड भूल गए?',
      'login': 'लॉगिन',
      'or': 'या',
      'dont_have_account': 'खाता नहीं है? ',
      'register': 'रजिस्टर',

      // ─── Register ───
      'accept_terms_error': 'कृपया नियम व शर्तें स्वीकार करें',
      'registration_success': 'पंजीकरण सफल!',
      'create_account': 'खाता बनाएं',
      'sign_up_get_started': 'शुरू करने के लिए साइन अप करें',
      'full_name': 'पूरा नाम',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'i_agree_to': 'मैं सहमत हूँ ',
      'terms_conditions': 'नियम व शर्तें',
      'already_have_account': 'पहले से खाता है? ',

      // ─── Forgot Password ───
      'reset_link_sent': 'रीसेट लिंक सफलतापूर्वक भेजा गया!',
      'forgot_password_title': 'पासवर्ड भूल गए?',
      'forgot_password_desc':
          'चिंता न करें! अपना पंजीकृत ईमेल या फ़ोन नंबर दर्ज करें और हम आपको रीसेट लिंक भेजेंगे।',
      'send_reset_link': 'रीसेट लिंक भेजें',
      'remember_password': 'अपना पासवर्ड याद है? ',

      // ─── Reset Password ───
      'password_reset_success': 'पासवर्ड सफलतापूर्वक रीसेट हुआ!',
      'reset_password': 'पासवर्ड रीसेट करें',
      'create_new_password': 'नया पासवर्ड बनाएं',
      'new_password': 'नया पासवर्ड',
      'confirm_new_password': 'नए पासवर्ड की पुष्टि करें',
      'at_least_8_chars': 'कम से कम 8 अक्षर',
      'one_uppercase': 'एक बड़ा अक्षर',
      'one_number': 'एक संख्या',
      'one_special_char': 'एक विशेष वर्ण',

      // ─── OTP ───
      'verify_your_number': 'अपना नंबर सत्यापित करें',
      'enter_4digit_code': 'हमारे द्वारा भेजा गया 4 अंकों का कोड दर्ज करें',
      'resend_code_in': 'कोड फिर से भेजें ',
      'resend': 'फिर से भेजें',
      'verify': 'सत्यापित करें',
      'enter_otp_error': 'कृपया 4 अंकों का OTP दर्ज करें',
      'otp_verified': 'OTP सफलतापूर्वक सत्यापित!',
      'otp_resent': 'OTP फिर से भेजा गया!',

      // ─── Profile ───
      'my_profile': 'मेरी प्रोफ़ाइल',
      'edit_profile': 'प्रोफ़ाइल संपादित करें',
      'my_bookings': 'मेरी बुकिंग',
      'loyalty_points': 'लॉयल्टी पॉइंट्स',
      'membership': 'मेम्बरशिप',
      'gift_cards': 'गिफ्ट कार्ड',
      'payment_methods': 'भुगतान के तरीके',
      'payment_coming_soon': 'भुगतान के तरीके - जल्द आ रहा है',
      'addresses': 'पते',
      'addresses_coming_soon': 'पते - जल्द आ रहा है',
      'notification_settings': 'सूचना सेटिंग्स',
      'account_settings': 'खाता सेटिंग्स',
      'app_theme': 'ऐप थीम',
      'dark': 'डार्क',
      'light': 'लाइट',
      'system': 'सिस्टम',
      'language': 'भाषा',
      'help_support': 'सहायता और समर्थन',
      'help_coming_soon': 'सहायता और समर्थन - जल्द आ रहा है',
      'pts': 'पॉइंट्स',
      'cards': 'कार्ड',

      // ─── Edit Profile ───
      'phone_number': 'फ़ोन नंबर',
      'email_address': 'ईमेल पता',
      'date_of_birth': 'जन्म तिथि',
      'gender': 'लिंग',
      'female': 'महिला',
      'male': 'पुरुष',
      'other': 'अन्य',
      'address': 'पता',
      'save_changes': 'बदलाव सहेजें',
      'profile_updated': 'प्रोफ़ाइल सफलतापूर्वक अपडेट हुई!',

      // ─── Language Selection ───
      'select_language': 'भाषा चुनें',
      'choose_language': 'अपनी पसंदीदा भाषा चुनें।',
      'default_lang': 'डिफ़ॉल्ट',

      // ─── Account Settings ───
      'change_password': 'पासवर्ड बदलें',
      'change_password_soon': 'पासवर्ड बदलना जल्द आ रहा है',
      'privacy_policy': 'गोपनीयता नीति',
      'privacy_policy_soon': 'गोपनीयता नीति जल्द आ रही है',
      'terms_conditions_title': 'नियम व शर्तें',
      'terms_conditions_soon': 'नियम व शर्तें जल्द आ रही हैं',
      'delete_account': 'खाता हटाएं',
      'delete_account_confirm':
          'क्या आप वाकई अपना खाता स्थायी रूप से हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।',
      'delete': 'हटाएं',
      'log_out': 'लॉग आउट',
      'log_out_confirm': 'क्या आप अपने खाते से लॉग आउट करना चाहते हैं?',

      // ─── Loyalty Points ───
      'available_points': 'उपलब्ध पॉइंट्स',
      'earning_smiles': 'आप मुस्कान कमा रहे हैं!',
      'pts_away_from': 'पॉइंट्स दूर',
      'you_are_pts_away': "आप {pts} पॉइंट्स दूर हैं {tier} से",
      'how_earn_points': 'आप पॉइंट्स कैसे कमाते हैं',
      'view_points_history': 'पॉइंट्स इतिहास देखें',

      // ─── Loyalty History ───
      'points_history': 'पॉइंट्स इतिहास',
      'no_history': 'कोई इतिहास नहीं मिला।',

      // ─── Membership ───
      'my_membership': 'मेरी मेम्बरशिप',
      'enjoy_benefits': 'विशेष लाभों का आनंद लें',
      'member_since': 'सदस्यता से',
      'member_id': 'सदस्य आईडी',
      'membership_benefits': 'मेम्बरशिप लाभ',
      'enjoy_exclusive_benefits': 'विशेष लाभ का आनंद लें',
      'view_membership_details': 'मेम्बरशिप विवरण देखें',

      // ─── Membership Details ───
      'membership_details': 'मेम्बरशिप विवरण',
      'valid_till': 'मान्य तक',
      'status': 'स्थिति',

      // ─── Gift Cards ───
      'my_gift_cards': 'मेरे गिफ्ट कार्ड',
      'add_card': '+ कार्ड जोड़ें',
      'no_gift_cards': 'कोई गिफ्ट कार्ड नहीं मिला।',
      'ever_salon': 'एवर सैलून',
      'gift_card': 'गिफ्ट कार्ड',
      'balance': 'बैलेंस',
      'card_no': 'कार्ड नंबर।',

      // ─── Home ───
      'good_morning': 'सुप्रभात',
      'search_hint': 'सैलून, सेवाएं खोजें...',
      'search_artists': 'सैलून, सेवाएं, कलाकार खोजें...',
      'categories': 'श्रेणियां',
      'featured_salons': 'फ़ीचर्ड सैलून',
      'explore_placeholder': 'एक्सप्लोर स्क्रीन (Screen 14 later)',

      // ─── Nearby Salons ───
      'nearby_salons': 'आस-पास के सैलून',
      'view_on_map': 'मानचित्र पर देखें',

      // ─── Featured Salons ───
      'book_now': 'अभी बुक करें',

      // ─── All Salons ───
      'all_salons': 'सभी सैलून',
      'nearby': 'आस-पास',

      // ─── Search ───
      'search': 'खोज',
      'search_hint_long': 'सैलून, सेवाएं, कलाकार खोजें...',
      'recent_searches': 'हाल की खोजें',
      'clear_all': 'सभी साफ़ करें',
      'popular_searches': 'लोकप्रिय खोजें',
      'no_matching': 'कोई मेल खाता सैलून या सेवा नहीं मिली।',

      // ─── Filters ───
      'filters': 'फ़िल्टर',
      'sort_by': 'क्रमबद्ध करें',
      'distance': 'दूरी',
      'km': 'किमी',
      'price_range': 'मूल्य सीमा',
      'rating': 'रेटिंग',
      'apply_filters': 'फ़िल्टर लागू करें',

      // ─── Notifications ───
      'notifications': 'सूचनाएं',
      'no_notifications': 'कोई नई सूचना नहीं',

      // ─── Offers ───
      'offers': 'ऑफर',
      'no_offers': 'कोई ऑफर उपलब्ध नहीं',
      'use_code': 'कोड इस्तेमाल करें:',
      'copy': 'कॉपी',
      'code_copied': "कोड '{code}' कॉपी हो गया!",

      // ─── Categories Screen ───
      'search_categories': 'श्रेणियां खोजें...',
      'no_categories': 'कोई श्रेणी नहीं मिली',

      // ─── Search Results ───
      'search_results': 'खोज परिणाम',
      'search_dots': 'खोज...',
      'results_found': 'परिणाम मिले',
      'no_results': 'कोई परिणाम नहीं मिला',

      // ─── Bookings ───
      'upcoming': 'आगामी',
      'completed': 'पूर्ण',
      'cancelled': 'रद्द',
      'no_bookings': 'कोई बुकिंग नहीं मिली।',
      'service': 'सेवा',
      'confirmed': 'पुष्टि',
      'salon': 'सैलून',

      // ─── Upcoming Booking ───
      'upcoming_booking': 'आगामी बुकिंग',
      'beautician': 'ब्यूटीशियन',
      'duration': 'अवधि',
      'price': 'कीमत',
      'rs': 'रु.',
      'mins': 'मिनट',
      'view_full_details': 'पूर्ण विवरण देखें',
      'booking_id_invoice': 'बुकिंग आईडी, इनवॉइस और अधिक',
      'reschedule': 'पुनर्निर्धारित',
      'cancel_booking': 'बुकिंग रद्द करें',

      // ─── Completed Booking ───
      'how_was_experience': 'आपका अनुभव कैसा रहा?',
      'write_review_optional': 'समीक्षा लिखें (वैकल्पिक)',
      'submit_review': 'समीक्षा सबमिट करें',
      'review_submitted': 'समीक्षा सफलतापूर्वक सबमिट हुई!',
      'review_failed': 'समीक्षा सबमिट नहीं हुई। पुनः प्रयास करें।',

      // ─── Booking Details ───
      'booking_details': 'बुकिंग विवरण',
      'booking_id': 'बुकिंग आईडी',
      'date': 'तारीख',
      'time': 'समय',
      'total_paid': 'कुल भुगतान',
      'view_invoice': 'इनवॉइस देखें',
      'invoice_ready': 'इनवॉइस तैयार है (मॉक डाउनलोड)।',
      'invoice_failed': 'इनवॉइस डाउनलोड नहीं हुई।',
      'qr_checkin': 'QR चेक-इन',
      'share_booking': 'बुकिंग साझा करें',

      // ─── Cancel Booking ───
      'booking_cancelled': 'बुकिंग रद्द',
      'booking_cancelled_desc': 'आपकी बुकिंग सफलतापूर्वक रद्द हो गई है।',
      'back_to_bookings': 'मेरी बुकिंग पर वापस',
      'explore_salons': 'अन्य सैलून खोजें',

      // ─── Reschedule ───
      'reschedule_booking': 'बुकिंग पुनर्निर्धारित करें',
      'select_new_date': 'नई तारीख चुनें',
      'sun': 'रवि',
      'mon': 'सोम',
      'tue': 'मंगल',
      'wed': 'बुध',
      'thu': 'गुरु',
      'fri': 'शुक्र',
      'sat': 'शनि',
      'select_time_slot': 'समय स्लॉट चुनें',
      'confirm_reschedule': 'पुनर्निर्धारण की पुष्टि करें',
      'reschedule_success': 'बुकिंग सफलतापूर्वक पुनर्निर्धारित!',
      'reschedule_failed': 'पुनर्निर्धारण विफल। पुनः प्रयास करें।',

      // ─── Cancellation Reason ───
      'cancellation_reason': 'रद्द करने का कारण',
      'are_you_sure': 'क्या आपको यकीन है?',
      'cancel_booking_desc':
          'आप यह बुकिंग रद्द करना चाहते हैं। यह क्रिया पूर्ववत नहीं की जा सकती।',
      'select_reason': 'कारण चुनें',
      'additional_notes': 'अतिरिक्त नोट्स (वैकल्पिक)',
      'write_notes': 'अपने नोट्स लिखें...',
      'cancellation_failed': 'रद्द करना विफल। पुनः प्रयास करें।',

      // ─── Booking Confirmed ───
      'booking_confirmed': 'बुकिंग पुष्ट!',
      'appointment_booked': 'आपकी अपॉइंटमेंट सफलतापूर्वक बुक हो गई है।',
      'view_my_bookings': 'मेरी बुकिंग देखें',
      'back_to_home': 'होम पर वापस',

      // ─── Payment ───
      'payment': 'भुगतान',
      'amount_to_pay': 'भुगतान राशि',
      'pay': 'भुगतान करें',
      'payment_failed': 'भुगतान विफल। कृपया पुनः प्रयास करें।',

      // ─── QR Check-in ───
      'your_booking_qr': 'आपकी बुकिंग QR',
      'qr_scan_instruction': 'चेक-इन के लिए सैलून में यह QR कोड दिखाएं।',
      'date_time': 'तारीख और समय',
      'download_qr': 'QR डाउनलोड करें',
      'qr_saved': 'QR सफलतापूर्वक सहेजा गया!',
      'qr_download_failed': 'QR डाउनलोड विफल',

      // ─── Add Notes ───
      'add_notes': 'नोट्स जोड़ें',
      'special_requests': 'कोई विशेष अनुरोध?',
      'notes_hint':
          'जैसे मेरी त्वचा संवेदनशील है, बालों पर कम गर्मी पसंद है, आदि।',
      'notes_optional':
          'नोट्स वैकल्पिक हैं। यदि कोई विशेष अनुरोध नहीं है तो आप यह चरण छोड़ सकते हैं।',

      // ─── Time Slots ───
      'available_time_slots': 'उपलब्ध समय स्लॉट',
      'no_time_slots': 'कोई समय स्लॉट उपलब्ध नहीं',
      'selected_time': 'चयनित समय',
      'please_select_time': 'कृपया समय चुनें',
      'please_select_slot': 'कृपया समय स्लॉट चुनें',
      'continue': 'जारी रखें',

      // ─── Apply Coupon ───
      'apply_coupon': 'कूपन लागू करें',
      'have_coupon': 'क्या आपके पास कूपन कोड है?',
      'enter_coupon': 'कूपन कोड दर्ज करें',
      'available_coupons': 'उपलब्ध कूपन',
      'skip_to_payment': 'छोड़ें और भुगतान पर जाएं',
      'enter_valid_coupon': 'कृपया एक मान्य कूपन कोड दर्ज करें',
      'invalid_coupon': 'अमान्य कूपन कोड',
      'coupon_applied': "कूपन '{code}' लागू हो गया!",
      'code': 'कोड',

      // ─── Select Date ───
      'select_date': 'तारीख चुनें',
      'selected_date': 'चयनित तारीख',
      'select_date_first': 'कृपया पहले तारीख चुनें',

      // ─── Booking Summary ───
      'booking_summary': 'बुकिंग सारांश',
      'price_details': 'मूल्य विवरण',
      'subtotal': 'उप-योग',
      'service_tax': 'सेवा कर (5%)',
      'total_amount': 'कुल राशि',

      // ─── Salon Details ───
      'salon_name': 'सैलून का नाम',
      'open_now': 'अभी खुला',
      'unisex_salon': 'यूनिसेक्स सैलून',
      'call': 'कॉल',
      'direction': 'दिशा',
      'share': 'साझा करें',
      'opening_hours': 'खुलने का समय',
      'mon_sun': 'सोम - रवि',
      'show_less': 'कम दिखाएं',
      'read_more': 'और पढ़ें',
      'gallery': 'गैलरी',
      'our_services': 'हमारी सेवाएं',
      'our_packages': 'हमारे पैकेज',
      'our_beauticians': 'हमारे ब्यूटीशियन',
      'reviews': 'समीक्षाएं',
      'user': 'उपयोगकर्ता',
      'location': 'स्थान',
      'address_not_available': 'पता उपलब्ध नहीं',
      'book_appointment': 'अपॉइंटमेंट बुक करें',

      // ─── Services ───
      'select_services': 'सेवाएं चुनें',
      'service_name': 'सेवा का नाम',
      'items_selected': 'आइटम चयनित',
      'select_at_least_one': 'कृपया कम से कम एक सेवा चुनें',

      // ─── Service Details ───
      'duration_label': 'अवधि:',
      'about_service': 'इस सेवा के बारे में',
      'service_includes': 'इस सेवा में शामिल है',
      'details_not_available': 'विवरण उपलब्ध नहीं।',

      // ─── Packages ───
      'select_package': 'पैकेज चुनें',
      'package_name': 'पैकेज का नाम',
      'skip_arrow': 'छोड़ें →',
      'no_package_selected': 'कोई पैकेज चयनित नहीं',
      'selected_label': 'चयनित',
      'optional_skip': 'वैकल्पिक — आप छोड़ सकते हैं',
      'confirm_label': 'पुष्टि करें',

      // ─── Package Details ───
      'package_includes': 'पैकेज में शामिल',

      // ─── Reviews ───
      'reviews_ratings': 'समीक्षाएं और रेटिंग',
      'write_review': 'समीक्षा लिखें',
      'user_name': 'उपयोगकर्ता नाम',

      // ─── Beauticians ───
      'select_beautician': 'ब्यूटीशियन चुनें',
      'beautician_name': 'ब्यूटीशियन का नाम',
      'specialist': 'विशेषज्ञ',
      'no_selection': 'कोई चयन नहीं',
      'choose_beautician': 'कृपया ब्यूटीशियन चुनें',
      'select_beautician_error': 'कृपया ब्यूटीशियन चुनें',

      // ─── Beautician Details ───
      'details': 'विवरण',
      'specializations': 'विशेषज्ञताएं',
      'about': 'परिचय',
      'no_specializations': 'कोई विशेषज्ञता सूचीबद्ध नहीं।',

      // ─── Salon Location ───
      'salon_location': 'सैलून स्थान',
      'open_hours_prefix': 'खुला',
      'directions': 'दिशाएं',
      'call_now': 'अभी कॉल करें',

      // ─── Favorites ───
      'my_favorites': 'मेरे पसंदीदा',
      'no_favorites': 'कोई पसंदीदा नहीं मिला।',
    },

    'bn': {
      // ─── Common ───
      'loading': 'লোড হচ্ছে',
      'error': 'ত্রুটি',
      'success': 'সফল',
      'retry': 'আবার চেষ্টা করুন',
      'yes': 'হ্যাঁ',
      'no': 'না',
      'confirm': 'নিশ্চিত করুন',
      'cancel': 'বাতিল করুন',
      'save': 'সংরক্ষণ',
      'continue_text': 'চালিয়ে যান',
      'close': 'বন্ধ করুন',
      'done': 'সম্পন্ন',
      'ok': 'ঠিক আছে',
      'apply': 'প্রয়োগ করুন',
      'reset': 'রিসেট',
      'see_all': 'সব দেখুন',
      'sort': 'সাজান',
      'from_rs': 'থেকে',

      // ─── Bottom Nav ───
      'nav_home': 'হোম',
      'nav_explore': 'অন্বেষণ',
      'nav_bookings': 'বুকিং',
      'nav_favorites': 'প্রিয়',
      'nav_profile': 'প্রোফাইল',

      // ─── Splash ───
      'splash_ever': 'এভার',
      'splash_salon': 'সেলুন',
      'splash_tagline': 'বুক করুন। পরিচালনা করুন। উজ্জ্বল হোন।',
      'splash_loading': 'আপনার সৌন্দর্যের জগৎ লোড হচ্ছে...',

      // ─── Onboarding ───
      'onboard_discover_title': 'সেরা সেলুন আবিষ্কার করুন',
      'onboard_discover_desc':
          'বিশ্বস্ত রিভিউসহ আপনার কাছের সেরা সেলুন খুঁজে নিন।',
      'onboard_booking_title': 'সহজ বুকিং',
      'onboard_booking_desc':
          'আপনার পছন্দের সেবা বেছে নিন, সময় নির্বাচন করুন ও সাথে সাথে বুক করুন।',
      'onboard_offers_title': 'দারুণ অফার',
      'onboard_offers_desc':
          'এক্সক্লুসিভ অফার, ডিসকাউন্ট এবং রয়্যালটি পুরস্কার উপভোগ করুন।',
      'skip': 'স্কিপ',

      // ─── Login ───
      'login_success': 'লগইন সফল!',
      'welcome_back': 'আবার স্বাগতম!',
      'login_to_continue': 'চালিয়ে যেতে লগইন করুন',
      'email_or_phone': 'ইমেইল বা ফোন নম্বর',
      'password': 'পাসওয়ার্ড',
      'forgot_password': 'পাসওয়ার্ড ভুলে গেছেন?',
      'login': 'লগইন',
      'or': 'অথবা',
      'dont_have_account': 'অ্যাকাউন্ট নেই? ',
      'register': 'রেজিস্টার',

      // ─── Register ───
      'accept_terms_error': 'অনুগ্রহ করে শর্তাবলী গ্রহণ করুন',
      'registration_success': 'রেজিস্ট্রেশন সফল!',
      'create_account': 'অ্যাকাউন্ট তৈরি করুন',
      'sign_up_get_started': 'শুরু করতে সাইন আপ করুন',
      'full_name': 'পুরো নাম',
      'confirm_password': 'পাসওয়ার্ড নিশ্চিত করুন',
      'i_agree_to': 'আমি সম্মত ',
      'terms_conditions': 'শর্তাবলী',
      'already_have_account': 'আগে থেকেই অ্যাকাউন্ট আছে? ',

      // ─── Forgot Password ───
      'reset_link_sent': 'রিসেট লিংক সফলভাবে পাঠানো হয়েছে!',
      'forgot_password_title': 'পাসওয়ার্ড ভুলে গেছেন?',
      'forgot_password_desc':
          'চিন্তা করবেন না! আপনার নিবন্ধিত ইমেইল বা ফোন নম্বর দিন এবং আমরা আপনাকে রিসেট লিংক পাঠাব।',
      'send_reset_link': 'রিসেট লিংক পাঠান',
      'remember_password': 'আপনার পাসওয়ার্ড মনে আছে? ',

      // ─── Reset Password ───
      'password_reset_success': 'পাসওয়ার্ড সফলভাবে রিসেট হয়েছে!',
      'reset_password': 'পাসওয়ার্ড রিসেট করুন',
      'create_new_password': 'নতুন পাসওয়ার্ড তৈরি করুন',
      'new_password': 'নতুন পাসওয়ার্ড',
      'confirm_new_password': 'নতুন পাসওয়ার্ড নিশ্চিত করুন',
      'at_least_8_chars': 'কমপক্ষে 8 অক্ষর',
      'one_uppercase': 'একটি বড় হাতের অক্ষর',
      'one_number': 'একটি সংখ্যা',
      'one_special_char': 'একটি বিশেষ চিহ্ন',

      // ─── OTP ───
      'verify_your_number': 'আপনার নম্বর যাচাই করুন',
      'enter_4digit_code': 'আমরা পাঠিয়েছি এমন 4 সংখ্যার কোড দিন',
      'resend_code_in': 'কোড আবার পাঠান ',
      'resend': 'আবার পাঠান',
      'verify': 'যাচাই করুন',
      'enter_otp_error': 'অনুগ্রহ করে 4 সংখ্যার OTP দিন',
      'otp_verified': 'OTP সফলভাবে যাচাই হয়েছে!',
      'otp_resent': 'OTP আবার পাঠানো হয়েছে!',

      // ─── Profile ───
      'my_profile': 'আমার প্রোফাইল',
      'edit_profile': 'প্রোফাইল সম্পাদনা করুন',
      'my_bookings': 'আমার বুকিং',
      'loyalty_points': 'রয়্যালটি পয়েন্ট',
      'membership': 'মেম্বারশিপ',
      'gift_cards': 'গিফট কার্ড',
      'payment_methods': 'পেমেন্ট পদ্ধতি',
      'payment_coming_soon': 'পেমেন্ট পদ্ধতি - শীঘ্রই আসছে',
      'addresses': 'ঠিকানা',
      'addresses_coming_soon': 'ঠিকানা - শীঘ্রই আসছে',
      'notification_settings': 'নোটিফিকেশন সেটিংস',
      'account_settings': 'অ্যাকাউন্ট সেটিংস',
      'app_theme': 'অ্যাপ থিম',
      'dark': 'ডার্ক',
      'light': 'লাইট',
      'system': 'সিস্টেম',
      'language': 'ভাষা',
      'help_support': 'সহায়তা ও সমর্থন',
      'help_coming_soon': 'সহায়তা ও সমর্থন - শীঘ্রই আসছে',
      'pts': 'পয়েন্ট',
      'cards': 'কার্ড',

      // ─── Edit Profile ───
      'phone_number': 'ফোন নম্বর',
      'email_address': 'ইমেইল ঠিকানা',
      'date_of_birth': 'জন্ম তারিখ',
      'gender': 'লিঙ্গ',
      'female': 'মহিলা',
      'male': 'পুরুষ',
      'other': 'অন্যান্য',
      'address': 'ঠিকানা',
      'save_changes': 'পরিবর্তন সংরক্ষণ',
      'profile_updated': 'প্রোফাইল সফলভাবে আপডেট হয়েছে!',

      // ─── Language Selection ───
      'select_language': 'ভাষা নির্বাচন করুন',
      'choose_language': 'আপনার পছন্দের ভাষা বেছে নিন।',
      'default_lang': 'ডিফল্ট',

      // ─── Account Settings ───
      'change_password': 'পাসওয়ার্ড পরিবর্তন',
      'change_password_soon': 'পাসওয়ার্ড পরিবর্তন শীঘ্রই আসছে',
      'privacy_policy': 'গোপনীয়তা নীতি',
      'privacy_policy_soon': 'গোপনীয়তা নীতি শীঘ্রই আসছে',
      'terms_conditions_title': 'শর্তাবলী',
      'terms_conditions_soon': 'শর্তাবলী শীঘ্রই আসছে',
      'delete_account': 'অ্যাকাউন্ট মুছুন',
      'delete_account_confirm':
          'আপনি কি সত্যিই আপনার অ্যাকাউন্ট স্থায়ীভাবে মুছতে চান? এই কাজটি ফেরানো যাবে না।',
      'delete': 'মুছুন',
      'log_out': 'লগ আউট',
      'log_out_confirm': 'আপনি কি আপনার অ্যাকাউন্ট থেকে লগ আউট করতে চান?',

      // ─── Loyalty Points ───
      'available_points': 'উপলব্ধ পয়েন্ট',
      'earning_smiles': 'আপনি হাসি কামাচ্ছেন!',
      'pts_away_from': 'পয়েন্ট দূরে',
      'you_are_pts_away': "আপনি {pts} পয়েন্ট দূরে {tier} থেকে",
      'how_earn_points': 'কীভাবে পয়েন্ট কামাবেন',
      'view_points_history': 'পয়েন্ট ইতিহাস দেখুন',

      // ─── Loyalty History ───
      'points_history': 'পয়েন্ট ইতিহাস',
      'no_history': 'কোনো ইতিহাস পাওয়া যায়নি।',

      // ─── Membership ───
      'my_membership': 'আমার মেম্বারশিপ',
      'enjoy_benefits': 'এক্সক্লুসিভ সুবিধা উপভোগ করুন',
      'member_since': 'সদস্য ভুক্তির সময়',
      'member_id': 'সদস্য আইডি',
      'membership_benefits': 'মেম্বারশিপ সুবিধা',
      'enjoy_exclusive_benefits': 'একচেটিয়া সুবিধার আনন্দ নিন',
      'view_membership_details': 'মেম্বারশিপ বিবরণ দেখুন',

      // ─── Membership Details ───
      'membership_details': 'মেম্বারশিপ বিবরণ',
      'valid_till': 'বৈধ পর্যন্ত',
      'status': 'স্থিতি',

      // ─── Gift Cards ───
      'my_gift_cards': 'আমার গিফট কার্ড',
      'add_card': '+ কার্ড যোগ করুন',
      'no_gift_cards': 'কোনো গিফট কার্ড পাওয়া যায়নি।',
      'ever_salon': 'এভার সেলুন',
      'gift_card': 'গিফট কার্ড',
      'balance': 'ব্যালেন্স',
      'card_no': 'কার্ড নং।',

      // ─── Home ───
      'good_morning': 'শুভ সকাল',
      'search_hint': 'সেলুন, সেবা খুঁজুন...',
      'search_artists': 'সেলুন, সেবা, শিল্পী খুঁজুন...',
      'categories': 'ক্যাটাগরি',
      'featured_salons': 'ফিচার্ড সেলুন',
      'explore_placeholder': 'এক্সপ্লোর স্ক্রিন (Screen 14 later)',

      // ─── Nearby Salons ───
      'nearby_salons': 'কাছের সেলুন',
      'view_on_map': 'ম্যাপে দেখুন',

      // ─── Featured Salons ───
      'book_now': 'এখন বুক করুন',

      // ─── All Salons ───
      'all_salons': 'সব সেলুন',
      'nearby': 'কাছে',

      // ─── Search ───
      'search': 'খোঁজ',
      'search_hint_long': 'সেলুন, সেবা, শিল্পী খুঁজুন...',
      'recent_searches': 'সাম্প্রতিক খোঁজ',
      'clear_all': 'সব মুছুন',
      'popular_searches': 'জনপ্রিয় খোঁজ',
      'no_matching': 'কোনো মিলে যাওয়া সেলুন বা সেবা পাওয়া যায়নি।',

      // ─── Filters ───
      'filters': 'ফিল্টার',
      'sort_by': 'সাজান',
      'distance': 'দূরত্ব',
      'km': 'কিমি',
      'price_range': 'মূল্যের সীমা',
      'rating': 'রেটিং',
      'apply_filters': 'ফিল্টার প্রয়োগ করুন',

      // ─── Notifications ───
      'notifications': 'নোটিফিকেশন',
      'no_notifications': 'কোনো নতুন নোটিফিকেশন নেই',

      // ─── Offers ───
      'offers': 'অফার',
      'no_offers': 'কোনো অফার উপলব্ধ নেই',
      'use_code': 'কোড ব্যবহার করুন:',
      'copy': 'কপি',
      'code_copied': "কোড '{code}' কপি হয়েছে!",

      // ─── Categories Screen ───
      'search_categories': 'ক্যাটাগরি খুঁজুন...',
      'no_categories': 'কোনো ক্যাটাগরি পাওয়া যায়নি',

      // ─── Search Results ───
      'search_results': 'খোঁজের ফলাফল',
      'search_dots': 'খোঁজ...',
      'results_found': 'ফলাফল পাওয়া গেছে',
      'no_results': 'কোনো ফলাফল পাওয়া যায়নি',

      // ─── Bookings ───
      'upcoming': 'আসন্ন',
      'completed': 'সম্পন্ন',
      'cancelled': 'বাতিল',
      'no_bookings': 'কোনো বুকিং পাওয়া যায়নি।',
      'service': 'সেবা',
      'confirmed': 'নিশ্চিত',
      'salon': 'সেলুন',

      // ─── Upcoming Booking ───
      'upcoming_booking': 'আসন্ন বুকিং',
      'beautician': 'বিউটিশিয়ান',
      'duration': 'সময়কাল',
      'price': 'মূল্য',
      'rs': '৳',
      'mins': 'মিনিট',
      'view_full_details': 'পূর্ণ বিবরণ দেখুন',
      'booking_id_invoice': 'বুকিং আইডি, ইনভয়েস ও আরও',
      'reschedule': 'পুনঃনির্ধারণ',
      'cancel_booking': 'বুকিং বাতিল করুন',

      // ─── Completed Booking ───
      'how_was_experience': 'আপনার অভিজ্ঞতা কেমন ছিল?',
      'write_review_optional': 'রিভিউ লিখুন (ঐচ্ছিক)',
      'submit_review': 'রিভিউ জমা দিন',
      'review_submitted': 'রিভিউ সফলভাবে জমা হয়েছে!',
      'review_failed': 'রিভিউ জমা হয়নি। আবার চেষ্টা করুন।',

      // ─── Booking Details ───
      'booking_details': 'বুকিং বিবরণ',
      'booking_id': 'বুকিং আইডি',
      'date': 'তারিখ',
      'time': 'সময়',
      'total_paid': 'মোট পরিশোধিত',
      'view_invoice': 'ইনভয়েস দেখুন',
      'invoice_ready': 'ইনভয়েস প্রস্তুত (মক ডাউনলোড)।',
      'invoice_failed': 'ইনভয়েস ডাউনলোড হয়নি।',
      'qr_checkin': 'QR চেক-ইন',
      'share_booking': 'বুকিং শেয়ার করুন',

      // ─── Cancel Booking ───
      'booking_cancelled': 'বুকিং বাতিল',
      'booking_cancelled_desc': 'আপনার বুকিং সফলভাবে বাতিল হয়েছে।',
      'back_to_bookings': 'আমার বুকিংয়ে ফিরুন',
      'explore_salons': 'অন্য সেলুন অন্বেষণ করুন',

      // ─── Reschedule ───
      'reschedule_booking': 'বুকিং পুনঃনির্ধারণ করুন',
      'select_new_date': 'নতুন তারিখ নির্বাচন করুন',
      'sun': 'রবি',
      'mon': 'সোম',
      'tue': 'মঙ্গল',
      'wed': 'বুধ',
      'thu': 'বৃহস্পতি',
      'fri': 'শুক্র',
      'sat': 'শনি',
      'select_time_slot': 'সময় স্লট নির্বাচন করুন',
      'confirm_reschedule': 'পুনঃনির্ধারণ নিশ্চিত করুন',
      'reschedule_success': 'বুকিং সফলভাবে পুনঃনির্ধারিত!',
      'reschedule_failed': 'পুনঃনির্ধারণ ব্যর্থ। আবার চেষ্টা করুন।',

      // ─── Cancellation Reason ───
      'cancellation_reason': 'বাতিলের কারণ',
      'are_you_sure': 'আপনি কি নিশ্চিত?',
      'cancel_booking_desc':
          'আপনি এই বুকিং বাতিল করতে চান। এই কাজটি ফেরানো যাবে না।',
      'select_reason': 'কারণ নির্বাচন করুন',
      'additional_notes': 'অতিরিক্ত নোট (ঐচ্ছিক)',
      'write_notes': 'আপনার নোট লিখুন...',
      'cancellation_failed': 'বাতিল করা ব্যর্থ। আবার চেষ্টা করুন।',

      // ─── Booking Confirmed ───
      'booking_confirmed': 'বুকিং নিশ্চিত!',
      'appointment_booked': 'আপনার অ্যাপয়েন্টমেন্ট সফলভাবে বুক হয়েছে।',
      'view_my_bookings': 'আমার বুকিং দেখুন',
      'back_to_home': 'হোমে ফিরুন',

      // ─── Payment ───
      'payment': 'পেমেন্ট',
      'amount_to_pay': 'পরিশোধের পরিমাণ',
      'pay': 'পরিশোধ করুন',
      'payment_failed': 'পেমেন্ট ব্যর্থ। আবার চেষ্টা করুন।',

      // ─── QR Check-in ───
      'your_booking_qr': 'আপনার বুকিং QR',
      'qr_scan_instruction': 'চেক-ইনের জন্য সেলুনে এই QR কোড দেখান।',
      'date_time': 'তারিখ ও সময়',
      'download_qr': 'QR ডাউনলোড করুন',
      'qr_saved': 'QR সফলভাবে সংরক্ষিত!',
      'qr_download_failed': 'QR ডাউনলোড ব্যর্থ',

      // ─── Add Notes ───
      'add_notes': 'নোট যোগ করুন',
      'special_requests': 'কোনো বিশেষ অনুরোধ আছে?',
      'notes_hint': 'যেমন আমার ত্বক সংবেদনশীল, চুলে কম তাপ পছন্দ, ইত্যাদি।',
      'notes_optional':
          'নোট ঐচ্ছিক। বিশেষ অনুরোধ না থাকলে আপনি এই ধাপটি এড়িয়ে যেতে পারেন।',

      // ─── Time Slots ───
      'available_time_slots': 'উপলব্ধ সময় স্লট',
      'no_time_slots': 'কোনো সময় স্লট উপলব্ধ নেই',
      'selected_time': 'নির্বাচিত সময়',
      'please_select_time': 'অনুগ্রহ করে সময় নির্বাচন করুন',
      'please_select_slot': 'অনুগ্রহ করে সময় স্লট নির্বাচন করুন',
      'continue': 'চালিয়ে যান',

      // ─── Apply Coupon ───
      'apply_coupon': 'কুপন প্রয়োগ করুন',
      'have_coupon': 'আপনার কাছে কি কুপন কোড আছে?',
      'enter_coupon': 'কুপন কোড লিখুন',
      'available_coupons': 'উপলব্ধ কুপন',
      'skip_to_payment': 'এড়িয়ে যান ও পেমেন্টে যান',
      'enter_valid_coupon': 'একটি বৈধ কুপন কোড লিখুন',
      'invalid_coupon': 'অবৈধ কুপন কোড',
      'coupon_applied': "কুপন '{code}' প্রয়োগ হয়েছে!",
      'code': 'কোড',

      // ─── Select Date ───
      'select_date': 'তারিখ নির্বাচন করুন',
      'selected_date': 'নির্বাচিত তারিখ',
      'select_date_first': 'অনুগ্রহ করে আগে তারিখ নির্বাচন করুন',

      // ─── Booking Summary ───
      'booking_summary': 'বুকিং সারাংশ',
      'price_details': 'মূল্যের বিবরণ',
      'subtotal': 'সাবটোটাল',
      'service_tax': 'সার্ভিস ট্যাক্স (5%)',
      'total_amount': 'মোট পরিমাণ',

      // ─── Salon Details ───
      'salon_name': 'সেলুনের নাম',
      'open_now': 'এখন খোলা',
      'unisex_salon': 'ইউনিসেক্স সেলুন',
      'call': 'কল',
      'direction': 'দিক',
      'share': 'শেয়ার',
      'opening_hours': 'খোলার সময়',
      'mon_sun': 'সোম - রবি',
      'show_less': 'কম দেখান',
      'read_more': 'আরও পড়ুন',
      'gallery': 'গ্যালারি',
      'our_services': 'আমাদের সেবা',
      'our_packages': 'আমাদের প্যাকেজ',
      'our_beauticians': 'আমাদের বিউটিশিয়ান',
      'reviews': 'রিভিউ',
      'user': 'ব্যবহারকারী',
      'location': 'অবস্থান',
      'address_not_available': 'ঠিকানা উপলব্ধ নেই',
      'book_appointment': 'অ্যাপয়েন্টমেন্ট বুক করুন',

      // ─── Services ───
      'select_services': 'সেবা নির্বাচন করুন',
      'service_name': 'সেবার নাম',
      'items_selected': 'আইটেম নির্বাচিত',
      'select_at_least_one': 'অনুগ্রহ করে কমপক্ষে একটি সেবা নির্বাচন করুন',

      // ─── Service Details ───
      'duration_label': 'সময়কাল:',
      'about_service': 'এই সেবা সম্পর্কে',
      'service_includes': 'এই সেবার মধ্যে রয়েছে',
      'details_not_available': 'বিবরণ উপলব্ধ নেই।',

      // ─── Packages ───
      'select_package': 'প্যাকেজ নির্বাচন করুন',
      'package_name': 'প্যাকেজের নাম',
      'skip_arrow': 'স্কিপ →',
      'no_package_selected': 'কোনো প্যাকেজ নির্বাচিত নয়',
      'selected_label': 'নির্বাচিত',
      'optional_skip': 'ঐচ্ছিক — আপনি এড়িয়ে যেতে পারেন',
      'confirm_label': 'নিশ্চিত করুন',

      // ─── Package Details ───
      'package_includes': 'প্যাকেজের মধ্যে রয়েছে',

      // ─── Reviews ───
      'reviews_ratings': 'রিভিউ ও রেটিং',
      'write_review': 'রিভিউ লিখুন',
      'user_name': 'ব্যবহারকারীর নাম',

      // ─── Beauticians ───
      'select_beautician': 'বিউটিশিয়ান নির্বাচন করুন',
      'beautician_name': 'বিউটিশিয়ানের নাম',
      'specialist': 'বিশেষজ্ঞ',
      'no_selection': 'কোনো নির্বাচন নেই',
      'choose_beautician': 'অনুগ্রহ করে বিউটিশিয়ান চয়ন করুন',
      'select_beautician_error': 'অনুগ্রহ করে বিউটিশিয়ান নির্বাচন করুন',

      // ─── Beautician Details ───
      'details': 'বিবরণ',
      'specializations': 'বিশেষত্ব',
      'about': 'পরিচিতি',
      'no_specializations': 'কোনো বিশেষত্ব তালিকাভুক্ত নেই।',

      // ─── Salon Location ───
      'salon_location': 'সেলুনের অবস্থান',
      'open_hours_prefix': 'খোলা',
      'directions': 'দিকনির্দেশ',
      'call_now': 'এখন কল করুন',

      // ─── Favorites ───
      'my_favorites': 'আমার প্রিয়',
      'no_favorites': 'কোনো প্রিয় পাওয়া যায়নি।',
    },
  };
}

/// Extension to look up translated strings from any [BuildContext].
extension AppTranslationsExtension on BuildContext {
  /// Returns the translated string for [key] in the current app language.
  String tr(String key) => AppTranslations.tr(this, key);
}
