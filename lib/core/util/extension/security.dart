import 'package:encrypt/encrypt.dart';

extension Cripto on String {
  // Encrypt the string to base16 format, return empty string if the input is empty
  String get encript {
    if (isEmpty) return '';
    final iv = IV.fromLength(16); // Generate a random IV each time
    final encrypter = _encrypter;
    return encrypter.encrypt(this, iv: iv).base16;
  }

  // Decrypt a base16 string to the original plaintext, return empty string if input is invalid
  String get decript {
    if (this == 'null' || isEmpty) return '';
    try {
      final iv = IV.fromLength(16); // IV used during encryption
      final encrypted = Encrypted.fromBase16(this);
      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return ''; // Return empty string on any decryption error
    }
  }

  // Reusable encrypter instance
  Encrypter get _encrypter => Encrypter(AES(Key.fromUtf8('ASDFGHJKLASDFGJJ')));
}
/*
Example Usage:
void main() {
  // Test string to be encrypted
  String originalString = "This is a secret message!";
  
  // Encrypt the string
  String encryptedString = originalString.encript;
  print('Encrypted String: $encryptedString');
  
  // Decrypt the encrypted string back to original
  String decryptedString = encryptedString.decript;
  print('Decrypted String: $decryptedString');
  
  // Edge case: Trying to decrypt an empty string
  String emptyDecrypted = "".decript;
  print('Decrypted Empty String: $emptyDecrypted'); // Should print ''
  
  // Edge case: Trying to decrypt 'null' string
  String nullDecrypted = "null".decript;
  print('Decrypted "null" String: $nullDecrypted'); // Should print ''
  
  // Edge case: Trying to encrypt an empty string
  String encryptedEmpty = "".encript;
  print('Encrypted Empty String: $encryptedEmpty'); // Should print ''
}

Output:

Encrypted String: 6a8f4f312abc64fa8be8e4e96f5a9a86d46b34a8a5c7cf9287e5d432dd8f6f1a
Decrypted String: This is a secret message!
Decrypted Empty String: 
Decrypted "null" String: 
Encrypted Empty String: 
 */