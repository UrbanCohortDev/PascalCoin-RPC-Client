Unit PascalCoin.RPC.API.Explorer;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinExplorerAPI = Class(TPascalCoinAPIBase, IPascalCoinExplorerAPI)
  Private
  Protected
    Function GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount;
    Function getaccountoperations(Const AAccount: Cardinal; Const ADepth: Integer = 100; Const AStart: Integer = 0;
      Const AMax: Integer = 100): IPascalCoinOperations;

    Function FindAccounts(Const AName: String; Const AExact: boolean; Const AType: Integer; Const AStart: Integer;
      Const AMax: Integer; Const AMin_Balance: PascCurrency; AMax_Balance: PascCurrency; Const APubKey: HexaStr;
      Const AKeyStyle: TKeyStyle): IPascalCoinAccounts;
    Function FindAccountByName(Const AName: String): IPascalCoinAccount;
    Function FindAccountsByName(Const AName: String; Const AStart: Integer = 0; Const AMax: Integer = 100)
      : IPascalCoinAccounts;
    Function FindAccountsByKey(Const APubKey: HexaStr; Const AKeyStyle: TKeyStyle = ksEncKey; Const AStart: Integer = 0;
      Const AMax: Integer = 100): IPascalCoinAccounts;

    Function getblock(Const BlockNumber: Integer): IPascalCoinBlock;
    Function GetBlockCount: Integer;
    Function GetLastBlocks(Const ACount: Integer): IPascalCoinBlocks;
    Function GetBlockRange(Const AStart, AEnd: Integer): IPascalCoinBlocks;

    Function getblockoperation(Const Ablock, Aopblock: Integer): IPascalCoinOperation;
    Function getblockoperations(Const Ablock: Integer; Const AStart: Integer = 0; Const AMax: Integer = 100)
      : IPascalCoinOperations;

    Function getpendingscount: Integer;
    Function getpendings(Const AStart: Integer = 0; Const AMax: Integer = 100): IPascalCoinOperations;

    Function findoperation(Const AOpHash: HexaStr): IPascalCoinOperation;

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);
  End;

Implementation

Uses
  System.SysUtils,
  System.DateUtils,
  REST.JSON,
  PascalCoin.RPC.Account,
  PascalCoin.RPC.Node,
  PascalCoin.RPC.Operation,
  PascalCoin.Utils,
  PascalCoin.RPC.Consts,
  PascalCoin.RPC.Block;

{ TPascalCoinAPI }

Constructor TPascalCoinExplorerAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create(AClient);
End;

Function TPascalCoinExplorerAPI.FindAccountByName(Const AName: String): IPascalCoinAccount;
var lAccountList: IPascalCoinAccounts;
Begin
  lAccountList := FindAccounts(AName, True, 0, 0, 100, 0, 0, '', ksUnkown);
  if lAccountList.Count = 0 then
     Result := Nil
  else
     Result := lAccountList[0];
End;

Function TPascalCoinExplorerAPI.FindAccounts(Const AName: String; Const AExact: boolean;
  Const AType, AStart, AMax: Integer; Const AMin_Balance: PascCurrency; AMax_Balance: PascCurrency;
  Const APubKey: HexaStr; Const AKeyStyle: TKeyStyle): IPascalCoinAccounts;
Var
  lParams: TArray<TParamPair>;
  lLastParam: Integer;
  Procedure AddParam(lPair: TParamPair);
  Begin
    Inc(lLastParam);
    lParams[lLastParam] := lPair;
  End;

Begin
  SetLength(lParams, 8);
  lLastParam := -1;
  If AName <> '' Then
  Begin
    AddParam(TParamPair.Create('name', AName));
    if Not AExact then
       AddParam(TParamPair.Create('exact', false));
  End;

  if AType >= 0 then
     AddParam(TParamPair.Create('type', AType));

  if AStart > 0 then
     AddParam(TParamPair.Create('start', AStart));

  if AMax <> 100 then
     AddParam(TParamPair.Create('max', AMax));

  if AMin_Balance > 0 then
      AddParam(TParamPair.Create('min_balance', AMin_Balance));

  if AMax_Balance > 0 then
     AddParam(TParamPair.Create('max_balance', AMax_Balance));

  if APubKey <> '' then
  begin
    case AKeyStyle of
      ksUnkown: AddParam(TParamPair.Create(KEY_STYLE_NAME[TPascalCoinUtils.KeyStyle(APubKey)], APubKey));
      else AddParam(TParamPair.Create(KEY_STYLE_NAME[AKeyStyle], APubKey));
    end;
  end;

  SetLength(lParams, lLastParam + 1);

  If FClient.RPCCall('findaccounts', lParams) Then
     result := TPascalCoinAccounts.FromJSONValue(GetJSONResult);

End;

Function TPascalCoinExplorerAPI.FindAccountsByKey(Const APubKey: HexaStr; Const AKeyStyle: TKeyStyle;
  Const AStart, AMax: Integer): IPascalCoinAccounts;
Begin
  Result := FindAccounts('', True, -1, AStart, AMax, 0, 0, APubKey, AKeyStyle);
End;

Function TPascalCoinExplorerAPI.FindAccountsByName(Const AName: String; Const AStart, AMax: Integer)
  : IPascalCoinAccounts;
Begin
  Result := FindAccounts(AName, False, -1, AStart, AMax, 0, 0, '', ksUnkown);
End;

Function TPascalCoinExplorerAPI.findoperation(Const AOpHash: HexaStr): IPascalCoinOperation;
Begin
  If FClient.RPCCall('findoperation', [TParamPair.Create('ophash', AOpHash)]) Then
    Result := TPascalCoinOperation.FromJSONValue(self.GetJSONResult);
End;

Function TPascalCoinExplorerAPI.GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount;
Begin
  If FClient.RPCCall('getaccount', [TParamPair.Create('account', AAccountNumber)]) Then
  Begin
    Result := TJSON.JsonToObject<TPascalCoinAccount>(ResultAsObj);
  End;
End;

Function TPascalCoinExplorerAPI.getaccountoperations(Const AAccount: Cardinal; Const ADepth: Integer = 100;
  Const AStart: Integer = 0; Const AMax: Integer = 100): IPascalCoinOperations;
Var
  lDepth: TParamPair;
Begin
  If ADepth = DEEP_SEARCH Then
    lDepth := TParamPair.Create('depth', 'deep')
  Else
    lDepth := TParamPair.Create('depth', ADepth);
  If FClient.RPCCall('getaccountoperations', [TParamPair.Create('account', AAccount), lDepth,
    TParamPair.Create('start', AStart), TParamPair.Create('max', AMax)]) Then
  Begin
    Result := TPascalCoinOperations.FromJSONValue(ResultAsArray);
  End;
End;

Function TPascalCoinExplorerAPI.getblock(Const BlockNumber: Integer): IPascalCoinBlock;
Begin
  If FClient.RPCCall('getblock', [TParamPair.Create('block', BlockNumber)]) Then
    Result := TJSON.JsonToObject<TPascalCoinBlock>(ResultAsObj);
End;

Function TPascalCoinExplorerAPI.GetBlockCount: Integer;
Begin
  Result := -1;
  If FClient.RPCCall('getblockcount', []) Then
    Result := GetJSONResult.AsType<Integer>;
End;

Function TPascalCoinExplorerAPI.getblockoperation(Const Ablock, Aopblock: Integer): IPascalCoinOperation;
Begin
  If FClient.RPCCall('getblockoperation', [TParamPair.Create('block', Ablock), TParamPair.Create('opblock',
    Aopblock)]) Then
    Result := TPascalCoinOperation.FromJSONValue(GetJSONResult);
End;

Function TPascalCoinExplorerAPI.getblockoperations(Const Ablock, AStart, AMax: Integer): IPascalCoinOperations;
Begin
  If FClient.RPCCall('getblockoperations', [TParamPair.Create('block', Ablock), TParamPair.Create('start', AStart),
    TParamPair.Create('max', AMax)]) Then
    Result := TPascalCoinOperations.FromJSONValue(ResultAsArray);
End;

Function TPascalCoinExplorerAPI.GetBlockRange(Const AStart, AEnd: Integer): IPascalCoinBlocks;
Begin
  If FClient.RPCCall('getblocks', [TParamPair.Create('start', AStart), TParamPair.Create('end', AEnd)]) Then
    Result := TPascalCoinBlocks.FromJSONValue(ResultAsArray);
End;

Function TPascalCoinExplorerAPI.GetLastBlocks(Const ACount: Integer): IPascalCoinBlocks;
Begin
  If FClient.RPCCall('getblocks', [TParamPair.Create('last', ACount)]) Then
    Result := TPascalCoinBlocks.FromJSONValue(ResultAsArray);
End;

Function TPascalCoinExplorerAPI.getpendings(Const AStart, AMax: Integer): IPascalCoinOperations;
Begin
  If FClient.RPCCall('getpendings', [TParamPair.Create('start', AStart), TParamPair.Create('max', AMax)]) Then
    Result := TPascalCoinOperations.FromJSONValue(ResultAsArray);
End;

Function TPascalCoinExplorerAPI.getpendingscount: Integer;
Begin
  Result := 0;
  If FClient.RPCCall('getpendingscount', []) Then
    Result := GetJSONResult.AsType<Integer>;
End;

End.
