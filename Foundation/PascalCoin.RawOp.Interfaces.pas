Unit PascalCoin.RawOp.Interfaces;

(* ***********************************************************************
  copyright 2019-2021  Russell Weetch
  Distributed under the MIT software license, see the accompanying file
  LICENSE or visit http://www.opensource.org/licenses/mit-license.php.

  PascalCoin website http://pascalcoin.org

  PascalCoin Delphi RPC Client Repository
  https://github.com/UrbanCohortDev/PascalCoin-RPC-Client

  PASC Donations welcome: Account (PASA) 1922-23
  BitCoin: 3DPfDtw455qby75TgL3tXTwBuHcWo4BgjL (now isn't the Pascal way easier?)

  ===========================================================================================
  The majority of this unit is derived from uPascalCoinKeyTool.pas from the tools library by
  Ugochukwu Mmaduekwe ( Copyright (c) 2018 ) Licensed and provided under The MIT License (MIT).

  The original project can be found at https://github.com/PascalCoinDev/PascalCoinTools

  Some elements are taken derived from Core/UPCCryptoLib4Pascal.pas by Albert Molina
  (Copyright (c) 2019)
  ===========================================================================================

  THIS LICENSE HEADER MUST NOT BE REMOVED.

  *********************************************************************** *)

Interface

Uses
  System.SysUtils,
  PascalCoin.Consts,
  PascalCoin.Key.Interfaces;

Type

  TPayloadType = (

    /// <summary>
    /// Payload encryption and encoding method not specified.
    /// </summary>
    ptNonDeterministic,

    /// <summary>
    /// Unencrypted, public payload.
    /// </summary>
    ptPublic,

    /// <summary>
    /// ECIES encrypted using recipient accounts public key.
    /// </summary>
    ptRecipientKeyEncrypted,

    /// <summary>
    /// ECIES encrypted using sender accounts public key.
    /// </summary>
    ptSenderKeyEncrypted,

    /// <summary>
    /// AES encrypted using pwd param
    /// </summary>
    ptPasswordEncrypted,

    /// <summary>
    /// E-PASA addressed by account name (not number).
    /// </summary>
    ptAddressedByName

    );

  TPayloadEncoding = (
    /// <summary>
    /// Payload data encoded in ASCII
    /// </summary>
    ptAsciiFormatted,

    /// <summary>
    /// Payload data encoded in HEX
    /// </summary>
    ptHexFormatted,

    /// <summary>
    /// Payload data encoded in Base58
    /// </summary>
    ptBase58Formatted

    );

  IPascalCoinPayload = Interface
    ['{8C45BE7B-2C5F-40F0-B854-7EEA7F9D597D}']
    Function GetPayload: String;
    Function GetEncryptionMethod: TPayloadEncryptionMethod;
    Function GetPassword: String;
    Procedure SetEncryptionMethod(Const Value: TPayloadEncryptionMethod);
    Procedure SetPassword(Const Value: String);
    Procedure SetPayload(Const Value: String);
    Function GetHexEncode: Boolean;
    Procedure SetHexEncode(Const Value: Boolean);
    Function GetPayloadType: TPayloadType;
    Procedure SetPayloadType(Const Value: TPayloadType);
    Function GetPayloadLength: Integer;

    Function GetEncryptedBytes: TBytes;
    Function GetAsHex: String;
    Procedure Clear;

    /// <summary>
    /// The plain text value to encode/encrypt
    /// </summary>
    Property Payload: String Read GetPayload Write SetPayload;
    /// <summary>
    /// Whether the plain text should be Hex Encoded before encryption
    /// </summary>
    Property HexEncode: Boolean Read GetHexEncode Write SetHexEncode;
    /// <summary>
    /// The encryption method to be used
    /// </summary>
    Property EncryptionMethod: TPayloadEncryptionMethod Read GetEncryptionMethod Write SetEncryptionMethod;
    /// <summary>
    /// As described on PIP-0027 (introduced on Protocol V5) <br />the
    /// payload of an operation will contain an initial byte that will <br />
    /// provide information about the payload content.
    /// </summary>
    Property PayloadType: TPayloadType Read GetPayloadType Write SetPayloadType;
    /// <summary>
    /// The encryption password if AES encryption is selected
    /// </summary>
    Property Password: String Read GetPassword Write SetPassword;

    /// <summary>
    /// The payload encoded as a hex string after encryption if required
    /// </summary>
    Property AsHex: String Read GetAsHex;
    /// <summary>
    /// The payload as TBytes, encrypted if required
    /// </summary>
    Property EncryptedBytes: TBytes Read GetEncryptedBytes;
    /// <summary>
    /// The length of the final payload Bytes
    /// </summary>
    Property PayloadLength: Integer Read GetPayloadLength;

  End;

  IPascalCoinRawOperation = Interface
    ['{2B3FCA04-4681-4980-8772-941B17EE5A0E}']
    Function GetRawOp: String;
    Function GetPrivateKey(Const AKeyType: TKeyType): String;
    Procedure SetPrivateKey(Const AKeyType: TKeyType; Const Value: String);
    Function GetPayload: IPascalCoinPayload;
    Procedure SetPayload(Const Value: IPascalCoinPayload);

    {$IFDEF UNITTEST}
    Function GetFixedRandomK: String;
    function TestValue(const AKey: string): string;
    Procedure SetFixedRandomK(const Value: String);
    Property FixedRandomK: String read GetFixedRandomK write SetFixedRandomK;
    {$ENDIF}

    Property RawOp: String Read GetRawOp;
    Property PrivateKey[Const AKeyType: TKeyType]: String Read GetPrivateKey Write SetPrivateKey;
    /// <summary>
    /// This is the encrypted/hex payload to be used in the operation
    /// </summary>
    Property Payload: IPascalCoinPayload Read GetPayload Write SetPayload;

  End;

    IPascalCoinMultiOperations = interface
    ['{3850F193-355D-402E-8F69-21D35B636DA4}']
    function GetRawOperation(const Index: integer): IPascalCoinRawOperation;
    function GetRawData: string;

    function AddRawOperation(Value: IPascalCoinRawOperation): integer;
    function Count: Integer;
    property RawData: string read GetRawData;
    property RawOperation[const Index: integer]: IPascalCoinRawOperation read GetRawOperation; default;
  end;


  IPascalCoinRawSend = Interface(IPascalCoinRawOperation)
    ['{12EE78A2-D165-49FF-B558-CA303E807A41}']
    Function GetAmount: Currency;
    Function GetReceiverAccount: String;
    Function GetSenderAccount: String;
    Procedure SetAmount(Const Value: Currency);
    Procedure SetReceiverAccount(Const Value: String);
    Procedure SetSenderAccount(Const Value: String);
    Function GetFee: Currency;
    Procedure SetFee(Const Value: Currency);
    Function GetOpNumber: Integer;
    Procedure SetOpNumber(Const Value: Integer);

    Property SenderAccount: String Read GetSenderAccount Write SetSenderAccount;
    Property ReceiverAccount: String Read GetReceiverAccount Write SetReceiverAccount;
    Property Amount: Currency Read GetAmount Write SetAmount;
    Property Fee: Currency Read GetFee Write SetFee;
    Property OpNumber: Integer Read GetOpNumber Write SetOpNumber;

  End;

Implementation

End.
