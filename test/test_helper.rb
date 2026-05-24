ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help' # ← これが必ず fixtures よりも上に必要です！
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 指定されたプロセッサー数でテストを並行実行する設定
  parallelize(workers: :number_of_processors)

  # すべてのテストで test/fixtures/*.yml のデータを自動読み込みする
  fixtures :all

  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # 単体テスト用のログインヘルパー（セッションを直接書き換える）
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# 統合テスト（Integration Test）用のログインヘルパー
class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end