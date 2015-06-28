object FHaupt: TFHaupt
  Left = 193
  Top = 111
  Width = 730
  Height = 599
  Caption = 'AstroCap 2.0'
  Color = clAppWorkSpace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  HelpFile = 'AstroCap.hlp'
  Menu = MMHaupt
  OldCreateOrder = False
  Scaled = False
  ShowHint = True
  WindowState = wsMaximized
  WindowMenu = MIWindow
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SBInfo: TStatusBar
    Left = 0
    Top = 534
    Width = 722
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object MMHaupt: TMainMenu
    Left = 108
    Top = 28
    object Programm1: TMenuItem
      Caption = 'Programm'
      object MISingleframe: TMenuItem
        Caption = 'Einzelbild'
        Hint = 'Nimmt ein Einzelbild auf'
        ShortCut = 113
        OnClick = MISingleframeClick
      end
      object MIMultiframe: TMenuItem
        Caption = 'Bildserie'
        Hint = 'Nimmt eine Bildserie auf'
        ShortCut = 114
        OnClick = MIMultiframeClick
      end
      object MIVorschau: TMenuItem
        Caption = 'Vorschau'
        Hint = 'Zeigt eine Aufnahmevorschau'
        ShortCut = 115
        OnClick = MIEffectClick
      end
      object MIOptometrie: TMenuItem
        Caption = 'Optometrie'
        Hint = 'Zeigt das Histogramm an'
        ShortCut = 121
        OnClick = MIEffectClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MIQuit: TMenuItem
        Caption = 'Beenden'
        Hint = 'Beendet das Programm'
        OnClick = MIQuitClick
      end
    end
    object MIEffects: TMenuItem
      Caption = 'Effekte'
      object MIBinning: TMenuItem
        Caption = 'RGB Binning'
        GroupIndex = 100
        Hint = 'Fasst Rot, Grün & Blau zu einem Grauwert zusammen'
        ShortCut = 16496
        OnClick = MIEffectClick
      end
      object MIContrast: TMenuItem
        Caption = 'Kontrast maximieren'
        GroupIndex = 100
        Hint = 'Dehnt das Histogramm auf die maximalen Werte aus'
        ShortCut = 16497
        OnClick = MIEffectClick
      end
      object MIInvert: TMenuItem
        Caption = 'Invertieren'
        GroupIndex = 100
        Hint = 'Erzeugt ein Negativbild'
        ShortCut = 16498
        OnClick = MIEffectClick
      end
      object MIColRot: TMenuItem
        Caption = 'Farbrotation'
        GroupIndex = 128
        OnClick = MIEffectClick
      end
      object MIFalseColor: TMenuItem
        Caption = 'Falschfarben'
        GroupIndex = 128
        OnClick = MIEffectClick
      end
      object MIBinning22: TMenuItem
        Caption = '2x2 Binning'
        GroupIndex = 128
        Hint = 'Fasst vier Pixel zu einem zusammen'
        ShortCut = 16500
        OnClick = MIEffectClick
      end
      object MIBinning21: TMenuItem
        Caption = '2x1 Binning'
        GroupIndex = 128
        Hint = 'Fasst je zwei horizontale Pixel zusammen'
        ShortCut = 16501
        OnClick = MIEffectClick
      end
      object MIGrayscale: TMenuItem
        Caption = 'Graustufen'
        GroupIndex = 128
        Hint = 'Wandelt das Bild in Graustufen um'
        ShortCut = 16502
        OnClick = MIEffectClick
      end
      object MIDarkframe: TMenuItem
        Caption = 'Darkframe'
        GroupIndex = 128
        Hint = 'Macht einen Dunkelstromabzug'
        ShortCut = 16503
        OnClick = MIDarkframeClick
      end
      object MIFlatfield: TMenuItem
        Caption = 'Flatfield'
        GroupIndex = 128
        Hint = 'Macht eine Flatfieldkorrektur'
        ShortCut = 16504
        OnClick = MIFlatfieldClick
      end
      object N3: TMenuItem
        Caption = '-'
        GroupIndex = 128
      end
      object MiMedian: TMenuItem
        Caption = 'Bilder mitteln'
        GroupIndex = 128
        Hint = 'Mittelt die einzelnen Frames'
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MIIntegrate: TMenuItem
        Caption = 'Bilder integrieren'
        GroupIndex = 128
        Hint = 'Integriert die einzelnen Frames'
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MIMinimum: TMenuItem
        Caption = 'Minimum'
        GroupIndex = 128
        Hint = 'Erfasst die dunkelsten Pixel der Frames'
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MIMaximum: TMenuItem
        Caption = 'Maximum'
        GroupIndex = 128
        Hint = 'Erfasst die hellsten Pixel der Frames'
        RadioItem = True
        OnClick = MIEffectClick
      end
    end
    object Filter1: TMenuItem
      Caption = 'Filter'
      object MINoise: TMenuItem
        Caption = 'Rauschunterdrückung'
        OnClick = MIEffectClick
      end
      object MIHighpass: TMenuItem
        Caption = 'Hochpass'
        OnClick = MIEffectClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object MIRed: TMenuItem
        Caption = 'Rot'
        GroupIndex = 124
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MIGreen: TMenuItem
        Caption = 'Grün'
        GroupIndex = 124
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MIBlue: TMenuItem
        Caption = 'Blau'
        GroupIndex = 124
        RadioItem = True
        OnClick = MIEffectClick
      end
      object MINone: TMenuItem
        Caption = '(keiner)'
        Checked = True
        GroupIndex = 124
        RadioItem = True
        OnClick = MIEffectClick
      end
    end
    object Treiber1: TMenuItem
      Caption = 'Treiber'
      object MIStartDriver: TMenuItem
        Caption = 'Starten'
        ShortCut = 119
        OnClick = MIStartDriverClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object MISource: TMenuItem
        Caption = 'Quelle'
        GroupIndex = 200
        Hint = 'Einstellungen für Belichtungswerte'
        OnClick = MISourceClick
      end
      object MIFormat: TMenuItem
        Caption = 'Format'
        GroupIndex = 200
        Hint = 'Einstellungen für das Bildformat'
        OnClick = MIFormatClick
      end
      object MIDisplay: TMenuItem
        Caption = 'Anzeige'
        GroupIndex = 200
        OnClick = MIDisplayClick
      end
      object MICompression: TMenuItem
        Caption = 'Kompression'
        GroupIndex = 200
        Hint = 'Einstellung für die AVI-Kompression'
        OnClick = MICompressionClick
      end
      object N2: TMenuItem
        Caption = '-'
        GroupIndex = 200
      end
      object MIOverlay: TMenuItem
        Caption = 'Overlay'
        GroupIndex = 200
        Hint = 'Overlaymodus (nur TV-Karten)'
        RadioItem = True
        OnClick = MIOverlayClick
      end
      object MIPreview: TMenuItem
        Caption = 'Preview'
        Checked = True
        GroupIndex = 200
        Hint = 'Inlay-Modus'
        RadioItem = True
        OnClick = MIPreviewClick
      end
    end
    object MIWindow: TMenuItem
      Caption = 'Fenster'
      object MITile: TMenuItem
        Caption = 'Nebeneinander'
        OnClick = MITileClick
      end
      object MICascade: TMenuItem
        Caption = 'Untereinander'
        OnClick = MICascadeClick
      end
    end
    object MIModus: TMenuItem
      Caption = 'Modus'
      Hint = 'wechselt vom Aufnahme- in den Fokusmodus'
      object Moduswechsel1: TMenuItem
        Caption = 'Moduswechsel'
        Hint = 'Wechselt zwischen Aufnahme und Fokusmodus'
        ShortCut = 120
        OnClick = MIModusClick
      end
      object N5: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object MIAufnahme: TMenuItem
        Caption = 'Aufnahme'
        Checked = True
        GroupIndex = 1
        Hint = 'großes Ergebnisbild'
        RadioItem = True
        OnClick = MIAufnahmeClick
      end
      object MIFokus: TMenuItem
        Caption = 'Fokus'
        GroupIndex = 1
        Hint = 'großes Vorschaubild'
        RadioItem = True
        OnClick = MIFokusClick
      end
    end
    object MIHilfe: TMenuItem
      Caption = 'Hilfe'
      object MIHelp: TMenuItem
        Caption = 'AstroCap-Hilfe'
        ShortCut = 112
        OnClick = MIHelpClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MIInfo: TMenuItem
        Caption = 'Info...'
        OnClick = MIInfoClick
      end
    end
  end
  object OpenPictureDialog: TOpenPictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp|Alle Dateien|*.*'
    Left = 180
    Top = 28
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 200
    Left = 220
    Top = 28
  end
end
