Unit PascalCoin.RPC.API.Wallet;

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
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base,
  PascalCoin.RPC.API.Explorer,
  PascalCoin.RPC.Account;

Type

  TPascalCoinWalletAPI = Class(TPascalCoinExplorerAPI, IPascalCoinWalletAPI)
  Private
  Protected
    Function getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; Const AStartIndex: Integer = 0;
      Const AMaxCount: Integer = 100): IPascalCoinAccounts;

    Function getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): Integer;

    Procedure AddWalletAccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; AAccountList: IPascalCoinAccounts;
      Const AStartIndex: Integer; Const AMaxCount: Integer = 100);

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);
  End;

Implementation

Uses
  Rest.JSON;

{ TPascalCoinExplorerAPI }

Procedure TPascalCoinWalletAPI.AddWalletAccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle;
  AAccountList: IPascalCoinAccounts; Const AStartIndex, AMaxCount: Integer);
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
End;

Constructor TPascalCoinWalletAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create(AClient);
End;

Function TPascalCoinWalletAPI.getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle;
  Const AStartIndex, AMaxCount: Integer): IPascalCoinAccounts;
Begin
  If FClient.RPCCall('getwalletaccounts', [PublicKeyParam(APublicKey, AKeyStyle), TParamPair.Create('start',
    AStartIndex), TParamPair.Create('max', AMaxCount)]) Then
    result := TPascalCoinAccounts.FromJSONValue(GetJSONResult);
End;

Function TPascalCoinWalletAPI.getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): Integer;
Begin
  result := -1;
  If FClient.RPCCall('getwalletaccountscount', PublicKeyParam(APublicKey, AKeyStyle)) Then
    result := GetJSONResult.AsType<Integer>;
End;

End.
