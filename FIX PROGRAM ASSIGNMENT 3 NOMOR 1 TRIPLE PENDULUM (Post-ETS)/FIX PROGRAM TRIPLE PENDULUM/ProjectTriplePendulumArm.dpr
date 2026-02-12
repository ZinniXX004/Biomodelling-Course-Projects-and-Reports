program ProjectTriplePendulumArm;

uses
  Vcl.Forms,
  TriplePendulumArm in 'TriplePendulumArm.pas' {Form1},
  MotionEquationTriplePendulum in 'MotionEquationTriplePendulum.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
