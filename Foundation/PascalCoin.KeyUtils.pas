Unit PascalCoin.KeyUtils;

(* ***********************************************************************
  copyright 2019-2021  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.

  PascalCoin website http://pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https://github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  ===========================================================================================
  The majority of this unit is derived from uPascalCoinKeyTool.pas from the tools library by
  Ugochukwu Mmaduekwe ( Copyright (c) 2018 ) Licensed and provided under The MIT License (MIT).

  The original project can be found at https://github.com/PascalCoinDev/PascalCoinTools

  Some elements are taken derived from Core/UPCCryptoLib4Pascal.pas by Albert Molina
  (Copyright (c) 2019)
  ===========================================================================================

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.SysUtils,
  PascalCoin.Consts,
  ClpBigInteger,
  ClpSecureRandom,
  ClpISecureRandom,
  ClpIECDomainParameters,
  ClpECDomainParameters,
  ClpIECPrivateKeyParameters,
  ClpIX9ECParameters,
  ClpIIESWithCipherParameters,
  ClpIIESEngine,
  ClpIBaseKdfBytesGenerator,
  ClpIIESParameterSpec,
  ClpIPascalCoinECIESKdfBytesGenerator,
  ClpIPascalCoinIESEngine,
  ClpCryptoLibTypes,
  ClpIECPublicKeyParameters,
  ClpIAsymmetricCipherKeyPair;

Type

  TKeyUtils = Class
  Strict Private

  Const
    PKCS5_SALT_LEN = Int32(8);
    SALT_MAGIC_LEN = Int32(8);
    SALT_SIZE = Int32(8);
    SALT_MAGIC: String = 'Salted__';
    B58_PUBKEY_PREFIX: String = '01';
    CURRENCY_SCALE: Integer = 10000;

    Class Var FRandom: ISecureRandom;

  Private
    // ComputeAES256_CBC_PKCS7PADDING_PascalCoinEncrypt
    Class Function AES256Encrypt(Const APlainTextBytes, APasswordBytes: TBytes): TBytes; Static;
    // ComputeAES256_CBC_PKCS7PADDING_PascalCoinDecrypt
    Class Function AES256Decrypt(Const ACipherTextBytes, APasswordBytes: TBytes; Out APlainText: TBytes)
      : boolean; Static;

    Class Function EVP_GetSalt: TBytes; Static;
    Class Function EVP_GetKeyIV(Const APasswordBytes, ASaltBytes: TBytes; Out AKeyBytes, AIVBytes: TBytes)
      : boolean; Static;

    Class Function GetECIESPascalCoinCompatibilityEngine(): IPascalCoinIESEngine; Static;
    Class Function GetIESParameterSpec: IIESParameterSpec; Static;

    Class Function GetCurveFromKeyType(AKeyType: TKeyType): IX9ECParameters; Static;
    Class Function ExtractAffineXFromPascalCoinPublicKey(Const APascalCoinPublicKey: String; Out AAffineXBytes: TBytes)
      : boolean; Static;
    Class Function ExtractAffineYFromPascalCoinPublicKey(Const APascalCoinPublicKey: String; Out AAffineYBytes: TBytes)
      : boolean; Static;
    Class Function ExtractAffineXYFromPascalCoinPublicKey(Const APascalCoinPublicKey: String;
      Out AAffineXBytes, AAffineYBytes: TBytes): boolean; Static;

    Class Function RecreatePublicKeyFromAffineXandAffineYCoord(AKeyType: TKeyType; Const AAffineX, AAffineY: TBytes)
      : IECPublicKeyParameters; Static;
    Class Function ComputeECIESPascalCoinEncrypt(Const APublicKey: IECPublicKeyParameters;
      Const APayloadToEncrypt: TBytes): TBytes; Static;

    class function GetPrivateKeyParams(const APrivateKey: String; const AKeyType:
        TKeyType): IECPrivateKeyParameters;

    Class Function GetPrivateKey(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes; Static;
    Class Function GetPrivateKeyPrefix(AKeyType: TKeyType; Const AInput: TBytes): TBytes; Static;
    Class Function GetPublicKeyAffineX(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes; Static;
    Class Function GetPublicKeyAffineY(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes; Static;

    class function GetPublicKeyAffineXFromParams(const APublicKeyParams:
        IECPublicKeyParameters): TBytes; static;
    class function GetPublicKeyAffineYFromParams(const APublicKeyParams:
        IECPublicKeyParameters): TBytes; static;


    Class Function GetAffineXPrefix(AKeyType: TKeyType; Const AInput: TBytes): TBytes; Static;
    Class Function GetAffineYPrefix(Const AInput: TBytes): TBytes; Static;

    Class Function GetPascalCoinPublicKeyAsHexString(AKeyType: TKeyType; Const AXInput, AYInput: TBytes)
      : String; Static;

    Class Function GetDomainParams(Const AKeyType: TKeyType): IECDomainParameters; Static;
    Class Function GetCurveParams(Const AKeyType: TKeyType): IX9ECParameters; Static;

    Class Function ComputeAES256_CBC_PKCS7PADDING_PascalCoinEncrypt(Const APlainTextBytes, APasswordBytes: TBytes)
      : TBytes; Static;
    Class Function ComputeAES256_CBC_PKCS7PADDING_PascalCoinDecrypt(Const ACipherTextBytes, APasswordBytes: TBytes;
      Out APlainText: TBytes): boolean; Static;

    Class Function RecreatePrivateKeyFromByteArray(AKeyType: TKeyType; Const APrivateKey: TBytes)
      : IECPrivateKeyParameters; Static;
    Class Function ExtractPrivateKeyFromPascalPrivateKey(Const APascalPrivateKey: TBytes): TBytes; Static;
{$IFDEF UNITTEST}
    Class Function DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes;
      Const ARandomK: String): TCryptoLibGenericArray<TBigInteger>; Static;
{$ELSE}
    Class Function DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes)
      : TCryptoLibGenericArray<TBigInteger>; Static;
{$ENDIF}
    Class Function ComputeSHA2_256_ToBytes(Const AInput: TBytes): TBytes; Static;
    Class Function GenerateECKeyPair(AKeyType: TKeyType): IAsymmetricCipherKeyPair; Static;

    Class Function UInt32ToLittleEndianByteArrayTwoBytes(AValue: UInt32): TBytes; Static;

  Public
    Class Constructor CreateKeyUtils;
    Class Function AsHex(Const Value: Cardinal): String; Overload; Static;
    Class Function AsHex(Const Value: Integer): String; Overload; Static;
    Class Function AsHex(Const Value: Currency): String; Overload; Static;
    Class Function AsHex(Const Value: String; Var ALen: Integer): String; Overload; Static;
    Class Function AsHex(Const Value: String): String; Overload; Static;
    Class Function AsHex(Const Value: TBytes): String; Overload; Static;
    Class Function IntToTwoByteHex(Const Value: Integer): String; Static;

    Class Function HexToCardinal(Const Value: String): Cardinal; Static;
    Class Function HexToInt(Const Value: String): Integer; Static;
    Class Function HexToCurrency(Const Value: String): Currency; Static;
    Class Function HexToStr(Const Value: String): String; Static;
    Class Function IntFromTwoByteHex(Const Value: String): Integer; Static;

    Class Function GenerateKeyPair(Const AKeyType: TKeyType): TStringPair;
    class function GetCorrespondingPublicKey(const APrivateKey: String; const
        AKeyType: TKeyType): String; static;
    Class Function GetPascalCoinPublicKeyAsBase58(Const APascalCoinPublicKey: String): String; Static;
    Class Function GetPascalCoinPublicKeyFromBase58(Const ABase58PublicKey: String): String; Static;

    Class Function GetKeyTypeNumericValue(AKeyType: TKeyType): Int32; Static;
    Class Function GetPascalCoinPrivateKeyAsHexString(AKeyType: TKeyType; Const AInput: TBytes): String; Static;
    Class Function EncryptPascalCoinPrivateKey(Const APascalCoinPrivateKey, APassword: String): String; Static;
    class function DecryptPascalCoinPrivateKey(Const APascalCoinEncryptedKey,
        APassword: String; out ADecryptedKey: String): Boolean; static;

    Class Function PrivateKeyFromPascalPrivateKey(Const APascalPrivateKey: String): String; Static;
    Class Function PrivateKeyToPascalPrivateKey(Const APrivateKey: String; Const AKeyType: TKeyType): String; Static;

    Class Function EncryptWithPassword(Const Value, APassword: String): TBytes; Static;
    /// <summary>
    /// raises an exception on fail. EHexException if not a valid hex string
    /// </summary>
    Class Function DecryptWithPassword(Const Value: String; Const APassword: String): String; Overload; Static;
    Class Function DecryptWithPassword(Const Value: String; Const APassword: String; Out Payload: String): boolean;
      Overload; Static;

    /// <param name="APublicKey">
    /// B58 Encoded Key
    /// </param>
    Class Function EncryptWithPublicKey(Const Value: String; Const APascalCoinPublicKey: String): TBytes;

{$IFDEF UNITTEST}
    Class Function SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage, K: String)
      : TECDSA_Signature; Overload; Static;
{$ELSE}
    Class Function SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage: String)
      : TECDSA_Signature; Overload; Static;
{$ENDIF}
    /// <summary>
    /// Returns the Hex Encoded Hash
    /// </summary>
    Class Function HashSHA2_256(Const AInput: String): String;

  End;

Implementation

Uses
  System.Rtti,
  clpEncoders,
  clpConverters,
  ClpCustomNamedCurves,
  ClpECPrivateKeyParameters,
  ClpIParametersWithRandom,
  ClpParametersWithRandom,
  ClpIECDsaSigner,
  ClpECDsaSigner,

  //
  ClpECPublicKeyParameters,
  ClpIECC,
  //
  ClpIIESCipher,
  ClpIESCipher,
  ClpIBufferedBlockCipher,
  ClpIAesEngine,
  ClpIBlockCipherModes,
  ClpIBasicAgreement,
  ClpIESParameterSpec,
  ClpIECDHBasicAgreement,
  ClpIMac,
  ClpECDHBasicAgreement,
  ClpPascalCoinECIESKdfBytesGenerator,
  ClpDigestUtilities,
  ClpMacUtilities,
  ClpAesEngine,
  ClpBlockCipherModes,
  ClpPaddedBufferedBlockCipher,
  ClpPaddingModes,
  ClpIPaddingModes,
  ClpPascalCoinIESEngine,
  //
  ClpIParametersWithIV,
  ClpIBufferedCipher,
  ClpArrayUtils,
  ClpCipherUtilities,
  ClpParametersWithIV,
  ClpParameterUtilities,
  ClpIDigest,
  //
  ClpIAsymmetricCipherKeyPairGenerator,
  ClpGeneratorUtilities,
  ClpECKeyGenerationParameters,
  ClpIECKeyGenerationParameters,
  ClpECKeyPairGenerator,
  ClpIX9ECParametersHolder,
  PascalCoin.RPC.Exceptions,
  PascalCoin.Utils,
  PascalCoin.RPC.Messages
{$IFDEF UNITTEST}
    ,
  ClpIFixedSecureRandom,
  clpFixedSecureRandom
{$ENDIF};

{ TKeyUtils }

Class Function TKeyUtils.AsHex(Const Value: Cardinal): String;
Begin
  Result := THEX.Encode(TConverters.ReadUInt32AsBytesLE(Value), True);
End;

Class Function TKeyUtils.AsHex(Const Value: Integer): String;
Begin
  Result := THEX.Encode(TConverters.ReadUInt32AsBytesLE(Value), True);
End;

Class Function TKeyUtils.AsHex(Const Value: Currency): String;
Var
  lVal: Int64;
Begin
  lVal := Trunc(Value * CURRENCY_SCALE);
  Result := THEX.Encode(TConverters.ReadUInt64AsBytesLE(lVal), True);
End;

Class Function TKeyUtils.AsHex(Const Value: String; Var ALen: Integer): String;
Var
  lVal: TBytes;
Begin
  lVal := TConverters.ConvertStringToBytes(Value, TEncoding.ANSI);
  ALen := Length(lVal);
  Result := THEX.Encode(lVal, True);
End;

Class Function TKeyUtils.AES256Decrypt(Const ACipherTextBytes, APasswordBytes: TBytes; Out APlainText: TBytes): boolean;
Var
  SalTBytes, KeyBytes, IVBytes, Buf, Chopped: TBytes;
  KeyParametersWithIV: IParametersWithIV;
  cipher: IBufferedCipher;
  LBufStart, LSrcStart, Count: Int32;
Begin
  Try
    System.SetLength(SalTBytes, SALT_SIZE);
    // First read the magic text and the salt - if any
    Chopped := System.Copy(ACipherTextBytes, 0, SALT_MAGIC_LEN);
    If (System.Length(ACipherTextBytes) >= SALT_MAGIC_LEN) And
      (TArrayUtils.AreEqual(Chopped, TConverters.ConvertStringToBytes(SALT_MAGIC, TEncoding.UTF8))) Then
    Begin
      System.Move(ACipherTextBytes[SALT_MAGIC_LEN], SalTBytes[0], SALT_SIZE);
      If Not EVP_GetKeyIV(APasswordBytes, SalTBytes, KeyBytes, IVBytes) Then
      Begin
        Result := False;
        Exit;
      End;
      LSrcStart := SALT_MAGIC_LEN + SALT_SIZE;
    End
    Else
    Begin
      If Not EVP_GetKeyIV(APasswordBytes, Nil, KeyBytes, IVBytes) Then
      Begin
        Result := False;
        Exit;
      End;
      LSrcStart := 0;
    End;

    cipher := TCipherUtilities.GetCipher('AES/CBC/PKCS7PADDING');
    KeyParametersWithIV := TParametersWithIV.Create(TParameterUtilities.CreateKeyParameter('AES', KeyBytes), IVBytes);

    cipher.Init(False, KeyParametersWithIV); // init decryption cipher

    System.SetLength(Buf, System.Length(ACipherTextBytes));

    LBufStart := 0;

    Count := cipher.ProcessBytes(ACipherTextBytes, LSrcStart, System.Length(ACipherTextBytes) - LSrcStart, Buf,
      LBufStart);
    System.Inc(LBufStart, Count);
    Count := cipher.DoFinal(Buf, LBufStart);
    System.Inc(LBufStart, Count);

    System.SetLength(Buf, LBufStart);

    APlainText := System.Copy(Buf);

    Result := True;
  Except
    Result := False;
  End;

End;

Class Function TKeyUtils.AES256Encrypt(Const APlainTextBytes, APasswordBytes: TBytes): TBytes;
Var
  SalTBytes, KeyBytes, IVBytes, Buf: TBytes;
  KeyParametersWithIV: IParametersWithIV;
  cipher: IBufferedCipher;
  LBlockSize, LBufStart, Count: Int32;
Begin
  SalTBytes := EVP_GetSalt();
  EVP_GetKeyIV(APasswordBytes, SalTBytes, KeyBytes, IVBytes);
  cipher := TCipherUtilities.GetCipher('AES/CBC/PKCS7PADDING');
  KeyParametersWithIV := TParametersWithIV.Create(TParameterUtilities.CreateKeyParameter('AES', KeyBytes), IVBytes);

  cipher.Init(True, KeyParametersWithIV); // init encryption cipher
  LBlockSize := cipher.GetBlockSize;

  System.SetLength(Buf, System.Length(APlainTextBytes) + LBlockSize + SALT_MAGIC_LEN + PKCS5_SALT_LEN);

  LBufStart := 0;

  System.Move(TConverters.ConvertStringToBytes(SALT_MAGIC, TEncoding.UTF8)[0], Buf[LBufStart],
    SALT_MAGIC_LEN * System.SizeOf(byte));
  System.Inc(LBufStart, SALT_MAGIC_LEN);
  System.Move(SalTBytes[0], Buf[LBufStart], PKCS5_SALT_LEN * System.SizeOf(byte));
  System.Inc(LBufStart, PKCS5_SALT_LEN);

  Count := cipher.ProcessBytes(APlainTextBytes, 0, System.Length(APlainTextBytes), Buf, LBufStart);
  System.Inc(LBufStart, Count);
  Count := cipher.DoFinal(Buf, LBufStart);
  System.Inc(LBufStart, Count);

  System.SetLength(Buf, LBufStart);
  Result := Buf;

End;

Class Function TKeyUtils.ComputeAES256_CBC_PKCS7PADDING_PascalCoinDecrypt(Const ACipherTextBytes,
  APasswordBytes: TBytes; Out APlainText: TBytes): boolean;
Var
  SalTBytes, KeyBytes, IVBytes, Buf, Chopped: TBytes;
  KeyParametersWithIV: IParametersWithIV;
  cipher: IBufferedCipher;
  LBufStart, LSrcStart, Count: Int32;
Begin
  Try
    System.SetLength(SalTBytes, SALT_SIZE);
    // First read the magic text and the salt - if any
    Chopped := System.Copy(ACipherTextBytes, 0, SALT_MAGIC_LEN);
    If (System.Length(ACipherTextBytes) >= SALT_MAGIC_LEN) And
      (TArrayUtils.AreEqual(Chopped, TConverters.ConvertStringToBytes(SALT_MAGIC, TEncoding.UTF8))) Then
    Begin
      System.Move(ACipherTextBytes[SALT_MAGIC_LEN], SalTBytes[0], SALT_SIZE);
      If Not EVP_GetKeyIV(APasswordBytes, SalTBytes, KeyBytes, IVBytes) Then
      Begin
        Result := False;
        Exit;
      End;
      LSrcStart := SALT_MAGIC_LEN + SALT_SIZE;
    End
    Else
    Begin
      If Not EVP_GetKeyIV(APasswordBytes, Nil, KeyBytes, IVBytes) Then
      Begin
        Result := False;
        Exit;
      End;
      LSrcStart := 0;
    End;

    cipher := TCipherUtilities.GetCipher('AES/CBC/PKCS7PADDING');
    KeyParametersWithIV := TParametersWithIV.Create(TParameterUtilities.CreateKeyParameter('AES', KeyBytes), IVBytes);

    cipher.Init(False, KeyParametersWithIV); // init decryption cipher

    System.SetLength(Buf, System.Length(ACipherTextBytes));

    LBufStart := 0;

    Count := cipher.ProcessBytes(ACipherTextBytes, LSrcStart, System.Length(ACipherTextBytes) - LSrcStart, Buf,
      LBufStart);
    System.Inc(LBufStart, Count);
    Count := cipher.DoFinal(Buf, LBufStart);
    System.Inc(LBufStart, Count);

    System.SetLength(Buf, LBufStart);

    APlainText := System.Copy(Buf);

    Result := True;
  Except
    Result := False;
  End;

End;

Class Function TKeyUtils.ComputeAES256_CBC_PKCS7PADDING_PascalCoinEncrypt(Const APlainTextBytes,
  APasswordBytes: TBytes): TBytes;
Var
  SalTBytes, KeyBytes, IVBytes, Buf: TBytes;
  KeyParametersWithIV: IParametersWithIV;
  cipher: IBufferedCipher;
  LBlockSize, LBufStart, Count: Int32;
Begin
  SalTBytes := EVP_GetSalt();
  EVP_GetKeyIV(APasswordBytes, SalTBytes, KeyBytes, IVBytes);
  cipher := TCipherUtilities.GetCipher('AES/CBC/PKCS7PADDING');
  KeyParametersWithIV := TParametersWithIV.Create(TParameterUtilities.CreateKeyParameter('AES', KeyBytes), IVBytes);

  cipher.Init(True, KeyParametersWithIV); // init encryption cipher
  LBlockSize := cipher.GetBlockSize;

  System.SetLength(Buf, System.Length(APlainTextBytes) + LBlockSize + SALT_MAGIC_LEN + PKCS5_SALT_LEN);

  LBufStart := 0;

  System.Move(TConverters.ConvertStringToBytes(SALT_MAGIC, TEncoding.UTF8)[0], Buf[LBufStart],
    SALT_MAGIC_LEN * System.SizeOf(byte));
  System.Inc(LBufStart, SALT_MAGIC_LEN);
  System.Move(SalTBytes[0], Buf[LBufStart], PKCS5_SALT_LEN * System.SizeOf(byte));
  System.Inc(LBufStart, PKCS5_SALT_LEN);

  Count := cipher.ProcessBytes(APlainTextBytes, 0, System.Length(APlainTextBytes), Buf, LBufStart);
  System.Inc(LBufStart, Count);
  Count := cipher.DoFinal(Buf, LBufStart);
  System.Inc(LBufStart, Count);

  System.SetLength(Buf, LBufStart);
  Result := Buf;

End;

Class Function TKeyUtils.ComputeECIESPascalCoinEncrypt(Const APublicKey: IECPublicKeyParameters;
  Const APayloadToEncrypt: TBytes): TBytes;
Var
  CipherEncrypt: IIESCipher;
Begin
  // Encryption
  CipherEncrypt := TIESCipher.Create(GetECIESPascalCoinCompatibilityEngine());
  CipherEncrypt.Init(True, APublicKey, GetIESParameterSpec(), FRandom);
  Result := CipherEncrypt.DoFinal(APayloadToEncrypt);
End;

Class Function TKeyUtils.ComputeSHA2_256_ToBytes(Const AInput: TBytes): TBytes;
Begin
  Result := TDigestUtilities.CalculateDigest('SHA-256', AInput);
End;

Class Constructor TKeyUtils.CreateKeyUtils;
Begin
  FRandom := TSecureRandom.Create();
End;

Class Function TKeyUtils.DecryptPascalCoinPrivateKey(Const APascalCoinEncryptedKey, APassword: String; out ADecryptedKey: String): Boolean;
Var
  CipherTextBytes, PasswordBytes, PlainTextBytes: TBytes;
Begin
  ADecryptedKey := '';
  CipherTextBytes := THEX.Decode(APascalCoinEncryptedKey);
  PasswordBytes := TConverters.ConvertStringToBytes(APassword, TEncoding.UTF8);
  Result := ComputeAES256_CBC_PKCS7PADDING_PascalCoinDecrypt(CipherTextBytes, PasswordBytes, PlainTextBytes);
  ADecryptedKey := THex.Encode(PlainTextBytes);
End;

Class Function TKeyUtils.DecryptWithPassword(Const Value, APassword: String; Out Payload: String): boolean;
Begin
  Payload := '';

  Try
    DecryptWithPassword(Value, APassword, Payload);
    Result := True;
  Except
    On e: exception Do
      Result := False;
  End;
End;

{$IFDEF UNITTEST}

Class Function TKeyUtils.DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes;
  Const ARandomK: String): TCryptoLibGenericArray<TBigInteger>;
{$ELSE}

Class Function TKeyUtils.DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes)
  : TCryptoLibGenericArray<TBigInteger>;
{$ENDIF}
Var
  Signer: IECDsaSigner;
  Param: IParametersWithRandom;
{$IFDEF UNITTEST}
  lRandomBytes: TBytes;
  lArray: TCryptoLibMatrixByteArray;
  {$ENDIF}
  lRandom: ISecureRandom;
Begin
{$IFDEF UNITTEST}
  If ARandomK = '' Then
    lRandom := FRandom
  Else
  Begin
    lRandomBytes := THEX.Decode(ARandomK);
    lArray := TCryptoLibMatrixByteArray.Create(lRandomBytes);
    // TBytes.Create(1, 2));
    lRandom := TFixedSecureRandom.From(lArray);
  End;
{$ELSE}
  lRandom := FRandom;
{$ENDIF UNITTEST}
  Param := TParametersWithRandom.Create(APrivateKey, lRandom);
  Signer := TECDsaSigner.Create();
  Signer.Init(True, Param);
  Result := Signer.GenerateSignature(AMessage);
End;

Class Function TKeyUtils.DecryptWithPassword(Const Value, APassword: String): String;
Var
  PasswordBytes, PayloadToDecryptBytes, DecryptedPayloadBytes: TBytes;
Begin
  PasswordBytes := TConverters.ConvertStringToBytes(APassword, TEncoding.UTF8);

  If (Not(TPascalCoinUtils.IsHex(Value))) Then
    Raise EHexException.Create(Value);

  PayloadToDecryptBytes := THEX.Decode(Value);

  If Not AES256Decrypt(PayloadToDecryptBytes, PasswordBytes, DecryptedPayloadBytes) Then
    Raise EDecryptException.Create;

  Result := TConverters.ConverTBytesToString(DecryptedPayloadBytes, TEncoding.UTF8);

End;

Class Function TKeyUtils.EncryptWithPassword(Const Value, APassword: String): TBytes;
Var
  PasswordBytes, PayloadToEncryptBytes: TBytes;
Begin
  PasswordBytes := TConverters.ConvertStringToBytes(APassword, TEncoding.UTF8);
  PayloadToEncryptBytes := TConverters.ConvertStringToBytes(Value, TEncoding.UTF8);
  Result := AES256Encrypt(PayloadToEncryptBytes, PasswordBytes);
End;

Class Function TKeyUtils.EncryptWithPublicKey(Const Value: String; Const APascalCoinPublicKey: String): TBytes;
Var
  lKeyType: TKeyType;
  AffineXCoord, AffineYCoord, PayloadToEncrypt: TBytes;
  RecreatedPublicKey: IECPublicKeyParameters;
Begin

  lKeyType := TPascalCoinUtils.KeyTypeFromPascalKey(APascalCoinPublicKey);

  PayloadToEncrypt := TConverters.ConvertStringToBytes(Value, TEncoding.UTF8);

  If Not ExtractAffineXFromPascalCoinPublicKey(APascalCoinPublicKey, AffineXCoord) Then
    Raise EKeyException.Create('Public', KEY_X_ERROR);

  If Not ExtractAffineYFromPascalCoinPublicKey(APascalCoinPublicKey, AffineYCoord) Then
    Raise EKeyException.Create('Public', KEY_Y_ERROR);

  RecreatedPublicKey := RecreatePublicKeyFromAffineXandAffineYCoord(lKeyType, AffineXCoord, AffineYCoord);

  Result := ComputeECIESPascalCoinEncrypt(RecreatedPublicKey, PayloadToEncrypt);

End;

Class Function TKeyUtils.EVP_GetKeyIV(Const APasswordBytes, ASaltBytes: TBytes;
  Out AKeyBytes, AIVBytes: TBytes): boolean;
Var
  LKey, LIV: Int32;
  LDigest: IDigest;
Begin
  LKey := 32; // AES256 CBC Key Length
  LIV := 16; // AES256 CBC IV Length
  System.SetLength(AKeyBytes, LKey);
  System.SetLength(AIVBytes, LKey);
  // Max size to start then reduce it at the end
  LDigest := TDigestUtilities.GetDigest('SHA-256'); // SHA2_256
  System.Assert(LDigest.GetDigestSize >= LKey);
  System.Assert(LDigest.GetDigestSize >= LIV);
  // Derive Key First
  LDigest.BlockUpdate(APasswordBytes, 0, System.Length(APasswordBytes));
  If ASaltBytes <> Nil Then
  Begin
    LDigest.BlockUpdate(ASaltBytes, 0, System.Length(ASaltBytes));
  End;
  LDigest.DoFinal(AKeyBytes, 0);
  // Derive IV Next
  LDigest.Reset();
  LDigest.BlockUpdate(AKeyBytes, 0, System.Length(AKeyBytes));
  LDigest.BlockUpdate(APasswordBytes, 0, System.Length(APasswordBytes));
  If ASaltBytes <> Nil Then
  Begin
    LDigest.BlockUpdate(ASaltBytes, 0, System.Length(ASaltBytes));
  End;
  LDigest.DoFinal(AIVBytes, 0);

  System.SetLength(AIVBytes, LIV);
  Result := True;
End;

Class Function TKeyUtils.EVP_GetSalt: TBytes;
Begin
  System.SetLength(Result, PKCS5_SALT_LEN);
  FRandom.NexTBytes(Result);
End;

Class Function TKeyUtils.ExtractAffineXFromPascalCoinPublicKey(Const APascalCoinPublicKey: String;
  Out AAffineXBytes: TBytes): boolean;
Var
  AffineXLength: Int32;
  LPascalCoinPublicKeyBytes: TBytes;
Begin
  LPascalCoinPublicKeyBytes := THEX.Decode(APascalCoinPublicKey);
  AffineXLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, 2, 1)[0]);
  AAffineXBytes := System.Copy(LPascalCoinPublicKeyBytes, 4, AffineXLength);
  Result := System.Length(AAffineXBytes) = AffineXLength;
End;

Class Function TKeyUtils.ExtractAffineXYFromPascalCoinPublicKey(Const APascalCoinPublicKey: String;
  Out AAffineXBytes, AAffineYBytes: TBytes): boolean;
Var
  AffineXLength, AffineYLength, Offset: Int32;
  LPascalCoinPublicKeyBytes: TBytes;
Begin
  LPascalCoinPublicKeyBytes := THEX.Decode(APascalCoinPublicKey);
  AffineXLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, 2, 1)[0]);
  AAffineXBytes := System.Copy(LPascalCoinPublicKeyBytes, 4, AffineXLength);

  Offset := 4 + AffineXLength;
  AffineYLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, Offset, 1)[0]);
  AAffineYBytes := System.Copy(LPascalCoinPublicKeyBytes, Offset + 2, AffineYLength);

  Result := (System.Length(AAffineXBytes) = AffineXLength) And (System.Length(AAffineYBytes) = AffineYLength);

End;

Class Function TKeyUtils.ExtractAffineYFromPascalCoinPublicKey(Const APascalCoinPublicKey: String;
  Out AAffineYBytes: TBytes): boolean;
Var
  AffineXLength, AffineYLength, Offset: Int32;
  LPascalCoinPublicKeyBytes: TBytes;
Begin
  LPascalCoinPublicKeyBytes := THEX.Decode(APascalCoinPublicKey);
  AffineXLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, 2, 1)[0]);
  Offset := 4 + AffineXLength;
  AffineYLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, Offset, 1)[0]);
  AAffineYBytes := System.Copy(LPascalCoinPublicKeyBytes, Offset + 2, AffineYLength);
  Result := System.Length(AAffineYBytes) = AffineYLength;
End;

Class Function TKeyUtils.ExtractPrivateKeyFromPascalPrivateKey(Const APascalPrivateKey: TBytes): TBytes;
Begin
  Result := System.Copy(APascalPrivateKey, 4, System.Length(APascalPrivateKey) - 4);
End;

Class Function TKeyUtils.GenerateECKeyPair(AKeyType: TKeyType): IAsymmetricCipherKeyPair;
Var
  LCurve: IX9ECParameters;
  Domain: IECDomainParameters;
  KeyPairGeneratorInstance: IAsymmetricCipherKeyPairGenerator;
Begin
  LCurve := GetCurveFromKeyType(AKeyType);
  KeyPairGeneratorInstance := TGeneratorUtilities.GetKeyPairGenerator('ECDSA');
  Domain := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);
  KeyPairGeneratorInstance.Init(TECKeyGenerationParameters.Create(Domain, FRandom) As IECKeyGenerationParameters);
  Result := KeyPairGeneratorInstance.GenerateKeyPair();
End;

Class Function TKeyUtils.GenerateKeyPair(Const AKeyType: TKeyType): TStringPair;
Var
  LKeyPair: IAsymmetricCipherKeyPair;
  LPrivateKey, LPublicKeyXCoord, LPublicKeyYCoord: TBytes;
Begin
  LKeyPair := GenerateECKeyPair(AKeyType);
  LPrivateKey := GetPrivateKey(LKeyPair);
  LPublicKeyXCoord := GetPublicKeyAffineX(LKeyPair);
  LPublicKeyYCoord := GetPublicKeyAffineY(LKeyPair);

  Result.Key := GetPascalCoinPrivateKeyAsHexString(AKeyType, LPrivateKey);
  Result.Value := GetPascalCoinPublicKeyAsHexString(AKeyType, LPublicKeyXCoord, LPublicKeyYCoord);
End;

Class Function TKeyUtils.GetAffineXPrefix(AKeyType: TKeyType; Const AInput: TBytes): TBytes;
Begin
  Result := TArrayUtils.Concatenate(UInt32ToLittleEndianByteArrayTwoBytes(UInt32(GetKeyTypeNumericValue(AKeyType))),
    UInt32ToLittleEndianByteArrayTwoBytes(System.Length(AInput)));
End;

Class Function TKeyUtils.GetAffineYPrefix(Const AInput: TBytes): TBytes;
Begin
  Result := UInt32ToLittleEndianByteArrayTwoBytes(System.Length(AInput));
End;

class function TKeyUtils.GetCorrespondingPublicKey(const APrivateKey: String; const AKeyType: TKeyType): String;
var lPrivateKeyParams: IECPrivateKeyParameters;
    lPublicKeyParams: IECPublicKeyParameters;
    LPublicKeyXCoord, LPublicKeyYCoord: TBytes;
begin
  lPrivateKeyParams := GetPrivateKeyParams(APrivateKey, AKeyType);
  lPublicKeyParams := TECKeyPairGenerator.GetCorrespondingPublicKey(lPrivateKeyParams);
  LPublicKeyXCoord := GetPublicKeyAffineXFromParams(lPublicKeyParams);
  LPublicKeyYCoord := GetPublicKeyAffineYFromParams(lPublicKeyParams);
  Result := GetPascalCoinPublicKeyAsHexString(AKeyType, LPublicKeyXCoord, LPublicKeyYCoord);
end;

Class Function TKeyUtils.GetCurveFromKeyType(AKeyType: TKeyType): IX9ECParameters;
Var
  CurveName: String;
Begin
  CurveName := TRttiEnumerationType.GetName<TKeyType>(AKeyType);
  Result := TCustomNamedCurves.GetByName(CurveName);
End;

Class Function TKeyUtils.GetCurveParams(Const AKeyType: TKeyType): IX9ECParameters;
Begin
  Result := TCustomNamedCurves.GetByName(TRttiEnumerationType.GetName<TKeyType>(AKeyType));
End;

Class Function TKeyUtils.GetDomainParams(Const AKeyType: TKeyType): IECDomainParameters;
Var
  LCurve: IX9ECParameters;
Begin
  LCurve := GetCurveParams(AKeyType);
  Result := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);
End;

Class Function TKeyUtils.GetECIESPascalCoinCompatibilityEngine: IPascalCoinIESEngine;
Var
  cipher: IBufferedBlockCipher;
  AesEngine: IAesEngine;
  blockCipher: ICbcBlockCipher;
  ECDHBasicAgreementInstance: IECDHBasicAgreement;
  KDFInstance: IPascalCoinECIESKdfBytesGenerator;
  DigestMACInstance: IMac;

Begin
  // Set up IES Cipher Engine For Compatibility With PascalCoin

  ECDHBasicAgreementInstance := TECDHBasicAgreement.Create();

  KDFInstance := TPascalCoinECIESKdfBytesGenerator.Create(TDigestUtilities.GetDigest('SHA-512'));

  DigestMACInstance := TMacUtilities.GetMac('HMAC-MD5');

  // Set Up Block Cipher
  AesEngine := TAesEngine.Create(); // AES Engine

  blockCipher := TCbcBlockCipher.Create(AesEngine); // CBC

  cipher := TPaddedBufferedBlockCipher.Create(blockCipher, TZeroBytePadding.Create() As IZeroBytePadding);
  // ZeroBytePadding

  Result := TPascalCoinIESEngine.Create(ECDHBasicAgreementInstance, KDFInstance, DigestMACInstance, cipher);
End;

Class Function TKeyUtils.GetIESParameterSpec: IIESParameterSpec;
Var
  Derivation, Encoding, IVBytes: TBytes;
  MacKeySizeInBits, CipherKeySizeInBits: Int32;
  UsePointCompression: boolean;
Begin
  // Set up IES Parameter Spec For Compatibility With PascalCoin Current Implementation

  // The derivation and encoding vectors are used when initialising the KDF and MAC.
  // They're optional but if used then they need to be known by the other user so that
  // they can decrypt the ciphertext and verify the MAC correctly. The security is based
  // on the shared secret coming from the (static-ephemeral) ECDH key agreement.
  Derivation := Nil;

  Encoding := Nil;

  System.SetLength(IVBytes, 16); // using Zero Initialized IV for compatibility

  MacKeySizeInBits := 32 * 8;

  // Since we are using AES256_CBC for compatibility
  CipherKeySizeInBits := 32 * 8;

  // whether to use point compression when deriving the octets string
  // from a point or not in the EphemeralKeyPairGenerator
  UsePointCompression := True; // for compatibility

  Result := TIESParameterSpec.Create(Derivation, Encoding, MacKeySizeInBits, CipherKeySizeInBits, IVBytes,
    UsePointCompression);
End;

Class Function TKeyUtils.GetKeyTypeNumericValue(AKeyType: TKeyType): Int32;
Begin
  Case AKeyType Of
    TKeyType.SECP256K1:
      Result := 714;
    TKeyType.SECP384R1:
      Result := 715;
    TKeyType.SECP521R1:
      Result := 716;
    TKeyType.SECT283K1:
      Result := 729
    Else Result := -1;
  End;
End;

Class Function TKeyUtils.GetPascalCoinPrivateKeyAsHexString(AKeyType: TKeyType; Const AInput: TBytes): String;
Begin
  Result := THEX.Encode(TArrayUtils.Concatenate(GetPrivateKeyPrefix(AKeyType, AInput), AInput));
End;

Class Function TKeyUtils.EncryptPascalCoinPrivateKey(Const APascalCoinPrivateKey, APassword: String): String;
Var
  PascalCoinPrivateKeyBytes, PasswordBytes: TBytes;
Begin
  PascalCoinPrivateKeyBytes := THEX.Decode(APascalCoinPrivateKey);
  PasswordBytes := TConverters.ConvertStringToBytes(APassword, TEncoding.UTF8);
  Result := THEX.Encode(ComputeAES256_CBC_PKCS7PADDING_PascalCoinEncrypt(PascalCoinPrivateKeyBytes, PasswordBytes));
End;

Class Function TKeyUtils.GetPascalCoinPublicKeyAsBase58(Const APascalCoinPublicKey: String): String;
Var
  PreBase58PublicKeyBytes, PascalCoinPublicKeyBytes, Base58PublicKeyBytes: TBytes;
Begin
  PascalCoinPublicKeyBytes := THEX.Decode(APascalCoinPublicKey);
  Base58PublicKeyBytes := THEX.Decode(B58_PUBKEY_PREFIX);
  PreBase58PublicKeyBytes := TArrayUtils.Concatenate(TArrayUtils.Concatenate(Base58PublicKeyBytes,
    PascalCoinPublicKeyBytes), System.Copy(ComputeSHA2_256_ToBytes(PascalCoinPublicKeyBytes), 0, 4));
  Result := TBase58.Encode(PreBase58PublicKeyBytes);
End;

Class Function TKeyUtils.GetPascalCoinPublicKeyAsHexString(AKeyType: TKeyType; Const AXInput, AYInput: TBytes): String;
Var
  PartX, PartY, TotalPart: TBytes;
Begin
  PartX := TArrayUtils.Concatenate(GetAffineXPrefix(AKeyType, AXInput), AXInput);
  PartY := TArrayUtils.Concatenate(GetAffineYPrefix(AYInput), AYInput);
  TotalPart := TArrayUtils.Concatenate(PartX, PartY);
  Result := THEX.Encode(TotalPart);
End;

Class Function TKeyUtils.GetPascalCoinPublicKeyFromBase58(Const ABase58PublicKey: String): String;
Var
  lBytes: TBytes;
Begin
  lBytes := System.Copy(TBase58.Decode(ABase58PublicKey), 1);
  Result := THEX.Encode(lBytes);
End;

Class Function TKeyUtils.GetPrivateKey(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes;
Var
  LPrivateKey: IECPrivateKeyParameters;
Begin
  LPrivateKey := AKeyPair.&Private As IECPrivateKeyParameters;
  Result := LPrivateKey.D.ToByteArrayUnsigned();
End;

class function TKeyUtils.GetPrivateKeyParams(const APrivateKey: String; const AKeyType: TKeyType): IECPrivateKeyParameters;
Var
  lPrivate: TBytes;
  LDomain: IECDomainParameters;
  LPrivD: TBigInteger;
  LSignerResult: TCryptoLibGenericArray<TBigInteger>;
Begin
  lPrivate := THEX.Decode(APrivateKey);
  LDomain := GetDomainParams(AKeyType);
  LPrivD := TBigInteger.Create(1, lPrivate);
  Result := TECPrivateKeyParameters.Create('ECDSA', LPrivD, LDomain);
end;

Class Function TKeyUtils.GetPrivateKeyPrefix(AKeyType: TKeyType; Const AInput: TBytes): TBytes;
Begin
  Result := TArrayUtils.Concatenate(UInt32ToLittleEndianByteArrayTwoBytes(UInt32(GetKeyTypeNumericValue(AKeyType))),
    UInt32ToLittleEndianByteArrayTwoBytes(System.Length(AInput)));
End;

Class Function TKeyUtils.GetPublicKeyAffineX(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes;
Var
  LPublicKey: IECPublicKeyParameters;
Begin
  LPublicKey := AKeyPair.&Public As IECPublicKeyParameters;
  Result := LPublicKey.Q.AffineXCoord.ToBigInteger().ToByteArrayUnsigned();
End;

class function TKeyUtils.GetPublicKeyAffineXFromParams(const APublicKeyParams: IECPublicKeyParameters): TBytes;
begin
  Result := APublicKeyParams.Q.AffineXCoord.ToBigInteger().ToByteArrayUnsigned();
end;

Class Function TKeyUtils.GetPublicKeyAffineY(Const AKeyPair: IAsymmetricCipherKeyPair): TBytes;
Var
  LPublicKey: IECPublicKeyParameters;
Begin
  LPublicKey := AKeyPair.&Public As IECPublicKeyParameters;
  Result := LPublicKey.Q.AffineYCoord.ToBigInteger().ToByteArrayUnsigned();
End;

class function TKeyUtils.GetPublicKeyAffineYFromParams(const APublicKeyParams: IECPublicKeyParameters): TBytes;
begin
  Result := APublicKeyParams.Q.AffineYCoord.ToBigInteger().ToByteArrayUnsigned();
end;

Class Function TKeyUtils.HashSHA2_256(Const AInput: String): String;
Begin
  Result := THEX.Encode(ComputeSHA2_256_ToBytes(THEX.Decode(AInput)));
End;

Class Function TKeyUtils.HexToCardinal(Const Value: String): Cardinal;
Var
  lBytes: TBytes;
Begin
  lBytes := THEX.Decode(Value);
  Result := TConverters.ReadBytesAsUInt32LE(PByte(lBytes), 0)
End;

Class Function TKeyUtils.HexToCurrency(Const Value: String): Currency;
Var
  lVal: Int64;
  lBytes: TBytes;
Begin
  lBytes := THEX.Decode(Value);
  lVal := TConverters.ReadBytesAsUInt64LE(PByte(lBytes), 0);
  Result := lVal / CURRENCY_SCALE;
End;

Class Function TKeyUtils.HexToInt(Const Value: String): Integer;
Var
  lBytes: TBytes;
Begin
  lBytes := THEX.Decode(Value);
  Result := TConverters.ReadBytesAsUInt32LE(PByte(lBytes), 0)
End;

Class Function TKeyUtils.HexToStr(Const Value: String): String;
Begin

End;

Class Function TKeyUtils.IntFromTwoByteHex(Const Value: String): Integer;
Var
  lBytes: TBytes;
Begin
  lBytes := THEX.Decode(Value);
  lBytes := TArrayUtils.Concatenate(lBytes, [0, 0]);
  Result := TConverters.ReadBytesAsUInt32LE(PByte(lBytes), 0)
End;

Class Function TKeyUtils.IntToTwoByteHex(Const Value: Integer): String;
Var
  lBytes: TBytes;
Begin
  lBytes := UInt32ToLittleEndianByteArrayTwoBytes(Value);
  Result := AsHex(lBytes);
End;

Class Function TKeyUtils.PrivateKeyFromPascalPrivateKey(Const APascalPrivateKey: String): String;
Var
  lPascKey, lPrivKey: TBytes;
Begin
  lPascKey := THEX.Decode(APascalPrivateKey);
  lPrivKey := ExtractPrivateKeyFromPascalPrivateKey(lPascKey);
  Result := THEX.Encode(lPrivKey);
End;

Class Function TKeyUtils.PrivateKeyToPascalPrivateKey(Const APrivateKey: String; Const AKeyType: TKeyType): String;
Var
  LPrivateKey: TBytes;
Begin
  LPrivateKey := THEX.Decode(APrivateKey);
  Result := THEX.Encode(TArrayUtils.Concatenate(GetPrivateKeyPrefix(AKeyType, LPrivateKey), LPrivateKey));
End;

Class Function TKeyUtils.RecreatePrivateKeyFromByteArray(AKeyType: TKeyType; Const APrivateKey: TBytes)
  : IECPrivateKeyParameters;
Var
  Domain: IECDomainParameters;
  LCurve: IX9ECParameters;
  PrivD: TBigInteger;
Begin
  LCurve := GetCurveFromKeyType(AKeyType);
  Domain := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);

  PrivD := TBigInteger.Create(1, APrivateKey);

  Result := TECPrivateKeyParameters.Create('ECDSA', PrivD, Domain);
End;

Class Function TKeyUtils.RecreatePublicKeyFromAffineXandAffineYCoord(AKeyType: TKeyType;
  Const AAffineX, AAffineY: TBytes): IECPublicKeyParameters;
Var
  Domain: IECDomainParameters;
  LCurve: IX9ECParameters;
  point: IECPoint;
  BigXCoord, BigYCoord: TBigInteger;
Begin
  LCurve := GetCurveFromKeyType(AKeyType);
  Domain := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);

  BigXCoord := TBigInteger.Create(1, AAffineX);
  BigYCoord := TBigInteger.Create(1, AAffineY);

  point := LCurve.Curve.CreatePoint(BigXCoord, BigYCoord);

  Result := TECPublicKeyParameters.Create('ECDSA', point, Domain);

End;

{$IFDEF UNITTEST}

Class Function TKeyUtils.SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage, K: String)
  : TECDSA_Signature;
{$ELSE}

Class Function TKeyUtils.SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage: String)
  : TECDSA_Signature;
{$ENDIF }
Var
  lPrivate: TBytes;
  LDomain: IECDomainParameters;
  LPrivD: TBigInteger;
  LPrivateKey: IECPrivateKeyParameters;
  LSignerResult: TCryptoLibGenericArray<TBigInteger>;
Begin

  lPrivate := THEX.Decode(APrivateKey);
  LDomain := GetDomainParams(AKeyType);
  LPrivD := TBigInteger.Create(1, lPrivate);
  LPrivateKey := TECPrivateKeyParameters.Create('ECDSA', LPrivD, LDomain);
{$IFDEF UNITTEST}
  LSignerResult := DoECDSASign(LPrivateKey, THEX.Decode(AMessage), K);
{$ELSE}
  LSignerResult := DoECDSASign(LPrivateKey, THEX.Decode(AMessage));
{$ENDIF}
  Result.R := THEX.Encode(LSignerResult[0].ToByteArrayUnsigned);
  Result.RLen := Length(LSignerResult[0].ToByteArrayUnsigned);
  Result.S := THEX.Encode(LSignerResult[1].ToByteArrayUnsigned);
  Result.SLen := Length(LSignerResult[1].ToByteArrayUnsigned);
End;

Class Function TKeyUtils.UInt32ToLittleEndianByteArrayTwoBytes(AValue: UInt32): TBytes;
Var
  lBytes: TBytes;
Begin
  lBytes := TConverters.ReadUInt32AsBytesLE(AValue);
  Result := System.Copy(lBytes, 0, 2);
End;

Class Function TKeyUtils.AsHex(Const Value: String): String;
Var
  lLen: Integer;
Begin
  Result := AsHex(Value, lLen);
End;

Class Function TKeyUtils.AsHex(Const Value: TBytes): String;
Begin
  Result := THEX.Encode(Value);
End;

End.
