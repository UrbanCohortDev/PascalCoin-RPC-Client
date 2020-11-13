Program DevApp;

Uses
  System.StartUpCopy,
  FMX.Forms,
  DevApp.Main In 'DevApp.Main.pas' {MainForm} ,
  UC.HTTPClient.Delphi In '..\..\Foundation\UC.HTTPClient.Delphi.pas',
  PascalCoin.RPC.Interfaces In '..\..\Foundation\PascalCoin.RPC.Interfaces.pas',
  UC.Net.Interfaces In '..\..\Foundation\UC.Net.Interfaces.pas',
  DevApp.Initialise In 'DevApp.Initialise.pas',
  DevApp.Config.Impl In 'DevApp.Config.Impl.pas',
  DevApp.Shared In 'DevApp.Shared.pas',
  PascalCoin.RPC.Client In '..\..\Foundation\PascalCoin.RPC.Client.pas',
  PascalCoin.RPC.API.Explorer In '..\..\Foundation\PascalCoin.RPC.API.Explorer.pas',
  PascalCoin.RPC.Node In '..\..\Foundation\PascalCoin.RPC.Node.pas',
  PascalCoin.RPC.Account In '..\..\Foundation\PascalCoin.RPC.Account.pas',
  PascalCoin.RPC.Operation In '..\..\Foundation\PascalCoin.RPC.Operation.pas',
  PascalCoin.Utils In '..\..\Foundation\PascalCoin.Utils.pas',
  PascalCoin.RPC.Consts In '..\..\Foundation\PascalCoin.RPC.Consts.pas',
  DevApp.Base.DetailForm In 'DevApp.Base.DetailForm.pas' {DevBaseForm} ,
  DevApp.Form.NodeStatus In 'DevApp.Form.NodeStatus.pas' {NodeStatusForm} ,
  DevApp.Form.AccountInfo In 'DevApp.Form.AccountInfo.pas' {AccountInfoForm} ,
  DevApp.Utils In 'DevApp.Utils.pas',
  FMX.PlatformUtils In '..\..\AppUtils\FMX.PlatformUtils.pas',
  DevApp.Form.BlockInfo In 'DevApp.Form.BlockInfo.pas' {BlockInfoForm} ,
  PascalCoin.RPC.Block In '..\..\Foundation\PascalCoin.RPC.Block.pas',
  PascalCoin.RPC.API.Base In '..\..\Foundation\PascalCoin.RPC.API.Base.pas',
  PascalCoin.RPC.API.Node In '..\..\Foundation\PascalCoin.RPC.API.Node.pas',
  PascalCoin.RPC.API.Wallet In '..\..\Foundation\PascalCoin.RPC.API.Wallet.pas',
  PascalCoin.RPC.API.Operations In '..\..\Foundation\PascalCoin.RPC.API.Operations.pas',
  PascalCoin.RPC.Exceptions In '..\..\Foundation\PascalCoin.RPC.Exceptions.pas',
  DevApp.Form.PendingInfo In 'DevApp.Form.PendingInfo.pas' {PendingInfo} ,
  UC.Internet.Support In '..\..\AppUtils\UC.Internet.Support.pas';

{$R *.res}

Begin
  InitialiseApp(Config);
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

End.
