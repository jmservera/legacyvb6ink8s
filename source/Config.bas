Attribute VB_Name = "Config"
Option Explicit

Const envMAXCONNS As String = "MAXCONNS"
Const defMAXCONNS As Integer = 4096


Public MAXCONNS As Integer

Public Sub LoadConfig()
    Dim maxConnections As String

    MAXCONNS = defMAXCONNS
    
    maxConnections = Environ$(envMAXCONNS)

    If maxConnections <> "" Then
        On Error Resume Next
        MAXCONNS = Val(maxConnections)
        On Error GoTo 0
    End If

    LogTrace "LoadConfig", "MAXCONNS=" & MAXCONNS

End Sub
