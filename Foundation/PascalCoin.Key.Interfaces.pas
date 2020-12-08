Unit PascalCoin.Key.Interfaces;

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
  PascalCoin.Consts;

Type

  IPascalPublicKey = Interface
    ['{876DD806-4F1B-4BD7-8470-7C9EECEC00B1}']
    Function GetX: TBytes;
    Procedure SetX(Const Value: TBytes);
    Function GetY: TBytes;
    Procedure SetY(Const Value: TBytes);

    Function GetAsHexEncoded: String;
    Procedure SetAsHexEncoded(Const Value: String);
    Function GetAsBase58: String;
    Procedure SetAsBase58(Const Value: String);

    Property X: TBytes Read GetX Write SetX;
    Property Y: TBytes Read GetY Write SetY;
    Property AsHexEncoded: String Read GetAsHexEncoded Write SetAsHexEncoded;
    Property AsBase58: String Read GetAsBase58 Write SetAsBase58;
  End;

  IPascalPrivateKey = Interface
    ['{A335FFED-93ED-487D-A6F5-1781D09210B3}']
    Function GetKey: TBytes;
    Procedure SetKey(Value: TBytes);
    Function GetKeyType: TKeyType;
    Procedure SetKeyType(Const Value: TKeyType);
    Function GetAsHexEncoded: String;
    Procedure SetAsHexEncoded(const Value: String);
    Function GetEncryptionState: TEncryptionState;
    Procedure SetEncryptionState(const Value: TEncryptionState);

    Property Key: TBytes Read GetKey Write SetKey;
    Property KeyType: TKeyType Read GetKeyType Write SetKeyType;
    Property AsHexEncoded: String Read GetAsHexEncoded Write SetAsHexEncoded;
    Property EncryptionState: TEncryptionState read GetEncryptionState write SetEncryptionState;
  End;

  IPascalKey = Interface
    ['{36A48FAD-2CAE-47A4-A36C-893CA877D03F}']
    Function GetPublicKey: IPascalPublicKey;
    Function GetPrivateKey: IPascalPrivateKey;
    Property PublicKey: IPascalPublicKey Read GetPublicKey;
    Property PrivateKey: IPascalPrivateKey Read GetPrivateKey;
  End;

Implementation

End.
