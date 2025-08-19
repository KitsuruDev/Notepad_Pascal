unit unitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus, StdCtrls,
  unitRef, unitHelp;

type

  { TformMain }

  TformMain = class(TForm)
    MainMenu: TMainMenu;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItemHelp: TMenuItem;
    SeparatorAbout: TMenuItem;
    MenuItemUndo: TMenuItem;
    SeparatorChange1: TMenuItem;
    MenuItemSelectAll: TMenuItem;
    SeparatorChange2: TMenuItem;
    MenuItemDel: TMenuItem;
    MenuItemInsert: TMenuItem;
    MenuItemCopy: TMenuItem;
    MenuItemChange: TMenuItem;
    MenuItemCut: TMenuItem;
    MenuItemRef: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    MenuItemExit: TMenuItem;
    SeparatorFile: TMenuItem;
    MenuItemOpen: TMenuItem;
    MenuItemSave: TMenuItem;
    MenuItemCreate: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemFile: TMenuItem;
    StatusBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure CaretPosChange(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuFileAction(Sender: TObject);
    procedure MenuChangeAction(Sender: TObject);
    procedure MenuAboutAction(Sender: TObject);
  private

  public

  end;

var
  formMain: TformMain;

implementation

uses LCLType, unitCode;


{$R *.lfm}

{ TformMain }

procedure TformMain.FormCreate(Sender: TObject);
var SuccessLoad: Boolean;
begin
  SuccessLoad:=LoadMagicKey;
  if SuccessLoad=False then begin
      MessageDlg('ОШИБКА ПРИ ЗАГРУЗКЕ КЛЮЧА!',mtError,[mbOk],0);
      Close;
  end;
end;

procedure TformMain.MenuAboutAction(Sender: TObject);
var AboutActionName: String;
begin
  AboutActionName:=(Sender as TMenuItem).Caption;
  case AboutActionName of
  'Содержание': begin
      formHelp:=TformHelp.Create(Application);
      formHelp.ShowModal;
    end;
  'О программе': begin
      formRef:=TformRef.Create(Application);
      formRef.ShowModal;
    end;
  end;
end;

procedure TformMain.MenuFileAction(Sender: TObject);
var FileActionName: String;
begin
  FileActionName:=(Sender as TMenuItem).Caption;
  case FileActionName of
  'Создать': Memo1.Clear;
  'Сохранить': if SaveDialog.Execute then begin
      Memo2.Text:=Code(Memo1.Text, True);
      Memo2.Lines.Insert(0, IntToStr(unitCode.KeyOpen));
      Memo2.Lines.SaveToFile(SaveDialog.FileName);
    end;
  'Открыть': if OpenDialog.Execute then begin
      Memo2.Lines.LoadFromFile(OpenDialog.FileName);
      unitCode.KeyOpen:=StrToInt(Memo2.Lines[0]);
      Memo2.Lines.Delete(0);
      Memo1.Text:=Code(Memo2.Text, False);
    end;
  'Выход': Close;
  end;
end;

procedure TformMain.MenuChangeAction(Sender: TObject);
var ChangeActionName: String;
begin
  ChangeActionName:=(Sender as TMenuItem).Caption;
  case ChangeActionName of
  'Отменить': Memo1.Undo;
  'Вырезать': Memo1.CutToClipboard;
  'Копировать': Memo1.CopyToClipboard;
  'Вставить': Memo1.PasteFromClipboard;
  'Удалить': Memo1.SelText:='';
  'Выбрать всё': Memo1.SelectAll;
  end;
end;

procedure TformMain.CaretPosChange(Sender: TObject);
begin
  StatusBar.Panels[0].Text:='Столбец '+IntToStr(Memo1.CaretPos.X)+
  ', строка '+IntToStr(Memo1.CaretPos.Y);
end;

procedure TformMain.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case Key of VK_LEFT,VK_RIGHT,VK_UP,VK_DOWN: StatusBar.Panels[0].Text:='Столбец '
   +IntToStr(Memo1.CaretPos.X)+', строка '+IntToStr(Memo1.CaretPos.Y);
   end;
end;

end.

