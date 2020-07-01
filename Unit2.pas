unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
Form1.UdalitPaneli;
Form1.Enabled:=True;
Form2.Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
Form1.KolPlus;
Form1.Enabled:=True;
Form2.Close;
end;

procedure TForm2.FormActivate(Sender: TObject);
begin
Form1.Enabled:=False;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
Form1.Close;
Form2.Close;
end;

end.
