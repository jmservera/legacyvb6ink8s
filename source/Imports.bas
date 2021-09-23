Attribute VB_Name = "Imports"
Option Explicit

Public Declare Sub GetLocalTime Lib "kernel32" (lpSystemTime As SYSTEMTIME)
Public Type SYSTEMTIME
    wYear As Integer
    wMonth As Integer
    wDayOfWeek As Integer
    wDay As Integer
    wHour As Integer
    wMinute As Integer
    wSecond As Integer
    wMilliseconds As Integer
End Type
