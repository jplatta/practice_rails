module TransactionsHelper
  require 'gchart'

  def next_mth(date)
    date = date >> 1
    @month = date.month
  end

  def prev_mth(date)
    date = date << 1
    @month = date.month
  end

  def next_yr(date)
    date = date >> 1
    @year = date.year
  end

  def prev_yr(date)
    date = date << 1
    @year = date.year
  end

  def month_pie_chart(cat_totals)
    category_list = []
    category_totals = []

    cat_totals.each do |ct|
      category_list << ct[0]
      category_totals << ct[1]
    end

    @pie_2d = Gchart.pie(:title => "Month Summary",
                        :size => '400x400',
                        :data => category_totals,
                        :legend => category_list,
                        :bar_colors => ['FF5733','3CFF33','F0F932','3256F9','F932C9'])

  end

end
