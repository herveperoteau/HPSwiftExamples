import Foundation;

// NSNumber implements Flyweight pattern when 2 values are equals
let num1 = NSNumber(value: 10);
let num2 = NSNumber(value: 10);

print("Comparison: \(num1 == num2)");
print("Identity: \(num1 === num2)");
