Unit PascalCoin.RPC.Exceptions;

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
  System.SysUtils;

Type

  ENotImplementedInFramework = Class(Exception)
  Public
    Constructor Create;
  End;

  ERPCException = Class(Exception)
  Private
    FStatusCode: Integer;
  Public
    Constructor Create(AStatusCode: Integer; AMessage: String);
    Property StatusCode: Integer Read FStatusCode Write FStatusCode;
  End;

  ERPCExceptionClass = Class Of ERPCException;

  EHTTPException = Class(ERPCException);
  ERPCGeneralException = Class(ERPCException);

  EInternalException = Class(ERPCException);
  ENotImplementedException = Class(ERPCException);
  EMethodNotFoundException = Class(ERPCException);
  EInvalidException = Class(ERPCException);
  EInvalidBlockException = Class(ERPCException);
  EInvalidOperationException = Class(ERPCException);
  EInvalidPubKeyException = Class(ERPCException);
  EInvalidAccountNameException = Class(ERPCException);
  ENotFoundException = Class(ERPCException);
  EPasswordProtectedException = Class(ERPCException);
  EInvalidDataException = Class(ERPCException);
  EInvalidSignatureException = Class(ERPCException);
  ENotAllowedException = Class(ERPCException);

Function GetRPCExceptionClass(AStatusCode: Integer): ERPCExceptionClass;

Implementation

Uses
  PascalCoin.RPC.Consts;

Function GetRPCExceptionClass(AStatusCode: Integer): ERPCExceptionClass;
Begin
  Case AStatusCode Of

    RPC_ERRNUM_INTERNALERROR:
      Result := EInternalException;
    RPC_ERRNUM_NOTIMPLEMENTED:
      Result := ENotImplementedException;

    RPC_ERRNUM_METHODNOTFOUND:
      Result := EMethodNotFoundException;
    RPC_ERRNUM_INVALIDACCOUNT:
      Result := EInvalidException;
    RPC_ERRNUM_INVALIDBLOCK:
      Result := EInvalidBlockException;
    RPC_ERRNUM_INVALIDOPERATION:
      Result := EInvalidOperationException;
    RPC_ERRNUM_INVALIDPUBKEY:
      Result := EInvalidPubKeyException;
    RPC_ERRNUM_INVALIDACCOUNTNAME:
      Result := EInvalidAccountNameException;
    RPC_ERRNUM_NOTFOUND:
      Result := ENotFoundException;
    RPC_ERRNUM_WALLETPASSWORDPROTECTED:
      Result := EPasswordProtectedException;
    RPC_ERRNUM_INVALIDDATA:
      Result := EInvalidDataException;
    RPC_ERRNUM_INVALIDSIGNATURE:
      Result := EInvalidSignatureException;
    RPC_ERRNUM_NOTALLOWEDCALL:
      Result := ENotAllowedException;
  Else
    Result := ERPCGeneralException;
  End;
End;

{ ERPCException }

Constructor ERPCException.Create(AStatusCode: Integer; AMessage: String);
Begin
  Inherited Create(AMessage);
  FStatusCode := AStatusCode;
End;

{ ENotImplementedInFramework }

Constructor ENotImplementedInFramework.Create;
Begin
  self.Message := 'Not yet implemented in framework';
End;

End.
