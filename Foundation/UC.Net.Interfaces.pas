Unit UC.Net.Interfaces;

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
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

Type

  EucHTTPException = Class(Exception);

{$SCOPEDENUMS ON}
  THTTPStatusType = (OK, Fail, Exception);
{$SCOPEDENUMS OFF}

  IucHTTPRequest = Interface(IInvokable)
    ['{67CDB48B-C4F4-4C0F-BE61-BDA3497CF892}']
    Function GetResponseStr: String;
    Function GetStatusCode: integer;
    Function GetStatusText: String;
    Function GetStatusType: THTTPStatusType;

    Procedure Clear;
    Function Post(AURL: String; AData: String): boolean;
    Function Get(AURL: String): String;

    Property ResponseStr: String Read GetResponseStr;
    Property StatusCode: integer Read GetStatusCode;
    Property StatusText: String Read GetStatusText;
    Property StstusType: THTTPStatusType Read GetStatusType;
  End;

Implementation

End.
