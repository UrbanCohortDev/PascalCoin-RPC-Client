Unit PascalCoin.RawOp.Send;

(* ***********************************************************************
  copyright 2019-2021  Russell Weetch
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
  System.SysUtils,
  PascalCoin.Consts,
  PascalCoin.RawOp.Interfaces,
  PascalCoin.RawOp.Base,
  PascalCoin.Utils,
  PascalCoin.KeyUtils;

Type

  TPascalCoinSendOperation = Class(TPascalCoinBaseRawOperation, IPascalCoinRawSend)
  Strict Private
  Const
    Op_Transaction = 1;
  Private
    FSenderAccount: String;
    FSendFrom: Cardinal;
    FReceiverAccount: String;
    FSendTo: Cardinal;
    FAmount: Currency;
    FFee: Currency;
    FOpNumber: Integer;
  Protected
    Function ValueToHash: String; Override;

    Function GetAmount: Currency;
    Function GetReceiverAccount: String;
    Function GetSenderAccount: String;
    Procedure SetAmount(Const Value: Currency);
    Procedure SetReceiverAccount(Const Value: String);
    Procedure SetSenderAccount(Const Value: String);
    Function GetFee: Currency;
    Procedure SetFee(Const Value: Currency);
    Function GetOpNumber: Integer;
    Procedure SetOpNumber(Const Value: Integer);

{$IFDEF UNITTEST}
    Function TestValue(Const AKey: String): String; Override;
{$ENDIF}
    Function GetRawOp: String; Override;
  Public
  End;

Implementation

Uses
  clpConverters,
  clpEncoders;

{ TPascalCoinSendOperation }

Function TPascalCoinSendOperation.GetAmount: Currency;
Begin
  Result := FAmount;
End;

Function TPascalCoinSendOperation.GetFee: Currency;
Begin
  Result := FFee;
End;

Function TPascalCoinSendOperation.GetOpNumber: Integer;
Begin
  Result := FOpNumber;
End;

Procedure TPascalCoinSendOperation.SetOpNumber(Const Value: Integer);
Begin
  FOpNumber := Value;
End;

Function TPascalCoinSendOperation.GetRawOp: String;
Begin
  SignOperation;

  Result := THEX.Encode(TConverters.ReadUInt32AsBytesLE(Op_Transaction)) +
            TKeyUtils.AsHex(FSendFrom) +
            TKeyUtils.AsHex(FOpNumber) +
            TKeyUtils.AsHex(FSendTo) +
            TKeyUtils.AsHex(FAmount) +
            TKeyUtils.AsHex(FFee) +
            TKeyUtils.IntToTwoByteHex(FPayload.PayloadLength) +
            FPayload.AsHex +
            '000000000000' +
            TKeyUtils.IntToTwoByteHex(FSignature.RLen) +
            FSignature.R +
            TKeyUtils.IntToTwoByteHex(FSignature.SLen) +
            FSignature.S;
End;

Function TPascalCoinSendOperation.GetReceiverAccount: String;
Begin
  Result := FReceiverAccount;
End;

Function TPascalCoinSendOperation.GetSenderAccount: String;
Begin
  Result := FSenderAccount;
End;

Procedure TPascalCoinSendOperation.SetAmount(Const Value: Currency);
Begin
  FAmount := Value;
  Clear;
End;

Procedure TPascalCoinSendOperation.SetFee(Const Value: Currency);
Begin
  FFee := Value;
  Clear;
End;

Procedure TPascalCoinSendOperation.SetReceiverAccount(Const Value: String);
Begin
  TPascalCoinUtils.VaildAccountNum(Value);
  FReceiverAccount := Value;
  FSendTo := TPascalCoinUtils.AccountNumber(FReceiverAccount);
  Clear;
End;

Procedure TPascalCoinSendOperation.SetSenderAccount(Const Value: String);
Begin
  TPascalCoinUtils.VaildAccountNum(Value);
  FSenderAccount := Value;
  FSendFrom := TPascalCoinUtils.AccountNumber(FSenderAccount);
  Clear;
End;

Function TPascalCoinSendOperation.ValueToHash: String;
Const
  OpType = '01';
Begin
  Result := TKeyUtils.AsHex(FSendFrom) + TKeyUtils.AsHex(FOpNumber) + TKeyUtils.AsHex(FSendTo) +
    TKeyUtils.AsHex(FAmount) + TKeyUtils.AsHex(FFee) + Payload.AsHex + NullBytes + OpType;
End;

{$IFDEF UNITTEST}

Function TPascalCoinSendOperation.TestValue(Const AKey: String): String;
Var
  lKey: String;
Begin
  lKey := AKey.ToUpper;

  If lKey.Equals('SENDFROM') Then
    Result := TKeyUtils.AsHex(FSendFrom)
  Else If lKey.Equals('NOP') Then
    Result := TKeyUtils.AsHex(FOpNumber)
  Else If lKey.Equals('SENDTO') Then
    Result := TKeyUtils.AsHex(FSendTo)
  Else If lKey.Equals('AMOUNT') Then
    Result := TKeyUtils.AsHex(FAmount)
  Else If lKey.Equals('FEE') Then
    Result := TKeyUtils.AsHex(FFee)
  Else If lKey.Equals('PAYLOADLEN') Then
    Result := TKeyUtils.IntToTwoByteHex(Payload.PayloadLength)
  Else If lKey.Equals('VALUETOHASH') Then
    Result := ValueToHash
  Else If lKey.Equals('HASH') Then
    Result := HashThis
  Else If lKey.Equals('SIG.R') Then
    Result := FSignature.R
  Else If lKey.Equals('SIG.S') Then
    Result := FSignature.S
  Else If lKey.Equals('SIG.R.LEN') Then
    Result := TKeyUtils.IntToTwoByteHex(FSignature.RLen)
  Else If lKey.Equals('SIG.S.LEN') Then
    Result := TKeyUtils.IntToTwoByteHex(FSignature.SLen)
  Else If lKey.Equals('KEY.HEX') Then
    Result := FPrivateKey
  Else If lKey.Equals('SIGNEDTX') Then
    Result := GetRawOp
  Else If lKey.Equals('KRANDOM') Then
    Result := FFixedRandomK
  Else
    Result := 'N/A';

End;

{$ENDIF}

End.
