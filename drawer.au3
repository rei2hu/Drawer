#include <GDIPlus.au3>
#include <Array.au3>
#include <WinAPI.au3>

Opt("MustDeclareVars", 1)
AutoItSetOption("MouseClickDelay", 0)
AutoItSetOption("MouseClickDownDelay", 0)
hotkeyset("{F1}","Exits")
hotkeyset("{F2}","slow")
_GDIPlus_Startup()
Dim $pixelarray
Local $file_in = "line-art.jpg"
Dim $binFlag = False
_FileImageToArray($file_in, $pixelarray)
;ConsoleWrite(UBound($pixelarray, 1))
;ConsoleWrite(UBound($pixelarray, 2))
Local $step = 2
Local $startx = MouseGetPos(0)
Local $starty = MouseGetPos(1)

Local $coords = ""

Global $px = MouseGetPos(0)
Global $py = MouseGetPos(1)

For $j = 0 To UBound($pixelarray, 2)-$step-1 Step $step ; y direction
   For $i = 0 To UBound($pixelarray, 1)-$step-1 Step $step ; x direction
	  ;MouseMove(MouseGetPos(0)+$step,MouseGetPos(1),0) ; increase x direction
	  Local $r = Dec(StringMid($pixelarray[$i][$j],1,2))
	  Local $g = Dec(StringMid($pixelarray[$i][$j],3,2))
	  Local $b = Dec(StringMid($pixelarray[$i][$j],5,2))
	  ;ToolTip($r & " " & $g & " " & $b & " " & Dec("EE"))
	  If($r < Dec("EE") and $g < Dec("EE") and $b < Dec("EE")) Then
		 ;MouseClick("left")
		 ; add $i and $j of pixel to coords array
		 $coords = $coords & $i & "," & $j & " "
		 ; this adds [X COORD],[Y COORD][SPACE] to the text
	  EndIf
	  ;Do
		 ;Sleep(1)
	  ;Until $binFlag
	  ;ToolTip(MouseGetPos(0) & " " & MouseGetPos(1) & @CRLF & $pixelarray[$j][$i], 0, 0)
   Next
   ;MouseMove($startx,MouseGetPos(1)+$step,0) ; increase y direction
Next

; an array of all x y coords with darker* dots
Local $coordsArray = StringSplit($coords, " ")
For $i = 1 To $coordsArray[0]
   Local $xcoor = StringSplit($coordsArray[$i],",")[1]
   Local $ycoor = StringSplit($coordsArray[$i],",")[2]
   MouseClick("left",$xcoor+$startx,$ycoor+$starty,1,0)
Next

;_FileArrayToImage($file_out, $pixelarray)
_GDIPlus_Shutdown()

Func Exits()
   Exit
EndFunc

Func slow()
   If($binFlag) Then
	  $px=MouseGetPos(0)
	  $py=MouseGetPos(1)
   Else
	  MouseMove($px, $py, 0)
   EndIf
   $binFlag = Not $binFlag
EndFunc

Func _FileImageToArray($filename, ByRef $aArray)
    Local $Reslt, $stride, $format, $Scan0, $iW, $iH, $hImage
    Local $v_Buffer, $width, $height
    Local $i, $j

    $hImage = _GDIPlus_ImageLoadFromFile($filename)
    $iW = _GDIPlus_ImageGetWidth($hImage)
    $iH = _GDIPlus_ImageGetHeight($hImage)
    $Reslt = _GDIPlus_BitmapLockBits($hImage, 0, 0, $iW, $iH, $GDIP_ILMREAD, $GDIP_PXF32ARGB)

    $width = DllStructGetData($Reslt, "width")
    $height = DllStructGetData($Reslt, "height")
    $stride = DllStructGetData($Reslt, "stride")
    $format = DllStructGetData($Reslt, "format")
    $Scan0 = DllStructGetData($Reslt, "Scan0")

    Dim $aArray[$width][$height]
    For $i = 0 To $iW - 1
        For $j = 0 To $iH - 1
            $v_Buffer = DllStructCreate("dword", $Scan0 + ($j * $stride) + ($i * 4))
            $aArray[$i][$j] = Hex(DllStructGetData($v_Buffer, 1), 6)
        Next
    Next
    _GDIPlus_BitmapUnlockBits($hImage, $Reslt)
    _GDIPlus_ImageDispose($hImage)
    Return
EndFunc
