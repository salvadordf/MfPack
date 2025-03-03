program LoopbackCapture3;

uses
  Vcl.Forms,
  Common in 'Common.pas',
  Writer in 'Writer.pas',
  UniThreadTimer in 'UniThreadTimer.pas',
  frmMain in 'frmMain.pas' {MainForm},
  LoopbackCapture in 'LoopbackCapture.pas',
  dlgDevices in 'dlgDevices.pas' {DevicesDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDevicesDlg, DevicesDlg);
  Application.Run;
end.
