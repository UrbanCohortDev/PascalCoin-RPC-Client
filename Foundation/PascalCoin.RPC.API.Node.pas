unit PascalCoin.RPC.API.Node;

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

Uses
  System.JSON,
  System.Generics.Collections,
  PascalCoin.RPC.Interfaces,
  PascalCoin.RPC.API.Base;

Type

  TPascalCoinNodeAPI = Class(TPascalCoinAPIBase, IPascalCoinNodeAPI)
  protected
    Function NodeStatus: IPascalCoinNodeStatus;
  public
  Constructor Create(AClient: IPascalCoinRPCClient);
  End;

implementation

{ TPascalCoinNodeAPI }

uses PascalCoin.RPC.Node;

constructor TPascalCoinNodeAPI.Create(AClient: IPascalCoinRPCClient);
begin
  inherited Create(AClient);
end;

function TPascalCoinNodeAPI.NodeStatus: IPascalCoinNodeStatus;
begin
  result := Nil;
  If FClient.RPCCall('nodestatus', []) Then
  Begin
    result := TPascalCoinNodeStatus.FromJsonValue(GetJSONResult);
  End;
end;

end.
