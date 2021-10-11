unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons;

type
  TFormCPUSpeed = class(TForm)
    BitBtnStart: TBitBtn;
    BitBtnStop: TBitBtn;
    LabelCPUSpeed: TLabel;
    Label1: TLabel;
    procedure BitBtnStartClick(Sender: TObject);
    procedure BitBtnStopClick(Sender: TObject);
  private
    { Private declarations }
    Stop: Boolean;
  public
    { Public declarations }
  end;

var
  FormCPUSpeed: TFormCPUSpeed;

implementation

{$R *.DFM}

function GetCPUSpeed: Double;
const
 DelayTime = 500;
var
 TimerHi, TimerLo: DWORD;
 PriorityClass, Priority: Integer;
begin
 PriorityClass := GetPriorityClass(GetCurrentProcess);
 Priority := GetThreadPriority(GetCurrentThread);

 SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
 SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);

 Sleep(10);

 asm
  dw 310Fh
  mov TimerLo, eax
  mov TimerHi, edx
 end;

 Sleep(DelayTime);

 asm
  dw 310Fh
  sub eax, TimerLo
  sbb edx, TimerHi
  mov TimerLo, eax
  mov TimerHi, edx
 end;

 SetThreadPriority(GetCurrentThread, Priority);
 SetPriorityClass(GetCurrentProcess, PriorityClass);

 Result := TimerLo / (1000.0 * DelayTime);
end;

procedure TFormCPUSpeed.BitBtnStartClick(Sender: TObject);
begin
 BitBtnStart.Enabled := False;
 BitBtnStop.Enabled := True;

 Stop := False;
 while not Stop do
  begin
   LabelCPUSpeed.Caption := FloatToStr(GetCPUSpeed)+' MHz';
   Application.ProcessMessages;
  end;

 BitBtnStart.Enabled := True;
 BitBtnStop.Enabled := False;
end;

procedure TFormCPUSpeed.BitBtnStopClick(Sender: TObject);
begin
 Stop := True;
end;

end.
