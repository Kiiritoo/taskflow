import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final EmailService _instance = EmailService._internal();
  factory EmailService() => _instance;
  EmailService._internal();

  Future<void> sendPasswordResetEmail(String toEmail, String resetToken) async {
    final gmailEmail = 'michakleb8@gmail.com';
    final gmailAppPassword = 'htup yezv ivmp hcvv';  

    final smtpServer = gmail(gmailEmail, gmailAppPassword);

    final message = Message()
      ..from = Address(gmailEmail, 'TaskFlow')
      ..recipients.add(toEmail)
      ..subject = 'Password Reset Request'
      ..html = '''
        <h3>Password Reset</h3>
        <p>You have requested to reset your password. Follow these steps:</p>
        
        <ol>
          <li>Open TaskFlow application</li>
          <li>Click "Forgot Password" on the login page</li>
          <li>Copy and paste this reset token:</li>
        </ol>
        
        <p style="background-color: #f0f0f0; padding: 15px; border-radius: 5px; font-family: monospace; font-size: 16px; text-align: center; margin: 20px 0;">
          <strong>$resetToken</strong>
        </p>
        
        <p>This token will expire in 24 hours.</p>
        <p>If you didn't request this password reset, please ignore this email.</p>
        
        <p style="color: #666; font-size: 12px; margin-top: 30px;">
          This is an automated message, please do not reply to this email.
        </p>
      ''';

    try {
      await send(message, smtpServer);
    } catch (e) {
      throw Exception('Failed to send email: $e');
    }
  }
} 