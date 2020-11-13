Unit PascalCoin.Utils;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinUtils = Class
  Private
  Public
    Class Function IsHexaString(Const Value: String): Boolean; Static;
    Class Function AccountNumberCheckSum(Const Value: Cardinal): Integer; Static;
    Class Function AccountNumberWithCheckSum(Const Value: Cardinal): String; Static;
    Class Function ValidAccountNumber(Const Value: String): Boolean; Static;
    Class Function AccountNumber(Const Value: String): Cardinal; Static;
    Class Procedure SplitAccount(Const Value: String; Out AccountNumber: Cardinal; Out CheckSum: Integer); Static;
    Class Function ValidateAccountName(Const Value: String): Boolean; Static;

    Class Function BlocksToRecovery(Const LatestBlock, LastActiveBlock: Integer): Integer; Static;
    Class Function DaysToRecovery(Const LatestBlock, LastActiveBlock: Integer): Double; Static;

    Class Function KeyStyle(Const AKey: String): TKeyStyle; Static;

    Class Function UnixToLocalDate(Const Value: Integer): TDateTime; Static;
    Class Function StrToHex(Const Value: String): String; Static;
  End;

Implementation

Uses
  System.SysUtils,
  System.DateUtils,
  clpConverters,
  clpEncoders,
  PascalCoin.RPC.Consts;

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

Class Function TPascalCoinUtils.IsHexaString(Const Value: String): Boolean;
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

Class Function TPascalCoinUtils.KeyStyle(Const AKey: String): TKeyStyle;
Begin
  If IsHexaString(AKey) Then
    Result := TKeyStyle.ksEncKey
  Else // if B58Key(AKey)
    Result := TKeyStyle.ksB58Key;
  // else
  // Result := TKeyStyle.ksUnkown
End;

Class Procedure TPascalCoinUtils.SplitAccount(Const Value: String; Out AccountNumber: Cardinal; Out CheckSum: Integer);
Var
  lVal: TArray<String>;
Begin
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

Class Function TPascalCoinUtils.ValidAccountNumber(Const Value: String): Boolean;
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

Class Function TPascalCoinUtils.ValidateAccountName(Const Value: String): Boolean;
Var
  i: Integer;
Begin
  Result := true;
  If Value = '' Then
    Exit;
  If Not CharInSet(Value.Chars[0], PASCALCOIN_ENCODING_START) Then
    Exit(False);
  If Value.Length < 3 Then
    Exit(False);
  If Value.Length > 64 Then
    Exit(False);
  For i := 0 To Value.Length - 1 Do
  Begin
    If Not CharInSet(Value.Chars[i], PASCALCOIN_ENCODING) Then
      Exit(False);
  End;
End;

End.
