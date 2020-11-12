unit DevApp.Config.Impl;

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

Uses Spring.Container, System.JSON;

Type

TDevAppConfig = class
private
    FContainer: TContainer;
    FConfigFile: String;
    FConfigData: TJSONObject;
    function GetContainer: TContainer;
    function GetServers: TJSONArray;
    function GetConfigFolder: String;
protected
public
  Constructor Create;
  Destructor Destroy; override;
  Procedure SaveConfig;
  Procedure AddServer(const AURI: String);
  Property Container: TContainer read GetContainer;
  Property ConfigFolder: String read GetConfigFolder;
  Property ConfigData: TJSONObject read FConfigData;
  Property Servers: TJSONArray read GetServers;
end;

implementation

uses System.IOUtils, System.SysUtils;

{ TDevAppConfig }

procedure TDevAppConfig.AddServer(const AURI: String);
begin
  GetServers.Add(AURI);
  SaveConfig;
end;

constructor TDevAppConfig.Create;
begin
  inherited Create;
  FConfigFile := TPath.Combine(TPath.Combine(TPath.GetHomePath, 'PascalCoin_UrbanCohort'), 'DevApp') + 'Config.json';
  FContainer := TContainer.Create;
  if TFile.Exists(FConfigFile) then
     FConfigData := TJSONObject.ParseJSONValue(TFile.ReadAllText(FConfigFile)) as TJSONObject
  else
    FConfigData := TJSONObject.ParseJSONValue('{"app":"DevApp", "Servers":[]}') as TJSONObject;
end;


destructor TDevAppConfig.Destroy;
begin
  FContainer.Free;
  inherited;
end;

function TDevAppConfig.GetConfigFolder: String;
begin
  Result := TPath.GetDirectoryName(FConfigFile);
end;

function TDevAppConfig.GetContainer: TContainer;
begin
  Result := FContainer;
end;

function TDevAppConfig.GetServers: TJSONArray;
begin
  Result := FConfigData.GetValue<TJSONArray>('Servers');
end;

procedure TDevAppConfig.SaveConfig;
begin
  TDirectory.CreateDirectory(ConfigFolder);
  TFile.WriteAllText(FConfigFile, FConfigData.ToJSON);
end;

end.
