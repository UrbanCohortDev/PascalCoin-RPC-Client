unit DevApp.Form.PendingInfo;

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
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, DevApp.Base.DetailForm,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, PascalCoin.RPC.Interfaces,
  FMX.ListBox;

type
  TPendingInfo = class(TDevBaseForm)
    Label1: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    Layout1: TLayout;
    Label2: TLabel;
    OpHashList: TComboBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    Procedure UpdateCount;
    Procedure ListOps;
  public
    { Public declarations }
    Procedure InitialiseThis; override;
  end;

var
  PendingInfo: TPendingInfo;

implementation

{$R *.fmx}

uses DevApp.Utils;

resourcestring
//Same block 1 & 2
live_1 = '984B0700A04A240001000000FCA1B7B71B603A4F017627078829FE3E59D86D44';
live_2 = '984B0700C14C240001000000752CE98EAC32F74944150665866F8CDCAE7AC5FE';


//block 477618
live_3 = 'B2490700EEB8080091380000B1ACD816599C01E680151DA3FC346DBB6D286685';


procedure TPendingInfo.Button1Click(Sender: TObject);
begin
  inherited;
  UpdateCount;
  end;

procedure TPendingInfo.Button2Click(Sender: TObject);
var lOp: IPascalCoinOperation;
begin
  inherited;
  Memo1.Lines.Clear;
  lOp := ExplorerAPI.findoperation(OpHashList.Items[OphashList.ItemIndex]);
  if lOp <> nil then
    TDevAppUtils.OperationInfo(lOp, Memo1.Lines)
  else
    ShowMessage('where''s the op?');

end;

{ TPendingInfo }

procedure TPendingInfo.InitialiseThis;
begin
  inherited;

  OpHashList.Items.Add(live_1);
  OpHashList.Items.Add(live_2);
  OpHashList.Items.Add(live_3);

  UpdateCount;


end;

procedure TPendingInfo.ListOps;
var lOps: IPascalCoinOperations;
  I: Integer;
begin
  lOps := ExplorerAPI.getpendings(0, 0);
  for I := 0 to lOps.Count - 1 do
  begin
    Memo1.Lines.Add('Pending Op ' + I.ToString);
    Memo1.Lines.Add(StringOfChar('=', 15));
    TDevAppUtils.OperationInfo(lOps[I], Memo1.Lines);
    Memo1.Lines.Add('');
  end;
end;

procedure TPendingInfo.UpdateCount;
var lCount: Integer;
begin
  Memo1.Lines.Clear;
  FormCaption.Text := 'Pending Ops; Last Block: ' + ExplorerAPI.GetBlockCount.ToString;
  lCount := ExplorerAPI.GetPendingsCount;
  Label1.Text := 'Pending Count: ' + lCount.ToString;
  if lCount > 0 then
     ListOps;
end;

end.
