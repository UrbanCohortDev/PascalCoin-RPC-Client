unit DevApp.Base.DetailForm;

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

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  PascalCoin.RPC.Interfaces, FMX.Controls.Presentation, FMX.StdCtrls, PascalCoin.RPC.Exceptions;

type
  TDevBaseForm = class(TForm)
    HeaderLayout: TLayout;
    FooterLayout: TLayout;
    ContentLayout: TLayout;
    FormCaption: TLabel;
  private
    FDefaultURI: String;
    procedure SetDefaultURI(const Value: String);
    { Private declarations }
  protected
    function NodeAPI: IPascalCoinNodeAPI;
    function ExplorerAPI: IPascalCoinExplorerAPI;
    function WalletExplorerAPI: IPascalCoinWalletAPI;

    function UseURI: String; virtual;
    procedure HandleAPIException(E: Exception);
  public
    { Public declarations }
    procedure InitialiseThis; virtual;
    function CanClose: Boolean; Virtual;
    procedure TearDown; virtual;
    property DefaultURI: String read FDefaultURI write SetDefaultURI;
  end;

var
  DevBaseForm: TDevBaseForm;

implementation

{$R *.fmx}

uses DevApp.Shared, FMX.DialogService;

{ TDevBaseForm }

function TDevBaseForm.CanClose: Boolean;
begin
  Result := True;
end;

function TDevBaseForm.ExplorerAPI: IPascalCoinExplorerAPI;
begin
  Result := Config.ExplorerAPI;
  Result.NodeURI := UseURI;
end;

function TDevBaseForm.NodeAPI: IPascalCoinNodeAPI;
begin
  Result := Config.NodeAPI;
  Result.NodeURI := UseURI;
end;

procedure TDevBaseForm.HandleAPIException(E: Exception);
begin
   TDialogService.ShowMessage(E.Message);
end;

procedure TDevBaseForm.InitialiseThis;
begin
//for descendants; not abstract as this is easier
end;

procedure TDevBaseForm.SetDefaultURI(const Value: String);
begin
  FDefaultURI := Value;
end;

procedure TDevBaseForm.TearDown;
begin
//for descendants; not abstract as this is easier
end;

function TDevBaseForm.UseURI: String;
begin
  Result := FDefaultURI;
end;

function TDevBaseForm.WalletExplorerAPI: IPascalCoinWalletAPI;
begin
  Result := Config.WalletAPI;
  Result.NodeURI := UseURI;
end;

end.

