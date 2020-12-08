Unit PascalCoin.RPC.Operation;

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
  System.Generics.Collections,
  System.JSON,
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinSender = Class(TInterfacedObject, IPascalCoinSender)
  Private
    FAccount: Cardinal;
    FN_Operation: Integer;
    FAmount: Currency;
    FAmount_s: String;
    FPayload: HexStr;
    FPayloadType: Integer;
  Protected
    Function GetAccount: Cardinal;
    Function GetN_operation: Integer;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexStr;
    Function GetPayloadType: Integer;
  Public
  End;

  TPascalCoinReceiver = Class(TInterfacedObject, IPascalCoinReceiver)
  Private
    FAccount: Cardinal;
    FAmount: Currency;
    FAmount_s: String;
    FPayload: HexStr;
    FPayloadType: Integer;
  Protected
    Function GetAccount: Cardinal;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexStr;
    Function GetPayloadType: Integer;
  Public
  End;

  TPascalCoinChanger = Class(TInterfacedObject, IPascalCoinChanger)
  Private
    FAccount: Cardinal;
    FN_Operation: Integer;
    FNew_enc_pubkey: HexStr;
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
    FEnc_Pubkey: HexStr;
    FOpHash: HexStr;
    FOld_Ophash: HexStr;
    FSubType: String;
    FSigner_account: Cardinal;
    FN_Operation: Integer;
    FPayload: HexStr;
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
    Function GetEnc_pubkey: HexStr;
    Function GetOphash: HexStr;
    Function GetOld_ophash: HexStr;
    Function GetSubtype: String;
    Function GetSigner_account: Cardinal;
    Function GetN_operation: Integer;
    Function GetPayload: HexStr;

    Function SendersCount: Integer;
    Function ReceiversCount: Integer;
    Function ChangersCount: Integer;

    Function GetSender(Const index: Integer): IPascalCoinSender;
    Function GetReceiver(Const index: Integer): IPascalCoinReceiver;
    Function GetChanger(Const index: Integer): IPascalCoinChanger;

  Public
    Class Function FromJSONValue(Value: TJSONValue): TPascalCoinOperation;
  End;

  TPascalCoinOperations = Class(TInterfacedObject, IPascalCoinOperations)
  Private
    FOperations: TArray<TPascalCoinOperation>;
  Protected
    Function GetOperation(Const index: Integer): IPascalCoinOperation;
    Function Count: Integer;
  Public
    Class Function FromJSONValue(AOps: TJSONArray): TPascalCoinOperations;
  End;

Implementation

{ TPascalCoinOperation }

Uses
  REST.JSON;

Function TPascalCoinOperation.ChangersCount: Integer;
Begin
  Result := Length(FChangers)
End;

Class Function TPascalCoinOperation.FromJSONValue(Value: TJSONValue): TPascalCoinOperation;
Var
  lObj: TJSONObject;
  lArr: TJSONArray;
  I: Integer;
  CD: Cardinal;
  S: String;
  C: Currency;
Begin
  lObj := Value As TJSONObject;
  Result := TPascalCoinOperation.Create;

  If lObj.TryGetValue<String>('valid', S) Then
    Result.FValid := (S <> 'false')
  Else
    Result.FValid := True;

  Result.FBlock := lObj.Values['block'].AsType<UInt64>; // 279915
  Result.FTime := lObj.Values['time'].AsType<Integer>; // 0,
  Result.FOpBlock := lObj.Values['opblock'].AsType<UInt64>; // 1,

  lObj.Values['maturation'].TryGetValue<Integer>(Result.FMaturation); // null,
  Result.FOpType := lObj.Values['optype'].AsType<Integer>; // 1,
  { TODO : should be Int? }
  Result.FSubType := lObj.Values['subtype'].AsType<String>; // 12,
  Result.FAccount := lObj.Values['account'].AsType<Cardinal>; // 865822,
  Result.FSigner_account := lObj.Values['signer_account'].AsType<Cardinal>;
  // 865851,
  Result.FN_Operation := lObj.Values['n_operation'].AsType<Integer>;
  Result.FOpTxt := lObj.Values['optxt'].AsType<String>;
  // "Tx-In 16.0000 PASC from 865851-95 to 865822-14",
  Result.FFee := lObj.Values['fee'].AsType<Currency>; // 0.0000,
  Result.FFee_s := lObj.Values['fee_s'].AsType<String>;
  Result.FAmount := lObj.Values['amount'].AsType<Currency>; // 16.0000,
  Result.FAmount_s := lObj.Values['amount_s'].AsType<String>;
  Result.FPayload := lObj.Values['payload'].AsType<HexStr>;
  // "7A6962626564656520646F6F646168",
  If lObj.TryGetValue<Currency>('balance', C) Then
    Result.FBalance := C; // 19.1528,
  If lObj.TryGetValue<Cardinal>('sender_account', CD) Then
    Result.FSender_Account := CD;
  If lObj.TryGetValue<Cardinal>('dest_account', CD) Then
    Result.FDest_Account := CD;
  // 865822,
  Result.FOpHash := lObj.Values['ophash'].AsType<HexStr>;

  lArr := lObj.Values['senders'] As TJSONArray;
  SetLength(Result.FSenders, lArr.Count);
  For I := 0 To lArr.Count - 1 Do
  Begin
    Result.FSenders[I] := TJSON.JsonToObject<TPascalCoinSender>(lArr[I] As TJSONObject);
  End;

  lArr := lObj.Values['receivers'] As TJSONArray;
  SetLength(Result.FReceivers, lArr.Count);
  For I := 0 To lArr.Count - 1 Do
  Begin
    Result.FReceivers[I] := TJSON.JsonToObject<TPascalCoinReceiver>(lArr[I] As TJSONObject);
  End;

  lArr := lObj.Values['changers'] As TJSONArray;
  SetLength(Result.FChangers, lArr.Count);
  For I := 0 To lArr.Count - 1 Do
  Begin
    Result.FChangers[I] := TJSON.JsonToObject<TPascalCoinChanger>(lArr[I] As TJSONObject);
  End;

End;

Function TPascalCoinOperation.GetAccount: Cardinal;
Begin
  Result := FAccount;
End;

Function TPascalCoinOperation.GetAmount: Currency;
Begin
  Result := FAmount;
End;

Function TPascalCoinOperation.GetAmount_s: String;
Begin
  Result := FAmount_s;
End;

Function TPascalCoinOperation.GetBalance: Currency;
Begin
  Result := FBalance;
End;

Function TPascalCoinOperation.GetBlock: UInt64;
Begin
  Result := FBlock;
End;

Function TPascalCoinOperation.GetChanger(Const index: Integer): IPascalCoinChanger;
Begin
  Result := FChangers[Index] As IPascalCoinChanger;
End;

Function TPascalCoinOperation.GetDest_account: Cardinal;
Begin
  Result := FDest_Account;
End;

Function TPascalCoinOperation.GetEnc_pubkey: HexStr;
Begin
  Result := FEnc_Pubkey;
End;

Function TPascalCoinOperation.GetErrors: String;
Begin
  Result := FErrors;
End;

Function TPascalCoinOperation.GetFee: Currency;
Begin
  Result := FFee;
End;

Function TPascalCoinOperation.GetFee_s: String;
Begin
  Result := FFee_s;
End;

Function TPascalCoinOperation.GetMaturation: Integer;
Begin
  Result := FMaturation;
End;

Function TPascalCoinOperation.GetN_operation: Integer;
Begin
  Result := FN_Operation;
End;

Function TPascalCoinOperation.GetOld_ophash: HexStr;
Begin
  Result := FOld_Ophash;
End;

Function TPascalCoinOperation.GetOpblock: Integer;
Begin
  Result := FOpBlock;
End;

Function TPascalCoinOperation.GetOperationType: TOperationType;
Begin
  Result := TOperationType(FOpType);
End;

Function TPascalCoinOperation.GetOphash: HexStr;
Begin
  Result := FOpHash;
End;

Function TPascalCoinOperation.GetOptxt: String;
Begin
  Result := FOpTxt;
End;

Function TPascalCoinOperation.GetOptype: Integer;
Begin
  Result := FOpType;
End;

Function TPascalCoinOperation.GetPayload: HexStr;
Begin
  Result := FPayload;
End;

Function TPascalCoinOperation.GetReceiver(Const index: Integer): IPascalCoinReceiver;
Begin
  Result := FReceivers[Index] As IPascalCoinReceiver;
End;

Function TPascalCoinOperation.GetSender(Const index: Integer): IPascalCoinSender;
Begin
  Result := FSenders[Index] As IPascalCoinSender;
End;

Function TPascalCoinOperation.GetSender_account: Cardinal;
Begin
  Result := FSender_Account;
End;

Function TPascalCoinOperation.GetSigner_account: Cardinal;
Begin
  Result := FSigner_account;
End;

Function TPascalCoinOperation.GetSubtype: String;
Begin
  Result := FSubType;
End;

Function TPascalCoinOperation.GetTime: Integer;
Begin
  Result := FTime;
End;

Function TPascalCoinOperation.GetValid: Boolean;
Begin
  Result := FValid;
End;

Function TPascalCoinOperation.ReceiversCount: Integer;
Begin
  Result := Length(FReceivers);
End;

Function TPascalCoinOperation.SendersCount: Integer;
Begin
  Result := Length(FSenders);
End;

{ TPascalCoinSender }

Function TPascalCoinSender.GetAccount: Cardinal;
Begin
  Result := FAccount;
End;

Function TPascalCoinSender.GetAmount: Currency;
Begin
  Result := FAmount;
End;

Function TPascalCoinSender.GetAmount_s: String;
Begin
  Result := FAmount_s;
End;

Function TPascalCoinSender.GetN_operation: Integer;
Begin
  Result := FN_Operation;
End;

Function TPascalCoinSender.GetPayload: HexStr;
Begin
  Result := FPayload;
End;

Function TPascalCoinSender.GetPayloadType: Integer;
Begin
  Result := FPayloadType;
End;

{ TPascalCoinReceiver }

Function TPascalCoinReceiver.GetAccount: Cardinal;
Begin
  Result := FAccount;
End;

Function TPascalCoinReceiver.GetAmount: Currency;
Begin
  Result := FAmount;
End;

Function TPascalCoinReceiver.GetAmount_s: String;
Begin
  Result := FAmount_s;
End;

Function TPascalCoinReceiver.GetPayload: HexStr;
Begin
  Result := FPayload;
End;

Function TPascalCoinReceiver.GetPayloadType: Integer;
Begin
  Result := FPayloadType;
End;

{ TPascalCoinChanger }

Function TPascalCoinChanger.GetAccount: Cardinal;
Begin
  Result := FAccount;
End;

Function TPascalCoinChanger.GetAccount_price: Currency;
Begin
  Result := FAccount_price;
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
  Result := FN_Operation;
End;

Function TPascalCoinChanger.GetSeller_account: Cardinal;
Begin
  Result := FSeller_account;
End;

{ TPascalCoinOperations }

Function TPascalCoinOperations.Count: Integer;
Begin
  Result := Length(FOperations);
End;

Class Function TPascalCoinOperations.FromJSONValue(AOps: TJSONArray): TPascalCoinOperations;
Var
  I: Integer;
Begin
  Result := TPascalCoinOperations.Create;

  SetLength(Result.FOperations, AOps.Count);
  For I := 0 To AOps.Count - 1 Do
  Begin
    Result.FOperations[I] := TPascalCoinOperation.FromJSONValue(AOps[I]);
  End;
End;

Function TPascalCoinOperations.GetOperation(Const index: Integer): IPascalCoinOperation;
Begin
  Result := FOperations[Index] As IPascalCoinOperation;
End;

End.
