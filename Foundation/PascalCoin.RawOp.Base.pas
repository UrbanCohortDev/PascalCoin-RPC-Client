Unit PascalCoin.RawOp.Base;

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
System.SysUtils,
  PascalCoin.Consts,
  PascalCoin.RawOp.Interfaces,
  PascalCoin.Key.Interfaces;

Type

  TPascalCoinBaseRawOperation = Class(TInterfacedObject, IPascalCoinRawOperation)
  Private
  Protected

    FPrivateKey: String;
    FKeyType: TKeyType;
    FPayload: IPascalCoinPayload;
    FPayloadType: TPayloadType;
    FHexEncode: Boolean;
    FSignature: TECDSA_Signature;
    {$IFDEF UNITTEST}
    FFixedRandomK: String;
    Function GetFixedRandomK: String;
    Procedure SetFixedRandomK(const Value: String);
    function TestValue(const AKey: string): string; virtual;
    {$ENDIF}

    Procedure Clear; virtual;
    Function GetPrivateKey(Const AKeyType: TKeyType): String;
    Procedure SetPrivateKey(Const AKeyType: TKeyType; Const Value: String);
    Function GetPayload: IPascalCoinPayload;
    Procedure SetPayload(Const Value: IPascalCoinPayload);
    Function GetHexEncode: Boolean;
    Procedure SetHexEncode(Const Value: Boolean);
    Function GetPayloadType: TPayloadType;
    Procedure SetPayloadType(Const Value: TPayloadType);

    procedure SignOperation;
    /// <summary>
    ///   Hashes ValueToHash with SHA2-256
    /// </summary>
    Function HashThis: String;
    Function ValueToHash: String; Virtual; Abstract;
    Function GetRawOp: String; Virtual; Abstract;

    Property Payload: IPascalCoinPayload read GetPayload;
  Public
    Constructor Create(APayload: IPascalCoinPayload);
  End;

Const
  NullBytes = '0000';

Implementation

{ TPascalCoinBaseRawOperation }

uses PascalCoin.KeyUtils, PascalCoin.Utils;

procedure TPascalCoinBaseRawOperation.Clear;
begin
  FSignature.Clear;
end;

constructor TPascalCoinBaseRawOperation.Create(APayload: IPascalCoinPayload);
begin
  inherited Create;
  FPayload := APayload;
end;


{$IFDEF UNITTEST}
procedure TPascalCoinBaseRawOperation.SetFixedRandomK(const Value: String);
begin
  FFixedRandomK := Value;
end;

function TPascalCoinBaseRawOperation.GetFixedRandomK: String;
begin
  Result := FFixedRandomK;
end;
{$ENDIF}

function TPascalCoinBaseRawOperation.GetHexEncode: Boolean;
begin
   result := FHexEncode;
end;

function TPascalCoinBaseRawOperation.GetPayload: IPascalCoinPayload;
Begin
  Result := FPayload;
End;

function TPascalCoinBaseRawOperation.GetPayloadType: TPayloadType;
begin
  result := FPayloadType;
end;

Function TPascalCoinBaseRawOperation.GetPrivateKey(Const AKeyType: TKeyType): String;
Begin
  Result := FPrivateKey;
End;

function TPascalCoinBaseRawOperation.HashThis: String;
begin
  Result := TKeyUtils.HashSHA2_256(ValueToHash);
end;

procedure TPascalCoinBaseRawOperation.SetHexEncode(const Value: Boolean);
begin
  FHexEncode := Value;
end;

procedure TPascalCoinBaseRawOperation.SetPayload(Const Value:
    IPascalCoinPayload);
begin
  FPayload := Value;
end;

procedure TPascalCoinBaseRawOperation.SetPayloadType(const Value: TPayloadType);
begin
  FPayloadType := Value;
end;

Procedure TPascalCoinBaseRawOperation.SetPrivateKey(Const AKeyType: TKeyType; Const Value: String);
Begin
  FKeyType := AKeyType;
  FPrivateKey := Value;
End;

Procedure TPascalCoinBaseRawOperation.SignOperation;
begin
  if FSignature.RLen > 0 then
     Exit;
  FSignature := TKeyUtils.SignOperation(FPrivateKey, FKeyType, HashThis{$IFDEF UNITTEST}, FFixedRandomK{$ENDIF});
end;

function TPascalCoinBaseRawOperation.TestValue(const AKey: string): string;
begin

end;

End.
