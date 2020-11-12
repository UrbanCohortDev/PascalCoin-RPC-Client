Unit FMX.PlatformUtils;

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
  FMX.Platform;

Type

  TFMXUtils = Class
  Public
    Class Function TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean; static;
    Class Function CopyToClipboard(const Value: string): Boolean; static;
    Class Function CopyFromClipboard(out Value: String): boolean; static;
  End;

Implementation

uses System.Rtti;

{ TFMXUtils }

class function TFMXUtils.CopyFromClipboard(out Value: String): boolean;
var
  lClipboard: IFMXClipboardService;
  lValue: TValue;
begin
  Result := TryGetClipboardService(lClipboard);
  if Result then
  begin
    lValue := lClipboard.GetClipboard;
    if not lValue.TryAsType(Value) then
      Value := '';
  end;
end;

class function TFMXUtils.CopyToClipboard(const Value: string): Boolean;
var
  lClipboard: IFMXClipboardService;
begin
  Result := TryGetClipboardService(lClipboard);
  if Result then
    lClipboard.SetClipboard(Value);
end;

Class Function TFMXUtils.TryGetClipboardService(Out AClipboard: IFMXClipboardService): boolean;
Begin
  Result := TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService);
  If Result Then
    AClipboard := IFMXClipboardService(TPlatformServices.Current.GetPlatformService(IFMXClipboardService));
End;

End.
