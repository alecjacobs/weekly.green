class Simulate
  DATA = <<-DATA.split("\n").map { |line| *words, last = line.strip.split("\t"); [words.join(" "), last.to_f]}
    WAL-MART #3229	-18.15
    PAPA JOHN'S #1066	-10.83
    JACK IN THE BOX 3836	-5.83
    EATZI'S MARKET &amp; BAKERY	-10.14
    EATZI'S MARKET &amp; BAKERY	-16.23
    JACK IN THE BOX 3836	-4.32
    TARGET        00017640	-17.65
    AIRBNB * HM3XZAH3HT	-45.16
    EATZI'S MARKET &amp; BAKERY	-20.31
    WHATABURGER 999	-7.11
    WHATABURGER 999	-7.11
    TARGET        00017640	-19.66
    AIRBNB * HMMAEQNHJ3	-349.99
    H-E-B #611	-29.77
    HAYS CITY STORE	-75.06
    CULWELL GROOMING ROOM	-33
    PET SUPPLIES PLUS #700	-19.46
    MCDONALD'S F14323	-4.75
    EATZI'S MARKET &amp; BAKERY	-18.15
    GATOR STOP 3	-41.42
    DFW AIRPORT PARKING	-2
    EATZI'S MARKET &amp; BAKERY	-11.9
    LOVERS EGG ROLL PLANO	-9.93
    GOOGLE *CLOUD_011FE8-F	-10
    KROGER 0540	-16.76
    EATZI'S MARKET &amp; BAKERY	-16.64
    TARGET        00017640	-50.2
    PAPA JOHN'S #1066	-15.95
    JACK IN THE BOX 3836	-7.45
    JACK IN THE BOX 3836	-3.02
    JACK IN THE BOX 3836	-5.61
    JACK IN THE BOX 3836	-3.02
    WHATABURGER 743    Q26	-8.85
    EATZI'S MARKET &amp; BAKERY	-8.64
    DNH*GODADDY.COM	-13.16
    GITHUB.COM	-7
    JACK IN THE BOX 3836	-3.24
    JACK IN THE BOX 3836	-7.56
    WAL-MART #2086	-11.12
    TARGET        00017640	-28.99
    EATZI'S MARKET &amp; BAKERY	-18.32
    TARGET        00017640	-16.25
    TOM THUMB #2570	-35.12
    KROGER 0540	-21.44
    EATZI'S MARKET &amp; BAKERY	-11.9
    TARGET        00017640	-15.54
    JACK IN THE BOX 3836	-6.37
    EATZI'S MARKET &amp; BAKERY	-30.62
    LEVELUP*STEAKNSHAKE832	-0.97
    JACK IN THE BOX 3836	-5.73
    PAPA JOHN'S #1066	-16.23
    LEVELUP*STEAKNSHAKE296	-6.58
    JACK IN THE BOX 3836	-5.19
    PAPA JOHN'S #1066	-8.65
    EINSTEIN BROS BAGELS2745	-6.59
    PET SUPPLIES PLUS #700	-18.38
    HEB  #611	-5.3
    FLORES MEXICAN RESTAUR	-18
    HEB  #611	-49.27
    WHOLE PETS MARKET  SSS	-20.54
    HEB  #611	-15.4
    WAL-MART #5931	-12
    WHATABURGER 564    Q26	-6.43
    JACK IN THE BOX 3836	-5.73
    MURPHY6548ATWALMART	-58.75
    TARGET        00017640	-24.15
    MURPHY6548ATWALMART	-40.1
    JACK IN THE BOX 3836	-5.19
    ALON 7-ELEVEN 4053	-11.29
    CORNER STORE 0723	-42.7
    STORE 2068	-22.79
    7-ELEVEN 23989	-29.95
    CORNER STORE 0723	-6.98
    FAMILY DOLLAR #10494	-8.59
    WAFFLE HOUSE 0815	-11.77
  DATA

  def sample
    fixed || Distribution::Normal.rng(min + (max - min) / 2.0, (max - min) / 2.0 / 3.0).call.round(2)
  end

  def fixed
    nil
  end

  def deductible
    false
  end
end

class WeeklyUberIncome < Simulate
  def min
    40.0 * 6
  end

  def max
    100.0 * 6
  end

  def description
    "UBER"
  end
end

class WeeklyGas < Simulate
  def min
    -50.0
  end

  def max
    -300.0
  end

  def deductible
    true
  end

  def description
    ["CHEVRON", "TEXACO", "EXXONMOBIL", "SHELL OIL", "PILOT"].sample + " " + (rand * 10000).to_i.to_s
  end
end

class MonthlyCarMaintenance < Simulate
  def min
    -50.0
  end

  def max
    -400.0
  end

  def deductible
    true
  end

  def description
    ["JOE'S TIRES", "JIFFY LUBE", "BUSY BUGGY AUTO REPAIR", "DESSERT INN AUTO", "COSTCO AUTO"].sample
  end
end

class MonthlyCarInsurance < Simulate
  def fixed
    -200.0
  end

  def description
    "LIBERTY MUTUAL"
  end

  def deductible
    true
  end
end

class MonthlyRent < Simulate
  def fixed
    900.0
  end

  def description
    "RENT CHECK"
  end

  def deductible
    false
  end
end

class Expense < Simulate
  def initialize
    @desc, @amt = Simulate::DATA.sample
  end

  def sample
    @amt
  end

  def description
    @desc
  end
end

def simulate(days)
  generators = [
    {
      start: (rand * 5).to_i,
      period: 7,
      klass: WeeklyUberIncome
    },
    {
      start: (rand * 5).to_i,
      period: 7,
      klass: WeeklyGas
    },
    {
      start: (rand * 2).to_i,
      period: 1,
      klass: Expense
    },
    {
      start: (rand * 10).to_i,
      period: 30,
      klass: MonthlyCarMaintenance
    },
    {
      start: (rand * 10).to_i,
      period: 30,
      klass: MonthlyCarInsurance
    },
    {
      start: (rand * 10).to_i,
      period: 30,
      klass: MonthlyRent
    }
  ]
  results = []
  bal = 1500
  start_date = 2.days.ago
  days.times do |day|
    generators.each do |generator|
      if day % (generator[:start] + generator[:period]) == 0
        instance = generator[:klass].new
        sample = instance.sample
        results << [instance.description, sample, bal, start_date - day.days, instance.deductible]
        bal -= sample
      end
    end
  end
  results
end

def json_transaction(transaction)
  desc, amt, bal, date, deductible = transaction

  {
    desc: desc,
    amt: amt,
    bal: bal,
    date: date,
    deductible: deductible
  }
end

def xml_transaction(transaction)
  desc, amt, bal, date, deductible = transaction

  if amt < 0
    base_type = "debit"
    type = "debit"
    amt *= -1
  else
    base_type = "credit"
    type = "deposit"
  end

  <<-XML
      <transaction baseType="#{base_type}" transactionStatus="posted" type="#{type}">
        <description>#{desc.encode(xml: :text)}</description>
        <transDate localFormat="yyyy-MM-dd">#{date.strftime("%Y-%m-%dT00:00:00")}</transDate>
        <postDate localFormat="yyyy-MM-dd">#{(date + 2.hours).strftime("%Y-%m-%dT00:00:00")}</postDate>
        <amount curCode="USD">#{amt}</amount>
        <transactionRunningBalance curCode="USD">#{bal}</transactionRunningBalance>
      </transaction>
  XML
end

def make_xml(transactions)
  puts <<-XML
<site>
  <bankAccount nickName="Interest Checking-2345" acctType="checking" accountClassification="personal">
    <accountName>Dag Checking Account</accountName>
    <fullAccountNumber>123445682345</fullAccountNumber>
    <accountNumber>2345</accountNumber>
    <routingNumber>xxxxxxxxx</routingNumber>
    <accountHolder>Robin</accountHolder>
    <balance balType="availableBalance">
      <curAmt curCode="USD">1500.00</curAmt>
    </balance>
    <balance balType="currentBalance">
      <curAmt curCode="USD">1600.00</curAmt>
    </balance>
    <balance balType="overdraftProtection">
      <curAmt curCode="USD">15750.00</curAmt>
    </balance>
    <asOf localFormat="yyyy-MM-dd">2018-10-20T00:00:00</asOf>
    <interestRate>0.01000</interestRate>
    <accountProfile>
      <address>
        <addressType>HOME</addressType>
        <address>
          <address1>Address1</address1>
          <address2>Address2</address2>
          <address3>Address3</address3>
          <city>Redwood City</city>
          <state>CA</state>
          <country>America</country>
          <zip>94065</zip>
        </address>
      </address>
      <fax>AccountFax1</fax>
      <company>Companyname</company>
      <phone>12345678</phone>
      <homePhone>12345678</homePhone>
      <workPhone>12345678</workPhone>
      <mobilePhone>12345678</mobilePhone>
      <email>email@gmail.com</email>
      <secondaryEmail>SecondaryEmail1@gmail.com</secondaryEmail>
      <personalEmail>PersonalEmail1@gmail.com</personalEmail>
      <othersEmail>OthersEmail1@gmail.com</othersEmail>
      <workEmail>workEmail1@gmail.com</workEmail>
      <primaryEmail>PrimaryEmail1@gmail.com</primaryEmail>
      <company>AccountCompany1</company>
      <birthDateTime localFormat="MM/DD/YYYY">2078-04-25T00:00:00</birthDateTime>
      <consumerIdentifier consumerIdentifierType="AADHAR">7576565567</consumerIdentifier>
      <consumerIdentifier1 consumerIdentifierType="NRIC">454765876876</consumerIdentifier1>
    </accountProfile>
    <individualInformation accountHolderType="Primary">
      <name>
        <lastName>Andrews</lastName>
        <middleName>George</middleName>
        <firstName>Robin</firstName>
      </name>
      <fullName>Robin George Andrews</fullName>
      <birthDateTime localFormat="MM/DD/YYYY">2012-01-01T00:00:00</birthDateTime>
      <consumerIdentifier consumerIdentifierType="AADHAR">4575476vhg</consumerIdentifier>
      <consumerIdentifier1 consumerIdentifierType="NRIC">64576587687</consumerIdentifier1>
    </individualInformation>
    <transactionList>
  XML

  transactions.each do |transaction|
    puts xml_transaction(transaction)
  end

  puts <<-XML
    </transactionList>
  </bankAccount>
</site>
  XML
end
