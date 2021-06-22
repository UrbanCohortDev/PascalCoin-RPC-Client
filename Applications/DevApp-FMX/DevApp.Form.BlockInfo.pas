unit DevApp.Form.BlockInfo;

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

interface

uses
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

type
  TBlockInfoForm = class(TDevBaseForm)
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
    CheckBox1: TCheckBox;
    procedure Block1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure BlockListCellClick(const Column: TColumn; const Row: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
  private
    { Private declarations }
    FLatestBlock: Integer;
    FBlockList: IPascalCoinBlocks;
    procedure LatestBlock;
    procedure GetSingleBlock;
    procedure ChangeBlock(const AIncrement: Integer);
    procedure GetBlockRange;
    procedure HandleRange(Value: IPascalCoinBlocks);
    procedure ShowBlockOps(const Row: Integer);
    procedure DisplayOps(ABlock: Integer);
    procedure ShowMultiOp(block: Integer);
    procedure ShowSingleOp(block: Integer; OpIndex: Integer = 0);
  public
    { Public declarations }
    procedure InitialiseThis; override;
  end;

var
  BlockInfoForm: TBlockInfoForm;

implementation

{$R *.fmx}

uses
  DevApp.Utils,
  PascalCoin.RPC.Exceptions;

procedure TBlockInfoForm.Block1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    Button1.OnClick(self)
  else if Key = vkUp then
    ChangeBlock(1)
  else if Key = vkDown then
    ChangeBlock(-1);

end;

procedure TBlockInfoForm.BlockListCellClick(const Column: TColumn; const Row: Integer);
begin
  Memo1.Lines.Clear;
  if Column.Name = 'OpsCol' then
    ShowBlockOps(Row)
  else
    TDevAppUtils.BlockInfo(FBlockList[Row], Memo1.Lines);
end;

procedure TBlockInfoForm.Button1Click(Sender: TObject);
begin
  inherited;
  if (Block2.Text = '') then
    GetSingleBlock
  else
    GetBlockRange;
end;

procedure TBlockInfoForm.Button2Click(Sender: TObject);
var
  lCount: Integer;
begin
  inherited;
  lCount := Trunc(LastNBlocks.Value);
  HandleRange(ExplorerAPI.GetLastBlocks(lCount));
end;

procedure TBlockInfoForm.ChangeBlock(const AIncrement: Integer);
var
  lBlock: Integer;
begin
  lBlock := Block1.Text.ToInteger;
  Block1.Text := (lBlock + AIncrement).ToString;
  GetSingleBlock;
end;

procedure TBlockInfoForm.ClearButtonClick(Sender: TObject);
begin
  inherited;
  Block1.Text := '';
  Block2.Text := '';
  Memo1.Lines.Clear;
  BlockList.RowCount := 0;
end;

procedure TBlockInfoForm.DisplayOps(ABlock: Integer);
begin

end;

procedure TBlockInfoForm.GetBlockRange;
begin
  HandleRange(ExplorerAPI.GetBlockRange(Block1.Text.ToInteger, Block2.Text.ToInteger));
end;

procedure TBlockInfoForm.GetSingleBlock;
var
  lBlock: IPascalCoinBlock;
  lOpCount: Integer;
begin
  Block2.Text := '';
  Memo1.Lines.Clear;
  try
    lBlock := ExplorerAPI.GetBlock(Block1.Text.ToInteger);
    if CheckBox1.IsChecked then
    begin
      lOpCount := lBlock.operations;
      if lOpCount = 0 then
        ShowMessage('No Operations in this block')
      else if lOpCount = 1 then
        ShowSingleOp(lBlock.block)
      else
        ShowMultiOp(lBlock.block);
    end;

    TDevAppUtils.BlockInfo(lBlock, Memo1.Lines);
  except
    on e: EInvalidBlockException do
    begin
      Memo1.Lines.Add('Oops, Invalid Block');
      Exit;
    end;

    on e: exception do
    begin
      self.HandleAPIException(e);
    end;

  end;
end;

procedure TBlockInfoForm.HandleRange(Value: IPascalCoinBlocks);
var
  I: Integer;
begin
  FBlockList := Value;
  BlockList.RowCount := 0;
  BlockList.RowCount := Value.Count;
  for I := 0 to FBlockList.Count - 1 do
  begin
    BlockList.Cells[0, I] := FBlockList.block[I].block.ToString;
    BlockList.Cells[1, I] := FormatDateTime('dd/mm/yy hh:nn:ss', FBlockList.block[I].TimeStampAsDateTime);
    BlockList.Cells[2, I] := FBlockList[I].operations.ToString;
  end;
end;

procedure TBlockInfoForm.InitialiseThis;
begin
  inherited;
  LatestBlock;
end;

procedure TBlockInfoForm.LatestBlock;
begin
  FLatestBlock := ExplorerAPI.GetBlockCount;
  FormCaption.Text := 'Block Explorer: Latest Block = ' + FLatestBlock.ToString;
end;

procedure TBlockInfoForm.ShowBlockOps(const Row: Integer);
var
  lOpCount: Integer;
begin
  lOpCount := FBlockList[Row].operations;
  if lOpCount = 0 then
    ShowMessage('No Operations in this block')
  else if lOpCount = 1 then
    ShowSingleOp(FBlockList[Row].block)
  else
    ShowMultiOp(FBlockList[Row].block);
end;

procedure TBlockInfoForm.ShowMultiOp(block: Integer);
var
  lOps: IPascalCoinOperations;
  I: Integer;
begin
  Memo1.Lines.Clear;
  lOps := ExplorerAPI.GetBlockOperations(block);
  for I := 0 to lOps.Count - 1 do
  begin
    Memo1.Lines.Add('Operation ' + I.ToString);
    Memo1.Lines.Add('===================');
    TDevAppUtils.OperationInfo(lOps[I], Memo1.Lines);
    Memo1.Lines.Add('');
  end;
end;

procedure TBlockInfoForm.ShowSingleOp(block: Integer; OpIndex: Integer = 0);
begin
  Memo1.Lines.Clear;
  TDevAppUtils.OperationInfo(ExplorerAPI.GetBlockOperation(block, OpIndex), Memo1.Lines);
end;

end.
