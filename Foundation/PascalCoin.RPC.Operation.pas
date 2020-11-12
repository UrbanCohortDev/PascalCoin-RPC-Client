Unit PascalCoin.RPC.Operation;

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

Uses
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  System.JSON;

Type

  TPascalCoinSender = Class(TInterfacedObject, IPascalCoinSender)
  Private
    FAccount: Cardinal;
    FN_Operation: Integer;
    FAmount: Currency;
    FAmount_s: String;
    FPayload: HexaStr;
    FPayloadType: integer;
  Protected
    Function GetAccount: Cardinal;
    Function GetN_operation: Integer;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexaStr;
    Function GetPayloadType: Integer;
  Public
  End;

  TPascalCoinReceiver = Class(TInterfacedObject, IPascalCoinReceiver)
  Private
    FAccount: Cardinal;
    FAmount: Currency;
    FAmount_s: String;
    FPayload: HexaStr;
    FPayloadType: integer;
  Protected
    Function GetAccount: Cardinal;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexaStr;
    Function GetPayloadType: Integer;
  Public
  End;

  TPascalCoinChanger = Class(TInterfacedObject, IPascalCoinChanger)
  Private
    FAccount: Cardinal;
    FN_Operation: Integer;
    FNew_enc_pubkey: HexaStr;
    FNew_Type: String;
    FSeller_account: Cardinal;
    FAccount_price: Currency;
    FLocked_until_block: UInt64;
    FFee: Currency;
  Protected
    Function GetAccount: Cardinal;
    Function GetN_operation: Integer;
    Function GetNew_enc_pubkey: String;
    Function GetNew_Type: String;
    Function GetSeller_account: Cardinal;
    Function GetAccount_price: Currency;
    Function GetLocked_until_block: UInt64;
    Function GetFee: Currency;
  Public
  End;


TPascalCoinOperation = Class(TInterfacedObject, IPascalCoinOperation)
  Private
    FValid: Boolean;
    FErrors: String;
    FBlock: UInt64;
    FTime: Integer;
    FOpBlock: UInt64;
    FMaturation: Integer;
    FOpType: Integer;
    FOpTxt: String;
    FAccount: Cardinal;
    FAmount: Currency;
    FAmount_s: String;
    FFee: Currency;
    FFee_s: String;
    FBalance: Currency;
    FSender_Account: Cardinal;
    FDest_Account: Cardinal;
    FEnc_Pubkey: HexaStr;
    FOpHash: HexaStr;
    FOld_Ophash: HexaStr;
    FSubType: String;
    FSigner_account: Cardinal;
    FN_Operation: Integer;
    FPayload: HexaStr;
    FSenders: TArray<IPascalCoinSender>;
    FReceivers: TArray<IPascalCoinReceiver>;
    FChangers: TArray<IPascalCoinChanger>;
  Protected
    Function GetValid: Boolean;
    Function GetErrors: String;
    Function GetBlock: UInt64;
    Function GetTime: Integer;
    Function GetOpblock: Integer;
    Function GetMaturation: Integer;
    Function GetOptype: Integer;
    Function GetOperationType: TOperationType;
    Function GetOptxt: String;
    Function GetAccount: Cardinal;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetFee: Currency;
    Function GetFee_s: String;
    Function GetBalance: Currency;
    Function GetSender_account: Cardinal;
    Function GetDest_account: Cardinal;
    Function GetEnc_pubkey: HexaStr;
    Function GetOphash: HexaStr;
    Function GetOld_ophash: HexaStr;
    Function GetSubtype: String;
    Function GetSigner_account: Cardinal;
    Function GetN_operation: Integer;
    Function GetPayload: HexaStr;

    Function SendersCount: Integer;
    Function ReceiversCount: Integer;
    Function ChangersCount: Integer;

    Function GetSender(const index: integer): IPascalCoinSender;
    Function GetReceiver(const index: integer): IPascalCoinReceiver;
    Function GetChanger(const index: integer): IPascalCoinChanger;

  Public
    class function FromJSONValue(Value: TJSONValue): TPascalCoinOperation;
  End;

  TPascalCoinOperations = class(TInterfacedObject, IPascalCoinOperations)
  Private
    FOperations: TArray<TPascalCoinOperation>;
  protected
      Function GetOperation(const index: integer): IPascalCoinOperation;
      Function Count: Integer;
  public
  class function FromJsonValue(AOps: TJSONArray): TPascalCoinOperations;
  end;


Implementation

{ TPascalCoinOperation }

Uses
  REST.JSON;

function TPascalCoinOperation.ChangersCount: Integer;
begin
  Result := Length(FChangers)
end;

class function TPascalCoinOperation.FromJSONValue(Value: TJSONValue): TPascalCoinOperation;
Var
  lObj: TJSONObject;
  lArr: TJSONArray;
  I: Integer;
  CD: Cardinal;
  S: String;
  C: Currency;
Begin
  lObj := Value As TJSONObject;
  result := TPascalCoinOperation.Create;

  If lObj.TryGetValue<String>('valid', S) Then
    result.FValid := (S <> 'false')
  Else
    result.FValid := True;

  result.FBlock := lObj.Values['block'].AsType<UInt64>; // 279915
  result.FTime := lObj.Values['time'].AsType<Integer>; // 0,
  result.FOpBlock := lObj.Values['opblock'].AsType<UInt64>; // 1,

  lObj.Values['maturation'].TryGetValue<Integer>(result.FMaturation); // null,
  result.FOpType := lObj.Values['optype'].AsType<Integer>; // 1,
  { TODO : should be Int? }
  result.FSubType := lObj.Values['subtype'].AsType<String>; // 12,
  result.FAccount := lObj.Values['account'].AsType<Cardinal>; // 865822,
  result.FSigner_account := lObj.Values['signer_account'].AsType<Cardinal>;
  // 865851,
  result.FN_Operation := lObj.Values['n_operation'].AsType<Integer>;
  result.FOpTxt := lObj.Values['optxt'].AsType<String>;
  // "Tx-In 16.0000 PASC from 865851-95 to 865822-14",
  result.FFee := lObj.Values['fee'].AsType<Currency>; // 0.0000,
  result.FFee_s := lObj.Values['fee_s'].AsType<String>;
  result.FAmount := lObj.Values['amount'].AsType<Currency>; // 16.0000,
  result.FAmount_s := lObj.Values['amount_s'].AsType<String>;
  result.FPayload := lObj.Values['payload'].AsType<HexaStr>;
  // "7A6962626564656520646F6F646168",
  if lObj.TryGetValue<Currency>('balance', C) then
     result.FBalance := C; // 19.1528,
  if lObj.TryGetValue<Cardinal>('sender_account', CD) then
     result.FSender_Account := CD;
  if lObj.TryGetValue<Cardinal>('dest_account', CD) then
     result.FDest_Account := CD;
  // 865822,
  result.FOpHash := lObj.Values['ophash'].AsType<HexaStr>;

  lArr := lObj.Values['senders'] As TJSONArray;
  SetLength(result.FSenders, lArr.Count);
  For I := 0 to lArr.Count - 1 Do
  Begin
    result.FSenders[I] := TJSON.JsonToObject<TPascalCoinSender>(lArr[I] As TJSONObject);
  End;

  lArr := lObj.Values['receivers'] As TJSONArray;
  SetLength(result.FReceivers, lArr.Count);
  For I := 0 to lArr.Count -1 Do
  Begin
    result.FReceivers[I] := TJSON.JsonToObject<TPascalCoinReceiver>(lArr[I] As TJSONObject);
  End;

  lArr := lObj.Values['changers'] As TJSONArray;
  SetLength(result.FChangers, lArr.Count);
  For I := 0 to lArr.Count - 1 do
  Begin
    result.FChangers[I] := TJSON.JsonToObject<TPascalCoinChanger>(lArr[I] As TJSONObject);
  End;

end;

Function TPascalCoinOperation.GetAccount: Cardinal;
Begin
  result := FAccount;
End;

Function TPascalCoinOperation.GetAmount: Currency;
Begin
  result := FAmount;
End;

function TPascalCoinOperation.GetAmount_s: String;
begin
  Result := FAmount_s;
end;

Function TPascalCoinOperation.GetBalance: Currency;
Begin
  result := FBalance;
End;

Function TPascalCoinOperation.GetBlock: UInt64;
Begin
  result := FBlock;
End;

function TPascalCoinOperation.GetChanger(const index: integer): IPascalCoinChanger;
begin
  Result := FChangers[index] as IPascalCoinChanger;
end;

Function TPascalCoinOperation.GetDest_account: Cardinal;
Begin
  result := FDest_Account;
End;

Function TPascalCoinOperation.GetEnc_pubkey: HexaStr;
Begin
  result := FEnc_Pubkey;
End;

Function TPascalCoinOperation.GetErrors: String;
Begin
  result := FErrors;
End;

Function TPascalCoinOperation.GetFee: Currency;
Begin
  result := FFee;
End;

function TPascalCoinOperation.GetFee_s: String;
begin
 Result := FFee_s;
end;

Function TPascalCoinOperation.GetMaturation: Integer;
Begin
  result := FMaturation;
End;

Function TPascalCoinOperation.GetN_operation: Integer;
Begin
  result := FN_Operation;
End;

Function TPascalCoinOperation.GetOld_ophash: HexaStr;
Begin
  result := FOld_Ophash;
End;

Function TPascalCoinOperation.GetOpblock: Integer;
Begin
  result := FOpBlock;
End;

Function TPascalCoinOperation.GetOperationType: TOperationType;
Begin
  result := TOperationType(FOpType);
End;

Function TPascalCoinOperation.GetOphash: HexaStr;
Begin
  result := FOpHash;
End;

Function TPascalCoinOperation.GetOptxt: String;
Begin
  result := FOpTxt;
End;

Function TPascalCoinOperation.GetOptype: Integer;
Begin
  result := FOpType;
End;

Function TPascalCoinOperation.GetPayload: HexaStr;
Begin
  result := FPayload;
End;

function TPascalCoinOperation.GetReceiver(const index: integer): IPascalCoinReceiver;
begin
  Result := FReceivers[index] as IPascalCoinReceiver;
end;

function TPascalCoinOperation.GetSender(const index: integer): IPascalCoinSender;
begin
  Result := FSenders[index] as IPascalCoinSender;
end;

Function TPascalCoinOperation.GetSender_account: Cardinal;
Begin
  result := FSender_Account;
End;

Function TPascalCoinOperation.GetSigner_account: Cardinal;
Begin
  result := FSigner_account;
End;

Function TPascalCoinOperation.GetSubtype: String;
Begin
  result := FSubType;
End;

Function TPascalCoinOperation.GetTime: Integer;
Begin
  result := FTime;
End;

Function TPascalCoinOperation.GetValid: Boolean;
Begin
  result := FValid;
End;

function TPascalCoinOperation.ReceiversCount: Integer;
begin
  Result := Length(FReceivers);
end;

function TPascalCoinOperation.SendersCount: Integer;
begin
  Result := Length(FSenders);
end;

{ TPascalCoinSender }

Function TPascalCoinSender.GetAccount: Cardinal;
Begin
  result := FAccount;
End;

Function TPascalCoinSender.GetAmount: Currency;
Begin
  result := FAmount;
End;

function TPascalCoinSender.GetAmount_s: String;
begin
  result := FAmount_s;
end;

Function TPascalCoinSender.GetN_operation: Integer;
Begin
  Result := FN_Operation;
End;

Function TPascalCoinSender.GetPayload: HexaStr;
Begin
  Result := FPayload;
End;

function TPascalCoinSender.GetPayloadType: Integer;
begin
  Result := FPayloadType;
end;

{ TPascalCoinReceiver }

Function TPascalCoinReceiver.GetAccount: Cardinal;
Begin
  Result := FAccount;
End;

Function TPascalCoinReceiver.GetAmount: Currency;
Begin
  Result := FAmount;
End;

function TPascalCoinReceiver.GetAmount_s: String;
begin
  Result := FAmount_s;
end;

Function TPascalCoinReceiver.GetPayload: HexaStr;
Begin
  Result := FPayload;
End;

function TPascalCoinReceiver.GetPayloadType: Integer;
begin
  Result := FPayloadType;
end;

{ TPascalCoinChanger }

Function TPascalCoinChanger.GetAccount: Cardinal;
Begin
 Result := FAccount;
End;

Function TPascalCoinChanger.GetAccount_price: Currency;
Begin
  Result := FAccount_Price;
End;

Function TPascalCoinChanger.GetFee: Currency;
Begin
  Result := FFee;
End;

Function TPascalCoinChanger.GetLocked_until_block: UInt64;
Begin
  Result := FLocked_until_block;
End;

Function TPascalCoinChanger.GetNew_enc_pubkey: String;
Begin
  Result := FNew_enc_pubkey;
End;

Function TPascalCoinChanger.GetNew_Type: String;
Begin
  Result := FNew_Type;
End;

Function TPascalCoinChanger.GetN_operation: Integer;
Begin
  Result := FN_operation;
End;

Function TPascalCoinChanger.GetSeller_account: Cardinal;
Begin
  Result := FSeller_account;
End;

{ TPascalCoinOperations }

function TPascalCoinOperations.Count: Integer;
begin
  Result := Length(FOperations);
end;

class function TPascalCoinOperations.FromJsonValue(AOps: TJSONArray): TPascalCoinOperations;
var
  I: Integer;
begin
  Result := TPascalCoinOperations.Create;

  SetLength(Result.FOperations, AOps.Count);
  for I := 0 to AOps.Count - 1 do
    begin
      Result.FOperations[I] := TPascalCoinOperation.FromJSONValue(AOps[I]);
    end;
end;

function TPascalCoinOperations.GetOperation(const index: integer): IPascalCoinOperation;
begin
  Result := FOperations[index] as IPascalCoinOperation;
end;

End.
