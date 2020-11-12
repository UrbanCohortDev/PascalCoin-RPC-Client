unit PascalCoin.RPC.Account;

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

interface

uses System.Generics.Collections, PascalCoin.RPC.Interfaces;

type

  TPascalCoinAccount = Class(TInterfacedObject, IPascalCoinAccount)
  private
    FAccount: Int64;
    Fenc_pubkey: HexaStr;
    FBalance: Currency;
    FBalance_s: String;
    FN_Operation: Integer;
    FUpdated_b: Integer;
    FUpdated_b_active_mode: Integer;
    FUpdated_b_passive_Mode: Integer;
    FState: string;
    FLocked_Until_Block: Integer;
    FPrice: Currency;
    FSeller_Account: Integer;
    FPrivate_Sale: Boolean;
    FNew_Enc_PubKey: HexaStr;
    FName: String;
    FAccountType: Integer;
    FSeal: String;
    FData: TAccountData;
  protected
    function GetAccount: Int64;
    function GetPubKey: HexaStr;
    function GetBalance: Currency;
    function GetN_Operation: Integer;
    function GetUpdated_b: Integer;
    function GetState: String;
    function GetLocked_Until_Block: Integer;
    function GetPrice: Currency;
    function GetSeller_Account: Integer;
    function GetPrivate_Sale: Boolean;
    function GetNew_Enc_PubKey: HexaStr;
    function GetName: String;
    function GetAccount_Type: Integer;
    Function GetBalance_s: String;
    Function GetUpdated_b_active_mode: Integer;
    Function GetUpdated_b_passive_mode: Integer;
    Function GetSeal: String;
    Function GetData: TAccountData;


    function SameAs(AAccount: IPascalCoinAccount): Boolean;
    procedure Assign(AAccount: IPascalCoinAccount);
  public
  End;

  TPascalCoinAccounts = class(TInterfacedObject, IPascalCoinAccounts)
  private
    { Use TList as simpler to add to than a TArray }
    { TODO : Maybe switch to TDictionary }
    FAccounts: TList<IPascalCoinAccount>;
  protected
    function GetAccount(const Index: Integer): IPascalCoinAccount;
    function FindAccount(const Value: Integer): IPascalCoinAccount; overload;
    function FindAccount(const Value: String): IPascalCoinAccount; overload;
    Function FindNamedAccount(Const Value: String): IPascalCoinAccount;
    function Count: Integer;
    procedure Clear;
    function AddAccount(Value: IPascalCoinAccount): Integer;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils;

{ TPascalCoinAccount }

procedure TPascalCoinAccount.Assign(AAccount: IPascalCoinAccount);
begin
  FAccount := AAccount.account;
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
end;

function TPascalCoinAccount.GetAccount: Int64;
begin
  result := FAccount;
end;

function TPascalCoinAccount.GetAccount_Type: Integer;
begin
  result := FAccountType;
end;

function TPascalCoinAccount.GetBalance: Currency;
begin
  result := FBalance;
end;

function TPascalCoinAccount.GetBalance_s: String;
begin
  Result := FBalance_s;
end;

function TPascalCoinAccount.GetData: TAccountData;
begin
  Result := FData;
end;

function TPascalCoinAccount.GetLocked_Until_Block: Integer;
begin
  result := FLocked_Until_Block;
end;

function TPascalCoinAccount.GetName: String;
begin
  result := FName;
end;

function TPascalCoinAccount.GetNew_Enc_PubKey: String;
begin
  result := FNew_Enc_PubKey;
end;

function TPascalCoinAccount.GetN_Operation: Integer;
begin
  result := FN_Operation;
end;

function TPascalCoinAccount.GetPrice: Currency;
begin
  result := FPrice;
end;

function TPascalCoinAccount.GetPrivate_Sale: Boolean;
begin
  result := FPrivate_Sale;
end;

function TPascalCoinAccount.GetPubKey: String;
begin
  result := Fenc_pubkey;
end;

function TPascalCoinAccount.GetSeal: String;
begin
  Result := FSeal;
end;

function TPascalCoinAccount.GetSeller_Account: Integer;
begin
  result := FSeller_Account;
end;

function TPascalCoinAccount.GetState: String;
begin
  result := FState;
end;

function TPascalCoinAccount.GetUpdated_b: Integer;
begin
  result := FUpdated_b;
end;

function TPascalCoinAccount.GetUpdated_b_active_mode: Integer;
begin
  Result := FUpdated_b_active_mode;
end;

function TPascalCoinAccount.GetUpdated_b_passive_mode: Integer;
begin
  Result := FUpdated_b_passive_Mode;
end;

function TPascalCoinAccount.SameAs(AAccount: IPascalCoinAccount): Boolean;
begin
   result := (FAccount = AAccount.account)
    and (Fenc_pubkey = AAccount.enc_pubkey)
    and (FBalance = AAccount.balance)
    and (FN_Operation = AAccount.n_operation)
    and (FUpdated_b = AAccount.updated_b)
    and (FState = AAccount.state)
    and (FLocked_Until_Block = AAccount.locked_until_block)
    and (FPrice = AAccount.price)
    and (FSeller_Account = AAccount.seller_account)
    and (FPrivate_Sale = AAccount.private_sale)
    and (FNew_Enc_PubKey = AAccount.new_enc_pubkey)
    and (FName = AAccount.name)
    and (FAccountType = AAccount.account_type);
end;

{ TPascalCoinAccounts }

function TPascalCoinAccounts.AddAccount(Value: IPascalCoinAccount): Integer;
begin
  result := FAccounts.Add(Value);
end;

procedure TPascalCoinAccounts.Clear;
begin
  FAccounts.Clear;
end;

function TPascalCoinAccounts.Count: Integer;
begin
  result := FAccounts.Count;
end;

constructor TPascalCoinAccounts.Create;
begin
  inherited Create;
  FAccounts := TList<IPascalCoinAccount>.Create;
end;

destructor TPascalCoinAccounts.Destroy;
begin
  FAccounts.Free;
  inherited;
end;

function TPascalCoinAccounts.FindAccount(const Value: String)
  : IPascalCoinAccount;
var
  lPos, lValue: Integer;
begin
  lPos := Value.IndexOf('-');
  if lPos > -1 then
    lValue := Value.Substring(0, lPos).ToInteger
  else
    lValue := Value.ToInteger;

  result := FindAccount(lValue);

end;

function TPascalCoinAccounts.FindNamedAccount(const Value: String): IPascalCoinAccount;
var
  lAccount: IPascalCoinAccount;
begin
  result := nil;
  for lAccount in FAccounts do
    if SameText(lAccount.Name, Value) then
      Exit(lAccount);

end;

function TPascalCoinAccounts.FindAccount(const Value: Integer) : IPascalCoinAccount;
var
  lAccount: IPascalCoinAccount;
begin
  result := nil;
  for lAccount in FAccounts do
    if lAccount.Account = Value then
      Exit(lAccount);
end;

function TPascalCoinAccounts.GetAccount(const Index: Integer)
  : IPascalCoinAccount;
begin
  result := FAccounts[Index];
end;

end.
