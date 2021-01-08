Unit DevApp.Form.RawOp.Analysis;

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
  System.Math.Vectors,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  FMX.Controls3D,
  FMX.Layers3D;

Type
  TRawOpAnalysis = Class(TDevBaseForm)
    Layout3D1: TLayout3D;
    Layout1: TLayout;
    Edit1: TEdit;
    Label1: TLabel;
    Layout2: TLayout;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    Procedure Button1Click(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  RawOpAnalysis: TRawOpAnalysis;

Implementation

{$R *.fmx}

Uses
  PascalCoin.KeyUtils;

Procedure TRawOpAnalysis.Button1Click(Sender: TObject);
Var
  lRawOp, lVal: String;
  lIdx, payloadLen, SigRLen, SigSLen: Integer;
Begin
  Inherited;

  { MultiOp
    0100000001000000740E000002000000D21E0000B888000000000000010000000000000007004558414D504C450000000000002000EFD5CBC12F6CC347ED55F26471E046CF59C87E099513F56F4F1DD49BDFA84C0E20007BCB0D96A93202A9C6F11D90BFDCAB99F513C880C4888FECAC74D9B09618C06E

    Op Count:    01000000
    Op Type:     01000000
    Sender:      740E0000
    nOp:         02000000
    Receiver:    D21E0000
    Amount:      B888000000000000
    Fee:         0100000000000000
    Payload Len: 0700
    Payload:     4558414D504C45
    Filler:      000000000000
    Sig R Len:   2000
    Sig R:       EFD5CBC12F6CC347ED55F26471E046CF59C87E099513F56F4F1DD49BDFA84C0E
    Sig S Len:   2000
    Sig S:       7BCB0D96A93202A9C6F11D90BFDCAB99F513C880C4888FECAC74D9B09618C06E
  }

  Memo1.Lines.Clear;
  lRawOp := Edit1.Text;
  lIdx := 0;
  If CheckBox1.IsChecked Then
  Begin
    lVal := lRawOp.Substring(lIdx, 8);
    Memo1.Lines.Add('Multi Op Count = ' + lVal + '; Value = ' + TKeyUtils.HexToInt(lVal).ToString);
    Inc(lIdx, 8);
  End;

  lVal := lRawOp.Substring(lIdx, 8);
  Memo1.Lines.Add('Transaction Type = ' + lVal + '; Value = ' + TKeyUtils.HexToInt(lVal).ToString);
  Inc(lIdx, 8);

  lVal := lRawOp.Substring(lIdx, 8);
  Memo1.Lines.Add('Sender Account = ' + lVal + '; Value = ' + TKeyUtils.HexToCardinal(lVal).ToString);
  Inc(lIdx, 8);

  lVal := lRawOp.Substring(lIdx, 8);
  Memo1.Lines.Add('NOp = ' + lVal + '; Value = ' + TKeyUtils.HexToInt(lVal).ToString);
  Inc(lIdx, 8);

  lVal := lRawOp.Substring(lIdx, 8);
  Memo1.Lines.Add('Receiver Account = ' + lVal + '; Value = ' + TKeyUtils.HexToCardinal(lVal).ToString);
  Inc(lIdx, 8);

  lVal := lRawOp.Substring(lIdx, 16);
  Memo1.Lines.Add('Amount = ' + lVal + '; Value = ' + CurrToStr(TKeyUtils.HexToCurrency(lVal)));
  Inc(lIdx, 16);

  lVal := lRawOp.Substring(lIdx, 16);
  Memo1.Lines.Add('Fee = ' + lVal + '; Value = ' + CurrToStr(TKeyUtils.HexToCurrency(lVal)));
  Inc(lIdx, 16);

  lVal := lRawOp.Substring(lIdx, 4);
  payloadLen := TKeyUtils.IntFromTwoByteHex(lVal);
  Memo1.Lines.Add('Payload Length = ' + lVal + '; Value = ' + payloadLen.ToString);
  payloadLen := payloadLen * 2; // Hex is 2 bytes each.
  Inc(lIdx, 4);

  lVal := lRawOp.Substring(lIdx, payloadLen);
  Memo1.Lines.Add('Payload = ' + lVal);
  Inc(lIdx, payloadLen);

  lVal := lRawOp.Substring(lIdx, 12);
  Memo1.Lines.Add('Filler = ' + lVal);
  Inc(lIdx, 12);

  lVal := lRawOp.Substring(lIdx, 4);
  SigRLen := TKeyUtils.IntFromTwoByteHex(lVal);
  Memo1.Lines.Add('SigR Length = ' + lVal + '; Value = ' + SigRLen.ToString);
  SigRLen := SigRLen * 2; // Hex is 2 bytes each.
  Inc(lIdx, 4);

  lVal := lRawOp.Substring(lIdx, SigRLen);
  Memo1.Lines.Add('SigR = ' + lVal);
  Inc(lIdx, SigRLen);

  lVal := lRawOp.Substring(lIdx, 4);
  SigSLen := TKeyUtils.IntFromTwoByteHex(lVal);
  Memo1.Lines.Add('SigS Length = ' + lVal + '; Value = ' + SigSLen.ToString);
  SigSLen := SigSLen * 2; // Hex is 2 bytes each.
  Inc(lIdx, 4);

  lVal := lRawOp.Substring(lIdx, SigSLen);
  Memo1.Lines.Add('SigS = ' + lVal);
  Inc(lIdx, SigSLen);

End;

End.
