program Project2;

uses
  Vcl.Forms,
  UnitKneeExtension in 'UnitKneeExtension.pas' {Form2},
  UnitEquation in 'UnitEquation.pas' {FormEquation},
  UnitDiagram in 'UnitDiagram.pas' {FormDiagram};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFormEquation, FormEquation);
  Application.CreateForm(TFormDiagram, FormDiagram);
  Application.Run;
end.
