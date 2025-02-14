program Rotating3DCube;
uses crt, math, sysutils;

var
  A, B, C: Real;
  cubeWidth: Real;
  width, height: Integer;
  zBuffer: array of Real;
  buffer: array of Char;
  backgroundASCIICode: Char;
  distanceFromCam: Integer;
  horizontalOffset: Real;
  K1: Real;

procedure InitializeVariables;
begin
  A := 0.0;
  B := 0.0;
  C := 0.0;
  cubeWidth := 10.0; // Ajuste o tamanho do cubo se necessário
  width := 80; // Reduzir a largura do console se necessário
  height := 24;
  backgroundASCIICode := '.';
  distanceFromCam := 100;
  horizontalOffset := 0.0;
  K1 := 40.0;
end;

procedure InitializeBuffers;
var
  i: Integer;
begin
  SetLength(zBuffer, width * height);
  SetLength(buffer, width * height);
  for i := 0 to width * height - 1 do
  begin
    zBuffer[i] := 0.0;
    buffer[i] := backgroundASCIICode;
  end;
end;

function CalculateX(i, j, k: Real): Real;
begin
  CalculateX := j * Sin(A) * Sin(B) * Cos(C) - k * Cos(A) * Sin(B) * Cos(C) +
                j * Cos(A) * Sin(C) + k * Sin(A) * Sin(C) +
                i * Cos(B) * Cos(C);
end;

function CalculateY(i, j, k: Real): Real;
begin
  CalculateY := j * Cos(A) * Cos(C) + k * Sin(A) * Cos(C) -
                j * Sin(A) * Sin(B) * Sin(C) + k * Cos(A) * Sin(B) * Sin(C) -
                i * Cos(B) * Sin(C);
end;

function CalculateZ(i, j, k: Real): Real;
begin
  CalculateZ := k * Cos(A) * Cos(B) - j * Sin(A) * Cos(B) +
                i * Sin(B);
end;

procedure CalculateForSurface(cubeX, cubeY, cubeZ: Real; ch: Char);
var
  x, y, z, ooz: Real;
  xp, yp, idx: Integer;
begin
  x := CalculateX(cubeX, cubeY, cubeZ);
  y := CalculateY(cubeX, cubeY, cubeZ);
  z := CalculateZ(cubeX, cubeY, cubeZ) + distanceFromCam;

  ooz := 1 / z;
  xp := Trunc(width / 2 + horizontalOffset + K1 * ooz * x);
  yp := Trunc(height / 2 - K1 * ooz * y); // Ajuste na fórmula de Y para inverter a direção

  idx := xp + yp * width;
  if (idx >= 0) and (idx < width * height) then
  begin
    if ooz > zBuffer[idx] then
    begin
      zBuffer[idx] := ooz;
      buffer[idx] := ch;
    end;
  end;
end;

procedure ClearScreen;
begin
  ClrScr;
end;

procedure RenderFrame;
var
  cubeX, cubeY, k: Integer;
begin
  InitializeBuffers;

  for cubeX := -Trunc(cubeWidth) to Trunc(cubeWidth) do
    for cubeY := -Trunc(cubeWidth) to Trunc(cubeWidth) do
    begin
      CalculateForSurface(cubeX, cubeY, -Trunc(cubeWidth), '@');
      CalculateForSurface(Trunc(cubeWidth), cubeY, cubeX, '$');
      CalculateForSurface(-Trunc(cubeWidth), cubeY, -cubeX, '~');
      CalculateForSurface(-cubeX, cubeY, Trunc(cubeWidth), '#');
      CalculateForSurface(cubeX, -Trunc(cubeWidth), -cubeY, ';');
      CalculateForSurface(cubeX, Trunc(cubeWidth), cubeY, '+');
    end;

  ClearScreen;

  for k := 0 to width * height - 1 do
  begin
    if (k mod width = 0) then
      WriteLn;
    Write(buffer[k]);
  end;

  A := A + 0.05;
  B := B + 0.05;
  C := C + 0.01;
end;

begin
  InitializeVariables;
  repeat
    RenderFrame;
    Delay(0); { ~60 FPS }
  until False;
end.
