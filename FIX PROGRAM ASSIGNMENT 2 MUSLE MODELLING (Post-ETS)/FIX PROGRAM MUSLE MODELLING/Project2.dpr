program Project2;

uses
  Vcl.Forms,
  UnitMuscleModelling in 'UnitMuscleModelling.pas' {Form2},
  UnitForceGeneration in 'UnitForceGeneration.pas' {FormForceGeneration},
  UnitHillTypeMuscleModel in 'UnitHillTypeMuscleModel.pas' {FormHillTypeMuscleModel};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TFormForceGeneration, FormForceGeneration);
  Application.CreateForm(TFormHillTypeMuscleModel, FormHillTypeMuscleModel);
  Application.Run;
end.
