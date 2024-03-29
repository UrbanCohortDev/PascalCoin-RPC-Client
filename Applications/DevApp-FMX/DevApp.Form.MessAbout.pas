unit DevApp.Form.MessAbout;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, DevApp.Base.DetailForm,
  FMX.Controls.Presentation, FMX.Layouts, System.Actions, FMX.ActnList, FMX.ListBox, FMX.Edit;

type
  TMessAbout = class(TDevBaseForm)
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    Label2: TLabel;
    SourceKey: TEdit;
    Layout3: TLayout;
    Layout4: TLayout;
    TargetLabel: TLabel;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    KeyStyle: TComboBox;
    ActionList1: TActionList;
    GetSourceStyle: TAction;
    ConvertSource: TAction;
    Layout5: TLayout;
    Button1: TButton;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ConvertSourceExecute(Sender: TObject);
    procedure GetSourceStyleExecute(Sender: TObject);
    procedure SourceKeyChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MessAbout: TMessAbout;

implementation

{$R *.fmx}

uses System.Rtti, PascalCoin.KeyUtils, PascalCoin.Utils, PascalCoin.Consts;

procedure TMessAbout.Button1Click(Sender: TObject);
var lKey: TStringPair;
    lPrefix: String;
begin
  inherited;

  lKey := TKeyUtils.GenerateKeyPair(TKeyType.SECP256K1);

  lPrefix := TRttiEnumerationType.GetName<TKeyType>(TPascalCoinUtils.KeyTypeFromPascalKey(lKey.Key));

//  lPrefix := System.Copy(lKey.Key, 0, 4);
  Label3.Text := lPrefix;
end;

procedure TMessAbout.ConvertSourceExecute(Sender: TObject);
var lKeyStyle: TKeyStyle;
begin
  inherited;
  if SourceKey.Text.Trim = ''  then
  begin
    ShowMessage('Enter a sourcekey');
    Exit;
  end;

  lKeyStyle := TKeyStyle(KeyStyle.ItemIndex);

case lKeyStyle of
  ksUnknown: ShowMessage('Unrecognised Key Style');

  ksEncKey: begin
    TargetLabel.Text := 'B58 Key';

  end;

  ksB58Key: begin
  end;
end;
end;

procedure TMessAbout.GetSourceStyleExecute(Sender: TObject);
var lKeyStyle: TKeyStyle;
begin
  inherited;
  lKeyStyle := TPascalCoinUtils.PublicKeyStyle(SourceKey.Text);
  KeyStyle.ItemIndex := Integer(lKeyStyle);
end;

procedure TMessAbout.SourceKeyChange(Sender: TObject);
begin
  inherited;
  GetSourceStyle.Execute;
end;

end.
