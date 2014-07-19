class BrotherMailer < ActionMailer::Base
  default from: "will.emmanuel@gmail.com"
 
  def overdue_email(brother, debts)
    @brother = brother
    @debts = debts
    @total = 0
    @debts.each do |d|
      @total += d.amount
    end
    mail(to: @brother.email, subject: 'Overdue debts to the house')
  end

  def future_email(brother, debts)
    @brother = brother
    @debts = debts
    @total = 0
    @debts.each do |d|
      @total += d.amount
    end
    mail(to: @brother.email, subject: 'Debts due to the house')
  end

end
