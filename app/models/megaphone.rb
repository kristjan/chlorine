class Megaphone < ActionMailer::Base


  def new_recruit(sent_at = Time.now)
    subject    'Megaphone#new_recruit'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def daily_report(sent_at = Time.now)
    subject    'Megaphone#daily_report'
    recipients ''
    from       ''
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

  def test(sent_at = Time.now)
    subject    'Megaphone#test'
    recipients ''
    from       'Chlorine'
    sent_on    sent_at

    body       :greeting => 'Hi,'
  end

end
