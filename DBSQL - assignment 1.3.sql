use [BankSogyo]
go

-- Assignment 1.3.1: Alle cliënten binnen de postcode range van 3000-4000 met een actieve leningen van meer dan 2500 euro.
select ClientNumber, FirstName
from CLient
where AddressID IN (select ID from Address where ZipCode LIKE '3%') AND ID IN (select ClientID from Loan where (Amount >= '2500') AND (DateClosed IS NULL))
go

-- Assignment 1.3.2: Lijst van transacties behorende bij een betaling voor een actieve lening geordend per cliënt.
select Loan.ClientID, AccountTransaction.ID, AccountTransaction.Amount, AccountTransaction.Description, AccountTransaction.Date
from AccountTransaction
JOIN Loan ON AccountTransaction.AccountID=Loan.AccountID
where Loan.DateClosed IS NULL AND Loan.ID IN (Select LoanID from payment where AccountTransaction.Date = date)
Order by Loan.ClientID
go

-- Assignment 1.3.3: Check voor cliënt Tieneke Van Brabandt of het totaal van de transacties van haar rekening courant klopt
-- met het saldo van haar rekening courant.
select Account.Balance, sum(AccountTransaction.Amount) - (

select sum(AccountTransaction.Amount)
from Account
join AccountTransaction ON Account.ID=AccountTransaction.AccountID
Where ClientID IN (Select ID From Client Where Client.Firstname LIKE 'Tieneke' AND Client.FamilyName LIKE '%Brabandt') AND Account.Type LIKE 'C' AND AccountTransaction.type LIKE 'D'
) as CreditMinusDebit

from Account
join AccountTransaction ON Account.ID=AccountTransaction.AccountID
Where ClientID IN (Select ID From Client Where Client.Firstname LIKE 'Tieneke' AND Client.FamilyName LIKE '%Brabandt') AND Account.Type LIKE 'C' AND AccountTransaction.type LIKE 'C'
group by Account.Balance
go

-- Assignment 1.3.4: De som van alle betalingen voor een actieve lening gegroepeerd per cliënt.
-- Deze query kan op twee manieren uitgevoerd worden, maak ze alle twee.
select Loan.ClientID, SUM(Payment.Amount) as SumLoanPayments
from Payment
JOIN Loan ON Payment.LoanID=Loan.ID
where LoanID IN (Select ID from Loan where (DateClosed IS NULL))
Group by Loan.ClientID, Payment.Amount
go

select loan.ClientID, sum(AccountTransaction.Amount) as SumLoanPayments
from AccountTransaction
JOIN Loan ON AccountTransaction.AccountID=Loan.AccountID
where Loan.DateClosed IS NULL AND Loan.ID IN (Select LoanID from payment where AccountTransaction.Date = date)
Group by loan.ClientID, AccountTransaction.Amount
go