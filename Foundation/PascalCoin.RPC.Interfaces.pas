Unit PascalCoin.RPC.Interfaces;

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
  System.Classes,
  System.Generics.Collections,
  System.JSON,
  System.SysUtils,
  System.Rtti,
  PascalCoin.Consts,
  PascalCoin.RPC.Exceptions;

Type

  TStringPair = TPair<String, String>;
  TParamPair = TPair<String, variant>;

  TSearchType = (stExact, stStartsWith, stNotStartsWith, stContains, stNotContains, stEndsWith, stNotEndsWith);

  TAccountStatusType = (astall, // Default option)
    astForSale, astForPublicSale, astForPrivateSale, astForSwap, astForAccountSwap, astForCoinSwap, astForSaleSwap,
    astNotForSaleSwap);

  IPascalCoinNodeStatus = Interface;

  IPascalCoinRPCClient = Interface
    ['{A04B65F9-345E-44F7-B834-88CCFFFAC4B6}']
    Function GetResponseObject: TJSONObject;
    Function GetResponseStr: String;
    Function GetResultValue: TJSONValue;
    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

    Function RPCCall(Const AMethod: String; Const AParams: Array Of TParamPair): boolean;
    Property ResponseObject: TJSONObject Read GetResponseObject;
    Property ResponseStr: String Read GetResponseStr;
    Property ResultValue: TJSONValue read GetResultValue;
    Property NodeURI: String Read GetNodeURI Write SetNodeURI;
  End;

  IPascalCoinAccount = Interface
    ['{10B1816D-A796-46E6-94DA-A4C6C2125F82}']

    Function GetAccount: Int64;
    Function GetPubKey: HexStr;
    Function GetBalance: Currency;
    Function GetN_Operation: integer;
    Function GetUpdated_b: integer;
    Function GetState: String;
    Function GetLocked_Until_Block: integer;
    Function GetPrice: Currency;
    Function GetSeller_Account: integer;
    Function GetPrivate_Sale: boolean;
    Function GetNew_Enc_PubKey: HexStr;
    Function GetName: String;
    Function GetAccount_Type: integer;
    Function GetBalance_s: String;
    Function GetUpdated_b_active_mode: integer;
    Function GetUpdated_b_passive_mode: integer;
    Function GetSeal: String;
    Function GetData: TAccountData;

    Function SameAs(AAccount: IPascalCoinAccount): boolean;
    Procedure Assign(AAccount: IPascalCoinAccount);

    /// <summary>
    /// Account Number (PASA)
    /// </summary>
    Property account: Int64 Read GetAccount;
    /// <summary>
    /// HEXASTRING - Encoded public key value (See decodepubkey)
    /// </summary>
    Property enc_pubkey: HexStr Read GetPubKey;
    /// <summary>
    /// Account Balance
    /// </summary>
    Property balance: Currency Read GetBalance;
    Property balance_s: String Read GetBalance_s;
    /// <summary>
    /// Operations made by this account (Note: When an account receives a
    /// transaction, n_operation is not changed)
    /// </summary>
    Property n_operation: integer Read GetN_Operation;
    /// <summary>
    /// Last block that updated this account. If equal to blockchain blocks
    /// count it means that it has pending operations to be included to the
    /// blockchain.
    /// </summary>
    Property updated_b: integer Read GetUpdated_b;
    /// <summary>
    /// ActiveMode = Account Buy; Sending (and signer, if not sender) PASC; AccountInfo changed (signer and target)
    /// </summary>
    Property updated_b_active_mode: integer Read GetUpdated_b_active_mode;
    /// <summary>
    /// PassiveMode = Account Sale; Receiving PASC
    /// </summary>
    Property updated_b_passive_mode: integer Read GetUpdated_b_passive_mode;
    /// <summary>
    /// Values can be normal or listed. When listed then account is for sale
    /// </summary>
    Property state: String Read GetState;
    /// <summary>
    /// Until what block this account is locked. Only set if state is listed
    /// </summary>
    Property locked_until_block: integer Read GetLocked_Until_Block;
    /// <summary>
    /// Price of account. Only set if state is listed
    /// </summary>
    Property price: Currency Read GetPrice;
    /// <summary>
    /// Seller's account number. Only set if state is listed
    /// </summary>
    Property seller_account: integer Read GetSeller_Account;
    /// <summary>
    /// Whether sale is private. Only set if state is listed
    /// </summary>
    Property private_sale: boolean Read GetPrivate_Sale;
    /// <summary>
    /// HEXSTRING - Private buyers public key. Only set if state is listed and
    /// private_sale is true
    /// </summary>
    Property new_enc_pubkey: HexStr Read GetNew_Enc_PubKey;
    /// <summary>
    /// Public name of account. Follows PascalCoin64 Encoding. Min Length = 3;
    /// Max Length = 64
    /// </summary>
    Property Name: String Read GetName;
    /// <summary>
    /// Type of account. Valid values range from 0..65535
    /// </summary>
    Property account_type: integer Read GetAccount_Type;

    Property Seal: String Read GetSeal;
    Property Data: TAccountData Read GetData;
  End;

  IPascalCoinAccounts = Interface
    ['{4C039C2C-4BED-4002-9EA2-7F16843A6860}']
    Function GetAccount(Const Index: integer): IPascalCoinAccount;
    Function Count: integer;
    Procedure Clear;
    Function AddAccount(Value: IPascalCoinAccount): integer;
    // procedure AddAccounts(Value: IPascalCoinAccounts);
    Function FindAccount(Const Value: integer): IPascalCoinAccount; Overload;
    Function FindAccount(Const Value: String): IPascalCoinAccount; Overload;
    Function FindNamedAccount(Const Value: String): IPascalCoinAccount;
    Property account[Const Index: integer]: IPascalCoinAccount Read GetAccount; Default;
  End;

  IPascalNetStats = Interface
    ['{0F8214FA-D42F-44A7-9B5B-4D6B3285E860}']
    Function GetActive: integer;
    Function GetClients: integer;
    Function GetServers: integer;
    Function GetServers_t: integer;
    Function GetTotal: integer;
    Function GetTClients: integer;
    Function GetTServers: integer;
    Function GetBReceived: integer;
    Function GetBSend: integer;

    Property active: integer Read GetActive;
    Property clients: integer Read GetClients;
    Property servers: integer Read GetServers;
    Property servers_t: integer Read GetServers_t;
    Property total: integer Read GetTotal;
    Property tclients: integer Read GetTClients;
    Property tservers: integer Read GetTServers;
    Property breceived: integer Read GetBReceived;
    Property bsend: integer Read GetBSend;
  End;

  IPascalCoinServer = Interface
    ['{E9878551-ADDF-4D22-93A5-3832588ACC45}']
    Function GetIP: String;
    Function GetPort: integer;
    Function GetLastCon: integer;
    Function GetAttempts: integer;
    Function GetLastConAsDateTime: TDateTime;
    Property ip: String Read GetIP;
    Property port: integer Read GetPort;
    Property lastcon: integer Read GetLastCon;
    Property LastConAsDateTime: TDateTime Read GetLastConAsDateTime;
    Property attempts: integer Read GetAttempts;
  End;

  IPascalCoinNetProtocol = Interface
    ['{DBAAA45D-5AC1-4805-9FDB-5A6B66B193DC}']
    Function GetVer: integer;
    Function GetVer_A: integer;
    Property ver: integer Read GetVer;
    Property ver_a: integer Read GetVer_A;
    // Net protocol available
  End;

  IPascalCoinNodeStatus = Interface
    ['{9CDDF2CB-3064-4CD6-859A-9E11348FF621}']
    Function GetReady: boolean;
    Function GetReady_S: String;
    Function GetStatus_S: String;
    Function GetPort: integer;
    Function GetLocked: boolean;
    Function GetTimeStamp: integer;
    Function GetVersion: String;
    Function GetNetProtocol: IPascalCoinNetProtocol;
    Function GetBlocks: integer;
    Function GetNetStats: IPascalNetStats;
    Function GetnodeServer(Const Index: integer): IPascalCoinServer;
    Function GetSBH: String;
    Function GetPOW: String;
    Function GetOpenSSL: String;
    Function GetTimeStampAsDateTime: TDateTime;

    Function NodeServerCount: integer;
    Function GetIsTestNet: boolean;

    Property ready: boolean Read GetReady;
    // Must be true, otherwise Node is not ready to execute operations
    Property ready_s: String Read GetReady_S;
    // Human readable information about ready or not
    Property status_s: String Read GetStatus_S;
    // Human readable information about node status... Running, downloading blockchain, discovering servers...
    Property port: integer Read GetPort;
    Property locked: boolean Read GetLocked;
    // True when this wallet is locked, false otherwise
    Property timestamp: integer Read GetTimeStamp;
    // Timestamp of the Node
    Property TimeStampAsDateTime: TDateTime Read GetTimeStampAsDateTime;
    Property version: String Read GetVersion;
    Property netprotocol: IPascalCoinNetProtocol Read GetNetProtocol;
    Property blocks: integer Read GetBlocks;
    // Blockchain blocks
    Property netstats: IPascalNetStats Read GetNetStats;
    // -JSON Object with net information
    // Property nodeservers: TArray<IPascalCoinServer> Read GetNodeServers; // JSON Array with servers candidates
    Property nodeServer[Const Index: integer]: IPascalCoinServer Read GetnodeServer;
    Property sbh: String Read GetSBH;
    Property pow: String Read GetPOW;
    Property openssl: String Read GetOpenSSL;

  End;

  IPascalCoinBlock = Interface
    ['{9BAA406C-BC52-4DB6-987D-BD458C0766E5}']
    Function GetBlock: integer;
    Function GetEnc_PubKey: String;
    Function GetFee: Currency;
    Function GetFee_s: String;
    Function GetHashRateKHS: integer;
    Function GetMaturation: integer;
    Function GetNonce: integer;
    Function GetOperations: integer;
    Function GetOPH: String;
    Function GetPayload: String;
    Function GetPOW: String;
    Function GetReward: Currency;
    Function GetReward_s: String;
    Function GetSBH: String;
    Function GetTarget: integer;
    Function GetTimeStamp: integer;
    Function GetVer: integer;
    Function GetVer_A: integer;

    Function GetTimeStampAsDateTime: TDateTime;

    Property block: integer Read GetBlock;
    // Encoded public key value used to init 5 created accounts of this block (See decodepubkey )
    Property enc_pubkey: String Read GetEnc_PubKey;
    // Reward of first account's block
    Property reward: Currency Read GetReward;
    Property reward_s: String Read GetReward_s;
    // Fee obtained by operations
    Property fee: Currency Read GetFee;
    Property fee_s: String Read GetFee_s;
    Property ver: integer Read GetVer;
    // Pascal Coin protocol available by the miner
    Property ver_a: integer Read GetVer_A;
    // Unix timestamp
    Property timestamp: integer Read GetTimeStamp;
    // target difficulty
    Property target: integer Read GetTarget;
    // nonce used
    Property nonce: integer Read GetNonce;
    // Miner's payload
    Property payload: String Read GetPayload;

    Property sbh: String Read GetSBH;
    Property oph: String Read GetOPH;
    Property pow: String Read GetPOW;
    // Number of operations included in this block
    Property operations: integer Read GetOperations;
    // Estimated network hashrate calculated by previous 50 blocks average
    Property hashratekhs: integer Read GetHashRateKHS;
    // Number of blocks in the blockchain higher than this
    Property maturation: integer Read GetMaturation;
    // helper property
    Property TimeStampAsDateTime: TDateTime Read GetTimeStampAsDateTime;
  End;

  IPascalCoinBlocks = Interface
    ['{9260792F-A849-4DF0-8944-9E500BFCA951}']
    Function GetBlock(Const Index: integer): IPascalCoinBlock;
    Function GetBlockNumber(Const Index: integer): IPascalCoinBlock;
    Function Count: integer;
    Property block[Const Index: integer]: IPascalCoinBlock Read GetBlock; Default;
    Property BlockNumber[Const Index: integer]: IPascalCoinBlock Read GetBlockNumber;
  End;

  /// <summary>
  /// straight integer mapping from the returned opType value
  /// </summary>
  TOperationType = (
    /// <summary>
    /// 0 - Blockchain Reward
    /// </summary>
    BlockchainReward,
    /// <summary>
    /// 1 = Transaction
    /// </summary>
    Transaction,
    /// <summary>
    /// 2 = Change Key
    /// </summary>
    ChangeKey,
    /// <summary>
    /// 3 = Recover Funds (lost keys)
    /// </summary>
    RecoverFunds, // (lost keys)
    /// <summary>
    /// 4 = List account for sale
    /// </summary>
    ListAccountForSale,
    /// <summary>
    /// 5 = Delist account (not for sale)
    /// </summary>
    DelistAccountForSale, // (not for sale)
    /// <summary>
    /// 6 = Buy account
    /// </summary>
    BuyAccount,
    /// <summary>
    /// 7 = Change Key signed by another account
    /// </summary>
    ChangeAccountKey, // (signed by another account)
    /// <summary>
    /// 8 = Change account info
    /// </summary>
    ChangeAccountInfo,
    /// <summary>
    /// 9 = Multi operation (introduced on Build 3.0; PIP-0017)
    /// </summary>
    Multioperation,
    /// <summary>
    /// 10 = Data operation (introduced on Build 4.0; PIP-0016)
    /// </summary>
    DataOp);

  IPascalCoinSender = Interface
    ['{F66B882F-C16E-4447-B881-CC3CFFABD287}']
    Function GetAccount: Cardinal;
    Function GetN_Operation: integer;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexStr;
    Function GetPayloadType: integer;

    /// <summary>
    /// Sending account (PASA)
    /// </summary>
    Property account: Cardinal Read GetAccount;
    Property n_operation: integer Read GetN_Operation;
    /// <summary>
    /// In negative value, due it's outgoing from "account"
    /// </summary>
    Property amount: Currency Read GetAmount;
    Property amount_s: String Read GetAmount_s;
    Property payload: HexStr Read GetPayload;
    Property payloadtype: integer Read GetPayloadType;
  End;

  IPascalCoinReceiver = Interface
    ['{3036AE17-52D6-4FF5-9541-E0B211FFE049}']
    Function GetAccount: Cardinal;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetPayload: HexStr;
    Function GetPayloadType: integer;

    /// <summary>
    /// Receiving account (PASA)
    /// </summary>
    Property account: Cardinal Read GetAccount;
    /// <summary>
    /// In positive value, due it's incoming from a sender to "account"
    /// </summary>
    Property amount: Currency Read GetAmount;
    Property amount_s: String Read GetAmount_s;
    Property payload: HexStr Read GetPayload;
    Property payloadtype: integer Read GetPayloadType;
  End;

  IPascalCoinChanger = Interface
    ['{860CE51D-D0D5-4AF0-9BD3-E2858BF1C59F}']
    Function GetAccount: Cardinal;
    Function GetN_Operation: integer;
    Function GetNew_Enc_PubKey: HexStr;
    Function GetNew_Type: String;
    Function GetSeller_Account: Cardinal;
    Function GetAccount_price: Currency;
    Function GetLocked_Until_Block: UInt64;
    Function GetFee: Currency;

    /// <summary>
    /// changing Account
    /// </summary>
    Property account: Cardinal Read GetAccount;
    Property n_operation: integer Read GetN_Operation;
    /// <summary>
    /// If public key is changed or when is listed for a private sale <br />
    /// property new_name: If name is changed
    /// </summary>
    Property new_enc_pubkey: HexStr Read GetNew_Enc_PubKey;
    /// <summary>
    /// if type is changed
    /// </summary>
    Property new_type: String Read GetNew_Type;
    /// <summary>
    /// If is listed for sale (public or private) will show seller account
    /// </summary>
    Property seller_account: Cardinal Read GetSeller_Account;
    /// <summary>
    /// If is listed for sale (public or private) will show account price
    /// </summary>
    Property account_price: Currency Read GetAccount_price;
    /// <summary>
    /// If is listed for private sale will show block locked
    /// </summary>
    Property locked_until_block: UInt64 Read GetLocked_Until_Block;
    /// <summary>
    /// In negative value, due it's outgoing from "account"
    /// </summary>
    Property fee: Currency Read GetFee;
  End;

  TOpTransactionStyle = (transaction_transaction, transaction_with_auto_buy_account, buy_account,
    transaction_with_auto_atomic_swap);
  // transaction = Sinlge standard transaction
  // transaction_with_auto_buy_account = Single transaction made over an account listed for private sale. For STORING purposes only
  // buy_account = A Buy account operation
  // transaction_with_auto_atomic_swap = Single transaction made over an account listed for atomic swap (coin swap or account swap)

  IPascalCoinOperation = Interface
    ['{0C059E68-CE57-4F06-9411-AAD2382246DE}']
    Function GetValid: boolean;
    Function GetErrors: String;
    Function GetBlock: UInt64;
    Function GetTime: integer;
    Function GetOpblock: integer;
    Function GetMaturation: integer;
    Function GetOptype: integer;
    Function GetOperationType: TOperationType;
    Function GetOptxt: String;
    Function GetAccount: Cardinal;
    Function GetAmount: Currency;
    Function GetAmount_s: String;
    Function GetFee: Currency;
    Function GetFee_s: String;
    Function GetBalance: Currency;
    Function GetSender_account: Cardinal;
    Function GetDest_account: Cardinal;
    Function GetEnc_PubKey: HexStr;
    Function GetOphash: HexStr;
    Function GetOld_ophash: HexStr;
    Function GetSubtype: String;
    Function GetSigner_account: Cardinal;
    Function GetN_Operation: integer;
    Function GetPayload: HexStr;

    Function GetSender(Const Index: integer): IPascalCoinSender;
    Function GetReceiver(Const Index: integer): IPascalCoinReceiver;
    Function GetChanger(Const Index: integer): IPascalCoinChanger;

    Function SendersCount: integer;
    Function ReceiversCount: integer;
    Function ChangersCount: integer;

    /// <summary>
    /// (optional) - If operation is invalid, value=false
    /// </summary>
    Property valid: boolean Read GetValid;
    /// <summary>
    /// (optional) - If operation is invalid, an error description
    /// </summary>
    Property errors: String Read GetErrors;
    /// <summary>
    /// Block number (only when valid)
    /// </summary>
    Property block: UInt64 Read GetBlock;
    /// <summary>
    /// Block timestamp (only when valid)
    /// </summary>
    Property time: integer Read GetTime;
    /// <summary>
    /// Operation index inside a block (0..operations-1). Note: If opblock=-1
    /// means that is a blockchain reward (only when valid)
    /// </summary>
    Property opblock: integer Read GetOpblock;
    /// <summary>
    /// Return null when operation is not included on a blockchain yet, 0 means
    /// that is included in highest block and so on...
    /// </summary>
    Property maturation: integer Read GetMaturation;
    /// <summary>
    /// see TOperationType above
    /// </summary>
    Property optype: integer Read GetOptype;
    /// <summary>
    /// converts optype to TOperationType
    /// </summary>
    Property OperationType: TOperationType Read GetOperationType;
    /// <summary>
    /// Human readable operation type
    /// </summary>
    Property optxt: String Read GetOptxt;
    /// <summary>
    /// Account affected by this operation. Note: A transaction has 2 affected
    /// accounts.
    /// </summary>
    Property account: Cardinal Read GetAccount;
    /// <summary>
    /// Amount of coins transferred from sender_account to dest_account (Only
    /// apply when optype=1)
    /// </summary>
    Property amount: Currency Read GetAmount;
    Property amount_s: String Read GetAmount_s;
    /// <summary>
    /// Fee of this operation
    /// </summary>
    Property fee: Currency Read GetFee;
    Property fee_s: String Read GetFee_s;
    /// <summary>
    /// Balance of account after this block is introduced in the Blockchain.
    /// Note: balance is a calculation based on current safebox account balance
    /// and previous operations, it's only returned on pending operations and
    /// account operations <br />
    /// </summary>
    Property balance: Currency Read GetBalance;
    /// <summary>
    /// Sender account in a transaction (only when optype = 1) <b>DEPRECATED</b>,
    /// use senders array instead
    /// </summary>
    Property sender_account: Cardinal Read GetSender_account;
    /// <summary>
    /// Destination account in a transaction (only when optype = 1) <b>DEPRECATED</b>
    /// , use receivers array instead
    /// </summary>
    Property dest_account: Cardinal Read GetDest_account;
    /// <summary>
    /// HEXASTRING - Encoded public key in a change key operation (only when
    /// optype = 2). See decodepubkey <b>DEPRECATED</b>, use changers array
    /// instead. See commented out enc_pubkey below. A second definition for use
    /// with other operation types: Will return both change key and the private
    /// sale public key value <b>DEPRECATED</b><br />
    /// </summary>
    Property enc_pubkey: HexStr Read GetEnc_PubKey;
    /// <summary>
    /// HEXASTRING - Operation hash used to find this operation in the blockchain
    /// </summary>
    Property ophash: HexStr Read GetOphash;
    /// <summary>
    /// /// &lt;summary&gt; <br />/// HEXSTRING - Operation hash as calculated
    /// prior to V2. Will only be <br />/// populated for blocks prior to V2
    /// activation. <b>DEPRECATED</b><br />
    /// </summary>
    Property old_ophash: HexStr Read GetOld_ophash;
    /// <summary>
    /// Associated with optype param, can be used to discriminate from the point
    /// of view of operation (sender/receiver/buyer/seller ...)
    /// </summary>
    Property subtype: String Read GetSubtype;
    /// <summary>
    /// Will return the account that signed (and payed fee) for this operation.
    /// Not used when is a Multioperation (optype = 9)
    /// </summary>
    Property signer_account: Cardinal Read GetSigner_account;

    Property n_operation: integer Read GetN_Operation;
    Property payload: HexStr Read GetPayload;

    /// <summary>
    /// Will return both change key and the private sale public key value <b>DEPRECATED</b>, use changers array instead
    /// </summary>
    Property enc_pubkey: HexStr Read GetEnc_PubKey;

    /// <summary>
    /// ARRAY of objects with senders, for example in a transaction (optype = 1)
    /// or multioperation senders (optype = 9)
    /// </summary>
    Property sender[Const Index: integer]: IPascalCoinSender Read GetSender;
    /// <summary>
    /// ARRAY of objects - When this is a transaction or multioperation, this array
    /// contains each receiver
    /// </summary>
    Property receiver[Const Index: integer]: IPascalCoinReceiver Read GetReceiver;
    /// <summary>
    /// ARRAY of objects - When accounts changed state
    /// </summary>
    Property changers[Const Index: integer]: IPascalCoinChanger Read GetChanger;

  End;

  IPascalCoinOperations = Interface
    ['{027ACE68-2D60-4E45-A67F-6DB53CE6191E}']
    Function GetOperation(Const Index: integer): IPascalCoinOperation;

    Function Count: integer;
    Property Operation[Const Index: integer]: IPascalCoinOperation Read GetOperation; Default;
  End;

  IPascalCoinConnection = Interface
    ['{C925AB61-8000-4165-99E0-13E6BA74F9A7}']
  End;

  IPascalCoinConnections = Interface
    ['{FFC86F9F-48C3-4A6E-9E8D-D20886D72F2A}']
  End;

  IPascalCoinBaseAPI = Interface
    ['{2EB22047-B7CE-4B6E-8B78-EFB4E8F349F4}']
    Function GetNodeURI: String;
    Procedure SetNodeURI(Const Value: String);

    Function GetLastError: String;

    Function GetJSONResult: TJSONValue;
    Function GetJSONResultStr: String;

    Property JSONResult: TJSONValue Read GetJSONResult;
    Property JSONResultStr: String Read GetJSONResultStr;
    Property NodeURI: String Read GetNodeURI Write SetNodeURI;
    Property LastError: String Read GetLastError;

  End;

  IPascalCoinNodeAPI = Interface(IPascalCoinBaseAPI)
    ['{C650A953-E3D7-4ED7-B942-7A6B0B6FC1ED}']
    Function NodeStatus: IPascalCoinNodeStatus;

    /// <param name="nodes">
    /// String containing 1 or multiple IP:port separated by ";" <br />
    /// </param>
    Function addnode(Const nodes: String): integer;
    Function getconnections: IPascalCoinConnections;
    Function stopnode: boolean;
    Function startnode: boolean;
    Function cleanblacklist: boolean;
    Function node_ip_stats: IPascalNetStats;

  End;

  IPascalCoinExplorerAPI = Interface(IPascalCoinBaseAPI)
    ['{310A40ED-F917-4075-B495-5E4906C4D8EB}']

    Function GetBlockCount: integer;
    Function GetBlock(Const BlockNumber: integer): IPascalCoinBlock;

    /// <summary>
    /// getblocks returns a JSON Array with blocks information from "start" to "end"
    /// (or "last" n blocks) Blocks are returned in DESCENDING order See
    /// getblock <br />Note: Must use param <b>last</b> alone, or <b>start</b>
    /// and end <br />
    /// This are implemnted as two methods to simplify usage. This calls getblocks with the "last" param<br />
    /// </summary>
    /// <param name="ACount">
    /// Last n blocks inthe blockchain (n&gt;0 and n&lt;=1000) <br />
    /// </param>
    Function GetLastBlocks(Const ACount: integer): IPascalCoinBlocks;
    /// <summary>
    /// makes a call to getblocks with "start" to "end"
    /// </summary>
    Function GetBlockRange(Const AStart, AEnd: integer): IPascalCoinBlocks;

    /// <summary>
    /// Find blocks by name/type
    /// </summary>
    /// <param name="APayload">
    /// value to search payload with
    /// </param>
    /// <param name="ASearchType">
    /// default "startswith"
    /// </param>
    /// <param name="AStart">
    /// default = 0
    /// </param>
    /// <param name="AEnd">
    /// default = -1 (no limit)
    /// </param>
    /// <param name="AMax">
    /// default = 100
    /// </param>
    Function FindBlocks(Const APayload: String; Const ASearchType: TSearchType; Const APubKey: HexStr;
      Const AKeyStyle: TKeyStyle; Const AStart: integer = 0; Const AEnd: integer = -1; Const AMax: integer = 100)
      : IPascalCoinBlocks;

    /// <summary>
    /// Params <br />block : Integer - Block number <br />opblock : Integer -
    /// Operation <br />
    /// </summary>
    /// <param name="block">
    /// Block Number
    /// </param>
    /// <param name="opblock">
    /// Operation Index (0..operations-1) of this block
    /// </param>
    Function getblockoperation(Const Ablock, Aopblock: integer): IPascalCoinOperation;

    /// <param name="ABlock">
    /// Block Number
    /// </param>
    /// <param name="AStart">
    /// Start with operation index (default 0)
    /// </param>
    /// <param name="Amax">
    /// Maximum number of operations to retrieve
    /// </param>
    Function getblockoperations(Const Ablock: integer; Const AStart: integer = 0; Const AMax: integer = 100)
      : IPascalCoinOperations;

    /// <summary>
    /// Returns node pending buffer count ( New on Build 3.0 )
    /// </summary>
    Function getpendingscount: integer;

    /// <summary>
    /// Get pending operations to be included in the blockchain
    /// </summary>
    /// <param name="AStart">
    /// Start at index
    /// </param>
    /// <param name="AMax">
    /// Number to return. Setting this as 0 returns all pending transactions
    /// </param>
    Function getpendings(Const AStart: integer = 0; Const AMax: integer = 100): IPascalCoinOperations;

    Function findoperation(Const AOpHash: HexStr): IPascalCoinOperation;

    /// <summary>
    ///   Standard GetAccount using the base account number
    /// </summary>
    Function GetAccount(Const AAccountNumber: Cardinal): IPascalCoinAccount; overload;
    Function GetAccount(Const AAccountNumber: String): IPascalCoinAccount; overload;
    /// <summary>
    /// Find Accounts
    /// </summary>
    /// <param name="AName">
    /// returns the account that matches this name
    /// </param>
    /// <param name="ASearchType">
    /// Default: exact. the exact param has been deprecated
    /// </param>
    /// <param name="AType">
    /// returns any accounts with this type
    /// </param>
    /// <param name="AStart">
    /// Start account (by default, 0) - NOTE: Is the "start account number",
    /// when executing multiple calls you must set start value to the latest
    /// returned account number + 1. When searching by public key the start
    /// param value is the position of indexed public keys list instead of
    /// accounts numbers. <br />
    /// </param>
    /// <param name="AMax">
    /// Max of accounts returned in array (by default, 100)
    /// </param>
    /// <param name="AMin_Balance">
    /// If have value, will filter by current account balance
    /// </param>
    /// <param name="AMax_Balance">
    /// If have value, will filter by current account balance
    /// </param>
    /// <param name="APubKey">
    /// Will return accounts with this public key
    /// </param>
    /// <param name="AKeyStyle">
    /// ksEncKey, ksB58Key
    /// </param>
    Function FindAccounts(Const AName: String; Const ASearchType: TSearchType; Const AType: integer;
      Const AStart: integer; Const AMax: integer; Const AMin_Balance: Currency; AMax_Balance: Currency;
      Const APubKey: HexStr; Const AKeyStyle: TKeyStyle; Const AAccountStatus: TAccountStatusType = astall)
      : IPascalCoinAccounts;
    /// <summary>
    /// Simplified call for finding account by name. Exact = True
    /// </summary>
    Function FindAccountByName(Const AName: String): IPascalCoinAccount;
    /// <summary>
    /// Simplified call for finding accounts by name. Exact = False
    /// </summary>
    Function FindAccountsByName(Const AName: String; Const ASearchType: TSearchType = stContains;
      Const AStart: integer = 0; Const AMax: integer = 100): IPascalCoinAccounts;
    /// <summary>
    /// Simplified call for finding accounts by key
    /// </summary>
    Function FindAccountsByKey(Const APubKey: HexStr; Const AKeyStyle: TKeyStyle = ksEncKey; Const AStart: integer = 0;
      Const AMax: integer = 100): IPascalCoinAccounts;

    /// <summary>
    /// Get operations made to an account <br />
    /// </summary>
    /// <param name="AAcoount">
    /// Account number (0..accounts count-1)
    /// </param>
    /// <param name="ADepth">
    /// Optional, default value 100 Depth to search on blocks where this
    /// account has been affected. Allowed to use deep as a param name too.
    /// </param>
    /// <param name="AStart">
    /// Optional, default = 0. If provided, will start at this position (index
    /// starts at position 0). If start is -1, then will include pending
    /// operations, otherwise only operations included on the blockchain
    /// </param>
    /// <param name="AMax">
    /// Optional, default = 100. If provided, will return max registers. If not
    /// provided, max=100 by default
    /// </param>
    Function getaccountoperations(Const AAccount: Cardinal; Const ADepth: integer = 100; Const AStart: integer = 0;
      Const AMax: integer = 100): IPascalCoinOperations;

  End;

  /// <summary>
  /// This has been created as an extended explorer to contain explorer
  /// methods which require the node to have the AllowUsePrivateKeys set to
  /// true and access to the wallet
  /// </summary>
  IPascalCoinWalletAPI = Interface(IPascalCoinExplorerAPI)
    ['{1FE4E934-1B75-4614-8EAA-5F71CA27C237}']
    Function getwalletaccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; Const AStartIndex: integer = 0;
      Const AMaxCount: integer = 100): IPascalCoinAccounts;

    // Support Methods
    Procedure AddWalletAccounts(Const APublicKey: String; Const AKeyStyle: TKeyStyle; AAccountList: IPascalCoinAccounts;
      Const AStartIndex: integer; Const AMaxCount: integer = 100);
    Function getwalletaccountscount(Const APublicKey: String; Const AKeyStyle: TKeyStyle): integer;


    // Function getwalletcoins(const APublicKey: String): Currency;
    // Function getwalletpubkeys - PK
    // Function getwalletpubkey - PK
    // Function importpubkey

    // Function sendto - PK
    // Function signsendto - PK
    // Function changekey - PK
    // Function changekeys - PK
    // Function signchangekey - PK
    // Function listaccountforsale - PK
    // Function signlistaccountforsale - PK
    // Function delistaccountforsale - PK
    // Function signdelistaccountforsale - PK
    // Function buyaccount - PK
    // Function signbuyaccount - PK
    // Function changeaccountinfo - PK
    // Function signchangeaccountinfo - PK
    // Function signmessage - PK

  End;

  IPascalCoinOperationsAPI = Interface(IPascalCoinBaseAPI)
    ['{111BF45E-B203-4E9E-A639-5D837EDFCC3F}']

    /// <summary>
    /// Encrypt a text "payload" using "payload_method" <br /><br /><br /><br />
    /// </summary>
    /// <param name="APayload">
    /// HEXASTRING - Text to encrypt in hexadecimal format
    /// </param>
    /// <param name="AKey">
    /// enc_pubkey : HEXASTRING <br />or <br />b58_pubkey : String
    /// </param>
    /// <param name="AKeyStyle">
    /// ksEncKey or ksB58Key
    /// </param>
    /// <returns>
    /// Returns a HEXASTRING with encrypted payload
    /// </returns>
    Function payloadEncryptWithPublicKey(Const APayload: String; Const AKey: String;
      Const AKeyStyle: TKeyStyle): String;

    Function executeoperations(Const RawOperationsArray: String): IPascalCoinOperations;
    Function executeoperation(Const RawOperation: String): IPascalCoinOperation;

    // Function verifysign

  End;

Const
  KEY_STYLE_NAME: Array [TKeyStyle] Of String = ('', 'enc_pubkey', 'b58_pubkey');

  SEARCH_TYPE: Array [TSearchType] Of String = ('exact', 'startswith', 'not-startswith', 'contains', 'not-contains',
    'endswith', 'not-endswith');

  DEFAULT_NAME_SEARCH = stExact;
  DEFAULT_BLOCK_SEARCH = stStartsWith;

  ACCOUNT_STATUS_TYPE: Array [TAccountStatusType] Of String = ('all', 'for-sale', 'for-public-sale', 'for-private-sale',
    'for-swap', 'for-account-swap', 'for-coin-swap', 'for-sale-swap', 'not-for-sale-swap');

  DEFAULT_ACCOUNT_STATUS_TYPE = astall;

Implementation

End.
