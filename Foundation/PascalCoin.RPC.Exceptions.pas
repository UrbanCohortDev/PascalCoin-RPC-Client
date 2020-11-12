unit PascalCoin.RPC.Exceptions;

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

uses System.SysUtils;

Type

  ERPCException = Class(Exception)
  private
    FStatusCode: Integer;
  public
    constructor Create(AStatusCode: Integer; AMessage: string);
    property StatusCode: Integer read FStatusCode write FStatusCode;
  End;

  ERPCExceptionClass = Class of ERPCException;

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

implementation

uses PascalCoin.RPC.Consts;

Function GetRPCExceptionClass(AStatusCode: Integer): ERPCExceptionClass;
begin
  case AStatusCode of

  RPC_ERRNUM_INTERNALERROR: Result := EInternalException;
  RPC_ERRNUM_NOTIMPLEMENTED: Result := ENotImplementedException;

  RPC_ERRNUM_METHODNOTFOUND: Result := EMethodNotFoundException;
  RPC_ERRNUM_INVALIDACCOUNT: Result := EInvalidException;
  RPC_ERRNUM_INVALIDBLOCK: Result := EInvalidBlockException;
  RPC_ERRNUM_INVALIDOPERATION: Result := EInvalidOperationException;
  RPC_ERRNUM_INVALIDPUBKEY: Result := EInvalidPubKeyException;
  RPC_ERRNUM_INVALIDACCOUNTNAME: Result := EInvalidAccountNameException;
  RPC_ERRNUM_NOTFOUND: Result := ENotFoundException;
  RPC_ERRNUM_WALLETPASSWORDPROTECTED: Result := EPasswordProtectedException;
  RPC_ERRNUM_INVALIDDATA: Result := EInvalidDataException;
  RPC_ERRNUM_INVALIDSIGNATURE: Result := EInvalidSignatureException;
  RPC_ERRNUM_NOTALLOWEDCALL: Result := ENotAllowedException;
  else Result :=  ERPCGeneralException;
  end;
end;

{ ERPCException }

constructor ERPCException.Create(AStatusCode: Integer; AMessage: string);
begin
  inherited Create(AMessage);
  FStatusCode := AStatusCode;
end;

end.
