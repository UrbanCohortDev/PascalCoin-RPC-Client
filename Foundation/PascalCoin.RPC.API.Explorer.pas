Unit PascalCoin.RPC.API.Explorer;

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
    Function GetLastBlocks(const ACount: Integer): IPascalCoinBlocks;
    Function GetBlockRange(const AStart, AEnd: Integer): IPascalCoinBlocks;

    Function getblockoperation(const Ablock, Aopblock: Integer): IPascalCoinOperation;
    Function getblockoperations(Const ABlock: Integer; const AStart: Integer = 0; const Amax: Integer = 100): IPascalCoinOperations;

    Function getpendingscount: Integer;
    Function getpendings(const AStart: Integer = 0; Const AMax: Integer = 100): IPascalCoinOperations;

    Function findoperation(const AOpHash: HexaStr): IPascalCoinOperation;


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
  PascalCoin.Utils, PascalCoin.RPC.Consts, PascalCoin.RPC.Block;

{ TPascalCoinAPI }

constructor TPascalCoinExplorerAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinExplorerAPI.findoperation(const AOpHash: HexaStr): IPascalCoinOperation;
begin
  if FClient.RPCCall('findoperation', [TParamPair.Create('ophash', AOpHash)])  then
     Result := TPascalCoinOperation.FromJSONValue(self.GetJSONResult);
end;

Function TPascalCoinExplorerAPI.GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount;
Begin
  If FClient.RPCCall('getaccount', [TParamPair.Create('account', AAccountNumber)]) Then
  Begin
    result := TJSON.JsonToObject<TPascalCoinAccount>(ResultAsObj);
  End;
End;

function TPascalCoinExplorerAPI.getaccountoperations(Const AAccount: Cardinal; Const
    ADepth: Integer = 100; Const AStart: Integer = 0; Const AMax: Integer =
    100): IPascalCoinOperations;
Var
  lDepth: TParamPair;
Begin
  if ADepth = DEEP_SEARCH then
     lDepth := TParamPair.Create('depth', 'deep')
  else
     lDepth := TParamPair.Create('depth', ADepth);
  If FClient.RPCCall('getaccountoperations', [TParamPair.Create('account', AAccount),
    lDepth, TParamPair.Create('start', AStart), TParamPair.Create('max', AMax)]) Then
  Begin
    result := TPascalCoinOperations.FromJSONValue(ResultAsArray);
  End;
End;

Function TPascalCoinExplorerAPI.getblock(Const BlockNumber: Integer): IPascalCoinBlock;
Begin
  if FClient.RPCCall('getblock', [TParamPair.Create('block', BlockNumber)]) then
     Result := TJSON.JsonToObject<TPascalCoinBlock>(ResultAsObj);
End;

function TPascalCoinExplorerAPI.GetBlockCount: Integer;
begin
  Result := -1;
  if FClient.RPCCall('getblockcount', []) then
     Result := GetJSONResult.AsType<Integer>;
end;


function TPascalCoinExplorerAPI.getblockoperation(const Ablock, Aopblock: Integer): IPascalCoinOperation;
begin
  if FClient.RPCCall('getblockoperation', [TParamPair.Create('block', Ablock), TParamPair.Create('opblock', Aopblock)]) then
     Result := TPascalCoinOperation.FromJSONValue(GetJSONResult);
end;

function TPascalCoinExplorerAPI.getblockoperations(const ABlock, AStart, Amax: Integer): IPascalCoinOperations;
begin
  if FClient.RPCCall('getblockoperations', [TParamPair.Create('block', ABlock), TParamPair.Create('start', AStart), TParamPair.Create('max', Amax)]) then
     Result := TPascalCoinOperations.FromJsonValue(ResultAsArray);
end;

function TPascalCoinExplorerAPI.GetBlockRange(const AStart, AEnd: Integer): IPascalCoinBlocks;
begin
  if FClient.RPCCall('getblocks', [TParamPair.Create('start', AStart), TParamPair.Create('end', AEnd)]) then
     Result := TPascalCoinBlocks.FromJsonValue(ResultAsArray);
end;

function TPascalCoinExplorerAPI.GetLastBlocks(const ACount: Integer): IPascalCoinBlocks;
begin
  if FClient.RPCCall('getblocks', [TParamPair.Create('last', ACount)]) then
     Result := TPascalCoinBlocks.FromJsonValue(ResultAsArray);
end;

function TPascalCoinExplorerAPI.getpendings(const AStart, AMax: Integer): IPascalCoinOperations;
begin
  if FClient.RPCCall('getpendings', [TParamPair.Create('start', AStart), TParamPair.Create('max', AMax)]) then
    Result := TPascalCoinOperations.FromJsonValue(ResultAsArray);
end;

function TPascalCoinExplorerAPI.getpendingscount: Integer;
begin
  Result := 0;
  if FClient.RPCCall('getpendingscount', []) then
     Result := GetJSONResult.AsType<Integer>;
end;

End.
