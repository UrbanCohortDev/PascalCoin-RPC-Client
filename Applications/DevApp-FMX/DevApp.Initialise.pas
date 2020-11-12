Unit DevApp.Initialise;

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
  Spring.Collections,
  DevApp.Config.Impl;

Procedure InitialiseApp(AConfig: TDevAppConfig);

Implementation

Uses
  UC.Net.Interfaces,
  UC.HTTPClient.Delphi,
  PascalCoin.RPC.Client,
  PascalCoin.RPC.Interfaces, PascalCoin.RPC.API.Node, PascalCoin.RPC.API.Explorer,
  pascalCoin.RPC.API.Wallet;

Procedure InitialiseApp(AConfig: TDevAppConfig);
Begin

  AConfig.Container.RegisterType<IucHTTPRequest, TDelphiHTTP>;
  AConfig.Container.RegisterType<IPascalCoinRPCClient, TPascalCoinRPCClient>;
  AConfig.Container.RegisterType<IPascalCoinExplorerAPI, TPascalCoinExplorerAPI>;
  AConfig.Container.RegisterType<IPascalCoinWalletAPI, TPascalCoinWalletAPI>;
  AConfig.Container.RegisterType<IPascalCoinNodeAPI, TPascalCoinNodeAPI>;
  AConfig.Container.Build;

End;

End.
