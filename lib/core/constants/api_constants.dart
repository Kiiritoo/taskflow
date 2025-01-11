class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost/taskflow_api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // User endpoints
  static const String users = '/users';
  static const String profile = '/users/profile';

  // Organization endpoints
  static const String organizations = '/organizations';
  
  // Project endpoints
  static const String projects = '/projects';
  
  // Task endpoints
  static const String tasks = '/tasks';

  // Team endpoints
  static const String teams = '/teams';
  static const String teamMembers = '/members';
}
