Unit PascalCoin.KeyUtils;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
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
  ClpIECPublicKeyParameters;

Type

  TKeyUtils = Class
  Strict Private

  Const
    PKCS5_SALT_LEN = Int32(8);
    SALT_MAGIC_LEN = Int32(8);
    SALT_SIZE = Int32(8);
    SALT_MAGIC: String = 'Salted__';
    B58_PUBKEY_PREFIX: String = '01';

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
    Class Function RecreatePublicKeyFromAffineXandAffineYCoord(AKeyType: TKeyType; Const AAffineX, AAffineY: TBytes)
      : IECPublicKeyParameters; Static;
    Class Function ComputeECIESPascalCoinEncrypt(Const APublicKey: IECPublicKeyParameters;
      Const APayloadToEncrypt: TBytes): TBytes; Static;

    Class Function RecreatePrivateKeyFromByteArray(AKeyType: TKeyType; Const APrivateKey: TBytes)
      : IECPrivateKeyParameters; Static;
{$IFDEF UNITTEST}
    Class Function DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes;
      Const ARandomK: String): TCryptoLibGenericArray<TBigInteger>; Static;
{$ELSE}
    Class Function DoECDSASign(Const APrivateKey: IECPrivateKeyParameters; Const AMessage: TBytes)
      : TCryptoLibGenericArray<TBigInteger>; Static;
{$ENDIF}
    Class Function ComputeSHA2_256_ToBytes(Const AInput: TBytes): TBytes; Static; Inline;

  Public
    Class Constructor CreateKeyUtils;
    Class Function AsHex(Const Value: Cardinal): String; Overload; Static;
    Class Function AsHex(Const Value: Integer): String; Overload; Static;
    Class Function AsHex(Const Value: Currency): String; Overload; Static;
    Class Function AsHex(Const Value: String; Var ALen: Integer): String; Overload; Static;
    Class Function AsHex(Const Value: String): String; Overload; Static;
    Class Function AsHex(Const Value: TBytes): String; Overload; Static;

    class function UInt32ToLittleEndianByteArrayTwoBytes(AValue: UInt32): TBytes; static;

    Class Function EncryptWithPassword(Const Value, APassword: String): TBytes; Static;
    /// <summary>
    /// raises an exception on fail. EHexException if not a valid hex string
    /// </summary>
    Class Function DecryptWithPassword(Const Value: String; Const APassword: String): String; Overload; Static;
    Class Function DecryptWithPassword(Const Value: String; Const APassword: String; Out Payload: String): boolean;
      Overload; Static;

    /// <param name="APublicKey">
    /// Hex Encoded Key (enc_pubkey)
    /// </param>
    Class Function EncryptWithPublicKey(Const Value: String; Const APublicKey: String; AKeyStyle: TKeyStyle = ksEncKey)
      : TBytes; Static;
{$IFDEF UNITTEST}
    Class Function SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage: String;
      Const ARandomK: String): TECDSA_Signature; Overload; Static;
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
  ClpIAsymmetricCipherKeyPair,
  ClpECKeyPairGenerator,
  ClpIX9ECParametersHolder,
  PascalCoin.RPC.Exceptions,
  PascalCoin.Utils,
  PascalCoin.RPC.Messages
  {$IFDEF UNITTEST}
  , ClpIFixedSecureRandom
  , clpFixedSecureRandom
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
  lVal := Trunc(Value * 10000);
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
  lRandomBytes: TBytes;
  lRandom: ISecureRandom;
  lArray: TCryptoLibMatrixByteArray;
Begin
{$IFDEF UNITTEST}
  if ARandomK = '' then
     lRandom := FRandom
  else
  begin
    lRandomBytes := THex.Decode(ARandomK);
    lArray := TCryptoLibMatrixByteArray.Create(lRandomBytes);
    // TBytes.Create(1, 2));
    lRandom := TFixedSecureRandom.From(lArray);
  end;
{$ELSE}
  lRandom := FRandom;
{$ENDIF UNITTEST}

  Param := TParametersWithRandom.Create(APrivateKey, FRandom);
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

Class Function TKeyUtils.EncryptWithPublicKey(Const Value: String; Const APublicKey: String;
  AKeyStyle: TKeyStyle = ksEncKey): TBytes;
Var
  lKeyType: TKeyType;
  LPascalCoinPublicKey: String;
  AffineXCoord, AffineYCoord, PayloadToEncrypt: TBytes;
  RecreatedPublicKey: IECPublicKeyParameters;
Begin

  If AKeyStyle = TKeyStyle.ksUnknown Then
    AKeyStyle := TPascalCoinUtils.KeyStyle(APublicKey);

  Case AKeyStyle Of
    ksEncKey:
      LPascalCoinPublicKey := APublicKey;
    ksB58Key:
      Begin
        If Not TPascalCoinUtils.IsBase58(APublicKey) Then
          Raise EBase58Exception.Create(APublicKey);
        LPascalCoinPublicKey := THEX.Encode(TBase58.Decode(APublicKey));
      End;
  End;

  PayloadToEncrypt := TConverters.ConvertStringToBytes(Value, TEncoding.UTF8);

  lKeyType := TPascalCoinUtils.KeyType(LPascalCoinPublicKey);

  If Not ExtractAffineXFromPascalCoinPublicKey(LPascalCoinPublicKey, AffineXCoord) Then
    Raise EKeyException.Create('Public', KEY_X_ERROR);

  If Not ExtractAffineYFromPascalCoinPublicKey(LPascalCoinPublicKey, AffineYCoord) Then
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
  AffineXLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, 3, 1)[0]);
  AAffineXBytes := System.Copy(LPascalCoinPublicKeyBytes, 5, AffineXLength);
  Result := System.Length(AAffineXBytes) = AffineXLength;
End;

Class Function TKeyUtils.ExtractAffineYFromPascalCoinPublicKey(Const APascalCoinPublicKey: String;
  Out AAffineYBytes: TBytes): boolean;
Var
  AffineXLength, AffineYLength, Offset: Int32;
  LPascalCoinPublicKeyBytes: TBytes;
Begin
  LPascalCoinPublicKeyBytes := THEX.Decode(APascalCoinPublicKey);
  AffineXLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, 3, 1)[0]);
  Offset := 5 + AffineXLength;
  AffineYLength := Int32(System.Copy(LPascalCoinPublicKeyBytes, Offset, 1)[0]);
  AAffineYBytes := System.Copy(LPascalCoinPublicKeyBytes, Offset + 2, AffineYLength);
  Result := System.Length(AAffineYBytes) = AffineYLength;
End;

Class Function TKeyUtils.GetCurveFromKeyType(AKeyType: TKeyType): IX9ECParameters;
Var
  CurveName: String;
Begin
  CurveName := TRttiEnumerationType.GetName<TKeyType>(AKeyType);
  Result := TCustomNamedCurves.GetByName(CurveName);
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

Class Function TKeyUtils.HashSHA2_256(Const AInput: String): String;
Begin
  Result := THEX.Encode(ComputeSHA2_256_ToBytes(THEX.Decode(AInput)));
End;

Class Function TKeyUtils.RecreatePrivateKeyFromByteArray(AKeyType: TKeyType; Const APrivateKey: TBytes)
  : IECPrivateKeyParameters;
Var
  domain: IECDomainParameters;
  LCurve: IX9ECParameters;
  PrivD: TBigInteger;
Begin
  LCurve := GetCurveFromKeyType(AKeyType);
  domain := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);

  PrivD := TBigInteger.Create(1, APrivateKey);

  Result := TECPrivateKeyParameters.Create('ECDSA', PrivD, domain);
End;

Class Function TKeyUtils.RecreatePublicKeyFromAffineXandAffineYCoord(AKeyType: TKeyType;
  Const AAffineX, AAffineY: TBytes): IECPublicKeyParameters;
Var
  domain: IECDomainParameters;
  LCurve: IX9ECParameters;
  point: IECPoint;
  BigXCoord, BigYCoord: TBigInteger;
Begin
  LCurve := GetCurveFromKeyType(AKeyType);
  domain := TECDomainParameters.Create(LCurve.Curve, LCurve.G, LCurve.N, LCurve.H, LCurve.GetSeed);

  BigXCoord := TBigInteger.Create(1, AAffineX);
  BigYCoord := TBigInteger.Create(1, AAffineY);

  point := LCurve.Curve.CreatePoint(BigXCoord, BigYCoord);

  Result := TECPublicKeyParameters.Create('ECDSA', point, domain);

End;

{$IFDEF UNITTEST}

Class Function TKeyUtils.SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType;
  Const AMessage, ARandomK: String): TECDSA_Signature;
{$ELSE}

Class Function TKeyUtils.SignOperation(Const APrivateKey: String; Const AKeyType: TKeyType; Const AMessage: String)
  : TECDSA_Signature;
{$ENDIF }
Var
  lPrivateKey: TBytes;
  LPrivateKeyBigInteger: TBigInteger;
  PrivateKeyRecreated: IECPrivateKeyParameters;
  LSig: TCryptoLibGenericArray<TBigInteger>;
  LMessage: TBytes;
Begin
  lPrivateKey := THEX.Decode(APrivateKey);

  LMessage := TConverters.ConvertStringToBytes(AMessage, TEncoding.UTF8);
  LPrivateKeyBigInteger := TBigInteger.Create(lPrivateKey);
  PrivateKeyRecreated := RecreatePrivateKeyFromByteArray(AKeyType, lPrivateKey);
  {$IFDEF UNITTEST}
  LSig := DoECDSASign(PrivateKeyRecreated, LMessage, ARandomK);
  {$ELSE}
  LSig := DoECDSASign(PrivateKeyRecreated, LMessage);
  {$ENDIF}
  Result.R := THEX.Encode(LSig[0].ToByteArrayUnsigned());
  Result.S := THEX.Encode(LSig[1].ToByteArrayUnsigned());
  Result.RLen := Length(LSig[0].ToByteArrayUnsigned);
  Result.SLen := Length(LSig[1].ToByteArrayUnsigned);

End;

class function TKeyUtils.UInt32ToLittleEndianByteArrayTwoBytes(AValue: UInt32): TBytes;
begin
Result := System.Copy(TConverters.ReadUInt32AsBytesLE(AValue), 0, 2);
end;

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
