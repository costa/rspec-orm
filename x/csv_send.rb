
module CsvReceiver

  # calls .send with arguments parsed from each line of the given CSV string
  #
  # CSV header line of the form "  ,  , a , b" (empty column names for a method
  # name and unnamed args, and then named columns for the last 'options' arg)
  # is required.
  # TIP: for an unlimited number of arguments and no 'options' a single comma
  # (,) header line will suffice
  #
  # WARNING: considered harmful in production code!
  def csv_send(csvs)
    res = []  # FIXME? some kind of arr.first(n){ }.last(n){ }.rest{ } useful?
    defn = nil
    for csv in csvs.split("\n")
      curr = csv.strip.split(",").collect { |v| v.strip }
      unless curr.empty?
        if defn.nil?
          defn = CsvReceiver._head_to_defn(curr)
        else
          res << send(*defn.call(curr))
        end
      end
    end
    res
  end

  def CsvReceiver._head_to_defn(head)
    fds = head.enum_with_index.collect do |f,i|
      res, opt, to =
        */^([^()]*[^()[:space:]]+)?[[:space:]]*(?:\(([^()]+)\))?$/.match(f)
      raise ArgumentError, "invalid column definition: #{f}" unless res
      if i == 0
        raise ArgumentError, "1st column must be a symbol" if to and to != 'sym'
        to, opt = 'to_sym', nil
      elsif to
        to = "to_#{to}"
        raise ArgumentError, "there's no conversion from string #{to}" unless
          "string".respond_to? to
      end
      [if to then to.to_sym end, if opt then opt.to_sym end]
    end

    lambda do |r|
      res = []
      opts = { }
      r.each_with_index do |v,i|
        to, opt = fds[i] # FIXME? I was wondering, is it easily possible to
                         # exploit more functional means of transfering data
                         # other than the array used here (note to myself).
        w = if to then v.send to else v end

        next if v.empty? # FIXME nils and stuff

        if opt
          opts[opt] = w
        else
          res << w
        end
      end
      res << opts unless opts.empty?
      res
    end
  end
end


class Object
  include CsvReceiver
end
