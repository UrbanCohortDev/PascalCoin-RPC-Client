﻿Unit PascalCoin.Consts;

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

Uses System.SysUtils, System.Rtti, System.Generics.Collections;

Type

  /// <summary>
  /// String that contains an hexadecimal value (ex. "4423A39C"). An
  /// hexadecimal string is always an even character length.
  /// </summary>
  HexStr = String;

  /// <summary>
  /// <para>
  /// Pascal Coin currency is a maximum 4 decimal number (ex. 12.1234).
  /// Decimal separator is a "." (dot)
  /// </para>
  /// <para>
  /// Note that Currency and not PASC_Currency is used in the framework.<br />
  /// Currency is limited to 4 decimals (actually stored as Int64).
  /// </para>
  /// To help with formatting you can set the Default Currnecy Defaults <br />
  /// - FormatSettings.CurrencyString := 'P'; <br />
  /// - FormatSettings.CurrencyFormat := 0; <br />
  /// - FormatSettings.CurrencyDecimals := 4;
  /// </summary>
  PASC_Currency = Currency;

  TAccountData = String; // Array [0 .. 31] Of Byte;

  TStringPair = TPair<String, String>;
  TParamPair = TPair<String, variant>;

  TStringPairList = TList<TStringPair>;

  /// <summary>
  ///   How the payload is / is to be encrypted
  /// </summary>
  TPayloadEncryptionMethod = (
    /// <summary>
    ///   Do not encrypt
    /// </summary>
    peNone,
    /// <summary>
    ///   Use the recipients public key
    /// </summary>
    pePublicKey,
    /// <summary>
    ///   Use a password and AES
    /// </summary>
    peAES);

  TKeyStyle = (ksUnknown, ksEncKey, ksB58Key);

  TKeyType = (SECP256K1, SECP384R1, SECP521R1, SECT283K1);

  /// <summary>
  ///   Whether the keys in the wallet are encrypted or not
  /// </summary>
  TEncryptionState = (
    /// <summary>
    /// The wallet is not encrypted
    /// </summary>
    esPlainText,
    /// <summary>
    /// The wallet is encrypted and no valid password has been entered
    /// </summary>
    esEncrypted);

  TECDSA_Signature = Record
    R: String;
    RLen: Integer;
    S: String;
    SLen: Integer;
    procedure Clear;
  End;


Const

  CT_OP_TRANSACTION = $01;
  CT_OP_CHANGEKEY = $02;
  CT_OP_RECOVER = $03;
  // Protocol 2 new operations
  CT_OP_LISTACCOUNTFORSALE = $04;
  CT_OP_DELISTACCOUNT = $05;
  CT_OP_BUYACCOUNT = $06;
  CT_OP_CHANGEKEYSIGNED = $07;
  CT_OP_CHANGEACCOUNTINFO = $08;
  // Protocol 3 new operations
  CT_OP_MULTIOPERATION = $09;  // PIP-0017
  // Protocol 4 new operations
  CT_OP_DATA = $0A;            // PIP-0016

  MAX_PAYLOAD_SIZE = 255;

  // All Approximate Values
  RECOVERY_WAIT_BLOCKS = 420480; // Approx 4 Years
  BLOCKS_PER_YEAR = 105120;
  BLOCKS_PER_MONTH = BLOCKS_PER_YEAR Div 12;
  BLOCKS_PER_DAY = BLOCKS_PER_YEAR Div 365;

  RPC_ERRNUM_INTERNALERROR = 100;
  RPC_ERRNUM_NOTIMPLEMENTED = 101;

  RPC_ERRNUM_METHODNOTFOUND = 1001;
  RPC_ERRNUM_INVALIDACCOUNT = 1002;
  RPC_ERRNUM_INVALIDBLOCK = 1003;
  RPC_ERRNUM_INVALIDOPERATION = 1004;
  RPC_ERRNUM_INVALIDPUBKEY = 1005;
  RPC_ERRNUM_INVALIDACCOUNTNAME = 1006;
  RPC_ERRNUM_NOTFOUND = 1010;
  RPC_ERRNUM_WALLETPASSWORDPROTECTED = 1015;
  RPC_ERRNUM_INVALIDDATA = 1016;
  RPC_ERRNUM_INVALIDSIGNATURE = 1020;
  RPC_ERRNUM_NOTALLOWEDCALL = 1021;

  RPC_ERRNUM_GENERAL_ERROR = 20000;
  RPC_ERRNUM_OPERATION_ERROR = 20001;

  RPC_MULTIPLE_ERRORS = 999999;

  DEEP_SEARCH = -1;

  PASCALCOIN_ENCODING = ['a' .. 'z', '0' .. '9', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+', '{', '}',
    '[', ']', '_', ':', '`', '|', '<', '>', ',', '.', '?', '/', '~'];
  PASCALCOIN_ENCODING_START = ['a' .. 'z', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '+', '{', '}', '[',
    ']', '_', ':', '`', '|', '<', '>', ',', '.', '?', '/', '~'];
  PASCALCOIN_BASE_58 = ['1' .. '9', 'A' .. 'H', 'J' .. 'N', 'P' .. 'Z', 'a' .. 'k', 'm' .. 'z'];
  PASCALCOIN_HEXA = ['0' .. '9', 'a' .. 'f', 'A' .. 'F'];

Implementation

{ TECDSA_Signature }

procedure TECDSA_Signature.Clear;
begin
    R := '';
    RLen := 0;
    S := '';
    SLen := 0;
end;

End.
