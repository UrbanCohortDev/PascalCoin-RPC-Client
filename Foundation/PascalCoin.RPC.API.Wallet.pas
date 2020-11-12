unit PascalCoin.RPC.API.Wallet;

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

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base,
  PascalCoin.RPC.API.Explorer,
  pascalCoin.RPC.Account;

Type

  TPascalCoinWalletAPI = Class(TPascalCoinExplorerAPI, IPascalCoinWalletAPI)
  private
  protected
    Function getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; Const AStartIndex: Integer = 0;
      Const AMaxCount: Integer = 100): IPascalCoinAccounts;


    Function getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): Integer;

    Procedure AddWalletAccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; AAccountList: IPascalCoinAccounts;
      Const AStartIndex: integer; Const AMaxCount: integer = 100);

  Public
  Constructor Create(AClient: IPascalCoinRPCClient);
  End;
implementation

uses Rest.JSON;

{ TPascalCoinExplorerAPI }

procedure TPascalCoinWalletAPI.AddWalletAccounts(const APublicKey: String; const AKeyStyle: TKeyStyle;
  AAccountList: IPascalCoinAccounts; const AStartIndex, AMaxCount: integer);
Var
  lAccounts: TJSONArray;
  lAccount: TJSONValue;
Begin
  If FClient.RPCCall('getwalletaccounts', [PublicKeyParam(APublicKey, AKeyStyle), TParamPair.Create('start',
    AStartIndex), TParamPair.Create('max', AMaxCount)]) Then
  Begin
    lAccounts := (GetJSONResult As TJSONArray);
    For lAccount In lAccounts Do
      AAccountList.AddAccount(TJSON.JsonToObject<TPascalCoinAccount>((lAccount As TJSONObject)));
  End;
end;

constructor TPascalCoinWalletAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinWalletAPI.getwalletaccounts(const APublicKey: String; const AKeyStyle: TKeyStyle;
  const AStartIndex, AMaxCount: Integer): IPascalCoinAccounts;
Var
  lAccounts: TJSONArray;
  lAccount: TJSONValue;
Begin
  If FClient.RPCCall('getwalletaccounts', [PublicKeyParam(APublicKey, AKeyStyle), TParamPair.Create('start',
    AStartIndex), TParamPair.Create('max', AMaxCount)]) Then
  Begin
    result := TPascalCoinAccounts.Create;
    lAccounts := (GetJSONResult As TJSONArray);
    For lAccount In lAccounts Do
      result.AddAccount(TJSON.JsonToObject<TPascalCoinAccount>((lAccount As TJSONObject)));
  End;
end;

function TPascalCoinWalletAPI.getwalletaccountscount(const APublicKey: String; const AKeyStyle: TKeyStyle): Integer;
begin
  Result := -1;
  If FClient.RPCCall('getwalletaccountscount', PublicKeyParam(APublicKey, AKeyStyle)) Then
    result := GetJSONResult.AsType<Integer>;
end;

end.
