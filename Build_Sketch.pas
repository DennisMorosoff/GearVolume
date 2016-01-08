unit Build_Sketch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SldWorks_TLB, StdCtrls, Math, ComObj, SwConst_TLB, Common_Unit, extctrls;

type

TRec_POINT= record   // Точка сплайна хранится в виде записи координат
  X: double;
  Y: double;
  Z: double;
end;

MassivSheZi=array of TRec_POINT;  // Массив точек сплайна,
                                  // использовать можно только динамический массив,
                                  // статический не примет команда построения CreateSpline


Procedure Postroenie_Sketch(MD: IModelDoc2; a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr: double; z_sh:integer); safecall; overload;

implementation

Procedure Postroenie_Sketch(MD: IModelDoc2; a_sh, da_sh, db_sh, d_sh, h_sh, d, da, db, z, cap, kvadr: double; z_sh:integer); safecall; overload;
var Point_Gear, Point_Gearvyk: array of ISketchPoint;
  psi, R, P1, P2, s, e1, w1,q1,t1,o1,e2, w2,q2,t2,o2, b_sh, psi_shv, xp,yp,c1, c2, xv,osx, osy, x1, u: double;
  un, uk, psin, psik : extended;
  i, l:integer;
  x_sh, x_shv: array of double;
  y_sh, y_shv: array of double;
  MyMas: array of double;
begin
  if MD = nil then          // Если указатель на документ модели не передан
    MD:=OpenSW;             // во входных параметрах, значит создаем новый документ

  FindPlanes(MD);           // Получаем указатели на главные плоскости

  if (xyPlane as IFeature).Select(False) then   // Выбираем плоскость XY
    md.InsertSketch                             // Создаем эскиз
    else
    Raise EOleError.Create('Не выбрана плоскость XY для эскиза');

{Математика}

    b_sh:=pi/(2*z);
    s:=(da-da_sh)/1000;
    R:=(1-(d_sh/d));
    a_sh:=a_sh*(pi/180);
    P1:= d/1000*(sin((b_sh))-cos(b_sh)*Tan(a_sh));

    un:= (-d/1000)*sin(a_sh)*sin(b_sh - a_sh)+ (cos(a_sh)*(sqrt(sqr(db/1000)-sqr(d/1000)*sqr(sin(b_sh - a_sh)))));
    u:=(d/d_sh)*((a_sh - arccos((R/(s*cos(a_sh)))*(un+(d/1000)*sin(a_sh)*sin(b_sh - a_sh)))));

    psin:=u;
    psi:=psin;

    SetLength(x_sh,0);
    SetLength(y_sh,0);
    SetLength(Point_Gear,0);

  while ((psi=psin) or (psi>psin)) and ((psi<pi/2) or (psi=pi/2)) do
   begin
    SetLength(x_sh,Length(x_sh)+1);    // Добавляем точку в массив
    SetLength(y_sh,Length(y_sh)+1);
    SetLength(Point_Gear,Length(x_sh)+1);

    P2:=tan(a_sh)*sin(psi-R*psi)+cos(psi-R*psi);
    q1:=(cos((a_sh)+R*psi))*P1;
    e1:=(s/R)*(sin(a_sh+R*psi))*P2;
    w1:=cos(a_sh);
    t1:=s*sin(psi);

    x_sh[High(x_sh)]:=(q1+e1)*w1-t1;     // записываем X

    q2:=(-sin(a_sh+R*psi))*P1;
    e2:=(s/R)*(cos(a_sh+R*psi))*P2;
    w2:=cos(a_sh);
    t2:=s*cos(psi);

    y_sh[High(y_sh)]:=(q2+e2)*w2-t2;     // записываем Y

    Point_Gear[High(x_sh)]:=md.ICreatePoint2(x_sh[High(x_sh)], y_sh[High(y_sh)], 0);
     // Построение точки по координатам из последней ячейки массива

    psi:=psi+pi/20;
  end;

  l:=0;
  SetLength(MyMas,Length(x_sh)*3);   // Все координаты запишем в один массив

  for i:=Low(x_sh) to High(x_sh) do  // Записываем координаты в масив MyMas
  begin                              // В следующем порядке:
   MyMas[l]:=x_sh[i];                // X1, Y1, Z1, X2, Y2 и т.д.,
   inc(l);                           // как того требует метод CreateSpline
   MyMas[l]:=y_sh[i];
   Inc(l);
   MyMas[l]:=0;                      // Z всегда 0
   Inc(l);
  end;

  MD.CreateSpline(MyMas);            // Построение сплайна


{ Выкружка }
{ Все аналогично }

   xp:=un*tan(a_sh)+P1;
   yp:=un-s;
   c1:=(sqr(db_sh/1000)-sqr(xp)-sqr(yp)-sqr(s))/(2*s);
   x1:= ((-2*c1*(yp+s))+(2*xp*sqrt(sqr(xp)+sqr(yp+s)-sqr(c1))))/(2*(sqr(xp)+sqr(yp+s)));
   psi_shv:= (arccos(x1))/(R-1);
   psi:=psin;

   SetLength(x_shv,0);
   SetLength(y_shv,0);
   SetLength(Point_Gearvyk,0);

   while (psi<=pi/10) and (psi>=psin) do
   begin
    SetLength(x_shv,Length(x_shv)+1);    // Добавляем точку в массив
    SetLength(y_shv,Length(y_shv)+1);
    SetLength(Point_Gearvyk,Length(x_shv)+1);

    x_shv[High(x_shv)]:= xp*cos(R*psi)+(yp+s)*sin(R*psi)-s*sin(psi);
    y_shv[High(y_shv)]:= -xp*sin(R*psi)+(yp+s)*cos(R*psi)-s*cos(psi);

    Point_Gearvyk[High(x_shv)]:=md.ICreatePoint2(x_shv[High(x_shv)], y_shv[High(y_shv)], 0);

    psi:=psi+pi/20;
   end;

  l:=0;
  SetLength(MyMas,Length(x_shv)*3);

  for i:=0 to High(x_shv) do
  begin
   MyMas[l]:=x_shv[i];
   inc(l);
   MyMas[l]:=y_shv[i];
   Inc(l);
   MyMas[l]:=0;
   Inc(l);
  end;

 MD.CreateSpline(MyMas);
end;

end.

