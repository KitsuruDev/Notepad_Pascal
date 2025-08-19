unit unitCode;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8;
var KeyOpen: LongWord;
function Code(S: WideString; GenerateNewKey: Boolean) : Widestring;
function LoadMagicKey : Boolean;

implementation

var Key,KeyPriv: LongWord;

function loadKey(fileName: String) : LongWord;
var F: TextFile; K: LongWord;
begin
  AssignFile(F, fileName); // связка с переменной
  Reset(F);
  ReadLn(F, K); // считываем ключ
  CloseFile(F);
  result:=K;
end;

function generateKey: LongWord;
var Number: LongWord; i,j: LongWord; arr: array of Boolean;
begin
  while True do begin
    Number:=Random(60000-20000+1)+20000; // диапазон
    SetLength(arr, Number);
    for i:=0 to Number do begin
      arr[i]:=True;
    end;
    i:=2;
    while i*i <= Number do begin           // решето Эратосфена
      if arr[i]=True then begin
        j:=i*i;
        while j <= Number do begin
          arr[j]:=False;
          j:=j+i;
        end;
      end;
      i:=i+1;
    end;
    if arr[Number]=True then Break;
  end;
  Result:=Number;
end;

function LoadMagicKey : Boolean;
begin
  Try KeyPriv:=loadKey('Key.txt');
  Except Result:=False;
  end;
  Result:=True;
end;

function Code(S: WideString; GenerateNewKey: Boolean) : Widestring;
var SS,SC: WideString; C: WideChar; K: LongWord; i,LengthS: Word;
begin
  if GenerateNewKey=True then begin
     Key:=generateKey;
     KeyOpen:=KeyPriv*Key;
  end
  else Key:=KeyOpen div KeyPriv;
  SS:='';
  LengthS:=Length(S);
  if S[LengthS-1]+S[LengthS]=LineEnding then LengthS:=LengthS-2;
  for i:=1 to LengthS do begin
    C:=S[i];
    K:=Ord(C);
    K:=K xor Key;
    SC:=UnicodeToUTF8(K);
    SS:=SS+SC;
  end;
  Result:=SS;
end;

end.

