program CPUSpeed;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {FormCPUSpeed};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormCPUSpeed, FormCPUSpeed);
  Application.Run;
end.
