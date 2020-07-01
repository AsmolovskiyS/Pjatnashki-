unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
  procedure SozdatPaneli; //Создаем панели
  procedure UdalitPaneli; //Удаляем панели
  procedure BaziDanih;    //Заполняем базу данных
  procedure Zapolnit;    //Записываем данные из базы в панели
  procedure Sravnit;     // Сравниваем базы данных
  procedure Click(Sender: TObject); //Нажати на панели (ход)
  procedure Proverka(i, j:Integer);  //Проверяем куда можно сдвинууть ячейку
  procedure Peremeshenie(n1,n2,n3,n4,i,j:integer); //Передвигаем
  procedure KolPlus;   //Увеличиваем уровень
  procedure FormCreate(Sender: TObject); //Первый запуск

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Panel:TPanel;
  Form1: TForm1;
  Kol:Integer;
  Prav : array of array of string;
  Mas : array of array of string;
implementation

uses Unit2;

{$R *.dfm}

//-------------------------------------------------
procedure TForm1.KolPlus;
Begin
Kol:=Kol+1;
UdalitPaneli;
end;
//--------------------------------------------------
procedure TForm1.SozdatPaneli;
 Var i, n,s:Integer;
Begin
n:=0; //Ячека по горизонтали
s:=0; //Ячейка по вертикали
// Создаем Панели
For i:=1 to Kol*Kol do Begin
Panel:=TPanel.Create(Self);
With Panel do begin
 Parent:=Form1;
 Name:='Panel'+IntToStr(i);
 Left:=n*50;
 Top:=s*50;
 OnClick:=Click;
 Width:=50;
 Height:=50;
 Font.Size:=14;
 If n<Kol-1 then begin
   n:=n+1;
   end
   else begin
    n:=0;
    s:=s+1;
    end;
 end;
end;
//Изменяем размер поля
Form1.ClientWidth:= Kol*50;
Form1.ClientHeight:= Kol*50;
BaziDanih;
End;
//----------------------------------------------------
procedure TForm1.UdalitPaneli;
var i:integer;
begin
for i:=ComponentCount-1 downto 0 do begin
 If Components[i].ClassName='TPanel'then begin
   Components[i].Free;
   End;
end;
SozdatPaneli;
end;
//-------------------------------------------------------
procedure TForm1.BaziDanih;
var
x1, y1, x2, y2, d, i, j,z:integer;
begin
//Задаем размеры массивов
SetLength(Prav,Kol,Kol);
SetLength (Mas,Kol,Kol);
//Заполняем массивы
 z:=0;
 For i:=0 to Kol-1 do begin
  For j:=0 to Kol-1 do begin
   z:=z+1;
   Prav [i] [j]:=IntToStr(z);
   Mas[i,j]:=Prav[i,j];
  end;
 end;
 //Последняя ячека должна быть пустой
 Prav [Kol-1] [Kol-1]:='';
 Mas [Kol-1] [Kol-1]:='';

 //Перемешиваем не правельный масив
  x1:=Kol-1;
  y1:=kol-1;
  randomize;
For i:=1 to Kol*Kol*20 do
begin
  repeat
    x2:=x1 ;
    y2:=y1;
    d:=Random(4)+1;
    case d of
      1:dec(x2);
      2:inc (x2);
      3:dec(y2);
      4:inc(y2);
    end;
  until (x2>=0) and(x2<=Kol-1) and (y2>=0) and (y2<=Kol-1);
  Mas[x1,y1]:=Mas[x2,y2];
  Mas[x2,y2]:='';
  x1:=x2;
  y1:=y2;
End;
Zapolnit;
end;
//-------------------------------------------------------------
Procedure TForm1.Zapolnit;
var
i, j,s:integer;
Begin
s:=0;
j:=0;
 for i:=0 to ComponentCount-1 do begin
   If (Components[i] is TPanel) then begin
    TPanel(Components[i]).Caption:=Mas[s][j];
     If j<kol-1 then
      j:=j+1
      else begin
       j:=0;
       s:=s+1;
       end;
   end;
 end;
End;
//-------------------------------------------------------------
Procedure TForm1.Sravnit;
Var
i,j, pob:Integer;
Begin
//Проверяем если оба массива одинаковые то вызываем окно пройденого уровня
For i:=0 to Kol-1 do begin
  for j:=0 to Kol-1 do begin
    If Mas[i,j] = Prav[i,j] then Pob:=1
    else Begin
    Pob:=0;
    exit;
    end;
  end;
end;
If pob=1 then Form2.Show;
End;
//-----------------------------------------------------
procedure TForm1.Click(Sender: TObject);
 var
 mx,my:Integer;
begin
//Определяем на какую панель нажали
 my:=Mouse.CursorPos.X-Form1.Left-4;
 mx:=Mouse.CursorPos.Y-Form1.Top-30;
 my:=my div 50;
 mx:=mx div 50;
 Proverka (mx, my);
end;
//----------------------------------------------------------------
procedure TForm1.Proverka(i, j:Integer);
Begin
//Проверяем в какие стороны можно передвинуть панельку верх, право, низ, лево
  If (i=0) and (j=0) then
     Peremeshenie (0, 1, 1, 0, i, j);
  If (i=0) and (j>0) and (j<Kol-1) then
     Peremeshenie (0, 1,1,1, i,j);
  If (i=0) and (j=Kol-1) then
    Peremeshenie (0,0,1,1, i,j);
  If (i>0) and (i<Kol-1) and (j=0) then
     Peremeshenie (1, 1, 1, 0, i, j);
  If (i>0) and (i<Kol-1) and (j>0) and (j<Kol-1) then
     Peremeshenie (1, 1,1,1, i,j);
  If (i>0) and (i<Kol-1) and (j=Kol-1) then
    Peremeshenie (1,0,1,1, i,j);
  If (i=Kol-1) and (j=0) then
     Peremeshenie (1, 1, 0, 0, i, j);
  If (i=Kol-1) and (j>0) and (j<Kol-1) then
     Peremeshenie (1, 1,0,1, i,j);
  If (i=Kol-1) and (j=Kol-1) then
    Peremeshenie (1,0,0,1, i,j);
end;
//------------------------------------------------------------------
procedure TForm1.Peremeshenie(n1,n2,n3,n4,i,j:integer);
Begin
  If (n1=1) and (Mas [i-1][j]='') then begin
    Mas [i-1][j]:=Mas [i][j];
    Mas [i][j]:='';
    end;
  If (n2=1) and (Mas [i][j+1]='') then begin
    Mas [i][j+1]:=Mas [i][j];
    Mas [i][j]:='';
    end;
  If (n3=1) and (Mas [i+1][j]='') then begin
    Mas [i+1][j]:=Mas [i][j];
    Mas [i][j]:='';
    end;
  If (n4=1) and (Mas [i][j-1]='') then begin
    Mas [i][j-1]:=Mas [i][j];
    Mas [i][j]:='';
    end;
  Zapolnit;
  Sravnit;
end;
//--------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
//Создаем пятнашки 3 на 3
Kol:=3;
UdalitPaneli;
end;

end.
