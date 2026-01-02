program ProjectDoublePendulumArm;

uses
  Vcl.Forms,
  UnitDoublePendulumArm in 'UnitDoublePendulumArm.pas' {FormDoublePendulumArm},
  Equation in 'Equation.pas' {FormDoublePendulumMotionEquation};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormDoublePendulumArm, FormDoublePendulumArm);
  Application.CreateForm(TFormDoublePendulumMotionEquation, FormDoublePendulumMotionEquation);
  Application.Run;
end.
