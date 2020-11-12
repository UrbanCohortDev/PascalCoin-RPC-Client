unit DevApp.Utils;

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

uses PascalCoin.RPC.Interfaces, System.Classes, System.SysUtils;

Type

TDevAppUtils = Class
public
  class procedure AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings;
      const ExcludePubKey: Boolean = True); static;
  class procedure BlockInfo(ABlock: IPascalCoinBlock; Strings: TStrings); static;
  class procedure OperationInfo(AOp: IPascalCoinOperation; Strings: TStrings);
      static;


  class function FormatAsTimeToGo(const ADate: TDateTime): string; static;
End;

implementation

uses System.DateUtils, System.Rtti;

const
bool_array: Array[Boolean] of String = ('False', 'True');

{ TDevAppUtils }

class procedure TDevAppUtils.AccountInfo(AAccount: IPascalCoinAccount; Strings: TStrings; const ExcludePubKey: Boolean = True);
begin
  Strings.Add('Account: ' + AAccount.account.ToString);
  Strings.Add('Name: ' + AAccount.Name);
  if Not ExcludePubkey then
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
  Strings.Add('Data: ' + AAccount.Data); //TEncoding.Unicode.GetString(AAccount.Data));
end;

class procedure TDevAppUtils.BlockInfo(ABlock: IPascalCoinBlock; Strings: TStrings);
begin
  Strings.AddPair('Block', ABlock.block.ToString);
  Strings.AddPair('enc_pubkey', ABlock.enc_pubkey);
  Strings.AddPair('reward', CurrToStr(ABlock.reward));
  Strings.AddPair('reward_s', ABlock.reward_s);
  Strings.AddPair('fee', CurrToStr(ABlock.fee));
  Strings.AddPair('fee_s', ABlock.fee_s);
  Strings.AddPair('ver', ABlock.ver.ToString);
  Strings.AddPair('ver_a', ABlock.ver_a.ToString);
  Strings.AddPair('timestamp', ABlock.timestamp.ToString + ' (' +
      FormatDateTime('dd/mm/yyyy hh:nn:ss:zz', ABlock.TimeStampAsDateTime) + ')');
  Strings.AddPair('target', ABlock.target.ToString);
  Strings.AddPair('nonce', ABlock.nonce.ToString);
  Strings.AddPair('payload', ABlock.payload);
  Strings.AddPair('sbh', ABlock.sbh);
  Strings.AddPair('oph', ABlock.oph);
  Strings.AddPair('pow', ABlock.pow);
  Strings.AddPair('operations', ABlock.operations.ToString);
  Strings.AddPair('maturation', ABlock.maturation.ToString);
  Strings.AddPair('hashratekhs', ABlock.hashratekhs.ToString);
end;

class function TDevAppUtils.FormatAsTimeToGo(const ADate: TDateTime): string;
var y,m,d,h,n,s,z: word;
    r: string;
begin
  r := '';
    y := 0;
    m := 0;
    d := 0;
    h := 0;
    n := 0;
    s := 0;
    z := 0;

    if ADate >= 1 then
       DecodeDateTime(ADate + 1,y,m,d,h,n,s,z)
    else
       DecodeTime(ADate, h,n,s,z);

       y := y - 1900;
    if y > 0 then
       r := y.ToString + ' years ';

    if m > 0 then
    begin
       r := r + m.ToString + 'mths ';
       if y > 0 then
          Exit(r.Trim);
    end;

    if d > 0 then
    begin
      r := r + d.ToString+ ' days ';
      if m > 0 then
         Exit(r.Trim);
    end;

    if h > 0 then
    begin
       r := r + h.ToString + ' hours ';
       if d > 0 then
          exit(r.Trim);
    end;

    if n > 0 then
    begin
      r := r + n.ToString + ' mins ';
      if h > 0 then
         exit(r.Trim);
    end;

    result := '!!!!!!!!';

end;


class procedure TDevAppUtils.OperationInfo(AOp: IPascalCoinOperation; Strings: TStrings);
Var I: Integer;
begin
    Strings.AddPair('valid', bool_array[AOp.Valid]);
    Strings.AddPair('errors', AOp.Errors);
    Strings.AddPair('block', AOp.Block.ToString);
    Strings.AddPair('time', AOp.Time.ToString);
    Strings.AddPair('opblock', AOp.Opblock.ToString);
    Strings.AddPair('maturation', AOp.Maturation.ToString);
    Strings.AddPair('optype', AOp.Optype.ToString);
    Strings.AddPair('OperationType', TRttiEnumerationType.GetName<TOperationType>(AOp.OperationType));
    Strings.AddPair('optxt', AOp.Optxt);
    Strings.AddPair('account', AOp.Account.ToString);
    Strings.AddPair('amount', CurrToStr(AOp.Amount));
    Strings.AddPair('fee', CurrToStr(AOp.Fee));
    Strings.AddPair('balance', CurrToStr(AOp.Balance));
    Strings.AddPair('sender_account', AOp.Sender_account.ToString);
    Strings.AddPair('dest_account', AOp.Dest_account.ToString);
    Strings.AddPair('enc_pubkey', AOp.Enc_PubKey);
    Strings.AddPair('ophash', AOp.Ophash);
    Strings.AddPair('old_ophash', AOp.Old_ophash);
    Strings.AddPair('subtype', AOp.Subtype);
    Strings.AddPair('signer_account', AOp.Signer_account.ToString);
    Strings.AddPair('n_operation', AOp.N_Operation.ToString);
    Strings.AddPair('payload', AOp.Payload);
    Strings.AddPair('enc_pubkey', AOp.Enc_PubKey);

    if AOp.SendersCount = 0 then
       Strings.AddPair('Senders', '0')
    else
    begin
      Strings.AddPair('SENDERS', AOp.SendersCount.ToString);
      for I := 0 to AOp.SendersCount - 1 do
      begin
         Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.sender[I].Account.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'n_operation', AOp.sender[I].N_Operation.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.sender[I].Amount));
         Strings.AddPair('  ' + I.ToString + ': ' + 'amount_s', AOp.sender[I].Amount_s);
         Strings.AddPair('  ' + I.ToString + ': ' + 'payload', AOp.sender[I].Payload);
         Strings.AddPair('  ' + I.ToString + ': ' + 'payloadtype', AOp.sender[I].PayloadType.ToString);
         Strings.Add('');
      end;
    end;

    if AOp.ReceiversCount= 0 then
       Strings.AddPair('Receivers', '0')
    else
    begin
      Strings.AddPair('RECEIVERS', AOp.SendersCount.ToString);
      for I := 0 to AOp.ReceiversCount - 1 do
      begin
         Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.receiver[I].Account.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.receiver[I].Amount));
         Strings.AddPair('  ' + I.ToString + ': ' + 'amount_s', AOp.receiver[I].Amount_s);
         Strings.AddPair('  ' + I.ToString + ': ' + 'payload', AOp.receiver[I].Payload);
         Strings.AddPair('  ' + I.ToString + ': ' + 'payloadtype', AOp.receiver[I].PayloadType.ToString);
         Strings.Add('');
      end;
    end;

    if AOp.ChangersCount = 0 then
       Strings.AddPair('Changers', '0')
    else
    begin
      Strings.AddPair('CHANGERS', AOp.ChangersCount.ToString);
      for I := 0 to AOp.ChangersCount - 1 do
      begin
         Strings.AddPair('  ' + I.ToString + ': ' + 'account', AOp.changers[I].Account.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'n_operation', AOp.changers[I].N_Operation.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'new_enc_pubkey', AOp.changers[I].new_enc_pubkey);
         Strings.AddPair('  ' + I.ToString + ': ' + 'new_type', AOp.changers[I].new_type);
         Strings.AddPair('  ' + I.ToString + ': ' + 'seller_account', AOp.changers[I].seller_account.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'amount', CurrToStr(AOp.changers[I].account_price));
         Strings.AddPair('  ' + I.ToString + ': ' + 'locker_until_block', AOp.changers[I].locked_until_block.ToString);
         Strings.AddPair('  ' + I.ToString + ': ' + 'fee', CurrToStr(AOp.changers[I].fee));
         Strings.Add('');
      end;
    end;

end;

end.
