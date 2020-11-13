Unit PascalCoin.RPC.API.Explorer;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23

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
