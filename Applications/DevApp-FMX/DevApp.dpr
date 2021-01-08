Program DevApp;

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  System.StartUpCopy,
  FMX.Forms,
  DevApp.Main in 'DevApp.Main.pas' {MainForm},
  UC.HTTPClient.Delphi in '..\..\Foundation\UC.HTTPClient.Delphi.pas',
  PascalCoin.RPC.Interfaces in '..\..\Foundation\PascalCoin.RPC.Interfaces.pas',
  UC.Net.Interfaces in '..\..\Foundation\UC.Net.Interfaces.pas',
  DevApp.Initialise in 'DevApp.Initialise.pas',
  DevApp.Config.Impl in 'DevApp.Config.Impl.pas',
  DevApp.Shared in 'DevApp.Shared.pas',
  PascalCoin.RPC.Client in '..\..\Foundation\PascalCoin.RPC.Client.pas',
  PascalCoin.RPC.API.Explorer in '..\..\Foundation\PascalCoin.RPC.API.Explorer.pas',
  PascalCoin.RPC.Node in '..\..\Foundation\PascalCoin.RPC.Node.pas',
  PascalCoin.RPC.Account in '..\..\Foundation\PascalCoin.RPC.Account.pas',
  PascalCoin.RPC.Operation in '..\..\Foundation\PascalCoin.RPC.Operation.pas',
  PascalCoin.Utils in '..\..\Foundation\PascalCoin.Utils.pas',
  PascalCoin.Consts in '..\..\Foundation\PascalCoin.Consts.pas',
  DevApp.Base.DetailForm in 'DevApp.Base.DetailForm.pas' {DevBaseForm},
  DevApp.Form.NodeStatus in 'DevApp.Form.NodeStatus.pas' {NodeStatusForm},
  DevApp.Form.AccountInfo in 'DevApp.Form.AccountInfo.pas' {AccountInfoForm},
  DevApp.Utils in 'DevApp.Utils.pas',
  FMX.PlatformUtils in '..\..\AppUtils\FMX.PlatformUtils.pas',
  DevApp.Form.BlockInfo in 'DevApp.Form.BlockInfo.pas' {BlockInfoForm},
  PascalCoin.RPC.Block in '..\..\Foundation\PascalCoin.RPC.Block.pas',
  PascalCoin.RPC.API.Base in '..\..\Foundation\PascalCoin.RPC.API.Base.pas',
  PascalCoin.RPC.API.Node in '..\..\Foundation\PascalCoin.RPC.API.Node.pas',
  PascalCoin.RPC.API.Wallet in '..\..\Foundation\PascalCoin.RPC.API.Wallet.pas',
  PascalCoin.RPC.API.Operations in '..\..\Foundation\PascalCoin.RPC.API.Operations.pas',
  PascalCoin.RPC.Exceptions in '..\..\Foundation\PascalCoin.RPC.Exceptions.pas',
  DevApp.Form.PendingInfo in 'DevApp.Form.PendingInfo.pas' {PendingInfo},
  UC.Internet.Support in '..\..\AppUtils\UC.Internet.Support.pas',
  PascalCoin.RawOp.Send in '..\..\Foundation\PascalCoin.RawOp.Send.pas',
  PascalCoin.RawOp.Base in '..\..\Foundation\PascalCoin.RawOp.Base.pas',
  PascalCoin.RPC.Messages in '..\..\Foundation\PascalCoin.RPC.Messages.pas',
  DevApp.Form.RawOp in 'DevApp.Form.RawOp.pas' {RawOpForm},
  PascalCoin.Key.Interfaces in '..\..\Foundation\PascalCoin.Key.Interfaces.pas',
  PascalCoin.RawOp.Interfaces in '..\..\Foundation\PascalCoin.RawOp.Interfaces.pas',
  PascalCoin.Payload in '..\..\Foundation\PascalCoin.Payload.pas',
  PascalCoin.KeyUtils in '..\..\Foundation\PascalCoin.KeyUtils.pas',
  PascalCoin.RawOp.MultiOperations in '..\..\Foundation\PascalCoin.RawOp.MultiOperations.pas',
  DevApp.Form.MessAbout in 'DevApp.Form.MessAbout.pas' {MessAbout},
  DevApp.Form.RawOp.Analysis in 'DevApp.Form.RawOp.Analysis.pas' {RawOpAnalysis};

{$R *.res}

Begin
  InitialiseApp(Config);
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

End.
