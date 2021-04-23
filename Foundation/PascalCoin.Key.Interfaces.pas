Unit PascalCoin.Key.Interfaces;

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

Interface

Uses
  System.SysUtils,
  PascalCoin.Consts;

Type

  IPascalPublicKey = Interface
    ['{876DD806-4F1B-4BD7-8470-7C9EECEC00B1}']
    Function GetKey: String;
    Procedure SetKey(Const Value: String);
    Function GetAsBase58: String;
    Procedure SetAsBase58(Const Value: String);
    Function GetKeyType: TKeyType;
    Procedure SetKeyType(Const Value: TKeyType);

    Property Key: String Read GetKey Write SetKey;
    Property KeyType: TKeyType Read GetKeyType Write SetKeyType;
    Property AsBase58: String Read GetAsBase58 Write SetAsBase58;
  End;

  /// <summary>
  ///   Stored as a PascalCoin Private Key. If the KeyRing is encrypted then
  ///   the Key is the encrypted value.
  /// </summary>
  IPascalPrivateKey = Interface
    ['{A335FFED-93ED-487D-A6F5-1781D09210B3}']
    Function GetKey: String;
    Procedure SetKey(Value: String);
    Procedure EncryptKey(Const AOldPassword, ANewPassword: String);
    Property Key: String Read GetKey Write SetKey;
  End;

  IPascalKey = Interface
    ['{36A48FAD-2CAE-47A4-A36C-893CA877D03F}']
    Function GetName: String;
    Procedure SetName(Const Value: String);
    Function GetKeyType: TKeyType;
    Procedure SetKeyType(Const Value: TKeyType);

    Function GetPublicKey: IPascalPublicKey;
    Function GetPrivateKey: IPascalPrivateKey;

    Function GetDecryptedPrivateKey: String;
    Procedure EncryptKey(Const AOldPassword, ANewPassword: String);
    Procedure Unlock(const APassword: String);
    Procedure Lock;

    Property Name: String Read GetName Write SetName;
    Property KeyType: TKeyType Read GetKeyType Write SetKeyType;
    Property PublicKey: IPascalPublicKey Read GetPublicKey;
    Property PrivateKey: IPascalPrivateKey Read GetPrivateKey;
  End;

  IPascalKeyRing = Interface
    ['{D5B6B103-CA76-4DA2-AACD-59A1B7014F89}']
    Function GetKey(Const Index: Integer): IPascalKey;
    Function GetKeyByName(Const AName: String): IPascalKey;
    Function GetEncryptionState: TEncryptionState;
    Function GetName: string;
    Procedure SetName(const Value: String);
    Procedure SaveAs(Const AFileName: String);
    Procedure Save;

    Procedure UnlockWallet(Const APassword: String = '');
    Procedure LockWallet;
    Procedure EncryptWallet(const AOldPassword, ANewPassword: String);

    Function AddKey(Value: IPascalKey): Integer;
    Function KeyCount: Integer;
    Property Key[Const Index: Integer]: IPascalKey Read GetKey;
    Property KeyByName[Const AName: String]: IPascalKey Read GetKeyByName;
    Property EncryptionState: TEncryptionState Read GetEncryptionState;

    Property Name: String read GetName write SetName;

  End;

Implementation

End.
