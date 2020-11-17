Unit DevApp.Utils;

(* ***********************************************************************
  copyright 2019-2020  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http:www.opensource.org/licenses/mit-license.php.

  PascalCoin website http:pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https:github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  PascalCoin.RPC.Interfaces,
  System.Classes,
  System.SysUtils;

Type

  TDevAppUtils = Class
  Public
    Class Procedure AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings;
      Const ExcludePubKey: Boolean = True); Static;
    Class Procedure BlockInfo(ABlock: IPascalCoinBlock; Strings: TStrings); Static;
    Class Procedure OperationInfo(AOp: IPascalCoinOperation; Strings: TStrings); Static;

    Class Function FormatAsTimeToGo(Const ADate: TDateTime): String; Static;
  End;

Implementation

Uses
  System.DateUtils,
  System.Rtti;

Const
  bool_array: Array [Boolean] Of String = ('False', 'True');

  { TDevAppUtils }

Class Procedure TDevAppUtils.AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings;
  Const ExcludePubKey: Boolean = True);
Begin
  Strings.Add('Account: ' + AAccount.account.ToString);
  Strings.Add('Name: ' + AAccount.Name);
  If Not ExcludePubKey Then
    Strings.Add('enc_pubkey: ' + AAccount.enc_pubkey);
  Strings.Add('balance: ' + FormatFloat('#,000.0000', AAccount.balance));
  Strings.Add('balance_s: ' + AAccount.balance_s);
  Strings.Add('n_operation: ' + AAccount.n_operation.ToString);
  Strings.Add('updated_b: ' + AAccount.updated_b.ToString);
  Strings.Add('updated_b_active_mode: ' + AAccount.updated_b_active_mode.ToString);
  Strings.Add('updated_b_passive_mode: ' + AAccount.updated_b_passive_mode.ToString);
  Strings.Add('state: ' + AAccount.state);
  Strings.Add('locked_until_block: ' + AAccount.locked_until_block.ToString);
  Strings.Add('price: ' + FormatFloat('#,000.0000', AAccount.price));
  Strings.Add('seller_account: ' + AAccount.seller_account.ToString);
  Strings.Add('private_sale: ' + AAccount.private_sale.ToString(True));
  Strings.Add('new_enc_pubkey: ' + AAccount.new_enc_pubkey);
  Strings.Add('account_type: ' + AAccount.account_type.ToString);
  Strings.Add('Seal: ' + AAccount.Seal);
  Strings.Add('Data: ' + AAccount.Data); // TEncoding.Unicode.GetString(AAccount.Data));
End;

Class Procedure TDevAppUtils.BlockInfo(ABlock: IPascalCoinBlock; Strings: TStrings);
Begin
  Strings.AddPair('Block', ABlock.block.ToString);
  Strings.AddPair('enc_pubkey', ABlock.enc_pubkey);
  Strings.AddPair('reward', CurrToStr(ABlock.reward));
  Strings.AddPair('reward_s', ABlock.reward_s);
  Strings.AddPair('fee', CurrToStr(ABlock.fee));
  Strings.AddPair('fee_s', ABlock.fee_s);
  Strings.AddPair('ver', ABlock.ver.ToString);
  Strings.AddPair('ver_a', ABlock.ver_a.ToString);
  Strings.AddPair('timestamp', ABlock.timestamp.ToString + ' (' + FormatDateTime('dd/mm/yyyy hh:nn:ss:zz',
    ABlock.TimeStampAsDateTime) + ')');
  Strings.AddPair('target', ABlock.target.ToString);
  Strings.AddPair('nonce', ABlock.nonce.ToString);
  Strings.AddPair('payload', ABlock.payload);
  Strings.AddPair('sbh', ABlock.sbh);
  Strings.AddPair('oph', ABlock.oph);
  Strings.AddPair('pow', ABlock.pow);
  Strings.AddPair('operations', ABlock.operations.ToString);
  Strings.AddPair('maturation', ABlock.maturation.ToString);
  Strings.AddPair('hashratekhs', ABlock.hashratekhs.ToString);
End;

Class Function TDevAppUtils.FormatAsTimeToGo(Const ADate: TDateTime): String;
Var
  y, m, d, h, n, s, z: word;
  r: String;
Begin
  r := '';
  y := 0;
  m := 0;
  d := 0;
  h := 0;
  n := 0;
  s := 0;
  z := 0;

  If ADate >= 1 Then
    DecodeDateTime(ADate + 1, y, m, d, h, n, s, z)
  Else
    DecodeTime(ADate, h, n, s, z);

  y := y - 1900;
  If y > 0 Then
    r := y.ToString + ' years ';

  If m > 0 Then
  Begin
    r := r + m.ToString + 'mths ';
    If y > 0 Then
      Exit(r.Trim);
  End;

  If d > 0 Then
  Begin
    r := r + d.ToString + ' days ';
    If m > 0 Then
      Exit(r.Trim);
  End;

  If h > 0 Then
  Begin
    r := r + h.ToString + ' hours ';
    If d > 0 Then
      Exit(r.Trim);
  End;

  If n > 0 Then
  Begin
    r := r + n.ToString + ' mins ';
    If h > 0 Then
      Exit(r.Trim);
  End;

  result := '!!!!!!!!';

End;

Class Procedure TDevAppUtils.OperationInfo(AOp: IPascalCoinOperation; Strings: TStrings);
Var
  I: Integer;
Begin
  Strings.AddPair('valid', bool_array[AOp.Valid]);
  Strings.AddPair('errors', AOp.Errors);
  Strings.AddPair('block', AOp.block.ToString);
  Strings.AddPair('time', AOp.Time.ToString);
  Strings.AddPair('opblock', AOp.Opblock.ToString);
  Strings.AddPair('maturation', AOp.maturation.ToString);
  Strings.AddPair('optype', AOp.Optype.ToString);
  Strings.AddPair('OperationType', TRttiEnumerationType.GetName<TOperationType>(AOp.OperationType));
  Strings.AddPair('optxt', AOp.Optxt);
  Strings.AddPair('account', AOp.account.ToString);
  Strings.AddPair('amount', CurrToStr(AOp.Amount));
  Strings.AddPair('fee', CurrToStr(AOp.fee));
  Strings.AddPair('balance', CurrToStr(AOp.balance));
  Strings.AddPair('sender_account', AOp.Sender_account.ToString);
  Strings.AddPair('dest_account', AOp.Dest_account.ToString);
  Strings.AddPair('enc_pubkey', AOp.enc_pubkey);
  Strings.AddPair('ophash', AOp.Ophash);
  Strings.AddPair('old_ophash', AOp.Old_ophash);
  Strings.AddPair('subtype', AOp.Subtype);
  Strings.AddPair('signer_account', AOp.Signer_account.ToString);
  Strings.AddPair('n_operation', AOp.n_operation.ToString);
  Strings.AddPair('payload', AOp.payload);
  Strings.AddPair('enc_pubkey', AOp.enc_pubkey);

  If AOp.SendersCount = 0 Then
    Strings.AddPair('Senders', '0')
  Else
  Begin
    Strings.AddPair('SENDERS', AOp.SendersCount.ToString);
    For I := 0 To AOp.SendersCount - 1 Do
    Begin
      Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.sender[I].account.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'n_operation', AOp.sender[I].n_operation.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.sender[I].Amount));
      Strings.AddPair('  ' + I.ToString + ': ' + 'amount_s', AOp.sender[I].Amount_s);
      Strings.AddPair('  ' + I.ToString + ': ' + 'payload', AOp.sender[I].payload);
      Strings.AddPair('  ' + I.ToString + ': ' + 'payloadtype', AOp.sender[I].PayloadType.ToString);
      Strings.Add('');
    End;
  End;

  If AOp.ReceiversCount = 0 Then
    Strings.AddPair('Receivers', '0')
  Else
  Begin
    Strings.AddPair('RECEIVERS', AOp.SendersCount.ToString);
    For I := 0 To AOp.ReceiversCount - 1 Do
    Begin
      Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.receiver[I].account.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.receiver[I].Amount));
      Strings.AddPair('  ' + I.ToString + ': ' + 'amount_s', AOp.receiver[I].Amount_s);
      Strings.AddPair('  ' + I.ToString + ': ' + 'payload', AOp.receiver[I].payload);
      Strings.AddPair('  ' + I.ToString + ': ' + 'payloadtype', AOp.receiver[I].PayloadType.ToString);
      Strings.Add('');
    End;
  End;

  If AOp.ChangersCount = 0 Then
    Strings.AddPair('Changers', '0')
  Else
  Begin
    Strings.AddPair('CHANGERS', AOp.ChangersCount.ToString);
    For I := 0 To AOp.ChangersCount - 1 Do
    Begin
      Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.changers[I].account.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'n_operation', AOp.changers[I].n_operation.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'new_enc_pubkey', AOp.changers[I].new_enc_pubkey);
      Strings.AddPair('  ' + I.ToString + ': ' + 'new_type', AOp.changers[I].new_type);
      Strings.AddPair('  ' + I.ToString + ': ' + 'seller_account', AOp.changers[I].seller_account.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.changers[I].account_price));
      Strings.AddPair('  ' + I.ToString + ': ' + 'locker_until_block', AOp.changers[I].locked_until_block.ToString);
      Strings.AddPair('  ' + I.ToString + ': ' + 'fee', CurrToStr(AOp.changers[I].fee));
      Strings.Add('');
    End;
  End;

End;

End.
