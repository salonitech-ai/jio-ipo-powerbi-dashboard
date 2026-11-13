// ===== Power BI > Home > Transform data > New Source > Blank Query > Advanced Editor =====
// STEP 1: Create a Parameter (Manage Parameters > New): Name = FolderPath, Type = Text
//         Value example: C:\Users\you\ipo_dashboard_starter\
// STEP 2: Create the queries below, one blank query each.

// ---------- Query: Fact_IPO ----------
let
    Source   = Csv.Document(File.Contents(FolderPath & "Fact_IPO.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed    = Table.TransformColumnTypes(Promoted, {
        {"IPO_ID", Int64.Type}, {"Company", type text}, {"Sector", type text}, {"Issue_Type", type text},
        {"Open_Date", type date}, {"Close_Date", type date}, {"Listing_Date", type date},
        {"Band_Low", type number}, {"Band_High", type number}, {"Issue_Price", type number},
        {"Lot_Size", Int64.Type}, {"Issue_Size_Cr", type number}, {"Listing_Price_NSE", type number},
        {"Subscription_Overall_x", type number}, {"GMP_Pre_Close", type number}, {"Source_Status", type text}}),
    // Calculated columns
    GainRs   = Table.AddColumn(Typed, "Listing_Gain_Rs", each [Listing_Price_NSE] - [Issue_Price], type number),
    GainPct  = Table.AddColumn(GainRs, "Listing_Gain_Pct", each ([Listing_Price_NSE] - [Issue_Price]) / [Issue_Price], Percentage.Type),
    MinInv   = Table.AddColumn(GainPct, "Min_Investment_Rs", each [Lot_Size] * [Issue_Price], type number),
    LotGain  = Table.AddColumn(MinInv, "Gain_Per_Lot_Rs", each [Lot_Size] * ([Listing_Price_NSE] - [Issue_Price]), type number),
    Year     = Table.AddColumn(LotGain, "Listing_Year", each Date.Year([Listing_Date]), Int64.Type),
    Outcome  = Table.AddColumn(Year, "Outcome",
                 each if [Listing_Gain_Pct] >= 0.5 then "Blockbuster"
                      else if [Listing_Gain_Pct] >= 0.1 then "Strong"
                      else if [Listing_Gain_Pct] >= 0 then "Flat"
                      else "Below Issue Price", type text),
    GMPAcc   = Table.AddColumn(Outcome, "GMP_Pct", each if [GMP_Pre_Close] = null then null else [GMP_Pre_Close] / [Issue_Price], Percentage.Type),
    IsJio    = Table.AddColumn(GMPAcc, "Is_Jio", each [Company] = "Jio Platforms", type logical)
in
    IsJio

// ---------- Query: Fact_Subscription_Daily ----------
let
    Source   = Csv.Document(File.Contents(FolderPath & "Fact_Subscription_Daily.csv"), [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    Typed    = Table.TransformColumnTypes(Promoted, {{"IPO_ID", Int64.Type}, {"Day", Int64.Type}, {"Date", type date},
        {"Overall_Subscription_x", type number}, {"QIB_x", type number}, {"NII_x", type number}, {"Retail_x", type number}})
in
    Typed

// ---------- Query: Dim_Date ----------
let
    StartDate = #date(2010, 1, 1),
    EndDate   = #date(2026, 12, 31),
    Days      = Duration.Days(EndDate - StartDate) + 1,
    DateList  = List.Dates(StartDate, Days, #duration(1,0,0,0)),
    ToTable   = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    Typed     = Table.TransformColumnTypes(ToTable, {{"Date", type date}}),
    Year      = Table.AddColumn(Typed, "Year", each Date.Year([Date]), Int64.Type),
    MonthNo   = Table.AddColumn(Year, "MonthNo", each Date.Month([Date]), Int64.Type),
    MonthName = Table.AddColumn(MonthNo, "Month", each Date.ToText([Date], "MMM"), type text)
in
    MonthName

// ---------- OPTIONAL Query: Jio_Price_History (add after you export prices to CSV) ----------
// Columns needed: Date, Open, High, Low, Close, Volume. Save as Jio_Price.csv in the same folder.
// let
//     Source   = Csv.Document(File.Contents(FolderPath & "Jio_Price.csv"), [Delimiter=",", Encoding=65001]),
//     Promoted = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
//     Typed    = Table.TransformColumnTypes(Promoted, {{"Date", type date}, {"Open", type number}, {"High", type number}, {"Low", type number}, {"Close", type number}, {"Volume", Int64.Type}})
// in
//     Typed
