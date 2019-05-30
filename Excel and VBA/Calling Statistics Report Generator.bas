Attribute VB_Name = "Module3"
Sub TelefundRanking()

'Revision to ranking system by Isaiah Morgan 10/25/2018
'This version incorporates the changes made to key indicators by the payment process change


'Create Date Range Input Box and assign to variable
Dim DateRange As Variant
DateRange = InputBox("What is the date range?")

'New Variables
Dim IndImmediateGiftRate As Double
Dim IndRecurringGiftRate As Double
Dim IndImmediateAmtHr As Double
Dim IndImmediatePerHr As Double
Dim IndRecurringPerHr As Double

'Add Column 'Immediate Gift Rate'(Calculated by (#One-time + #Recurring Gifts) / Total #Pledges))
Range("U1").Value = "Immediate"
Range("U2").Value = "Gift Rate"
Range("U1").Font.Bold = True
Range("U2").Font.Bold = True
Range("U1").Font.Name = "Verdana"
Range("U2").Font.Name = "Verdana"
Range("U1").Font.Size = 9
Range("U2").Font.Size = 9

Range("P3").Select
Do Until IsEmpty(ActiveCell)
    If (ActiveCell.Value + ActiveCell.Offset(0, 2)) = 0 Then
    ActiveCell.Offset(0, 5).Value = 0
    ActiveCell.Offset(0, 5).NumberFormat = "0.00%"
    Else
    IndImmediateGiftRate = ((ActiveCell.Value + ActiveCell.Offset(0, 2).Value) / ActiveCell.Offset(0, -13).Value)
    ActiveCell.Offset(0, 5).Value = Math.Round(IndImmediateGiftRate, 4)
    ActiveCell.Offset(0, 5).NumberFormat = "0.00%"
    IndImmediateGiftRate = 0
    End If
    ActiveCell.Offset(1, 0).Select
Loop

'Add Column 'Recurring Gift Rate'(Calculated by # Recurring Gifts / Total # Pledges)
Range("V1").Value = "Recurring"
Range("V2").Value = "Gift Rate"
Range("V1").Font.Bold = True
Range("V2").Font.Bold = True
Range("V1").Font.Name = "Verdana"
Range("V2").Font.Name = "Verdana"
Range("V1").Font.Size = 9
Range("V2").Font.Size = 9

Range("R3").Select
Do Until IsEmpty(ActiveCell)
    If ActiveCell.Value = 0 Then
    ActiveCell.Offset(0, 4).Value = 0
    ActiveCell.Offset(0, 4).NumberFormat = "0.00%"
    Else
    IndRecurringGiftRate = (ActiveCell.Value / (ActiveCell.Offset(0, -15).Value - ActiveCell.Offset(0, -2).Value))
    ActiveCell.Offset(0, 4).Value = Math.Round(IndRecurringGiftRate, 4)
    ActiveCell.Offset(0, 4).NumberFormat = "0.00%"
    IndRecurringGiftRate = 0
    End If
    ActiveCell.Offset(1, 0).Select
Loop

'Add Column 'Immediate Amount Per Hour' (Calculated by $ of Immediate Gifts divided by system hours)
Range("W1").Value = "Immediate"
Range("W2").Value = "Amount/Hr"
Range("W1").Font.Bold = True
Range("W2").Font.Bold = True
Range("W1").Font.Name = "Verdana"
Range("W2").Font.Name = "Verdana"
Range("W1").Font.Size = 9
Range("W2").Font.Size = 9

Range("Q3").Select
Do Until IsEmpty(ActiveCell)
    IndImmediateAmtHr = ((ActiveCell.Value + ActiveCell.Offset(0, 2).Value) / ActiveCell.Offset(0, -15).Value)
    ActiveCell.Offset(0, 6).Value = Math.Round(IndImmediateAmtHr, 2)
    IndChargesHr = 0
    ActiveCell.Offset(1, 0).Select
Loop

'Add Column 'Immediate Gifts Per Hour' (Calculated by # of Immediate Gifts divided by system hours)
Range("X1").Value = "Immediate"
Range("X2").Value = "Gifts/Hr"
Range("X1").Font.Bold = True
Range("X2").Font.Bold = True
Range("X1").Font.Name = "Verdana"
Range("X2").Font.Name = "Verdana"
Range("X1").Font.Size = 9
Range("X2").Font.Size = 9

Range("P3").Select
Do Until IsEmpty(ActiveCell)
    IndImmediatePerHr = ((ActiveCell.Value + ActiveCell.Offset(0, 2).Value) / ActiveCell.Offset(0, -14).Value)
    ActiveCell.Offset(0, 8).Value = Math.Round(IndImmediatePerHr, 2)
    IndChargesHr = 0
    ActiveCell.Offset(1, 0).Select
Loop

'Add Column 'Recurring Gifts Per Hour' (Calculated by # of Recurring Gifts divided by system hours)
Range("Y1").Value = "Recurring"
Range("Y2").Value = "Gifts/Hr"
Range("Y1").Font.Bold = True
Range("Y2").Font.Bold = True
Range("Y1").Font.Name = "Verdana"
Range("Y2").Font.Name = "Verdana"
Range("Y1").Font.Size = 9
Range("Y2").Font.Size = 9

Range("R3").Select
Do Until IsEmpty(ActiveCell)
    IndRecurringPerHr = (ActiveCell.Value / ActiveCell.Offset(0, -16).Value)
    ActiveCell.Offset(0, 7).Value = Math.Round(IndRecurringPerHr, 2)
    IndChargesHr = 0
    ActiveCell.Offset(1, 0).Select
Loop

'Delete Unneccesary columns

Columns(20).EntireColumn.Delete 'Gift Aid Amount
Columns(15).EntireColumn.Delete 'Completes per Hour
Columns(13).EntireColumn.Delete 'Incompletes per Hour
Columns(12).EntireColumn.Delete 'Complete Count
Columns(10).EntireColumn.Delete 'Matching Amount
Columns(9).EntireColumn.Delete 'Amount Per Hour
Columns(7).EntireColumn.Delete 'Average Pledge
Columns(6).EntireColumn.Delete 'Pledge Amount
Columns(4).EntireColumn.Delete 'No Pledge Count

'Delete Rows after total
Rows(ActiveSheet.Range("A" & Rows.Count).End(xlUp).Row).Delete
Rows(ActiveSheet.Range("A" & Rows.Count).End(xlUp).Row).Delete

'Rearrange columns

Columns("H").Cut
Columns("D").Insert Shift:=xlToRight

Columns("J").Cut
Columns("E").Insert Shift:=xlToRight

Columns("J").Cut
Columns("H").Insert Shift:=xlToRight

Columns("K").Cut
Columns("I").Insert Shift:=xlToRight

Columns("K").Cut
Columns("Q").Insert Shift:=xlToRight

Columns("G").Cut
Columns("K").Insert Shift:=xlToRight

'Calculate and assign to variables

Dim PledgeRate As Double
Dim ImmGiftRate As Double
Dim RecGiftRate As Double
Dim ImmAmtHr As Double
Dim ImmPerHr As Double
Dim RecPerHr As Double

'Added failsafe to prevent division by zero - Duncan Purser

    'Pledge Rate
    Range("J1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    PledgeRate = 0.001
    Else
    PledgeRate = ActiveCell.Value
    End If

    'Immediate Gift Rate
    Range("K1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    ImmGiftRate = 0.001
    Else
    ImmGiftRate = ActiveCell.Value
    End If
    
    'Recurring Gift Rate
    Range("L1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    RecGiftRate = 0.001
    Else
    RecGiftRate = ActiveCell.Value
    End If
    
    'Immediate Amt per Hour
    Range("M1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    ImmAmtHr = 0.001
    Else
    ImmAmtHr = ActiveCell.Value
    End If
    
    'Immediate Gifts per Hour
    Range("N1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    ImmPerHr = 0.001
    Else
    ImmPerHr = ActiveCell.Value
    End If
    
    'Recurring Gifts per Hour
    Range("O1").End(xlDown).Select
    If ActiveCell.Value = 0 Then
    RecPerHr = 0.001
    Else
    RecPerHr = ActiveCell.Value
    End If
 
'Count total number of callers
Dim F As Double
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    F = F + 1
    ActiveCell.Offset(1, 0).Select
Loop

'Create Percentile Columns
Let range1 = "J3:" & "J" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    PledgeRate = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 9).Value)
    ActiveCell.Offset(0, 17).Value = PledgeRate
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop

Let range1 = "K3:" & "K" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    ImmGiftRate = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 10).Value)
    ActiveCell.Offset(0, 18).Value = ImmGiftRate
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop

Let range1 = "L3:" & "L" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    RecGiftRate = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 11).Value)
    ActiveCell.Offset(0, 19).Value = RecGiftRate
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop

Let range1 = "M3:" & "M" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    ImmAmtHr = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 12).Value)
    ActiveCell.Offset(0, 20).Value = ImmAmtHr
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop

Let range1 = "N3:" & "N" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    ImmPerHr = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 13).Value)
    ActiveCell.Offset(0, 21).Value = ImmPerHr
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop

Let range1 = "O3:" & "O" & 2 + F
Range("A3").Select
Do Until ActiveCell.Value = "Total"
    RecPerHr = Application.WorksheetFunction.PercentRank_Exc(Range(range1).Value, ActiveCell.Offset(0, 14).Value)
    ActiveCell.Offset(0, 22).Value = RecPerHr
    PledgeRate = 0
    ActiveCell.Offset(1, 0).Select
Loop
    
'Add Column 'Fundraising Score' and calculate

Dim FScore As Double

Range("Q1").Value = "Fundraising"
Range("Q2").Value = "Score"
Range("Q1").Font.Bold = True
Range("Q2").Font.Bold = True
Range("Q1").Font.Name = "Verdana"
Range("Q2").Font.Name = "Verdana"
Range("Q1").Font.Size = 9
Range("Q2").Font.Size = 9

Range("P3").End(xlDown).Select
ActiveCell.Offset(0, 1).Value = "---"

Range("A3").Select
Do Until ActiveCell.Value = "Total"
    FScore = 0.2 * ActiveCell.Offset(0, 17) + 0.2 * ActiveCell.Offset(0, 18) + 0.12 * ActiveCell.Offset(0, 19) + 0.16 * ActiveCell.Offset(0, 20) + 0.2 * ActiveCell.Offset(0, 21) + 0.12 * ActiveCell.Offset(0, 22)
    ActiveCell.Offset(0, 16).Value = Math.Round(FScore, 2)
    FScore = 0
    ActiveCell.Offset(1, 0).Select
Loop

'Delete Percentile Columns

Columns(23).EntireColumn.Delete
Columns(22).EntireColumn.Delete
Columns(21).EntireColumn.Delete
Columns(20).EntireColumn.Delete
Columns(19).EntireColumn.Delete
Columns(18).EntireColumn.Delete
Columns(16).EntireColumn.Delete 'Removes Contacts per Hour. Not enough space.

'Order rows according to Caller Score

Range(Cells(3, 1), Cells(F + 2, 17)).Select
    Selection.Sort Key1:=Range("P3"), Order1:=xlDescending, Header:=xlNo, _
        OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, _
        DataOption1:=xlSortNormal


'Add Column 'Rank'

Columns("A:A").Select
    Selection.Insert Shift:=xlToRight, CopyOrigin:=xlFormatFromLeftOrAbove

Range("A1").Value = "Rank"
Range("A1").Font.Bold = True
Range("A1").Font.Name = "Verdana"
Range("A1").Font.Size = 9

Range("B3").End(xlDown).Select
ActiveCell.Offset(0, -1).Value = "---"


'Write in Ranking

Dim J As Double

Range("A3").Select
Do Until Not IsEmpty(ActiveCell)
    J = J + 1
    ActiveCell.Value = J
    ActiveCell.Offset(1, 0).Select
Loop


'Re-format table

Range(Cells.Address).Font.Name = "Verdana"
Range(Cells.Address).Font.Size = 9
Range(Cells.Address).VerticalAlignment = xlCenter
Range(Cells.Address).HorizontalAlignment = xlCenter

Range("C1:C2").UnMerge
Range("C1").Value = "System"
Range("C2").Value = "Time"

Range("D1:D2").UnMerge
Range("D1").Value = "Total"
Range("D2").Value = "Gifts"

Range("E1:E2").UnMerge
Range("E1").Value = "One Time"
Range("E2").Value = "Gifts"

Range("F1:F2").UnMerge
Range("F1").Value = "Recurring"
Range("F2").Value = "Gifts"

Range("H1:H2").UnMerge
Range("H1").Value = "One Time"
Range("H2").Value = "Amount"

Range("I1:I2").UnMerge
Range("I1").Value = "Recurring"
Range("I2").Value = "Amount"

Range("K1:K2").UnMerge
Range("K1").Value = "Participation"
Range("K2").Value = "Rate"

Range("C3").Select
Do Until IsEmpty(ActiveCell)
    ActiveCell.NumberFormat = "0.00"
    ActiveCell.Offset(1, 0).Select
Loop

Range("N3").Select
Do Until IsEmpty(ActiveCell)
    ActiveCell.NumberFormat = "$0.00"
    ActiveCell.Offset(1, 0).Select
Loop

Range("O3").Select
Do Until IsEmpty(ActiveCell)
    ActiveCell.NumberFormat = "0.00"
    ActiveCell.Offset(1, 0).Select
Loop

Range("P3").Select
Do Until IsEmpty(ActiveCell)
    ActiveCell.NumberFormat = "0.00"
    ActiveCell.Offset(1, 0).Select
Loop

Range("Q3").Select
Do Until IsEmpty(ActiveCell)
    ActiveCell.NumberFormat = "0.00"
    ActiveCell.Offset(1, 0).Select
Loop

Range("A1:A2").Merge
Range("B1:B2").Merge


'Add Borders

Dim B As Double
Range("A3").Select
Do Until IsEmpty(ActiveCell)
    B = B + 1
    ActiveCell.Offset(1, 0).Select
Loop

Range(Cells(3, 1), Cells(B + 2, 17)).Select

    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With


Range("A1:A2").Select
    
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With


Range("B1:B2").Select
    
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With


Range("C1:Q2").Select

    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
    End With
    

'Delete the duplicate username

Range("B3").Select

Do Until ActiveCell.Value = "Total"
For Each c In ActiveCell
    If InStr(c.Value, "*") > 0 Then
    c.Value = Left(c.Value, InStr(c.Value, "*") - 1)
    End If
Next c
ActiveCell.Offset(1, 0).Select
Loop

Columns("B").HorizontalAlignment = xlHAlignLeft
Columns("B").WrapText = False


'Resize columns and rows

Cells.Select
Columns.AutoFit
Rows.RowHeight = 22.5



'Bold entire total row

Range("J1").End(xlDown).Select
Selection.Font.Bold = True
Range("K1").End(xlDown).Select
Selection.Font.Bold = True
Range("L1").End(xlDown).Select
Selection.Font.Bold = True
Range("M1").End(xlDown).Select
Selection.Font.Bold = True
Range("N1").End(xlDown).Select
Selection.Font.Bold = True
Range("O1").End(xlDown).Select
Selection.Font.Bold = True
Range("P1").End(xlDown).Select
Selection.Font.Bold = True
Range("Q1").End(xlDown).Select
Selection.Font.Bold = True


'Bold employee cell

Range("B1:B2").Select
Selection.Font.Bold = True


'Add Date/Title at Top

Range("A1").EntireRow.Insert
Range("F1:L1").Merge
Range("F1:L1").Borders.LineStyle = xlContinuous
Range("F1:L1").Value = DateRange
Range("F1:L1").HorizontalAlignment = xlCenter
Range("F1:L1").VerticalAlignment = xlCenter
Range("F1:L1").Font.Bold = True
Range("F1:L1").Select

'Setting margins and print area

Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        .PrintTitleRows = ""
        .PrintTitleColumns = ""
    End With
    Application.PrintCommunication = True
    ActiveSheet.PageSetup.PrintArea = ""
    Application.PrintCommunication = False
    With ActiveSheet.PageSetup
        .LeftHeader = ""
        .CenterHeader = ""
        .RightHeader = ""
        .LeftFooter = ""
        .CenterFooter = ""
        .RightFooter = ""
        .LeftMargin = Application.InchesToPoints(0.25)
        .RightMargin = Application.InchesToPoints(0.25)
        .TopMargin = Application.InchesToPoints(0.25)
        .BottomMargin = Application.InchesToPoints(0.5)
        .HeaderMargin = Application.InchesToPoints(0.25)
        .FooterMargin = Application.InchesToPoints(0.25)
        .PrintHeadings = False
      .PrintGridlines = False
        .PrintComments = xlPrintNoComments
        .PrintQuality = 600
        .CenterHorizontally = False
        .CenterVertically = False
       .Orientation = xlPortrait
        .Draft = False
        .PaperSize = xlPaperLetter
        .FirstPageNumber = xlAutomatic
        .Order = xlDownThenOver
        .BlackAndWhite = False
        .Zoom = 100
        .PrintErrors = xlPrintErrorsDisplayed
        .OddAndEvenPagesHeaderFooter = False
        .DifferentFirstPageHeaderFooter = False
        .ScaleWithDocHeaderFooter = True
        .AlignMarginsHeaderFooter = True
        .EvenPage.LeftHeader.Text = ""
        .EvenPage.CenterHeader.Text = ""
        .EvenPage.RightHeader.Text = ""
        .EvenPage.LeftFooter.Text = ""
        .EvenPage.CenterFooter.Text = ""
        .EvenPage.RightFooter.Text = ""
        .FirstPage.LeftHeader.Text = ""
        .FirstPage.CenterHeader.Text = ""
        .FirstPage.RightHeader.Text = ""
        .FirstPage.LeftFooter.Text = ""
        .FirstPage.CenterFooter.Text = ""
        .FirstPage.RightFooter.Text = ""
    End With
    Application.PrintCommunication = True


End Sub

