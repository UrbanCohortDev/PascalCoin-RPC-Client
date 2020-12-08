Unit PascalCoin.Payload;

Interface

Uses
  System.SysUtils,
  PascalCoin.Consts,
  PascalCoin.RawOp.Interfaces;

Type

  TPascalCoinPayload = Class(TInterfacedObject, IPascalCoinPayload)
  Private
    FPayload: String;
    FEncryptionMethod: TPayloadEncryptionMethod;
    FPassword: String;
    FEncryptedBytes: TBytes;
    FLength: Integer;
    FPayloadType: TPayloadType;
    FHexEncode: Boolean;
  Protected
    Function GetPayload: String;
    Function GetEncryptionMethod: TPayloadEncryptionMethod;
    Function GetPassword: String;
    Function GetEncryptedBytes: TBytes;
    Function GetAsHex: String;
    Function GetPayloadLength: Integer;
    Procedure SetEncryptionMethod(Const Value: TPayloadEncryptionMethod);
    Procedure SetPassword(Const Value: String);
    Procedure SetPayload(Const Value: String);
    Function GetHexEncode: Boolean;
    Procedure SetHexEncode(Const Value: Boolean);
    Function GetPayloadType: TPayloadType;
    Procedure SetPayloadType(Const Value: TPayloadType);
    Procedure Clear;
  End;

Implementation

Uses
  PascalCoin.KeyUtils,
  clpConverters;

{ TPascalCoinPayload }

Function TPascalCoinPayload.GetEncryptedBytes: TBytes;
Var
  lPayload: String;
Begin

  If Length(FEncryptedBytes) > 0 Then
    Exit(FEncryptedBytes);

  FLength := 0;
  If FHexEncode Then
    lPayload := TKeyUtils.AsHex(FPayload)
  Else
    lPayload := FPayload;

  Case FEncryptionMethod Of
    peNone:
      FEncryptedBytes := TConverters.ConvertStringToBytes(lPayload, TEncoding.ANSI);
    pePublicKey:
      FEncryptedBytes := TKeyUtils.EncryptWithPublicKey(lPayload, FPassword);
    peAES:
      FEncryptedBytes := TKeyUtils.EncryptWithPassword(lPayload, FPassword);
  End;

  FLength := Length(FEncryptedBytes);
  Result := FEncryptedBytes;
End;

procedure TPascalCoinPayload.Clear;
begin
  SetLength(FEncryptedBytes, 0);
  FLength := 0;
end;

Function TPascalCoinPayload.GetAsHex: String;
Begin

  Result := TKeyUtils.AsHex(GetEncryptedBytes);

End;

Function TPascalCoinPayload.GetPayload: String;
Begin
  Result := FPayload;
End;

function TPascalCoinPayload.GetPayloadLength: Integer;
begin
  Result := Flength;
end;

Function TPascalCoinPayload.GetPayloadType: TPayloadType;
Begin
  Result := FPayloadType;
End;

Function TPascalCoinPayload.GetEncryptionMethod: TPayloadEncryptionMethod;
Begin
  Result := FEncryptionMethod;
End;

Function TPascalCoinPayload.GetHexEncode: Boolean;
Begin
  Result := FHexEncode;
End;

Function TPascalCoinPayload.GetPassword: String;
Begin
  Result := FPassword;
End;

Procedure TPascalCoinPayload.SetPayload(Const Value: String);
Begin
  If FPayload = Value Then
    Exit;
  FPayload := Value;
  SetLength(FEncryptedBytes, 0);
  FLength := 0;
End;

Procedure TPascalCoinPayload.SetPayloadType(Const Value: TPayloadType);
Begin
  If FPayloadType = Value Then
    Exit;
  FPayloadType := Value;
  SetLength(FEncryptedBytes, 0);
  FLength := 0;
End;

Procedure TPascalCoinPayload.SetEncryptionMethod(Const Value: TPayloadEncryptionMethod);
Begin
  If FEncryptionMethod = Value Then
    Exit;
  FEncryptionMethod := Value;
  SetLength(FEncryptedBytes, 0);
  FLength := 0;
End;

Procedure TPascalCoinPayload.SetHexEncode(Const Value: Boolean);
Begin
  If FHexEncode = Value Then
    Exit;
  FHexEncode := Value;
  SetLength(FEncryptedBytes, 0);
End;

Procedure TPascalCoinPayload.SetPassword(Const Value: String);
Begin
  If FPassword = Value Then
    Exit;
  FPassword := Value;
  SetLength(FEncryptedBytes, 0);
End;

End.
