let ledger = Ledger()

ledger.addEntry("Bob", amount: 100.43)
ledger.addEntry("Joe", amount: 200.20)

let memento = ledger.createMemento()

ledger.addEntry("Alice", amount: 500.20)
ledger.printEntries()

ledger.applyMemento(memento)
ledger.printEntries()

ledger.addEntry("Paul", amount: 50.20)
ledger.printEntries()
