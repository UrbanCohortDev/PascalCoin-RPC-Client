Unit PascalCoin.RPC.Exceptions;

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
  System.SysUtils, PascalCoin.RPC.Messages;

Type

  ENotImplementedInFramework = Class(Exception)
  Public
    Constructor Create;
  End;

  EHexException = class(Exception)
  Public
    Constructor Create(const AValue: string);
  End;

  EBase58Exception = class(Exception)
  Public
    Constructor Create(const AValue: string);
  End;

  EAccountNumberException = class(Exception)
  Public
    constructor Create(const AValue: string);
  End;

  EAccountNameException = class(Exception)
  Public
    constructor Create(const AValue, AReason: string);
  End;

  EDecryptException = class(Exception)
  public
    constructor Create;
  end;

  EUnrecognisedKeyStyle = class(Exception)
  Public
  constructor Create(const AValue: string);
  end;

  EKeyException = class(Exception)
  public
  constructor Create(const AType, AProblem: string);
  end;

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
  EOperationException = Class(ERPCException);

Function GetRPCExceptionClass(AStatusCode: Integer): ERPCExceptionClass;
Function GetRPCExceptionByMethod(AMethod, AMessage: String): ERPCException;

Implementation

Uses
  PascalCoin.Consts;

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

Function GetRPCExceptionByMethod(AMethod, AMessage: String): ERPCException;
begin
  if AMethod = 'executeoperations' then
  begin
     //zero fee operations per block limit:1
     //Invalid n_operation 3 (expected 2)
     //Insufficient sender funds 278 < (1000 + 0 = 1000)
     Result := EOperationException.Create(RPC_ERRNUM_OPERATION_ERROR, AMessage);
  end
  else
    Result := ERPCGeneralException.Create(RPC_ERRNUM_GENERAL_ERROR, Amessage);
end;

{ ERPCException }

Constructor ERPCException.Create(AStatusCode: Integer; AMessage: String);
Begin
  Inherited Create(AMessage);
  FStatusCode := AStatusCode;
End;

{ ENotImplementedInFramework }

Constructor ENotImplementedInFramework.Create;
Begin
  inherited Create(NOT_IMPLEMENTED_IN_FRAMEWORK);
End;

{ EHexaStrException }

constructor EHexException.Create(const AValue: string);
begin
  inherited Create(HEX_ERROR.Replace('$V', AValue));
end;

{ EBase58Exception }

constructor EBase58Exception.Create(const AValue: string);
begin
  inherited Create(BASE58_ERROR.Replace('$V', AValue));
end;

{ EAccountNumberException }

constructor EAccountNumberException.Create(const AValue: string);
begin
  inherited Create(ACCOUNT_NUM_INVALID_FORMAT.Replace('$V', AValue));
end;

{ EAccountNameException }

constructor EAccountNameException.Create(const AValue, AReason: string);
begin
   inherited Create(NAME_INVALID_CONNECTOR.Replace('$V', AValue).Replace('$R', AReason));
end;

{ EDecryptException }

constructor EDecryptException.Create;
begin
  inherited Create(DECRYPTION_FAILED);
end;

{ EUnrecognisedKeyStyle }

constructor EUnrecognisedKeyStyle.Create(const AValue: string);
begin
  inherited Create(UNRECOGNISED_KEY.Replace('$V', AValue));
end;

{ EPublicKeyException }

constructor EKeyException.Create(const AType, AProblem: string);
begin
  inherited Create(PUBLIC_KEY_FAIL.Replace('$T', AType).Replace('$V', AProblem));
end;

End.
