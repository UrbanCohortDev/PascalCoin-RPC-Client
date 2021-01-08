Unit PascalCoin.Utils;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.

  PascalCoin website http://pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https://github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.Exceptions,
  PascalCoin.RPC.Messages;

Type

  TPascalCoinUtils = Class
  Private
  Public
    Class Function IsHex(Const Value: String): Boolean; Static;
    /// <summary>
    /// Raises a EHexaStrException if Value is not a PascalCoin valid hex
    /// encoded string
    /// </summary>
    Class Procedure ValidHex(Const Value: String); Static;
    Class Function IsBase58(Const Value: String): Boolean; Static;
    /// <summary>
    /// Raises a EBase58Exception if Value is not a PascalCoin valid hex
    /// encoded string
    /// </summary>
    Class Procedure ValidBase58(Const Value: String); Static;

    Class Function IsAccountNumberValid(Const Value: String): Boolean; Static;

    /// <summary>
    /// raises an EAccountNumberException if in valid format, or fails the
    /// checksum
    /// </summary>
    Class Procedure VaildAccountNum(Const Value: String); Static;

    Class Function IsValid64Encoded(Const Value: String): Boolean; Static;

    Class Function AccountNumberCheckSum(Const Value: Cardinal): Integer; Static;
    Class Function AccountNumberWithCheckSum(Const Value: Cardinal): String; Static;
    Class Function AccountNumber(Const Value: String): Cardinal; Static;
    Class Procedure SplitAccount(Const Value: String; Out AccountNumber: Cardinal; Out CheckSum: Integer); Static;

    Class Function IsAccountNameValid(Const Value: String; Var RejectReason: String): Boolean; Static;
    Class Function IsValidAccountName(Const Value: String): Boolean; Static;
    Class Procedure ValidAccountName(Const Value: String); Static;

    Class Function BlocksToRecovery(Const LatestBlock, LastActiveBlock: Integer): Integer; Static;
    Class Function DaysToRecovery(Const LatestBlock, LastActiveBlock: Integer): Double; Static;

    Class Function KeyStyle(Const AKey: String): TKeyStyle; Static;
    Class Function KeyType(const AKey: String): TKeyType; static;

    Class Function UnixToLocalDate(Const Value: Integer): TDateTime; Static;
    Class Function StrToHex(Const Value: String): String; Static;
  End;

Implementation

Uses
  System.SysUtils,
  System.DateUtils,
  clpBits,
  clpConverters,
  clpEncoders,
  clpDigestUtilities,
  clpArrayUtils,
  clpIDigest;

{ TPascalCoinTools }

Class Function TPascalCoinUtils.AccountNumber(Const Value: String): Cardinal;
Var
  lCheckSum: Integer;
Begin
  SplitAccount(Value, Result, lCheckSum);
End;

Class Function TPascalCoinUtils.AccountNumberCheckSum(Const Value: Cardinal): Integer;
Var
  lVal: Int64;
Begin
  lVal := Value;
  Result := ((lVal * 101) MOD 89) + 10;
End;

Class Function TPascalCoinUtils.AccountNumberWithCheckSum(Const Value: Cardinal): String;
Begin
  Result := Value.ToString + '-' + AccountNumberCheckSum(Value).ToString;
End;

Class Function TPascalCoinUtils.BlocksToRecovery(Const LatestBlock, LastActiveBlock: Integer): Integer;
Begin
  Result := (LastActiveBlock + RECOVERY_WAIT_BLOCKS) - LatestBlock;
End;

Class Function TPascalCoinUtils.DaysToRecovery(Const LatestBlock, LastActiveBlock: Integer): Double;
Begin
  Result := BlocksToRecovery(LatestBlock, LastActiveBlock) / BLOCKS_PER_DAY;
End;

Class Procedure TPascalCoinUtils.ValidHex(Const Value: String);
Begin
  If Not IsHex(Value) Then
    Raise EHexException.Create(Value);
End;

Class Function TPascalCoinUtils.IsBase58(Const Value: String): Boolean;
Var
  Chopped, DecodedPascalCoinBase58Key, OriginalChecksum, CalculatedChecksum: TBytes;
  DecodedPascalCoinBase58KeyLength: Int32;
Begin
  DecodedPascalCoinBase58Key := TBase58.Decode(Value);
  If DecodedPascalCoinBase58Key = Nil Then
    Exit(False);
  DecodedPascalCoinBase58KeyLength := System.Length(DecodedPascalCoinBase58Key);
  CalculatedChecksum := System.Copy(DecodedPascalCoinBase58Key, DecodedPascalCoinBase58KeyLength - 4,
    DecodedPascalCoinBase58KeyLength - 1);
  Chopped := System.Copy(DecodedPascalCoinBase58Key, 1, DecodedPascalCoinBase58KeyLength - 5);
  OriginalChecksum := System.Copy(TDigestUtilities.CalculateDigest('SHA-256', Chopped), 0, 4);
  Result := TArrayUtils.AreEqual(OriginalChecksum, CalculatedChecksum);
End;

Class Function TPascalCoinUtils.IsHex(Const Value: String): Boolean;
Var
  i: Integer;
Begin
  If Value.Length Mod 2 > 0 Then
    Exit(False);

  Result := true;
  For i := Low(Value) To High(Value) Do
    If (NOT CharInSet(Value[i], PASCALCOIN_HEXA)) Then
    Begin
      Exit(False);
    End;
End;

Class Function TPascalCoinUtils.IsValid64Encoded(Const Value: String): Boolean;
Var
  i: Integer;
Begin
  For i := 0 To Value.Length - 1 Do
  Begin
    If Not CharInSet(Value.Chars[i], PASCALCOIN_ENCODING) Then
      Exit(False);
  End;
  Result := true;
End;

Class Function TPascalCoinUtils.KeyStyle(Const AKey: String): TKeyStyle;
Begin
  If IsHex(AKey) Then
    Result := TKeyStyle.ksEncKey
  Else If IsBase58(AKey) Then
    Result := TKeyStyle.ksB58Key
  Else
    Raise EUnrecognisedKeyStyle.Create(AKey);
End;

class function TPascalCoinUtils.KeyType(const AKey: String): TKeyType;
const
AOFFSET = 0;
var
  ReversedSlice: TBytes;
  lValue: Int32;
  lKey: TBytes;
begin
  lKey := THex.Decode(AKey);

  System.SetLength(ReversedSlice, 2);
  TBits.ReverseByteArray(System.Copy(lKey, AOFFSET, 2), ReversedSlice, Length(ReversedSlice) * System.SizeOf(byte));
  lValue := ('$' + THex.Encode(ReversedSlice)).ToInteger;

  case lValue of
    714:
      Result := TKeyType.SECP256K1;
    715:
      Result := TKeyType.SECP384R1;
    716:
      Result := TKeyType.SECP521R1;
    729:
      Result := TKeyType.SECT283K1
  else
    raise EKeyException.Create('Public', INVALID_KEY_TYPE);
  end;
end;

Class Procedure TPascalCoinUtils.SplitAccount(Const Value: String; Out AccountNumber: Cardinal; Out CheckSum: Integer);
Var
  lVal: TArray<String>;
Begin
  VaildAccountNum(Value);
  If Value.IndexOf('-') > 0 Then
  Begin
    lVal := Value.Trim.Split(['-']);
    AccountNumber := lVal[0].ToInt64;
    CheckSum := lVal[1].ToInteger;
  End
  Else
  Begin
    AccountNumber := Value.ToInt64;
    CheckSum := -1;
  End;
End;

Class Function TPascalCoinUtils.StrToHex(Const Value: String): String;
Begin
  Result := THex.Encode(TConverters.ConvertStringToBytes(Value, TEncoding.ANSI));
End;

Class Function TPascalCoinUtils.UnixToLocalDate(Const Value: Integer): TDateTime;
Begin
  Result := TTimeZone.Local.ToLocalTime(UnixToDateTime(Value));
End;

Class Function TPascalCoinUtils.IsAccountNameValid(Const Value: String; Var RejectReason: String): Boolean;
Begin
  Result := true;
  RejectReason := '';
  If Value = '' Then
    Exit;

  If Not CharInSet(Value.Chars[0], PASCALCOIN_ENCODING_START) Then
  Begin
    RejectReason := NAME_INVALID_START.Replace('$', Value.Chars[0]);
    Exit(False);
  End;

  If Value.Length < 3 Then
  Begin
    RejectReason := NAME_TOO_SHORT;
    Exit(False);
  End;

  If Value.Length > 64 Then
  Begin
    RejectReason := NAME_TOO_LONG;
    Exit(False);
  End;

  If Not IsValid64Encoded(Value) Then
  Begin
    RejectReason := NAME_CONTAINS_INVALID_CHARACTERS;
    Exit(False);
  End;

End;

Class Function TPascalCoinUtils.IsAccountNumberValid(Const Value: String): Boolean;
Var
  lVal: TArray<String>;
  lChk: Integer;
  lAcct: Int64;
Begin
  Result := False;
  lVal := Value.Trim.Split(['-']);
  If Length(lVal) = 1 Then
  Begin
    If TryStrToInt64(lVal[0], lAcct) Then
      Result := true;
  End
  Else
  Begin
    If TryStrToInt64(lVal[0], lAcct) Then
    Begin
      lChk := AccountNumberCheckSum(lVal[0].Trim.ToInt64);
      Result := lChk = lVal[1].Trim.ToInteger;
    End;
  End;
End;

Class Procedure TPascalCoinUtils.VaildAccountNum(Const Value: String);
Begin
  If Not IsAccountNumberValid(Value) Then
    Raise EAccountNumberException.Create(Value);
End;

Class Function TPascalCoinUtils.IsValidAccountName(Const Value: String): Boolean;
Var
  ARejectReason: String;
Begin
  Result := IsAccountNameValid(Value, ARejectReason);
End;

Class Procedure TPascalCoinUtils.ValidAccountName(Const Value: String);
Var
  lRejectReason: String;
Begin
  If Not IsAccountNameValid(Value, lRejectReason) Then
    Raise EAccountNameException.Create(Value, lRejectReason);
End;

Class Procedure TPascalCoinUtils.ValidBase58(Const Value: String);
Begin
  If Not IsBase58(Value) Then
    Raise EBase58Exception.Create(Value);
End;

End.
