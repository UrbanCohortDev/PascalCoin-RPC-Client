unit PascalCoin.RPC.Messages;

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

interface


ResourceString

NOT_IMPLEMENTED_IN_FRAMEWORK = 'Not yet implemented in framework';

HEX_ERROR = '$V is not a valid PascalCoin Hex Encoded string';
BASE58_ERROR = '$V is not a valid Base 58 encoding';

ACCOUNT_NUM_INVALID_FORMAT = '$V is not a valid Account Number format';

NAME_INVALID_CONNECTOR = '$V is invalid because it $R';
NAME_TOO_SHORT = 'must be longer than 3 characters';
NAME_TOO_LONG = 'cannot be longer than 64 characters';
NAME_INVALID_START = 'cannot start with "$"';
NAME_CONTAINS_INVALID_CHARACTERS = 'contains invalid characters';

DECRYPTION_FAILED = 'The decryption failed';
UNRECOGNISED_KEY = '$V has an unrecognised key format';
INVALID_KEY_TYPE = 'Invalid or corrupt public key';
PUBLIC_KEY_FAIL = '$T key error: $V';
KEY_X_ERROR =   'Error Extracting X Coord From PascalCoin Public Key.';
KEY_Y_ERROR =   'Error Extracting Y Coord From PascalCoin Public Key.';

KEY_HEADER_FAILED_MATCH = 'PascalCoin Public Key Header Does Not Match Selected Key Type.';


implementation

end.
