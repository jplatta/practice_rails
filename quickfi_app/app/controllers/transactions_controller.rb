class TransactionsController < ApplicationController

  before_action :logged_in_user, only: [:index,:new,:create,:edit,:update,:destroy,:month]

  def index
    @transactions = Transaction.where(user_id: params[:user_id]).paginate(page: params[:page], per_page: 15)
  end

  def month
    month = params[:month].to_s
    year = params[:year].to_s

    @date = Date.parse("#{year}-#{month}-01")

    @transactions = Transaction.month(current_user,month,year).paginate(page: params[:page], per_page: 10)

    @cat_totals = Transaction.month_category_totals(current_user,month,year)
    
  end

  #For illustration
  def charts
    @chart = Gchart.line( :title => "example title",
                          :bg => 'efefef',
                          :legend => ['first data set label', 'second data set label'],
                          :data => [10, 30, 120, 45, 72])

    @bar = Gchart.bar(:data => [300, 100, 30, 200])

    @venn = Gchart.venn(:data => [100, 80, 60, 30, 30, 30, 10])

    @bar2 = Gchart.bar(:title => "Matt's Mojo",
           :data => [15, 30, 10, 20, 100, 20, 40, 100, 90, 100, 80],
           :bar_colors => '76A4FB',
           :background => 'EEEEEE', :chart_background => 'CCCCCC')

    @pie_2d = Gchart.pie(:title => "2D Pie Chart",
                        :size => '500x500',
                        :data => [60, 60],
                        :labels => ["Group1", "Group2"])

    @pie_3d = Gchart.pie_3d(:title => 'ruby_fu', :size => '400x200',
              :data => [10, 45, 45], :labels => ["DHH", "Rob", "Matt"] )
  end

  def new
    @user = User.find(params[:user_id])
    @transaction = @user.transactions.build
    @categories = Category.user_categories(params[:user_id])
  end

  def create
    @transaction = current_user.transactions.build(transaction_params)
    if @transaction.save
      flash[:success] = "Transaction saved!"
      redirect_to user_transactions_path
    else
      render 'new'
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
    @categories = Category.user_categories(params[:user_id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update_attributes(transaction_params)
      flash[:success] = "Transaction updated"
      redirect_to user_transactions_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    Transaction.find(params[:id]).destroy
    flash[:success] = "Transaction deleted."
    redirect_to user_transactions_path(current_user)
  end

  private
    def transaction_params
      params.require(:transaction).permit(:amount,:description,:category_id,:credit,:date,:user_id)
    end
end
