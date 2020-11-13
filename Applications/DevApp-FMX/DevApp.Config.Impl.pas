Unit DevApp.Config.Impl;

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
  PascalCoin.RPC.Interfaces;

Type

  TDevAppConfig = Class
  Private
    FConfigFile: String;
    FConfigData: TJSONObject;
    Function GetServers: TJSONArray;
    Function GetConfigFolder: String;
    Function GetRPCClient: IPascalCoinRPCClient;
    Function GetExplorerAPI: IPascalCoinExplorerAPI;
    Function GetNodeAPI: IPascalCoinNodeAPI;
    Function GetWalletAPI: IPascalCoinWalletAPI;
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
  PascalCoin.RPC.API.Wallet;

{ TDevAppConfig }

Procedure TDevAppConfig.AddServer(Const AURI: String);
Begin
  GetServers.Add(AURI);
  SaveConfig;
End;

Constructor TDevAppConfig.Create;
Begin
  Inherited Create;
  FConfigFile := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort'), 'DevApp') + 'Config.json';
  If TFile.Exists(FConfigFile) Then
    FConfigData := TJSONObject.ParseJSONValue(TFile.ReadAllText(FConfigFile)) As TJSONObject
  Else
    FConfigData := TJSONObject.ParseJSONValue('{"app":"DevApp", "Servers":[]}') As TJSONObject;
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
