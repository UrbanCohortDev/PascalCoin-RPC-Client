unit PascalCoin.RPC.Consts;

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

const

  //All Approximate Values
  RECOVERY_WAIT_BLOCKS = 420480; //Approx 4 Years
  BLOCKS_PER_YEAR = 105120; //Approx
  BLOCKS_PER_MONTH = BLOCKS_PER_YEAR div 12;
  BLOCKS_PER_DAY = BLOCKS_PER_YEAR div 365;

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

  RPC_MULTIPLE_ERRORS = 999999;

  DEEP_SEARCH = -1;

  PASCALCOIN_ENCODING = ['a' .. 'z', '0' .. '9', '!', '@', '#', '$', '%', '^',
    '&', '*', '(', ')', '-', '+', '{', '}', '[', ']', '_', ':', '`', '|', '<',
    '>', ',', '.', '?', '/', '~'];
  PASCALCOIN_ENCODING_START = ['a' .. 'z', '!', '@', '#', '$', '%', '^', '&', '*',
    '(', ')', '-', '+', '{', '}', '[', ']', '_', ':', '`', '|', '<', '>', ',',
    '.', '?', '/', '~'];
  PASCALCOIN_BASE_58 = ['1' .. '9', 'A' .. 'H', 'J' .. 'N', 'P' .. 'Z',
    'a' .. 'k', 'm' .. 'z'];
  PASCALCOIN_HEXA = ['0'..'9', 'a'..'f', 'A'..'F'];

implementation

end.
