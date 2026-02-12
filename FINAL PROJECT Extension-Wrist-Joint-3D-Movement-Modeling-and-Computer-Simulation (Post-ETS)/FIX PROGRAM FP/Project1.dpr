program Project1;

uses
  Vcl.Forms,
  FinalProject in 'FinalProject.pas' {FormWristJoint},
  MotionEquationUpperLimb in 'MotionEquationUpperLimb.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormWristJoint, FormWristJoint);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
