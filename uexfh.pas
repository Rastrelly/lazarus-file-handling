unit uexfh;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type

  { TForm1 }

  dta=record
    x,y:real;
  end;

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid1: TStringGrid;
    procedure outputcdta;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  x1,x2:real;
  i,j,n:integer;
  d,w:real;
  cdta:array of dta;

  datafile:TextFile;

implementation

{$R *.lfm}

{ TForm1 }

procedure tform1.outputcdta;
begin
    StringGrid1.RowCount:=length(cdta)+1;
    StringGrid1.ColCount:=3;
    for i:=0 to (StringGrid1.RowCount-2) do
    begin
      StringGrid1.Cells[0,i+1]:=inttostr(i);
      StringGrid1.Cells[1,i+1]:=floattostr(cdta[i].x);
      StringGrid1.Cells[2,i+1]:=floattostr(cdta[i].y);
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TryStrToFloat(edit1.text,x1);
  TryStrToFloat(edit2.text,x2);
  TryStrToInt  (edit3.text,n);
  w:=x2-x1;
  d:=w/n;
  SetLength(cdta,n);
  for i:=0 to n-1 do
  begin
    cdta[i].x:=x1+d*i;
    cdta[i].y:=10*sin(0.1*cdta[i].x);
  end;
  outputcdta;
end;

procedure TForm1.Button2Click(Sender: TObject);
var fline:string;
begin
  AssignFile(datafile,'datastore.csv');
  if Length(cdta)>0 then
  begin
    Rewrite(datafile);
    for i:=0 to Length(cdta)-1 do
    begin
      fline:=floattostr(cdta[i].x)+';'+floattostr(cdta[i].y);
      WriteLn(datafile,fline);
    end;
  end;
  CloseFile(datafile);
end;

procedure TForm1.Button3Click(Sender: TObject);
var k,cl:string;
    readtox:boolean;
begin
  AssignFile(datafile,'datastore.csv');
  Reset(datafile);
  SetLength(cdta,0);
  j:=-1;
  while not eof(datafile) do
  begin
    inc(j);
    ReadLn(datafile,cl);
    if length(cl)>0 then
    begin
      readtox:=true; k:='';
      SetLength(cdta,length(cdta)+1);
      for i:=1 to Length(cl) do
      begin
        if (cl[i]<>';') and (i<>Length(cl)) then
        begin
          k:=k+cl[i];
        end
        else
        begin
          if readtox then
          begin
            TryStrToFloat(k,cdta[j].x);
            k:='';
            readtox:=false;
          end
          else
          begin
            if not TryStrToFloat(k,cdta[j].y) then
            begin
              //SetLength(cdta,Length(cdta)-1);
              //j:=j-1;
            end;
            k:='';
          end;
        end;
      end;
    end;
  end;
  CloseFile(datafile);
  outputcdta;
end;

end.

