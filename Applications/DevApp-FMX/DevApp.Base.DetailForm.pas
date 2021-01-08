Unit DevApp.Base.DetailForm;

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
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  PascalCoin.RPC.Interfaces,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  PascalCoin.RPC.Exceptions;

Type
  TDevBaseForm = Class(TForm)
    HeaderLayout: TLayout;
    FooterLayout: TLayout;
    ContentLayout: TLayout;
    FormCaption: TLabel;
  Private
    FDefaultURI: String;
    Procedure SetDefaultURI(Const Value: String);
    { Private declarations }
  Protected
    Function NodeAPI: IPascalCoinNodeAPI;
    Function ExplorerAPI: IPascalCoinExplorerAPI;
    Function WalletExplorerAPI: IPascalCoinWalletAPI;
    function OperationsAPI: IPascalCoinOperationsAPI;

    Function UseURI: String; Virtual;
    Procedure HandleAPIException(E: Exception);
  Public
    { Public declarations }
    Procedure InitialiseThis; Virtual;
    Function CanClose: Boolean; Virtual;
    Procedure TearDown; Virtual;
    Property DefaultURI: String Read FDefaultURI Write SetDefaultURI;
  End;

Var
  DevBaseForm: TDevBaseForm;

Implementation

{$R *.fmx}

Uses
  DevApp.Shared,
  FMX.DialogService;

{ TDevBaseForm }

Function TDevBaseForm.CanClose: Boolean;
Begin
  Result := True;
End;

Function TDevBaseForm.ExplorerAPI: IPascalCoinExplorerAPI;
Begin
  Result := Config.ExplorerAPI;
  Result.NodeURI := UseURI;
End;

Function TDevBaseForm.NodeAPI: IPascalCoinNodeAPI;
Begin
  Result := Config.NodeAPI;
  Result.NodeURI := UseURI;
End;

function TDevBaseForm.OperationsAPI: IPascalCoinOperationsAPI;
begin
  Result := Config.OperationsAPI;
  Result.NodeURI := UseURI;
end;

Procedure TDevBaseForm.HandleAPIException(E: Exception);
Begin
  TDialogService.ShowMessage(E.Message);
End;

Procedure TDevBaseForm.InitialiseThis;
Begin
  // for descendants; not abstract as this is easier
End;

Procedure TDevBaseForm.SetDefaultURI(Const Value: String);
Begin
  FDefaultURI := Value;
End;

Procedure TDevBaseForm.TearDown;
Begin
  // for descendants; not abstract as this is easier
End;

Function TDevBaseForm.UseURI: String;
Begin
  Result := FDefaultURI;
End;

Function TDevBaseForm.WalletExplorerAPI: IPascalCoinWalletAPI;
Begin
  Result := Config.WalletAPI;
  Result.NodeURI := UseURI;
End;

End.
