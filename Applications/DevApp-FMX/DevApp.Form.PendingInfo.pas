Unit DevApp.Form.PendingInfo;

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
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  PascalCoin.RPC.Interfaces,
  FMX.ListBox;

Type
  TPendingInfo = Class(TDevBaseForm)
    Label1: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Layout1: TLayout;
    Label2: TLabel;
    OpHashList: TComboBox;
    Button2: TButton;
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
  Private
    { Private declarations }
    Procedure UpdateCount;
    Procedure ListOps;
  Public
    { Public declarations }
    Procedure InitialiseThis; Override;
  End;

Var
  PendingInfo: TPendingInfo;

Implementation

{$R *.fmx}

Uses
  DevApp.Utils;

Resourcestring
  // Same block 1 & 2
  live_1 = '984B0700A04A240001000000FCA1B7B71B603A4F017627078829FE3E59D86D44';
  live_2 = '984B0700C14C240001000000752CE98EAC32F74944150665866F8CDCAE7AC5FE';

  // block 477618
  live_3 = 'B2490700EEB8080091380000B1ACD816599C01E680151DA3FC346DBB6D286685';

Procedure TPendingInfo.Button1Click(Sender: TObject);
Begin
  Inherited;
  UpdateCount;
End;

Procedure TPendingInfo.Button2Click(Sender: TObject);
Var
  lOp: IPascalCoinOperation;
Begin
  Inherited;
  Memo1.Lines.Clear;
  lOp := ExplorerAPI.findoperation(OpHashList.Items[OpHashList.ItemIndex]);
  If lOp <> Nil Then
    TDevAppUtils.OperationInfo(lOp, Memo1.Lines)
  Else
    ShowMessage('where''s the op?');

End;

{ TPendingInfo }

Procedure TPendingInfo.InitialiseThis;
Begin
  Inherited;

  OpHashList.Items.Add(live_1);
  OpHashList.Items.Add(live_2);
  OpHashList.Items.Add(live_3);

  UpdateCount;

End;

Procedure TPendingInfo.ListOps;
Var
  lOps: IPascalCoinOperations;
  I: Integer;
Begin
  lOps := ExplorerAPI.getpendings(0, 0);
  For I := 0 To lOps.Count - 1 Do
  Begin
    Memo1.Lines.Add('Pending Op ' + I.ToString);
    Memo1.Lines.Add(StringOfChar('=', 15));
    TDevAppUtils.OperationInfo(lOps[I], Memo1.Lines);
    Memo1.Lines.Add('');
  End;
End;

Procedure TPendingInfo.UpdateCount;
Var
  lCount: Integer;
Begin
  Memo1.Lines.Clear;
  FormCaption.Text := 'Pending Ops; Last Block: ' + ExplorerAPI.GetBlockCount.ToString;
  lCount := ExplorerAPI.GetPendingsCount;
  Label1.Text := 'Pending Count: ' + lCount.ToString;
  If lCount > 0 Then
    ListOps;
End;

End.
