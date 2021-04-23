Unit PascalCoin.RPC.Node;

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
  PascalCoin.RPC.Interfaces,
  System.JSON;

Type

  TPascalCoinNetProtocol = Class(TInterfacedObject, IPascalCoinNetProtocol)
  Private
    FVer: Integer;
    FVer_A: Integer;
  Protected
    Function GetVer: Integer;
    Function GetVer_A: Integer;
  Public
    Class Function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetProtocol;
  End;

  TPascalCoinNetStats = Class(TInterfacedObject, IPascalNetStats)
  Private
    FActive: Integer;
    FClients: Integer;
    FServers: Integer;
    FServers_t: Integer;
    FTotal: Integer;
    FTClients: Integer;
    FTServers: Integer;
    FBReceived: Integer;
    FBSend: Integer;
  Protected
    Function GetActive: Integer;
    Function GetClients: Integer;
    Function GetServers: Integer;
    Function GetServers_t: Integer;
    Function GetTotal: Integer;
    Function GetTClients: Integer;
    Function GetTServers: Integer;
    Function GetBReceived: Integer;
    Function GetBSend: Integer;
  Public
    Class Function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetStats;
  End;

  TPascalCoinServer = Class(TInterfacedObject, IPascalCoinServer)
  Private
    FIP: String;
    FPort: Integer;
    FLastCon: Integer;
    FAttempts: Integer;
  Protected
    Function GetIP: String;
    Procedure SetIP(Const Value: String);
    Function GetPort: Integer;
    Procedure SetPort(Const Value: Integer);
    Function GetLastCon: Integer;
    Procedure SetLastCon(Const Value: Integer);
    Function GetAttempts: Integer;
    Procedure SetAttempts(Const Value: Integer);
    Function GetLastConAsDateTime: TDateTime;
    Procedure SetLastConAsDateTime(Const Value: TDateTime);
  Public
    Class Function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinServer;
  End;

  TPascalCoinNodeStatus = Class(TInterfacedObject, IPascalCoinNodeStatus)
  Private
    FReady: Boolean;
    FReady_S: String;
    FStatus_S: String;
    FPort: Integer;
    FLocked: Boolean;
    FTimeStamp: Integer;
    FVersion: String;
    FNetProtocol: TPascalCoinNetProtocol;
    FBlocks: Integer;
    FNetStats: TPascalCoinNetStats;
    FNodeServers: TArray<TPascalCoinServer>;
    FSBH: String;
    FPOW: String;
    FOpenSSL: String;
  Protected
    Function GetReady: Boolean;
    Function GetReady_S: String;
    Function GetStatus_S: String;
    Function GetPort: Integer;
    Function GetLocked: Boolean;
    Function GetTimeStamp: Integer;
    Function GetVersion: String;
    Function GetNetProtocol: IPascalCoinNetProtocol;
    Function GetBlocks: Integer;
    Function GetNetStats: IPascalNetStats;
    Function GetnodeServer(Const Index: Integer): IPascalCoinServer;
    Function NodeServerCount: Integer;

    Function GetSBH: String;
    Function GetPOW: String;
    Function GetOpenSSL: String;

    Function GetTimeStampAsDateTime: TDateTime;
    Function GetIsTestNet: Boolean;

  Public
    Class Function FromJsonValue(AJSONValue: TJSONValue): TPascalCoinNodeStatus;
  End;

Implementation

Uses
  System.DateUtils,
  System.SysUtils,
  Rest.JSON;

{ TPascalCoinNodeStatus }

Class Function TPascalCoinNodeStatus.FromJsonValue(AJSONValue: TJSONValue): TPascalCoinNodeStatus;
Begin
  Result := TJSON.JsonToObject<TPascalCoinNodeStatus>(AJSONValue As TJSONObject);
End;

Function TPascalCoinNodeStatus.GetBlocks: Integer;
Begin
  Result := FBlocks;
End;

Function TPascalCoinNodeStatus.GetIsTestNet: Boolean;
Begin
  Result := FVersion.Contains('TESTNET');
End;

Function TPascalCoinNodeStatus.GetLocked: Boolean;
Begin
  Result := FLocked;
End;

Function TPascalCoinNodeStatus.GetNetProtocol: IPascalCoinNetProtocol;
Begin
  If FNetProtocol = Nil Then
    FNetProtocol := TPascalCoinNetProtocol.Create;
  Result := FNetProtocol;
End;

Function TPascalCoinNodeStatus.GetNetStats: IPascalNetStats;
Begin
  Result := FNetStats;
End;

Function TPascalCoinNodeStatus.GetnodeServer(Const Index: Integer): IPascalCoinServer;
Begin
  Result := FNodeServers[Index] As IPascalCoinServer;
End;

Function TPascalCoinNodeStatus.GetOpenSSL: String;
Begin
  Result := FOpenSSL;
End;

Function TPascalCoinNodeStatus.GetPort: Integer;
Begin
  Result := FPort;
End;

Function TPascalCoinNodeStatus.GetPOW: String;
Begin
  Result := FPOW;
End;

Function TPascalCoinNodeStatus.GetReady: Boolean;
Begin
  Result := FReady;
End;

Function TPascalCoinNodeStatus.GetReady_S: String;
Begin
  Result := FReady_S;
End;

Function TPascalCoinNodeStatus.GetSBH: String;
Begin
  Result := FSBH;
End;

Function TPascalCoinNodeStatus.GetStatus_S: String;
Begin
  Result := FStatus_S;
End;

Function TPascalCoinNodeStatus.GetTimeStamp: Integer;
Begin
  Result := FTimeStamp;
End;

Function TPascalCoinNodeStatus.GetTimeStampAsDateTime: TDateTime;
Begin
  Result := UnixToDateTime(FTimeStamp);
End;

Function TPascalCoinNodeStatus.GetVersion: String;
Begin
  Result := FVersion;
End;

Function TPascalCoinNodeStatus.NodeServerCount: Integer;
Begin
  Result := Length(FNodeServers);
End;

{ TNetProtocol }

Class Function TPascalCoinNetProtocol.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetProtocol;
Begin
  Result := TJSON.JsonToObject<TPascalCoinNetProtocol>(AJsonObject);
End;

Function TPascalCoinNetProtocol.GetVer: Integer;
Begin
  Result := FVer;
End;

Function TPascalCoinNetProtocol.GetVer_A: Integer;
Begin
  Result := FVer_A;
End;

{ TPascalCoinServer }

Class Function TPascalCoinServer.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinServer;
Begin
  Result := TJSON.JsonToObject<TPascalCoinServer>(AJsonObject)
End;

Function TPascalCoinServer.GetAttempts: Integer;
Begin
  Result := FAttempts;
End;

Function TPascalCoinServer.GetIP: String;
Begin
  Result := FIP;
End;

Function TPascalCoinServer.GetLastCon: Integer;
Begin
  Result := FLastCon;
End;

Function TPascalCoinServer.GetLastConAsDateTime: TDateTime;
Begin
  Result := UnixToDateTime(FLastCon);
End;

Function TPascalCoinServer.GetPort: Integer;
Begin
  Result := FPort;
End;

Procedure TPascalCoinServer.SetAttempts(Const Value: Integer);
Begin
  FAttempts := Value;
End;

Procedure TPascalCoinServer.SetIP(Const Value: String);
Begin
  FIP := Value;
End;

Procedure TPascalCoinServer.SetLastCon(Const Value: Integer);
Begin
  FLastCon := Value;
End;

Procedure TPascalCoinServer.SetLastConAsDateTime(Const Value: TDateTime);
Begin
  FLastCon := DateTimeToUnix(Value);
End;

Procedure TPascalCoinServer.SetPort(Const Value: Integer);
Begin
  FPort := Value;
End;

{ TPascalCoinNetStats }

Class Function TPascalCoinNetStats.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetStats;
Begin
  Result := TJSON.JsonToObject<TPascalCoinNetStats>(AJsonObject);
End;

Function TPascalCoinNetStats.GetActive: Integer;
Begin
  Result := FActive;
End;

Function TPascalCoinNetStats.GetBReceived: Integer;
Begin
  Result := FBReceived;
End;

Function TPascalCoinNetStats.GetBSend: Integer;
Begin
  Result := FBSend;
End;

Function TPascalCoinNetStats.GetClients: Integer;
Begin
  Result := FClients;
End;

Function TPascalCoinNetStats.GetServers: Integer;
Begin
  Result := FServers;
End;

Function TPascalCoinNetStats.GetServers_t: Integer;
Begin
  Result := FServers_t;
End;

Function TPascalCoinNetStats.GetTClients: Integer;
Begin
  Result := FTClients;
End;

Function TPascalCoinNetStats.GetTotal: Integer;
Begin
  Result := FTotal;
End;

Function TPascalCoinNetStats.GetTServers: Integer;
Begin
  Result := FTServers;
End;

End.
