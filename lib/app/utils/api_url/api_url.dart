class ApiUrl {


  static const String baseUrl = "http://192.168.0.109:8000/api";

  static const String sendOtp = "$baseUrl/send-otp";
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String login = "$baseUrl/login";

  static const String allPosts = "$baseUrl/posts";


  // প্রোফাইল ম্যানেজমেন্ট
  static const String completeProfile = "$baseUrl/complete-profile";
  static const String uploadImage = "$baseUrl/upload-image";
  static const String userProfile = "$baseUrl/user-profile"; // নিজের প্রোফাইল
  static const String updateProfile = "$baseUrl/update-profile";
  static const String logout = "$baseUrl/logout";

  // অন্য ইউজারের প্রোফাইল দেখার জন্য (ID পাস করতে হবে)
  static String otherUserProfile(int id) => "$baseUrl/user/$id/profile";

  // --- পোস্ট ম্যানেজমেন্ট ---
  static const String myPosts = "$baseUrl/my-posts";
  static const String createPost = "$baseUrl/posts";

  // আপডেট এবং ডিলিট করার জন্য ID ডাইনামিক ভাবে পাঠাতে হবে
  static String updatePost(int id) => "$baseUrl/posts/$id";
  static String deletePost(int id) => "$baseUrl/posts/$id";

  // --- সোশ্যাল অ্যাকশনস (লাইক, কমেন্ট, শেয়ার) ---
  static String toggleLike(int id) => "$baseUrl/posts/$id/like";
  static String storeComment(int id) => "$baseUrl/posts/$id/comment";
  static String sharePost(int id) => "$baseUrl/posts/$id/share";

  // --- ফ্রেন্ড সিস্টেম রাউটস ---
  static const String sendFriendRequest = "$baseUrl/friend/send";
  static const String pendingRequests = "$baseUrl/friend/pending-requests";
  static const String friendsList = "$baseUrl/friend/list";

  // এক্সেপ্ট এবং ডিক্লাইন করার জন্য ID ডাইনামিক
  static String acceptFriendRequest(int id) => "$baseUrl/friend/accept/$id";
  static String declineFriendRequest(int id) => "$baseUrl/friend/decline/$id";
}