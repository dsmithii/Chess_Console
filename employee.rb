class Employee

   attr_accessor :boss
   attr_reader :name, :title, :salary

   def initialize(name, title , salary, boss)
     @boss = boss
     @boss.add_employee(self) unless boss.nil?
     @title = title
     @salary = salary
     @name = name
   end

   def calculate_bonus(multiplier)
     @bonus = salary * multiplier
   end

end


class Manager < Employee

  attr_reader :employees

  def initialize(name,title,salary,boss=nil)
    super(name,title,salary,boss)
    @employees = []
  end

  def add_employee(employee)
    @employees << employee
  end

  def calculate_bonus(multiplier)
    sum = 0
    @employees.each do |person|
      if person.is_a?(Manager)
        sum += person.salary * multiplier + person.calculate_bonus(multiplier)
      else
        sum += person.calculate_bonus(multiplier)
      end
    end
    sum
  end

end


e0 = Manager.new("Larry", "Project Manager", 50, nil)
e3 = Manager.new("Jon", "Jr. Manager", 20, e0)
e1  = Employee.new("David", "Engineer",15, e3)
e2 = Employee.new("Arron", "SOmething", 10,e3)

#(10+15+20)*2

puts e3.calculate_bonus(2)
puts "at bottom #{e0.employees[0].name}"



