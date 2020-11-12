Unit DevApp.Form.AccountInfo;

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
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  Aurelius.Mapping.Metadata;

Type
  TAccountInfoForm = Class(TDevBaseForm)
    Layout1: TLayout;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    Layout2: TLayout;
    Label2: TLabel;
    PublicKey: TLabel;
    Layout3: TLayout;
    AccountList: TStringGrid;
    StringColumn1: TStringColumn;
    Col2: TStringColumn;
    NumAccountsLabel: TLabel;
    NumAccounts: TLabel;
    LiveCol: TStringColumn;
    LinkedAccountsBtn: TSpeedButton;
    CopyPubKeyBtn: TSpeedButton;
    PastePubKeyBtn: TSpeedButton;
    Layout4: TLayout;
    Memo2: TMemo;
    OpsButton: TButton;
    OpDepth: TEdit;
    Label3: TLabel;
    Procedure AccountListCellClick(Const Column: TColumn; Const Row: Integer);
    Procedure Button1Click(Sender: TObject);
    Procedure CopyPubKeyBtnClick(Sender: TObject);
    Procedure Edit1KeyDown(Sender: TObject; Var Key: Word; Var KeyChar: Char; Shift: TShiftState);
    Procedure LinkedAccountsBtnClick(Sender: TObject);
    Procedure OpsButtonClick(Sender: TObject);
    Procedure PastePubKeyBtnClick(Sender: TObject);
  Private
    { Private declarations }
    FAccounts: Integer;
    FLastAccountIndex: Integer;
    FLatestBlock: Integer;
    Procedure FetchNextAccounts;
    Function DisplayAccountInfo(Const AnAccount: String): String;
    Function SanitiseRecovery(Const DaysToRecovery: Double): String;
  Public
    { Public declarations }
  End;

Var
  AccountInfoForm: TAccountInfoForm;

Implementation

{$R *.fmx}

Uses
  System.DateUtils,
  PascalCoin.Utils,
  PascalCoin.RPC.Interfaces,
  DevApp.Utils,
  FMX.PlatformUtils,
  PascalCoin.RPC.Consts;

Procedure TAccountInfoForm.AccountListCellClick(Const Column: TColumn; Const Row: Integer);
Begin
  Inherited;
  DisplayAccountInfo(AccountList.Cells[0, Row]);
End;

Procedure TAccountInfoForm.Button1Click(Sender: TObject);
Var
  pk: String;
Begin
  pk := DisplayAccountInfo(Edit1.Text);
  If pk <> PublicKey.Text Then
  Begin
    PublicKey.Text := pk;
    AccountList.RowCount := 0;
  End;
End;

Procedure TAccountInfoForm.CopyPubKeyBtnClick(Sender: TObject);
Var
  S: String;
Begin
  Inherited;
  S := PublicKey.Text;
  If S = '' Then
  Begin
    ShowMessage('Set a public key first');
    Exit;
  End;

  If TFMXUtils.CopyToClipboard(S) Then
    ShowMessage('Copied to clipboard')
  Else
    ShowMessage('Can''t copy to clipboard on this platform');

End;

Function TAccountInfoForm.DisplayAccountInfo(Const AnAccount: String): String;
Var
  lAccount: IPascalCoinAccount;
Begin
  If Not TPascalCoinUtils.ValidAccountNumber(AnAccount) Then
  Begin
    ShowMessage('Not a valid account number');
    Exit;
  End;

  Edit1.Text := AnAccount;
  lAccount := ExplorerAPI.GetAccount(TPascalCoinUtils.AccountNumber(AnAccount));

  Memo1.Lines.Clear;
  TDevAppUtils.AccountInfo(lAccount, Memo1.Lines);
  Result := lAccount.enc_pubkey;
End;

Procedure TAccountInfoForm.Edit1KeyDown(Sender: TObject; Var Key: Word; Var KeyChar: Char; Shift: TShiftState);
Begin
  If Key = vkReturn Then
    Button1Click(self);
End;

Procedure TAccountInfoForm.FetchNextAccounts;
Var
  lAccounts: IPascalCoinAccounts;
  I, lastRow: Integer;
Begin
  FLatestBlock := ExplorerAPI.GetBlockCount;
  lAccounts := WalletExplorerAPI.getwalletaccounts(PublicKey.Text, TKeyStyle.ksEncKey, FLastAccountIndex);

  FLastAccountIndex := FLastAccountIndex + lAccounts.Count;
  lastRow := AccountList.RowCount - 1;
  AccountList.RowCount := AccountList.RowCount + lAccounts.Count;
  For I := 0 To lAccounts.Count - 1 Do
  Begin
    inc(lastRow);
    AccountList.Cells[0, lastRow] := TPascalCoinUtils.AccountNumberWithCheckSum(lAccounts[I].Account);
    AccountList.Cells[1, lastRow] := lAccounts[I].Name;
    AccountList.Cells[2, lastRow] := SanitiseRecovery(TPascalCoinUtils.DaysToRecovery(FLatestBlock,
      lAccounts[I].updated_b_active_mode));
  End;

End;

Procedure TAccountInfoForm.LinkedAccountsBtnClick(Sender: TObject);
Begin
  Inherited;
  AccountList.RowCount := 0;
  FLastAccountIndex := -1;
  Try
    FAccounts := WalletExplorerAPI.getwalletaccountscount(PublicKey.Text, TKeyStyle.ksEncKey);
  Except
    On e: Exception Do
      HandleAPIException(e);
  End;
  NumAccounts.Text := FormatFloat('#,##0', FAccounts);
  FetchNextAccounts;
  AccountList.Visible := True;
End;

Procedure TAccountInfoForm.OpsButtonClick(Sender: TObject);
var lDepth: Integer;
Begin
  Inherited;
  if SameText(OpDepth.Text, 'deep') then
     lDepth := DEEP_SEARCH
  else
     lDepth := StrToInt(OpDepth.Text.Trim);
  ExplorerAPI.getaccountoperations(TPascalCoinUtils.AccountNumber(Edit1.Text), lDepth);
End;

Procedure TAccountInfoForm.PastePubKeyBtnClick(Sender: TObject);
Var
  S: String;
Begin
  Inherited;
  If Not TFMXUtils.CopyFromClipboard(S) Then
  Begin
    ShowMessage('Sorry, can''t access the clipboard on this platform');
    Exit;
  End;

  If S = '' Then
  Begin
    ShowMessage('Unable to retrieve the value from teh clipboard');
    Exit;
  End;

  If TPascalCoinUtils.KeyStyle(S) <> TKeyStyle.ksEncKey Then
  Begin
    ShowMessage('Please paste Encoded Public Keys only');
    Exit;
  End;

  Edit1.Text := '';
  Memo1.Lines.Clear;
  PublicKey.Text := S;
  LinkedAccountsBtnClick(self);

End;

Function TAccountInfoForm.SanitiseRecovery(Const DaysToRecovery: Double): String;
Var
  DTR: TDateTime;
  T: Double;
Begin

  T := Frac(DaysToRecovery);
  DTR := IncDay(Now, Trunc(DaysToRecovery)) + T;
  Result := TDevAppUtils.FormatAsTimeToGo(DTR - Now);

End;

End.
