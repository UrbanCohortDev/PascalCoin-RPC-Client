Unit PascalCoin.Utils;

//************************************************************************//
//                copyright 2019-2020  Russell Weetch                     //
// Distributed under the MIT software license, see the accompanying file  //
//  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.  //
//                                                                        //
//               PascalCoin website http://pascalcoin.org                 //
//                                                                        //
//                 PascalCoin Delphi RPC Client Repository                //
//        https://github.com/UrbanCohortDev/PascalCoin-RPC-Client         //
//                                                                        //
//             PASC Donations welcome: Account (PASA) 1922-23             //
//                                                                        //
//                THIS LICENSE HEADER MUST NOT BE REMOVED.                //
//                                                                        //
//************************************************************************//

Interface

uses PascalCoin.RPC.Interfaces;

Type

  TPascalCoinUtils = Class
  Private
  Public
    Class Function IsHexaString(Const Value: String): Boolean; Static;
    Class Function AccountNumberCheckSum(Const Value: Cardinal): Integer; Static;
    Class Function AccountNumberWithCheckSum(Const Value: Cardinal): String; Static;
    Class Function ValidAccountNumber(Const Value: String): Boolean; Static;
    Class Function AccountNumber(Const Value: String): Cardinal; Static;
    class procedure SplitAccount(Const Value: String; Out AccountNumber: Cardinal;
        Out CheckSum: Integer); static;
    Class Function ValidateAccountName(Const Value: String): Boolean; Static;

    Class Function BlocksToRecovery(Const LatestBlock, LastActiveBlock: Integer): Integer; static;
    Class Function DaysToRecovery(Const LatestBlock, LastActiveBlock: Integer): Double; static;

    Class Function KeyStyle(const AKey: String): TKeyStyle; static;

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

class function TPascalCoinUtils.AccountNumber(const Value: String): Cardinal;
var lCheckSum: Integer;
begin
  SplitAccount(Value, Result, lCheckSum);
end;

Class Function TPascalCoinUtils.AccountNumberCheckSum(Const Value: Cardinal): Integer;
Var
  lVal: Int64;
Begin
  lVal := Value;
  result := ((lVal * 101) MOD 89) + 10;
End;

class function TPascalCoinUtils.AccountNumberWithCheckSum(const Value: Cardinal): String;
begin
  Result := Value.ToString + '-' + AccountNumberCheckSum(Value).ToString;
end;

class function TPascalCoinUtils.BlocksToRecovery(const LatestBlock, LastActiveBlock: Integer): Integer;
begin
  Result := (LastActiveBlock + RECOVERY_WAIT_BLOCKS) - LatestBlock;
end;

class function TPascalCoinUtils.DaysToRecovery(const LatestBlock, LastActiveBlock: Integer): Double;
begin
  Result := BlocksToRecovery(LatestBlock, LastActiveBlock) / BLOCKS_PER_DAY;
end;

Class Function TPascalCoinUtils.IsHexaString(Const Value: String): Boolean;
Var
  i: Integer;
Begin
  if Value.Length mod 2 > 0 then
     Exit(False);

  result := true;
  For i := Low(Value) To High(Value) Do
    If (NOT CharInSet(Value[i], PASCALCOIN_HEXA))Then
    Begin
      Exit(false);
    End;
End;

class function TPascalCoinUtils.KeyStyle(const AKey: String): TKeyStyle;
begin
  if IsHexaString(AKey) then
     Result := TKeyStyle.ksEncKey
  else //if B58Key(AKey)
     Result := TKeyStyle.ksB58Key;
//  else
//     Result := TKeyStyle.ksUnkown
end;

Class Procedure TPascalCoinUtils.SplitAccount(Const Value: String; Out AccountNumber: Cardinal;
  Out CheckSum: Integer);
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
  result := THex.Encode(TConverters.ConvertStringToBytes(Value, TEncoding.ANSI));
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
  result := false;
  lVal := Value.Trim.Split(['-']);
  If length(lVal) = 1 Then
  Begin
    If TryStrToInt64(lVal[0], lAcct) Then
      result := true;
  End
  Else
  Begin
    If TryStrToInt64(lVal[0], lAcct) Then
    Begin
      lChk := AccountNumberCheckSum(lVal[0].Trim.ToInt64);
      result := lChk = lVal[1].Trim.ToInteger;
    End;
  End;
End;

Class Function TPascalCoinUtils.ValidateAccountName(Const Value: String): Boolean;
Var
  i: Integer;
Begin
  result := true;
  If Value = '' Then
    exit;
  If Not CharInSet(Value.Chars[0], PASCALCOIN_ENCODING_START) Then
    exit(false);
  If Value.length < 3 Then
    exit(false);
  If Value.length > 64 Then
    exit(false);
  For i := 0 To Value.length - 1 Do
  Begin
    If Not CharInSet(Value.Chars[i], PASCALCOIN_ENCODING) Then
      exit(false);
  End;
End;

End.
