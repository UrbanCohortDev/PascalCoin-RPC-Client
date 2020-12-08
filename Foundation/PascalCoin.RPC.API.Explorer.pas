Unit PascalCoin.RPC.API.Explorer;

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
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinExplorerAPI = Class(TPascalCoinAPIBase, IPascalCoinExplorerAPI)
  Private
  Protected
    Function GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount; overload;
    Function GetAccount(Const AAccountNumber: String): IPascalCoinAccount; overload;
    Function getaccountoperations(Const AAccount: Cardinal; Const ADepth: Integer = 100; Const AStart: Integer = 0;
      Const AMax: Integer = 100): IPascalCoinOperations;

    function FindAccounts(Const AName: String; Const ASearchType: TSearchType;
        Const AType: Integer; Const AStart: Integer; Const AMax: Integer; Const
        AMin_Balance: Currency; AMax_Balance: Currency; Const APubKey:
        String; Const AKeyStyle: TKeyStyle; Const AAccountStatus:
        TAccountStatusType = astAll): IPascalCoinAccounts;
    Function FindAccountByName(Const AName: String): IPascalCoinAccount;
    Function FindAccountsByName(Const AName: String; Const ASearchType: TSearchType = stContains; Const AStart: Integer = 0; Const AMax: Integer = 100)
      : IPascalCoinAccounts;
    function FindAccountsByKey(Const APubKey: String; Const AKeyStyle: TKeyStyle;
        Const AStart, AMax: Integer): IPascalCoinAccounts;

    Function getblock(Const BlockNumber: Integer): IPascalCoinBlock;
    Function GetBlockCount: Integer;
    Function GetLastBlocks(Const ACount: Integer): IPascalCoinBlocks;
    Function GetBlockRange(Const AStart, AEnd: Integer): IPascalCoinBlocks;
    function FindBlocks(const APayload: String; const ASearchType: TSearchType;
        const APubKey: String; Const AKeyStyle: TKeyStyle; const AStart: Integer =
        0; Const AEnd: Integer = -1; Const AMax: Integer = 100): IPascalCoinBlocks;


    Function getblockoperation(Const Ablock, Aopblock: Integer): IPascalCoinOperation;
    Function getblockoperations(Const Ablock: Integer; Const AStart: Integer = 0; Const AMax: Integer = 100)
      : IPascalCoinOperations;

    Function getpendingscount: Integer;
    Function getpendings(Const AStart: Integer = 0; Const AMax: Integer = 100): IPascalCoinOperations;

    Function findoperation(Const AOpHash: HexStr): IPascalCoinOperation;

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);
  End;

Implementation

Uses
  System.SysUtils,
  System.Rtti,
  System.DateUtils,
  REST.JSON,
  PascalCoin.RPC.Account,
  PascalCoin.RPC.Node,
  PascalCoin.RPC.Operation,
  PascalCoin.Utils,
  PascalCoin.RPC.Block;

{ TPascalCoinAPI }

Constructor TPascalCoinExplorerAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create(AClient);
End;

Function TPascalCoinExplorerAPI.FindAccountByName(Const AName: String): IPascalCoinAccount;
var lAccountList: IPascalCoinAccounts;
Begin
  lAccountList := FindAccounts(AName, stExact, 0, 0, 100, 0, 0, '', ksUnknown);
  if lAccountList.Count = 0 then
     Result := Nil
  else
     Result := lAccountList[0];
End;

function TPascalCoinExplorerAPI.FindAccounts(Const AName: String; Const
    ASearchType: TSearchType; Const AType: Integer; Const AStart: Integer;
    Const AMax: Integer; Const AMin_Balance: Currency; AMax_Balance: Currency;
    Const APubKey: String; Const AKeyStyle: TKeyStyle; Const AAccountStatus:
    TAccountStatusType = astAll): IPascalCoinAccounts;
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
    if (ASearchType <> stExact) then
       AddParam(TParamPair.Create('namesearchtype', SEARCH_TYPE[ASearchType]));
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

  if AAccountStatus <> astAll then
     AddParam(TParamPair.Create('statustype', ACCOUNT_STATUS_TYPE[AAccountStatus]));

  if APubKey <> '' then
     AddParam(PublicKeyParam(APubKey, AKeyStyle));

  SetLength(lParams, lLastParam + 1);

  If FClient.RPCCall('findaccounts', lParams) Then
     result := TPascalCoinAccounts.FromJSONValue(GetJSONResult);

End;

Function TPascalCoinExplorerAPI.FindAccountsByKey(Const APubKey: String; Const AKeyStyle: TKeyStyle;
  Const AStart, AMax: Integer): IPascalCoinAccounts;
Begin
  TPascalCoinUtils.ValidHex(APubKey);
  Result := FindAccounts('', stExact, -1, AStart, AMax, 0, 0, APubKey, AKeyStyle);
End;

function TPascalCoinExplorerAPI.FindAccountsByName(Const AName: String; Const
    ASearchType: TSearchType = stContains; Const AStart: Integer = 0; Const
    AMax: Integer = 100): IPascalCoinAccounts;
Begin
  Result := FindAccounts(AName, ASearchType, -1, AStart, AMax, 0, 0, '', ksUnknown);
End;

function TPascalCoinExplorerAPI.FindBlocks(const APayload: String; const
    ASearchType: TSearchType; const APubKey: String; Const AKeyStyle:
    TKeyStyle; const AStart: Integer = 0; Const AEnd: Integer = -1; Const AMax:
    Integer = 100): IPascalCoinBlocks;
var
  lParams: TArray<TParamPair>;
  lLastParam: Integer;
  Procedure AddParam(lPair: TParamPair);
  Begin
    Inc(lLastParam);
    lParams[lLastParam] := lPair;
  End;

Begin
  SetLength(lParams, 6);
  lLastParam := -1;
  if APayload <> '' then
  begin
    AddParam(TParamPair.Create('payload', APayload));
    AddParam(TParamPair.Create('payloadsearchtype', SEARCH_TYPE[ASearchType]));
  end;

  AddParam(TParamPair.Create('start', AStart));
  AddParam(TParamPair.Create('end', AEnd));
  AddParam(TParamPair.Create('max', AMax));

  if APubKey <> '' then
     AddParam(PublicKeyParam(APubKey, AKeyStyle));

  SetLength(lParams, lLastParam + 1);

  If FClient.RPCCall('findblocks', lParams) Then
     Result := TPascalCoinBlocks.FromJSONValue(ResultAsArray);
end;

Function TPascalCoinExplorerAPI.findoperation(Const AOpHash: HexStr): IPascalCoinOperation;
Begin
  TPascalCoinUtils.ValidHex(AOpHash);
  If FClient.RPCCall('findoperation', [TParamPair.Create('ophash', AOpHash)]) Then
    Result := TPascalCoinOperation.FromJSONValue(self.GetJSONResult);
End;

function TPascalCoinExplorerAPI.GetAccount(const AAccountNumber: String): IPascalCoinAccount;
begin
  Result := GetAccount(TPascalCoinUtils.AccountNumber(AAccountNumber));
end;

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
