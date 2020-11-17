Unit DevApp.Form.NodeStatus;

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
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  DevApp.Base.DetailForm,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo;

Type
  TNodeStatusForm = Class(TDevBaseForm)
    Edit1: TEdit;
    Layout1: TLayout;
    Layout4: TLayout;
    Label1: TLabel;
    Button1: TButton;
    URILabel: TLabel;
    Memo1: TMemo;
    Procedure Button1Click(Sender: TObject);
  Private
    FURI: String;
    Procedure SetURI(Const Value: String);
    { Private declarations }
  Protected
    Function UseURI: String; Override;
    Property URI: String Read FURI Write SetURI;
  Public
    { Public declarations }
    Procedure InitialiseThis; Override;

  End;

Var
  NodeStatusForm: TNodeStatusForm;

Implementation

{$R *.fmx}

Uses
  System.JSON,
  PascalCoin.RPC.Interfaces;

Procedure TNodeStatusForm.Button1Click(Sender: TObject);
Begin
  URI := Edit1.Text;
End;

{ TNodeStatusForm }

Procedure TNodeStatusForm.InitialiseThis;
Begin
  Inherited;
  URI := DefaultURI;
End;

Procedure TNodeStatusForm.SetURI(Const Value: String);
Var
  lNode: IPascalCoinNodeStatus;
  I: Integer;
Begin

  Memo1.Lines.Clear;
  FURI := Value;
  URILabel.Text := FURI;

  Try
    lNode := NodeAPI.NodeStatus;

    Memo1.Lines.Add('ready: ' + lNode.ready_s);
    Memo1.Lines.Add('status: ' + lNode.status_s);
    Memo1.Lines.Add('version: ' + lNode.version);
    Memo1.Lines.Add('port: ' + lNode.port.ToString);
    Memo1.Lines.Add('timestamp: ' + lNode.timestamp.ToString);
    Memo1.Lines.Add('as date time: ' + FormatDateTime('dd/mm/yyyy hh:nn:ss', lNode.TimeStampAsDateTime));
    Memo1.Lines.Add('locked: ' + lNode.locked.ToString());
    Memo1.Lines.Add('blocks: ' + lNode.blocks.ToString);
    Memo1.Lines.Add('sbh: ' + lNode.sbh);
    Memo1.Lines.Add('openssl: ' + lNode.openssl);
    Memo1.Lines.Add('NetProtocol/ver: ' + lNode.netprotocol.ver.ToString);
    Memo1.Lines.Add('NetProtocol/ver_a: ' + lNode.netprotocol.ver_a.ToString);
    Memo1.Lines.Add('NetStats/active' + lNode.netstats.active.ToString);
    Memo1.Lines.Add('NetStats/clients' + lNode.netstats.clients.ToString);
    Memo1.Lines.Add('NetStats/servers' + lNode.netstats.servers.ToString);
    Memo1.Lines.Add('NetStats/servers_t' + lNode.netstats.servers_t.ToString);
    Memo1.Lines.Add('NetStats/total' + lNode.netstats.total.ToString);
    Memo1.Lines.Add('NetStats/tclients' + lNode.netstats.tclients.ToString);
    Memo1.Lines.Add('NetStats/tservers' + lNode.netstats.tservers.ToString);
    Memo1.Lines.Add('NetStats/breceived' + lNode.netstats.breceived.ToString);
    Memo1.Lines.Add('NetStats/bsend' + lNode.netstats.bsend.ToString);

    Memo1.Lines.Add('Server Count' + lNode.NodeServerCount.ToString);
    Memo1.Lines.Add('Servers');
    Memo1.Lines.Add('=========================');

    For I := 0 To lNode.NodeServerCount - 1 Do
    Begin
      Memo1.Lines.Add('Server ' + I.ToString + '/ip:port: ' + lNode.nodeServer[I].ip + ':' + lNode.nodeServer[I]
        .port.ToString);
      Memo1.Lines.Add('Server ' + I.ToString + '/lastcon: ' + lNode.nodeServer[I].lastcon.ToString + ' [' +
        FormatDateTime('dd-mm-yyyy hh:nn:ss', lNode.nodeServer[I].LastConAsDateTime) + ']');
      Memo1.Lines.Add('Server ' + I.ToString + '/attempts: ' + lNode.nodeServer[I].attempts.ToString);
      Memo1.Lines.Add('-------------------------');
    End;

  Except
    On E: Exception Do
    Begin
      HandleAPIException(E);
    End;

  End;

End;

Function TNodeStatusForm.UseURI: String;
Begin
  Result := FURI;
End;

End.
