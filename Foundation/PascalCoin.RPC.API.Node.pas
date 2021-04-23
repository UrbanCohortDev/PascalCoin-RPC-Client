Unit PascalCoin.RPC.API.Node;

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
  System.JSON,
  System.Generics.Collections,
  PascalCoin.Consts,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base,
  PascalCoin.RPC.Exceptions;

Type

  TPascalCoinNodeAPI = Class(TPascalCoinAPIBase, IPascalCoinNodeAPI)
  Protected
    Function NodeStatus: IPascalCoinNodeStatus;
    Function addnode(Const nodes: String): integer;
    Function getconnections: IPascalCoinConnections;
    Function stopnode: boolean;
    Function startnode: boolean;
    Function cleanblacklist: boolean;
    Function node_ip_stats: IPascalNetStats;

  Public
    Constructor Create(AClient: IPascalCoinRPCClient);
  End;

Implementation

{ TPascalCoinNodeAPI }

Uses
  PascalCoin.RPC.Node;

Function TPascalCoinNodeAPI.addnode(Const nodes: String): integer;
Begin
  Raise ENotImplementedInFramework.Create;
End;

Function TPascalCoinNodeAPI.cleanblacklist: boolean;
Begin
  Raise ENotImplementedInFramework.Create;
End;

Constructor TPascalCoinNodeAPI.Create(AClient: IPascalCoinRPCClient);
Begin
  Inherited Create(AClient);
End;

Function TPascalCoinNodeAPI.getconnections: IPascalCoinConnections;
Begin
  Raise ENotImplementedInFramework.Create;
End;

Function TPascalCoinNodeAPI.NodeStatus: IPascalCoinNodeStatus;
Begin
  result := Nil;
  If FClient.RPCCall('nodestatus', []) Then
  Begin
    result := TPascalCoinNodeStatus.FromJsonValue(GetJSONResult);
  End;
End;

Function TPascalCoinNodeAPI.node_ip_stats: IPascalNetStats;
Begin
  Raise ENotImplementedInFramework.Create;
End;

Function TPascalCoinNodeAPI.startnode: boolean;
Begin
  Raise ENotImplementedInFramework.Create;
End;

Function TPascalCoinNodeAPI.stopnode: boolean;
Begin
  Raise ENotImplementedInFramework.Create;
End;

End.
