#Requires AutoHotkey v2.0.2
#SingleInstance Force

Komorebic(cmd) {
    RunWait(format("komorebic.exe {}", cmd), , "Hide")
}

!^+Home::Komorebic("stop --ahk"), Komorebic("start --ahk")

!w::Komorebic("close")
!²::Komorebic("minimize")

; Focus windows
!q::Komorebic("focus left")
!s::Komorebic("focus down")
!z::Komorebic("focus up")
!d::Komorebic("focus right")

!+[::Komorebic("cycle-focus previous")
!+]::Komorebic("cycle-focus next")

; Move windows // Remplacement de shift + numpad par leur version shiftee direct
!+q::Komorebic("move left")
!+s::Komorebic("move down")
!+z::Komorebic("move up")
!+d::Komorebic("move right")

; Stack windows
!^q::Komorebic("stack left")
!^s::Komorebic("stack down")
!^z::Komorebic("stack up")
!^d::Komorebic("stack right")
!^r::Komorebic("unstack")
!Numpad7::Komorebic("cycle-stack previous")
!Numpad9::Komorebic("cycle-stack next")

; Resize
!=::Komorebic("resize-axis horizontal increase")
!-::Komorebic("resize-axis horizontal decrease")
!+=::Komorebic("resize-axis vertical increase")
!+_::Komorebic("resize-axis vertical decrease")

; Manipulate windows
!v::Komorebic("toggle-float")
!c::Komorebic("toggle-monocle")
!m::Komorebic("manage")

; Window manager options
!r::Komorebic("retile")
!p::Komorebic("toggle-pause")

; Layouts
!x::Komorebic("flip-layout horizontal")
!y::Komorebic("flip-layout vertical")

; Workspaces
!&::Komorebic("focus-workspace 0")
!é::Komorebic("focus-workspace 1")
!"::Komorebic("focus-workspace 2")
!'::Komorebic("focus-workspace 3")
!(::Komorebic("focus-workspace 4")
; !6::Komorebic("focus-workspace 5")
; !7::Komorebic("focus-workspace 6")
; !8::Komorebic("focus-workspace 7")

; Move windows across workspaces
!+&::Komorebic("move-to-workspace 0")
!+é::Komorebic("move-to-workspace 1")
!+"::Komorebic("move-to-workspace 2")
!+'::Komorebic("move-to-workspace 3")
!+(::Komorebic("move-to-workspace 4")
; !+6::Komorebic("move-to-workspace 5")
; !+7::Komorebic("move-to-workspace 6")
; !+8::Komorebic("move-to-workspace 7")