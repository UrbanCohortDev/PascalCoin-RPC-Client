unit PascalCoin.RPC.Node;

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

uses System.Generics.Collections,
  PascalCoin.RPC.Interfaces, System.JSON;

type

  TPascalCoinNetProtocol = class(TInterfacedObject, IPascalCoinNetProtocol)
  private
    FVer: Integer;
    FVer_A: Integer;
  protected
    function GetVer: Integer;
    function GetVer_A: Integer;
  public
   class function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetProtocol;
  end;

  TPascalCoinNetStats = class(TInterfacedObject, IPascalNetStats)
  private
    FActive: Integer;
    FClients: Integer;
    FServers: Integer;
    FServers_t: Integer;
    FTotal: Integer;
    FTClients: Integer;
    FTServers: Integer;
    FBReceived: Integer;
    FBSend: Integer;
  protected
    function GetActive: Integer;
    function GetClients: Integer;
    function GetServers: Integer;
    function GetServers_t: Integer;
    function GetTotal: Integer;
    function GetTClients: Integer;
    function GetTServers: Integer;
    function GetBReceived: Integer;
    function GetBSend: Integer;
  public
    class function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetStats;
  end;

  TPascalCoinServer = class(TInterfacedObject, IPascalCoinServer)
  private
    FIP: String;
    FPort: Integer;
    FLastCon: Integer;
    FAttempts: Integer;
  protected
    function GetIP: String;
    procedure SetIP(const Value: String);
    function GetPort: Integer;
    procedure SetPort(const Value: Integer);
    function GetLastCon: Integer;
    procedure SetLastCon(const Value: Integer);
    function GetAttempts: Integer;
    procedure SetAttempts(const Value: Integer);
    function GetLastConAsDateTime: TDateTime;
    procedure SetLastConAsDateTime(const Value: TDateTime);
  public
  class function FromJsonObject(AJsonObject: TJSONObject): TPascalCoinServer;
  end;


  TPascalCoinNodeStatus = class(TInterfacedObject, IPascalCoinNodeStatus)
  private
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
  protected
    function GetReady: Boolean;
    function GetReady_S: String;
    function GetStatus_S: String;
    function GetPort: Integer;
    function GetLocked: Boolean;
    function GetTimeStamp: Integer;
    function GetVersion: String;
    function GetNetProtocol: IPascalCoinNetProtocol;
    function GetBlocks: Integer;
    function GetNetStats: IPascalNetStats;
    Function GetnodeServer(const Index: Integer): IPascalCoinServer;
    Function NodeServerCount: Integer;

    function GetSBH: String;
    function GetPOW: String;
    function GetOpenSSL: String;

    function GetTimeStampAsDateTime: TDateTime;
    function GetIsTestNet: Boolean;

  public
    class function FromJsonValue(AJSONValue: TJSONValue): TPascalCoinNodeStatus;
  end;


implementation

uses System.DateUtils, System.SysUtils, Rest.JSON;

{ TPascalCoinNodeStatus }

class function TPascalCoinNodeStatus.FromJsonValue(AJSONValue: TJSONValue): TPascalCoinNodeStatus;
begin
  Result := TJSON.JsonToObject<TPascalCoinNodeStatus>(AJSONValue as TJSONObject);
end;

function TPascalCoinNodeStatus.GetBlocks: Integer;
begin
  result := FBlocks;
end;

function TPascalCoinNodeStatus.GetIsTestNet: Boolean;
begin
  Result := Fversion.Contains('TESTNET');
end;

function TPascalCoinNodeStatus.GetLocked: Boolean;
begin
  result := FLocked;
end;

function TPascalCoinNodeStatus.GetNetProtocol: IPascalCoinNetProtocol;
begin
  if FNetProtocol = nil then
    FNetProtocol := TPascalCoinNetProtocol.Create;
  result := FNetProtocol;
end;

function TPascalCoinNodeStatus.GetNetStats: IPascalNetStats;
begin
  result := FNetStats;
end;

function TPascalCoinNodeStatus.GetnodeServer(const Index: Integer): IPascalCoinServer;
begin
  Result := FNodeServers[Index] as IPascalCoinServer;
end;

function TPascalCoinNodeStatus.GetOpenSSL: String;
begin
  result := FOpenSSL;
end;

function TPascalCoinNodeStatus.GetPort: Integer;
begin
  result := FPort;
end;

function TPascalCoinNodeStatus.GetPOW: String;
begin
  result := FPOW;
end;

function TPascalCoinNodeStatus.GetReady: Boolean;
begin
  result := FReady;
end;

function TPascalCoinNodeStatus.GetReady_S: String;
begin
  result := FReady_S;
end;

function TPascalCoinNodeStatus.GetSBH: String;
begin
  result := FSBH;
end;

function TPascalCoinNodeStatus.GetStatus_S: String;
begin
  result := FStatus_S;
end;

function TPascalCoinNodeStatus.GetTimeStamp: Integer;
begin
  result := FTimeStamp;
end;

function TPascalCoinNodeStatus.GetTimeStampAsDateTime: TDateTime;
begin
  result := UnixToDateTime(FTimeStamp);
end;

function TPascalCoinNodeStatus.GetVersion: String;
begin
  result := FVersion;
end;

function TPascalCoinNodeStatus.NodeServerCount: Integer;
begin
  Result := Length(FNodeServers);
end;

{ TNetProtocol }

class function TPascalCoinNetProtocol.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetProtocol;
begin
  Result := TJSON.JsonToObject<TPascalCoinNetProtocol>(AJsonObject);
end;

function TPascalCoinNetProtocol.GetVer: Integer;
begin
  result := FVer;
end;

function TPascalCoinNetProtocol.GetVer_A: Integer;
begin
  result := FVer_A;
end;

{ TPascalCoinServer }

class function TPascalCoinServer.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinServer;
begin
  result := TJson.JsonToObject<TPascalCoinServer>(AJsonObject)
end;

function TPascalCoinServer.GetAttempts: Integer;
begin
  result := FAttempts;
end;

function TPascalCoinServer.GetIP: String;
begin
  result := FIP;
end;

function TPascalCoinServer.GetLastCon: Integer;
begin
  result := FLastCon;
end;

function TPascalCoinServer.GetLastConAsDateTime: TDateTime;
begin
  result := UnixToDateTime(FLastCon);
end;

function TPascalCoinServer.GetPort: Integer;
begin
  result := FPort;
end;

procedure TPascalCoinServer.SetAttempts(const Value: Integer);
begin
  FAttempts := Value;
end;

procedure TPascalCoinServer.SetIP(const Value: String);
begin
  FIP := Value;
end;

procedure TPascalCoinServer.SetLastCon(const Value: Integer);
begin
  FLastCon := Value;
end;

procedure TPascalCoinServer.SetLastConAsDateTime(const Value: TDateTime);
begin
  FLastCon := DateTimeToUnix(Value);
end;

procedure TPascalCoinServer.SetPort(const Value: Integer);
begin
  FPort := Value;
end;

{ TPascalCoinNetStats }

class function TPascalCoinNetStats.FromJsonObject(AJsonObject: TJSONObject): TPascalCoinNetStats;
begin
 result := TJson.JsonToObject<TPascalCoinNetStats>(AJsonObject);
end;

function TPascalCoinNetStats.GetActive: Integer;
begin
  result := FActive;
end;

function TPascalCoinNetStats.GetBReceived: Integer;
begin
  result := FBReceived;
end;

function TPascalCoinNetStats.GetBSend: Integer;
begin
  result := FBSend;
end;

function TPascalCoinNetStats.GetClients: Integer;
begin
  result := FClients;
end;

function TPascalCoinNetStats.GetServers: Integer;
begin
  result := FServers;
end;

function TPascalCoinNetStats.GetServers_t: Integer;
begin
  result := FServers_t;
end;

function TPascalCoinNetStats.GetTClients: Integer;
begin
  result := FTClients;
end;

function TPascalCoinNetStats.GetTotal: Integer;
begin
  result := FTotal;
end;

function TPascalCoinNetStats.GetTServers: Integer;
begin
  result := FTServers;
end;


end.
