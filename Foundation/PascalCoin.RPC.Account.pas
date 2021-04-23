Unit PascalCoin.RPC.Account;

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
  System.Generics.Collections,
  System.JSON,
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces;

Type

  TPascalCoinAccount = Class(TInterfacedObject, IPascalCoinAccount)
  Private
    FAccount: Int64;
    Fenc_pubkey: HexStr;
    FBalance: Currency;
    FBalance_s: String;
    FN_Operation: Integer;
    FUpdated_b: Integer;
    FUpdated_b_active_mode: Integer;
    FUpdated_b_passive_Mode: Integer;
    FState: String;
    FLocked_Until_Block: Integer;
    FPrice: Currency;
    FSeller_Account: Integer;
    FPrivate_Sale: Boolean;
    FNew_Enc_PubKey: HexStr;
    FName: String;
    FAccountType: Integer;
    FSeal: String;
    FData: TAccountData;
  Protected
    Function GetAccount: Int64;
    Function GetPubKey: HexStr;
    Function GetBalance: Currency;
    Function GetN_Operation: Integer;
    Function GetUpdated_b: Integer;
    Function GetState: String;
    Function GetLocked_Until_Block: Integer;
    Function GetPrice: Currency;
    Function GetSeller_Account: Integer;
    Function GetPrivate_Sale: Boolean;
    Function GetNew_Enc_PubKey: HexStr;
    Function GetName: String;
    Function GetAccount_Type: Integer;
    Function GetBalance_s: String;
    Function GetUpdated_b_active_mode: Integer;
    Function GetUpdated_b_passive_mode: Integer;
    Function GetSeal: String;
    Function GetData: TAccountData;

    Function SameAs(AAccount: IPascalCoinAccount): Boolean;
    Procedure Assign(AAccount: IPascalCoinAccount);
  Public
  End;

  TPascalCoinAccounts = Class(TInterfacedObject, IPascalCoinAccounts)
  Private
    { Use TList as simpler to add to than a TArray }
    { TODO : Maybe switch to TDictionary }
    FAccounts: TList<IPascalCoinAccount>;
  Protected
    Function GetAccount(Const Index: Integer): IPascalCoinAccount;
    Function FindAccount(Const Value: Integer): IPascalCoinAccount; Overload;
    Function FindAccount(Const Value: String): IPascalCoinAccount; Overload;
    Function FindNamedAccount(Const Value: String): IPascalCoinAccount;
    Function Count: Integer;
    Procedure Clear;
    Function AddAccount(Value: IPascalCoinAccount): Integer;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    class function FromJSONValue(Value: TJSONValue): TPascalCoinAccounts;
  End;

Implementation

Uses
  System.SysUtils,
  REST.Json;

{ TPascalCoinAccount }

Procedure TPascalCoinAccount.Assign(AAccount: IPascalCoinAccount);
Begin
  FAccount := AAccount.Account;
  Fenc_pubkey := AAccount.enc_pubkey;
  FBalance := AAccount.balance;
  FBalance_s := AAccount.balance_s;
  FN_Operation := AAccount.n_operation;
  FUpdated_b := AAccount.updated_b;
  FUpdated_b_active_mode := AAccount.updated_b_active_mode;
  FUpdated_b_passive_Mode := AAccount.updated_b_passive_mode;
  FState := AAccount.state;
  FLocked_Until_Block := AAccount.locked_until_block;
  FPrice := AAccount.price;
  FSeller_Account := AAccount.seller_account;
  FPrivate_Sale := AAccount.private_sale;
  FNew_Enc_PubKey := AAccount.new_enc_pubkey;
  FName := AAccount.name;
  FAccountType := AAccount.account_type;
  FSeal := AAccount.Seal;
  FData := AAccount.Data;
End;

Function TPascalCoinAccount.GetAccount: Int64;
Begin
  result := FAccount;
End;

Function TPascalCoinAccount.GetAccount_Type: Integer;
Begin
  result := FAccountType;
End;

Function TPascalCoinAccount.GetBalance: Currency;
Begin
  result := FBalance;
End;

Function TPascalCoinAccount.GetBalance_s: String;
Begin
  result := FBalance_s;
End;

Function TPascalCoinAccount.GetData: TAccountData;
Begin
  result := FData;
End;

Function TPascalCoinAccount.GetLocked_Until_Block: Integer;
Begin
  result := FLocked_Until_Block;
End;

Function TPascalCoinAccount.GetName: String;
Begin
  result := FName;
End;

Function TPascalCoinAccount.GetNew_Enc_PubKey: String;
Begin
  result := FNew_Enc_PubKey;
End;

Function TPascalCoinAccount.GetN_Operation: Integer;
Begin
  result := FN_Operation;
End;

Function TPascalCoinAccount.GetPrice: Currency;
Begin
  result := FPrice;
End;

Function TPascalCoinAccount.GetPrivate_Sale: Boolean;
Begin
  result := FPrivate_Sale;
End;

Function TPascalCoinAccount.GetPubKey: String;
Begin
  result := Fenc_pubkey;
End;

Function TPascalCoinAccount.GetSeal: String;
Begin
  result := FSeal;
End;

Function TPascalCoinAccount.GetSeller_Account: Integer;
Begin
  result := FSeller_Account;
End;

Function TPascalCoinAccount.GetState: String;
Begin
  result := FState;
End;

Function TPascalCoinAccount.GetUpdated_b: Integer;
Begin
  result := FUpdated_b;
End;

Function TPascalCoinAccount.GetUpdated_b_active_mode: Integer;
Begin
  result := FUpdated_b_active_mode;
End;

Function TPascalCoinAccount.GetUpdated_b_passive_mode: Integer;
Begin
  result := FUpdated_b_passive_Mode;
End;

Function TPascalCoinAccount.SameAs(AAccount: IPascalCoinAccount): Boolean;
Begin
  result := (FAccount = AAccount.Account) And (Fenc_pubkey = AAccount.enc_pubkey) And (FBalance = AAccount.balance) And
    (FN_Operation = AAccount.n_operation) And (FUpdated_b = AAccount.updated_b) And (FState = AAccount.state) And
    (FLocked_Until_Block = AAccount.locked_until_block) And (FPrice = AAccount.price) And
    (FSeller_Account = AAccount.seller_account) And (FPrivate_Sale = AAccount.private_sale) And
    (FNew_Enc_PubKey = AAccount.new_enc_pubkey) And (FName = AAccount.name) And (FAccountType = AAccount.account_type);
End;

{ TPascalCoinAccounts }

Function TPascalCoinAccounts.AddAccount(Value: IPascalCoinAccount): Integer;
Begin
  result := FAccounts.Add(Value);
End;

Procedure TPascalCoinAccounts.Clear;
Begin
  FAccounts.Clear;
End;

Function TPascalCoinAccounts.Count: Integer;
Begin
  result := FAccounts.Count;
End;

Constructor TPascalCoinAccounts.Create;
Begin
  Inherited Create;
  FAccounts := TList<IPascalCoinAccount>.Create;
End;

Destructor TPascalCoinAccounts.Destroy;
Begin
  FAccounts.Free;
  Inherited;
End;

Function TPascalCoinAccounts.FindAccount(Const Value: String): IPascalCoinAccount;
Var
  lPos, lValue: Integer;
Begin
  lPos := Value.IndexOf('-');
  If lPos > -1 Then
    lValue := Value.Substring(0, lPos).ToInteger
  Else
    lValue := Value.ToInteger;

  result := FindAccount(lValue);

End;

Function TPascalCoinAccounts.FindNamedAccount(Const Value: String): IPascalCoinAccount;
Var
  lAccount: IPascalCoinAccount;
Begin
  result := Nil;
  For lAccount In FAccounts Do
    If SameText(lAccount.name, Value) Then
      Exit(lAccount);

End;

class function TPascalCoinAccounts.FromJSONValue(Value: TJSONValue): TPascalCoinAccounts;
var lAccount: TJSONValue;
    lAccounts: TJSONArray;
begin
  Result := TPascalCoinAccounts.Create;
  lAccounts := (Value as TJSONArray);
  For lAccount In lAccounts Do
      result.AddAccount(TJSON.JsonToObject<TPascalCoinAccount>((lAccount As TJSONObject)));
end;

Function TPascalCoinAccounts.FindAccount(Const Value: Integer): IPascalCoinAccount;
Var
  lAccount: IPascalCoinAccount;
Begin
  result := Nil;
  For lAccount In FAccounts Do
    If lAccount.Account = Value Then
      Exit(lAccount);
End;

Function TPascalCoinAccounts.GetAccount(Const Index: Integer): IPascalCoinAccount;
Begin
  result := FAccounts[Index];
End;

End.
