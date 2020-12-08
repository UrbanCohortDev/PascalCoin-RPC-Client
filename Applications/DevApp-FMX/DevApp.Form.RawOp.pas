Unit DevApp.Form.RawOp;

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
  FMX.Controls.Presentation,
  FMX.Layouts,
  PascalCoin.Key.Interfaces,
  FMX.ListBox,
  FMX.Edit,
  FMX.Menus,
  PascalCoin.RawOp.Interfaces,
  PascalCoin.Consts,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  PascalCoin.RPC.Interfaces,
  System.Actions,
  FMX.ActnList;

Type
  TRawOpForm = Class(TDevBaseForm)
    KeyLayout: TLayout;
    Label1: TLabel;
    PrivateKey: TEdit;
    KeyTypeCombo: TComboBox;
    Layout2: TLayout;
    Label2: TLabel;
    FromAccount: TEdit;
    Label3: TLabel;
    ToAccount: TEdit;
    Layout3: TLayout;
    Label4: TLabel;
    NextNOp: TEdit;
    Label5: TLabel;
    Amount: TEdit;
    OpNumber: TEdit;
    Label10: TLabel;
    Layout4: TLayout;
    Label9: TLabel;
    KRandom: TEdit;
    UseClass: TCheckBox;
    Layout5: TLayout;
    Label6: TLabel;
    Fee: TEdit;
    Label8: TLabel;
    Payload: TEdit;
    Layout1: TLayout;
    ExecuteButton: TButton;
    Button1: TButton;
    PayloadEncryptionCombo: TComboBox;
    Label7: TLabel;
    PasswordLayout: TLayout;
    Label11: TLabel;
    PasswordEdit: TEdit;
    Memo1: TMemo;
    ActionList1: TActionList;
    ClearAction: TAction;
    StandardDataAction: TAction;
    Button2: TButton;
    Procedure ClearActionExecute(Sender: TObject);
    Procedure ExecuteButtonClick(Sender: TObject);
    Procedure MenuItem2Click(Sender: TObject);
    Procedure PayloadEncryptionComboChange(Sender: TObject);
    Procedure StandardDataActionExecute(Sender: TObject);
    Procedure ToAccountExit(Sender: TObject);
  Private
    { Private declarations }
    FExpectedSender: String;
    FExpectedNOp: String;
    FExpectedReceiver: String;
    FExpectedAmount: String;
    FExpectedFee: String;
    FExpectedHash: String;
    FExpectedHashSig: String;
    FExpectedPaylen: String;
    FExpectedPayload: String;
    FExpectedRawOp: String;
    FExpectedRLen: String;
    FExpectedSignedTx: String;
    FExpectedStrToHash: String;
    FExpectedSignR: String;
    FExpectedSignS: String;
    FExpectedSLen: String;
    FExpectedK: String;

    FCanExecute: Boolean;
    FRecipientAccount: IPascalCoinAccount;
    Procedure Clear;
    Function PayloadEncryptionMethod: TPayloadEncryptionMethod;
    Function GetKeyType: TKeyType;
    {$IFDEF UNITTEST}
    procedure CheckStepValues(AMultiOp: IPascalCoinMultiOperations);
    {$ENDIF}
  Public
    { Public declarations }
    Procedure InitialiseThis; Override;
  End;

Var
  RawOpForm: TRawOpForm;

Implementation

{$R *.fmx}

Uses
  System.Rtti,
  System.StrUtils,
  PascalCoin.Utils,
  PascalCoin.RPC.RawOp.Send,
  PascalCoin.Payload,
  PascalCoin.KeyUtils, PascalCoin.RawOp.MultiOperations;

{$IFDEF UNITTEST}
procedure TRawOpForm.CheckStepValues(AMultiOp: IPascalCoinMultiOperations);

procedure AddToMemo(AName, AValue, AExpected: string);
  const
  c_bool: array[boolean] of string = ('No', 'Yes');
  begin
   Memo1.Lines.Add(AName + ' | ' + c_bool[AValue = AExpected]);
   Memo1.Lines.Add('Val: ' + AValue);
   Memo1.Lines.Add('Exp: ' + AExpected);
   Memo1.Lines.Add(StringOfChar('-', 60));
  end;
var ARawOp: IPascalCoinRawOperation;
begin

  ARawOp := AMultiOp[0];
  AddToMemo('Sender', ARawOp.TestValue('SENDFROM'), FExpectedSender);
  AddToMemo('NOp', ARawOp.TestValue('NOP'), FExpectedNOp);
  AddToMemo('Receiver', ARawOp.TestValue('SendTo'),  FExpectedReceiver);
  AddToMemo('Amount Hex', ARawOp.TestValue('Amount'), FExpectedAmount);
  AddToMemo('Fee HEX', ARawOp.TestValue('Fee'), FExpectedFee);
  AddToMemo('Random K', ARawOp.TestValue('KRANDOM'), FExpectedK);
  AddToMemo('Payload', ARawOp.Payload.AsHex, FExpectedPayload);
  AddToMemo('PayloadLen', ARawOp.TestValue('PayloadLen'), FExpectedPaylen);
  AddToMemo('ValueToHash', ARawOp.TestValue('ValueToHash'), FExpectedStrToHash);
  AddToMemo('HASH', ARawOp.TestValue('Hash'), FExpectedHash);
  AddToMemo('Sig.R', ARawOp.TestValue('SIG.R'), FExpectedSignR);
  AddToMemo('Sig.S', ARawOp.TestValue('SIG.S'), FExpectedSignS);
  AddToMemo('Sig.R.Len', ARawOp.TestValue('Sig.R.Len'), FExpectedRLen);
  AddToMemo('Sig.S.Len', ARawOp.TestValue('Sig.S.Len'), FExpectedSLen);
  AddToMemo('SignedTx', ARawOp.TestValue('SignedTx'), FExpectedSignedTx);

  AddToMemo('Raw Op', AMultiOp.RawData, FExpectedRawOp);

end;
{$ENDIF}

Procedure TRawOpForm.Clear;
Begin
  FromAccount.Text := '';
  ToAccount.Text := '';
  NextNOp.Text := '';
  Amount.Text := '';
  Fee.Text := '';
  Payload.Text := '';
  PrivateKey.Text := '';
  KeyTypeCombo.ItemIndex := 0;
  PayloadEncryptionCombo.ItemIndex := 0;
  KRandom.Text := '';
  OpNumber.Text := '1';
  FExpectedSignedTx := '';
  FExpectedRawOp := '';
  FCanExecute := True;
  Memo1.Lines.Clear;
End;

Procedure TRawOpForm.ClearActionExecute(Sender: TObject);
Begin
  Inherited;
  Clear;
End;

Procedure TRawOpForm.ExecuteButtonClick(Sender: TObject);
Var
  lRawOp: IPascalCoinRawSend;
  lMultiOp: IPascalCoinMultiOperations;
  lOp: String;
Begin
  lRawOp := TPascalCoinSendOperation.Create(TPascalCoinPayload.Create);
  lRawOp.SenderAccount := FromAccount.Text;
  lRawOp.ReceiverAccount := ToAccount.Text;
  lRawOp.Amount := StrToCurr(Amount.Text.Trim);
  lRawOp.Fee := StrToCurr(Fee.Text.Trim);
  lRawOp.OpNumber := NextNOp.Text.ToInteger;
{$IFDEF UNITTEST}
  lRawOp.FixedRandomK := KRandom.Text;
{$ENDIF}
  lRawOp.Payload.EncryptionMethod := PayloadEncryptionMethod;
  lRawOp.Payload.Payload := Payload.Text;
  Case lRawOp.Payload.EncryptionMethod Of
    peNone:
      ;
    pePublicKey:
      lRawOp.Payload.Password := FRecipientAccount.enc_pubkey;
    peAES:
      lRawOp.Payload.Password := PasswordEdit.Text;
  End;

  lRawOp.PrivateKey[GetKeyType] := PrivateKey.Text;

  lMultiOp := TPascalCoinMultiOperations.Create;
  lMultiOp.AddRawOperation(lRawOp);
  lOp := lMultiOp.RawData;

  If FExpectedRawOp <> '' Then
  Begin
    {$IFDEF UNITTEST}
    CheckStepValues(lMultiOp);
    {$ELSE}
    If lOp <> FExpectedRawOp Then
    Begin
      Memo1.Lines.Add('RawOp doesn''t match the expected value');
      Memo1.Lines.Add('Expected:');
      Memo1.Lines.Add(FExpectedRawOp);
    End
    Else
      Memo1.Lines.Add('RawOp matches the expected value')
    {$ENDIF}
  End;
  Memo1.Lines.Add('RawOp:');
  Memo1.Lines.Add(lOp);

  If FCanExecute Then
  Begin

  End;
End;

Function TRawOpForm.GetKeyType: TKeyType;
Begin
  Result := TRttiEnumerationType.GetValue<TKeyType>(KeyTypeCombo.Items[KeyTypeCombo.ItemIndex]);
End;

{ TRawOpForm }

Procedure TRawOpForm.InitialiseThis;
Var
  KT: TKeyType;
  PE: TPayloadEncryptionMethod;
Begin
  Inherited;
  KeyTypeCombo.Items.Clear;
  For KT := Low(TKeyType) To High(TKeyType) Do
    KeyTypeCombo.Items.Add(TRttiEnumerationType.GetName<TKeyType>(KT));
  KeyTypeCombo.ItemIndex := 0;

  For PE := Low(TPayloadEncryptionMethod) To High(TPayloadEncryptionMethod) Do
    PayloadEncryptionCombo.Items.Add(TRttiEnumerationType.GetName<TPayloadEncryptionMethod>(PE));
  PayloadEncryptionCombo.ItemIndex := 0;

End;

Procedure TRawOpForm.MenuItem2Click(Sender: TObject);
Begin
  Clear;
End;

Procedure TRawOpForm.PayloadEncryptionComboChange(Sender: TObject);
Begin
  Inherited;
  PasswordLayout.Visible := PayloadEncryptionMethod = peAES;
End;

Function TRawOpForm.PayloadEncryptionMethod: TPayloadEncryptionMethod;
Begin
  If PayloadEncryptionCombo.ItemIndex < 0 Then
    PayloadEncryptionCombo.ItemIndex;
  Result := TRttiEnumerationType.GetValue<TPayloadEncryptionMethod>
    (PayloadEncryptionCombo.Items[PayloadEncryptionCombo.ItemIndex]);
End;

Procedure TRawOpForm.StandardDataActionExecute(Sender: TObject);
Begin
  Clear;
  FromAccount.Text := '3700';
  ToAccount.Text := '7890';
  NextNOp.Text := '2';
  Amount.Text := '3.5';
  Fee.Text := '0.0001';
  Payload.Text := 'EXAMPLE';
  PayloadEncryptionCombo.ItemIndex := 0;
  PrivateKey.Text := '37B799726961D231492823513F5686B3F7C7909DEFF20907D91BF4D24A356624';
  KeyTypeCombo.ItemIndex := KeyTypeCombo.Items.IndexOf('SECP256K1');
  KRandom.Text := 'A235553C44D970D0FC4D0C6C1AF80330BF06E3B4A6C039A7B9E8A2B5D3722D1F';
  OpNumber.Text := '1';

  FExpectedSender := '740E0000';
  FExpectedNOp := '02000000';
  FExpectedReceiver := 'D21E0000';
  FExpectedAmount := 'B888000000000000';
  FExpectedFee := '0100000000000000';
  FExpectedPayload := '4558414D504C45';
  FExpectedPaylen := '0700';
  FExpectedStrToHash := '740E000002000000D21E0000B88800000000000001000000000000004558414D504C45000001';

  FExpectedHash := 'B8C2057F4BA187B7A29CC810DB56B66C7B9361FA64FD77BADC759DD21FF4ABE7';
  FExpectedK := 'A235553C44D970D0FC4D0C6C1AF80330BF06E3B4A6C039A7B9E8A2B5D3722D1F';
  FExpectedHashSig := '37B799726961D231492823513F5686B3F7C7909DEFF20907D91BF4D24A356624';
  FExpectedSignR := 'EFD5CBC12F6CC347ED55F26471E046CF59C87E099513F56F4F1DD49BDFA84C0E';
  FExpectedRLen := '2000';
  FExpectedSignS := '7BCB0D96A93202A9C6F11D90BFDCAB99F513C880C4888FECAC74D9B09618C06E';
  FExpectedSLen := '2000';
  FExpectedSignedTx :=
    '01000000740E000002000000D21E0000B888000000000000010000000000000007004558414D504C450000000000002000EFD5CBC12F6CC347ED55F26471E046CF59C87E099513F56F4F1DD49BDFA84C0E20007BCB0D96A93202A9C6F11D90BFDCAB99F513C880C4888FECAC74D9B09618C06E';
  FExpectedRawOp := '01000000' + FExpectedSignedTx;

  FCanExecute := False;
End;

Procedure TRawOpForm.ToAccountExit(Sender: TObject);
Var
  acct: Cardinal;
Begin
  Inherited;
  FRecipientAccount := Nil;
  If TPascalCoinUtils.IsAccountNumberValid(ToAccount.Text) Then
  Begin
    acct := TPascalCoinUtils.AccountNumber(ToAccount.Text);
    FRecipientAccount := ExplorerAPI.GetAccount(acct);
  End
  Else
    ShowMessage('This is not a valid account number');

End;

End.
