unit DevApp.Shared;

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

Uses DevApp.Config.Impl;


Function Config: TDevAppConfig;

implementation

var _Config: TDevAppConfig;

Function Config: TDevAppConfig;
begin
  if Not Assigned(_Config) then
     _Config := TDevAppConfig.Create();
  Result := _Config;
end;

initialization

finalization
if Assigned(_Config) then
   _Config.Free;

end.
