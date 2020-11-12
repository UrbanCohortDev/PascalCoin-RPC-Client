Unit DevApp.Form.BlockInfo;

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

Interface

Uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  PascalCoin.RPC.Interfaces,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  DevApp.Base.DetailForm,
  FMX.Controls.Presentation,
  FMX.Layouts,
  FMX.Edit,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.EditBox,
  FMX.SpinBox,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  Aurelius.Mapping.Metadata;

Type
  TBlockInfoForm = Class(TDevBaseForm)
    Layout1: TLayout;
    Label1: TLabel;
    Block1: TEdit;
    Label2: TLabel;
    Block2: TEdit;
    Button1: TButton;
    ClearButton: TButton;
    Memo1: TMemo;
    Layout2: TLayout;
    Label3: TLabel;
    Button2: TButton;
    LastNBlocks: TSpinBox;
    Layout3: TLayout;
    BlockList: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    OpsCol: TStringColumn;
    Procedure Block1KeyDown(Sender: TObject; Var Key: Word; Var KeyChar: Char; Shift: TShiftState);
    Procedure BlockListCellClick(Const Column: TColumn; Const Row: Integer);
    Procedure Button1Click(Sender: TObject);
    Procedure Button2Click(Sender: TObject);
    Procedure ClearButtonClick(Sender: TObject);
  Private
    { Private declarations }
    FLatestBlock: Integer;
    FBlockList: IPascalCoinBlocks;
    Procedure LatestBlock;
    Procedure GetSingleBlock;
    Procedure ChangeBlock(Const AIncrement: Integer);
    Procedure GetBlockRange;
    Procedure HandleRange(Value: IPascalCoinBlocks);
    Procedure ShowBlockOps(Const Row: Integer);
    Procedure ShowMultiOp(block: Integer);
    procedure ShowSingleOp(block: Integer; OpIndex: Integer = 0);
  Public
    { Public declarations }
    Procedure InitialiseThis; Override;
  End;

Var
  BlockInfoForm: TBlockInfoForm;

Implementation

{$R *.fmx}

Uses
  DevApp.Utils,
  PascalCoin.RPC.Exceptions;

Procedure TBlockInfoForm.Block1KeyDown(Sender: TObject; Var Key: Word; Var KeyChar: Char; Shift: TShiftState);
Begin
  If Key = vkReturn Then
    Button1.OnClick(self)
  Else If Key = vkUp Then
    ChangeBlock(1)
  Else If Key = vkDown Then
    ChangeBlock(-1);

End;

Procedure TBlockInfoForm.BlockListCellClick(Const Column: TColumn; Const Row: Integer);
Begin
  Memo1.Lines.Clear;
  If Column.Name = 'OpsCol' Then
    ShowBlockOps(Row)
  Else
    TDevAppUtils.BlockInfo(FBlockList[Row], Memo1.Lines);
End;

Procedure TBlockInfoForm.Button1Click(Sender: TObject);
Begin
  Inherited;
  If (Block2.Text = '') Then
    GetSingleBlock
  Else
    GetBlockRange;
End;

Procedure TBlockInfoForm.Button2Click(Sender: TObject);
Var
  lCount: Integer;
Begin
  Inherited;
  lCount := Trunc(LastNBlocks.Value);
  HandleRange(ExplorerAPI.GetLastBlocks(lCount));
End;

Procedure TBlockInfoForm.ChangeBlock(Const AIncrement: Integer);
Var
  lBlock: Integer;
Begin
  lBlock := Block1.Text.ToInteger;
  Block1.Text := (lBlock + AIncrement).ToString;
  GetSingleBlock;
End;

Procedure TBlockInfoForm.ClearButtonClick(Sender: TObject);
Begin
  Inherited;
  Block1.Text := '';
  Block2.Text := '';
  Memo1.Lines.Clear;
  BlockList.RowCount := 0;
End;

Procedure TBlockInfoForm.GetBlockRange;
Begin
  HandleRange(ExplorerAPI.GetBlockRange(Block1.Text.ToInteger, Block2.Text.ToInteger));
End;

Procedure TBlockInfoForm.GetSingleBlock;
Var
  lBlock: IPascalCoinBlock;
Begin
  Block2.Text := '';
  Memo1.Lines.Clear;
  Try
    lBlock := ExplorerAPI.GetBlock(Block1.Text.ToInteger);
    TDevAppUtils.BlockInfo(lBlock, Memo1.Lines);
  Except
    On e: EInvalidBlockException Do
    Begin
      Memo1.Lines.Add('Oops, Invalid Block');
      Exit;
    End;

    On e: exception Do
    Begin
      self.HandleAPIException(e);
    End;

  End;
End;

Procedure TBlockInfoForm.HandleRange(Value: IPascalCoinBlocks);
Var
  I: Integer;
Begin
  FBlockList := Value;
  BlockList.RowCount := 0;
  BlockList.RowCount := Value.Count;
  For I := 0 To FBlockList.Count - 1 Do
  Begin
    BlockList.Cells[0, I] := FBlockList.block[I].block.ToString;
    BlockList.Cells[1, I] := FormatDateTime('dd/mm/yy hh:nn:ss', FBlockList.block[I].TimeStampAsDateTime);
    BlockList.Cells[2, I] := FBlockList[I].operations.ToString;
  End;
End;

Procedure TBlockInfoForm.InitialiseThis;
Begin
  Inherited;
  LatestBlock;
End;

Procedure TBlockInfoForm.LatestBlock;
Begin
  FLatestBlock := ExplorerAPI.GetBlockCount;
  FormCaption.Text := 'Block Explorer: Latest Block = ' + FLatestBlock.ToString;
End;

Procedure TBlockInfoForm.ShowBlockOps(Const Row: Integer);
Var
  lOpCount: Integer;
Begin
  lOpCount := FBlockList[Row].operations;
  If lOpCount = 0 Then
    ShowMessage('No Operations in this block')
  Else If lOpCount = 1 Then
    ShowSingleOp(FBlockList[Row].block)
  Else
    ShowMultiOp(FBlockList[Row].block);

End;

Procedure TBlockInfoForm.ShowMultiOp(block: Integer);
var lOps: IPascalCoinOperations;
  I: Integer;
Begin
  Memo1.Lines.Clear;
  lOps := ExplorerAPI.GetBlockOperations(block);
  for I := 0 to lOps.Count - 1 do
  begin
    Memo1.Lines.Add('Operation ' + I.ToString);
    Memo1.Lines.Add('===================');
    TDevAppUtils.OperationInfo(lOps[I], Memo1.Lines);
    Memo1.Lines.Add('');
  end;
End;

Procedure TBlockInfoForm.ShowSingleOp(block: Integer; OpIndex: Integer = 0);
Begin
  Memo1.Lines.Clear;
  TDevAppUtils.OperationInfo(ExplorerAPI.GetBlockOperation(block, OpIndex), Memo1.Lines);
End;

End.
