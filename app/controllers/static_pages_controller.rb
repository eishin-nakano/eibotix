class StaticPagesController < ActionController::Base
  def authentication_form
  end

  def authentication
    p "----------------"
    p params
    # 開発中
    admin_name = params[:admin_name]
    admin_password = params[:admin_password]

    if admin_name == "admin" && admin_password == "foobar"
      confirm_user(params[:confirmation_token])
      flash[:notice] = "登録が完了しました！"
      redirect_to authentication_form_path
    else
      flash[:alert] = "adminが見つかりませんでした"
      redirect_to authentication_form_path
    end
  end

  private

  def register_user(token)
    user = User.find_by(confirmation_token: token)
    user.set_status(DEFAULT)
  end

end
