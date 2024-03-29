Unit DevApp.Config.Impl;

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
  PascalCoin.RPC.Interfaces;

Type

  TDevAppConfig = Class
  Private
    FConfigFolder: String;
    FConfigFile: String;
    FConfigData: TJSONObject;
    Function GetServers: TJSONArray;
    Function GetConfigFolder: String;
    Function GetRPCClient: IPascalCoinRPCClient;
    Function GetExplorerAPI: IPascalCoinExplorerAPI;
    Function GetNodeAPI: IPascalCoinNodeAPI;
    Function GetWalletAPI: IPascalCoinWalletAPI;
    function GetOperationsAPI: IPascalCoinOperationsAPI;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure SaveConfig;
    Procedure AddServer(Const AURI: String);
    Property ConfigFolder: String Read GetConfigFolder;
    Property ConfigData: TJSONObject Read FConfigData;
    Property Servers: TJSONArray Read GetServers;
    Property ExplorerAPI: IPascalCoinExplorerAPI Read GetExplorerAPI;
    Property NodeAPI: IPascalCoinNodeAPI Read GetNodeAPI;
    Property WalletAPI: IPascalCoinWalletAPI Read GetWalletAPI;
    Property OperationsAPI: IPascalCoinOperationsAPI read GetOperationsAPI;
  End;

Implementation

Uses
  System.IOUtils,
  System.SysUtils,
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  PascalCoin.RPC.Client,
  PascalCoin.RPC.API.Node,
  PascalCoin.RPC.API.Explorer,
  PascalCoin.RPC.API.Wallet,
  PascalCoin.RPC.API.Operations;

{ TDevAppConfig }

Procedure TDevAppConfig.AddServer(Const AURI: String);
Begin
  GetServers.Add(AURI);
  SaveConfig;
End;

Constructor TDevAppConfig.Create;
Begin
  Inherited Create;

  {$IFDEF TESTNET}
   FConfigFolder := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort_TestNet'), 'DevApp');
  {$ELSE}
  FConfigFolder := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort'), 'DevApp');
  {$ENDIF}

  FConfigFile := TPath.Combine(FConfigFolder, 'Config.json');

  If TFile.Exists(FConfigFile) Then
    FConfigData := TJSONObject.ParseJSONValue(TFile.ReadAllText(FConfigFile)) As TJSONObject
  Else
    {$IFDEF TESTNET}
    FConfigData := TJSONObject.ParseJSONValue('{"app":"DevApp", "TestNet":true, "Servers":[]}') As TJSONObject;
    {$ELSE}
    FConfigData := TJSONObject.ParseJSONValue('{"app":"DevApp", "TestNet":false, "Servers":[]}') As TJSONObject;
    {$ENDIF}
End;

Destructor TDevAppConfig.Destroy;
Begin
  Inherited;
End;

Function TDevAppConfig.GetConfigFolder: String;
Begin
  Result := TPath.GetDirectoryName(FConfigFile);
End;

Function TDevAppConfig.GetExplorerAPI: IPascalCoinExplorerAPI;
Begin
  Result := TPascalCoinExplorerAPI.Create(GetRPCClient);
End;

Function TDevAppConfig.GetNodeAPI: IPascalCoinNodeAPI;
Begin
  Result := TPascalCoinNodeAPI.Create(GetRPCClient);
End;

function TDevAppConfig.GetOperationsAPI: IPascalCoinOperationsAPI;
begin
  Result := TPascalCoinOperationsAPI.Create(GetRPCClient);
end;

Function TDevAppConfig.GetRPCClient: IPascalCoinRPCClient;
Begin
  Result := TPascalCoinRPCClient.Create(TDelphiHTTP.Create);
End;

Function TDevAppConfig.GetServers: TJSONArray;
Begin
  Result := FConfigData.GetValue<TJSONArray>('Servers');
End;

Function TDevAppConfig.GetWalletAPI: IPascalCoinWalletAPI;
Begin
  Result := TPascalCoinWalletAPI.Create(GetRPCClient);
End;

Procedure TDevAppConfig.SaveConfig;
Begin
  TDirectory.CreateDirectory(ConfigFolder);
  TFile.WriteAllText(FConfigFile, FConfigData.ToJSON);
End;

End.
