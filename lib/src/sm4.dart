import 'dart:convert';
import 'dart:typed_data';
import 'utils/utils.dart';

enum SM4CryptoMode {
  ECB,
  CBC
}

class SM4 {
  static const List<int> S_BOX = [
    0xd6,
    0x90,
    0xe9,
    0xfe,
    0xcc,
    0xe1,
    0x3d,
    0xb7,
    0x16,
    0xb6,
    0x14,
    0xc2,
    0x28,
    0xfb,
    0x2c,
    0x05,
    0x2b,
    0x67,
    0x9a,
    0x76,
    0x2a,
    0xbe,
    0x04,
    0xc3,
    0xaa,
    0x44,
    0x13,
    0x26,
    0x49,
    0x86,
    0x06,
    0x99,
    0x9c,
    0x42,
    0x50,
    0xf4,
    0x91,
    0xef,
    0x98,
    0x7a,
    0x33,
    0x54,
    0x0b,
    0x43,
    0xed,
    0xcf,
    0xac,
    0x62,
    0xe4,
    0xb3,
    0x1c,
    0xa9,
    0xc9,
    0x08,
    0xe8,
    0x95,
    0x80,
    0xdf,
    0x94,
    0xfa,
    0x75,
    0x8f,
    0x3f,
    0xa6,
    0x47,
    0x07,
    0xa7,
    0xfc,
    0xf3,
    0x73,
    0x17,
    0xba,
    0x83,
    0x59,
    0x3c,
    0x19,
    0xe6,
    0x85,
    0x4f,
    0xa8,
    0x68,
    0x6b,
    0x81,
    0xb2,
    0x71,
    0x64,
    0xda,
    0x8b,
    0xf8,
    0xeb,
    0x0f,
    0x4b,
    0x70,
    0x56,
    0x9d,
    0x35,
    0x1e,
    0x24,
    0x0e,
    0x5e,
    0x63,
    0x58,
    0xd1,
    0xa2,
    0x25,
    0x22,
    0x7c,
    0x3b,
    0x01,
    0x21,
    0x78,
    0x87,
    0xd4,
    0x00,
    0x46,
    0x57,
    0x9f,
    0xd3,
    0x27,
    0x52,
    0x4c,
    0x36,
    0x02,
    0xe7,
    0xa0,
    0xc4,
    0xc8,
    0x9e,
    0xea,
    0xbf,
    0x8a,
    0xd2,
    0x40,
    0xc7,
    0x38,
    0xb5,
    0xa3,
    0xf7,
    0xf2,
    0xce,
    0xf9,
    0x61,
    0x15,
    0xa1,
    0xe0,
    0xae,
    0x5d,
    0xa4,
    0x9b,
    0x34,
    0x1a,
    0x55,
    0xad,
    0x93,
    0x32,
    0x30,
    0xf5,
    0x8c,
    0xb1,
    0xe3,
    0x1d,
    0xf6,
    0xe2,
    0x2e,
    0x82,
    0x66,
    0xca,
    0x60,
    0xc0,
    0x29,
    0x23,
    0xab,
    0x0d,
    0x53,
    0x4e,
    0x6f,
    0xd5,
    0xdb,
    0x37,
    0x45,
    0xde,
    0xfd,
    0x8e,
    0x2f,
    0x03,
    0xff,
    0x6a,
    0x72,
    0x6d,
    0x6c,
    0x5b,
    0x51,
    0x8d,
    0x1b,
    0xaf,
    0x92,
    0xbb,
    0xdd,
    0xbc,
    0x7f,
    0x11,
    0xd9,
    0x5c,
    0x41,
    0x1f,
    0x10,
    0x5a,
    0xd8,
    0x0a,
    0xc1,
    0x31,
    0x88,
    0xa5,
    0xcd,
    0x7b,
    0xbd,
    0x2d,
    0x74,
    0xd0,
    0x12,
    0xb8,
    0xe5,
    0xb4,
    0xb0,
    0x89,
    0x69,
    0x97,
    0x4a,
    0x0c,
    0x96,
    0x77,
    0x7e,
    0x65,
    0xb9,
    0xf1,
    0x09,
    0xc5,
    0x6e,
    0xc6,
    0x84,
    0x18,
    0xf0,
    0x7d,
    0xec,
    0x3a,
    0xdc,
    0x4d,
    0x20,
    0x79,
    0xee,
    0x5f,
    0x3e,
    0xd7,
    0xcb,
    0x39,
    0x48
  ];

  static const List<int> FK = [
    0xA3B1BAC6,
    0x56AA3350,
    0x677D9197,
    0xB27022DC
  ];

  static const List<int> CK = [
    0x00070e15,
    0x1c232a31,
    0x383f464d,
    0x545b6269,
    0x70777e85,
    0x8c939aa1,
    0xa8afb6bd,
    0xc4cbd2d9,
    0xe0e7eef5,
    0xfc030a11,
    0x181f262d,
    0x343b4249,
    0x50575e65,
    0x6c737a81,
    0x888f969d,
    0xa4abb2b9,
    0xc0c7ced5,
    0xdce3eaf1,
    0xf8ff060d,
    0x141b2229,
    0x30373e45,
    0x4c535a61,
    0x686f767d,
    0x848b9299,
    0xa0a7aeb5,
    0xbcc3cad1,
    0xd8dfe6ed,
    0xf4fb0209,
    0x10171e25,
    0x2c333a41,
    0x484f565d,
    0x646b7279
  ];

  static const int SM4_ENCRYPT = 1;

  static const int SM4_DECRYPT = 0;

  static const int blockSize = 16;

  static final _encryptKey = List<int>.filled(32, 0);
  static final _decryptKey = List<int>.filled(32, 0);

  static int _readUint32BE(List<int> b, int i) {
    return ((b[i] & 0xff) << 24) | ((b[i + 1] & 0xff) << 16) | ((b[i + 2] & 0xff) << 8) | (b[i + 3] & 0xff);
  }

  static void _writeUint32BE(int n, List<int> b, int i) {
    b[i] = ((n >> 24) & 0xff);
    b[i + 1] = ((n >> 16) & 0xff);
    b[i + 2] = ((n >> 8) & 0xff);
    b[i + 3] = n & 0xff;
  }

  static int _Sbox(int inch) => S_BOX[inch & 0xFF];

  static int _sm4F(int x0, int x1, int x2, int x3, int rk) {
    final x = x1 ^ x2 ^ x3 ^ rk;
    int bb = 0;
    int c = 0;
    List<int> a = List<int>.filled(4, 0);
    List<int> b = List<int>.filled(4, 0);
    _writeUint32BE(x, a, 0);
    b[0] = _Sbox(a[0]);
    b[1] = _Sbox(a[1]);
    b[2] = _Sbox(a[2]);
    b[3] = _Sbox(a[3]);
    bb = _readUint32BE(b, 0);

    c = bb ^ SMUtils.leftShift(bb, 2) ^ SMUtils.leftShift(bb, 10) ^ SMUtils.leftShift(bb, 18) ^ SMUtils.leftShift(bb, 24);
    return x0 ^ c;
  }

  static int _calculateRoundKey(int key) {
    int roundKey = 0;
    List<int> keyBytes = List<int>.filled(4, 0);
    List<int> sboxBytes = List<int>.filled(4, 0);
    _writeUint32BE(key, keyBytes, 0);
    for (int i = 0; i < 4; i++) {
      sboxBytes[i] = _Sbox(keyBytes[i]);
    }
    int temp = _readUint32BE(sboxBytes, 0);
    roundKey = temp ^ SMUtils.leftShift(temp, 13) ^ SMUtils.leftShift(temp, 23);
    return roundKey;
  }

  static void setKey(String key) {
    // 改用 utf8.decode
    List<int> keyBytes = utf8.encode(key.substring(0, 16));
    setKeyBytes(Uint8List.fromList(keyBytes));
  }

  static void setKeyBytes(Uint8List key) {
    // 改用 utf8.decode
    List<int> keyBytes = key.toList();
    List<int> intermediateKeys = List<int>.filled(36, 0);
    for (int i = 0; i < 4; i++) {
      intermediateKeys[i] = _readUint32BE(keyBytes, i * 4) ^ FK[i];
    }
    for (int i = 0; i < 32; i++) {
      intermediateKeys[i + 4] = intermediateKeys[i] ^ _calculateRoundKey(intermediateKeys[i + 1] ^ intermediateKeys[i + 2] ^ intermediateKeys[i + 3] ^ CK[i]);
      _encryptKey[i] = intermediateKeys[i + 4];
    }

    for (int i = 0; i < 16; i++) {
      int temp = _encryptKey[i];
      _decryptKey[i] = _encryptKey[31 - i];
      _decryptKey[31 - i] = temp;
    }
  }

  static void _round(List<int> sk, List<int> input, List<int> output) {
    int i = 0;
    List<int> ulbuf = List<int>.filled(36, 0);
    ulbuf[0] = _readUint32BE(input, 0);
    ulbuf[1] = _readUint32BE(input, 4);
    ulbuf[2] = _readUint32BE(input, 8);
    ulbuf[3] = _readUint32BE(input, 12);
    while (i < 32) {
      ulbuf[i + 4] = _sm4F(ulbuf[i], ulbuf[i + 1], ulbuf[i + 2], ulbuf[i + 3], sk[i]);
      i++;
    }

    _writeUint32BE(ulbuf[35], output, 0);
    _writeUint32BE(ulbuf[34], output, 4);
    _writeUint32BE(ulbuf[33], output, 8);
    _writeUint32BE(ulbuf[32], output, 12);
  }

  static List<int> _padding(List<int> input, int mode) {
    final int padLen = blockSize - (input.length % blockSize);

    if (mode == SM4_ENCRYPT) {
      final paddedList = List<int>.filled(input.length + padLen, 0);
      paddedList.setRange(0, input.length, input);
      for (int i = input.length; i < paddedList.length; i++) {
        // 改用填充0
        // paddedList[i] = padLen;
        paddedList[i] = 0;
      }
      return paddedList;
    } else {
      final lastByte = input.last;
      final cutLen = input.length - lastByte;
      return input.sublist(0, cutLen);
    }
  }

  static List<int> _unpadding(List<int> input, int mode) {
    if (mode == SM4_DECRYPT) {
      // 找到最后一个非0字节的位置
      int lastNonZeroIndex = input.length - 1;
      while (lastNonZeroIndex >= 0 && input[lastNonZeroIndex] == 0) {
        lastNonZeroIndex--;
      }

      // 如果全是0,返回空列表
      if (lastNonZeroIndex < 0) {
        return [];
      }

      // 返回截取到最后一个非0字节的子列表
      return input.sublist(0, lastNonZeroIndex + 1);
    }
    return input;
  }

  static List<int> _crypto(List<int> data, int flag, SM4CryptoMode mode, String? iv) {
    List<int>? lastVector;
    if (mode == SM4CryptoMode.CBC) {
      if (iv == null) {
        // 可以不需要传入
      } else if (iv.length != 32) {
        throw Exception("IV must be a string of length 32");
      } else {
        lastVector = utf8.encode(iv.substring(0, 32));
      }
    }
    final key = (flag == SM4_ENCRYPT) ? _encryptKey : _decryptKey;
    if (flag == SM4_ENCRYPT) {
      data = _padding(data, SM4_ENCRYPT);
    }
    final length = data.length;
    final List<int> output = [];

    for (int offset = 0; offset < length; offset += blockSize) {
      final outData = List<int>.filled(blockSize, 0);
      final copyLen = (offset + blockSize <= length) ? blockSize : length - offset;
      final input = data.sublist(offset, offset + copyLen);
      if (mode == SM4CryptoMode.CBC && flag == SM4_ENCRYPT && iv != null) {
        for (int i = 0; i < blockSize; i++) {
          input[i] = input[i] ^ lastVector![i]; // 改为异或
        }
      }
      _round(key, input, outData);

      if (mode == SM4CryptoMode.CBC && flag == SM4_DECRYPT && iv != null) {
        for (int i = 0; i < blockSize; i++) {
          outData[i] ^= lastVector![i];
        }
      }
      output.addAll(outData);

      if (mode == SM4CryptoMode.CBC) {
        if (flag == SM4_ENCRYPT) {
          lastVector = outData;
        } else {
          lastVector = input;
        }
      }
    }
    if (flag == SM4_DECRYPT) {
      return _unpadding(output, SM4_DECRYPT);
    }
    return output;
  }

  static String encrypt(String plainText, {String? key, SM4CryptoMode mode = SM4CryptoMode.ECB, String? iv}) {
    if (key != null) setKey(key);
    List<int> input = utf8.encode(plainText);
    List<int> output = _crypto(input, SM4_ENCRYPT, mode, iv);
    return base64.encode(output);
  }

  static String decrypt(String cipherText, {String? key, SM4CryptoMode mode = SM4CryptoMode.ECB, String? iv}) {
    if (key != null) setKey(key);
    List<int> input = base64.decode(cipherText);
    List<int> output = _crypto(input, SM4_DECRYPT, mode, iv);
    return utf8.decode(output);
  }

  static Uint8List encryptBytes(Uint8List plainText, {Uint8List? key, SM4CryptoMode mode = SM4CryptoMode.ECB, String? iv}) {
    if (key != null) setKeyBytes(key);
    List<int> input = plainText.toList();
    List<int> output = _crypto(input, SM4_ENCRYPT, mode, iv);
    return Uint8List.fromList(output);
  }

  static Uint8List decryptBytes(Uint8List cipherText, {Uint8List? key, SM4CryptoMode mode = SM4CryptoMode.ECB, String? iv}) {
    if (key != null) setKeyBytes(key);
    List<int> input = cipherText.toList();
    List<int> output = _crypto(input, SM4_DECRYPT, mode, iv);
    return Uint8List.fromList(output);
  }
}
