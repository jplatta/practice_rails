module SvnHelper
  class LogMessage
    attr_accessor :rev_num, :rev_dev, :rev_time, :rev_msg
    def initialize(detls, msg="")
      @rev_num = detls[0].strip
      @rev_dev = format_rev_dev(detls[1].strip)
      @rev_time = format_rev_time(detls[2].strip)
      @rev_msg = format_rev_msg(msg)
    end

    def format_rev_dev(dev)
      if dev.include?(".")
        return dev.slice(0,dev.rindex(".")).capitalize + " " + dev.slice(dev.index(".")+1, dev.length).capitalize
      else
        return dev.capitalize
      end
    end

    def format_rev_time(time)
      return time.slice(time.index("(")+1, time.length-time.index("(")-2)
    end

    def format_rev_msg(msg)
      return msg.capitalize
    end
  end

  def parse_svn_log(log_msgs =[])
    count = 0

    dtls = []
    msg = ""
    log_messages = []

    log_msgs.each do |line|
      if line.to_s.include?('------------------------------------------------------------------------')

        if dtls.count > 0
          m = LogMessage.new(dtls.dup, msg.dup)
          log_messages.push(m)

          dtls = []
          msg = ""
        end

      elsif line != "" and !line.nil? and !line.to_s.empty? and !line.to_s.include?('------------------------------------------------------------------------')
        if line.include?("|")
          dtls = line.split("|")
        else
          msg = line.strip
        end
      end
      count += 1
    end
    
    return log_messages

  end
end
