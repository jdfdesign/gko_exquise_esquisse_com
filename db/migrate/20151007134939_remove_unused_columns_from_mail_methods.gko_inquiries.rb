# This migration comes from gko_inquiries (originally 20120311444444)
class RemoveUnusedColumnsFromMailMethods < ActiveRecord::Migration
  def up
    remove_column :mail_methods, :enable_mail_delivery if column_exists?(:mail_methods, :enable_mail_delivery)
    remove_column :mail_methods, :mail_host if column_exists?(:mail_methods, :mail_host)
    remove_column :mail_methods, :mail_domain if column_exists?(:mail_methods, :mail_domain)
    remove_column :mail_methods, :mail_port if column_exists?(:mail_methods, :mail_port)
    remove_column :mail_methods, :mail_auth_type if column_exists?(:mail_methods, :mail_auth_type)
    remove_column :mail_methods, :smtp_username if column_exists?(:mail_methods, :smtp_username)
    remove_column :mail_methods, :smtp_password if column_exists?(:mail_methods, :smtp_password)
    remove_column :mail_methods, :secure_connection_type if column_exists?(:mail_methods, :secure_connection_type)
    remove_column :mail_methods, :mails_from if column_exists?(:mail_methods, :mails_from)
    remove_column :mail_methods, :mail_bcc if column_exists?(:mail_methods, :mail_bcc)
    remove_column :mail_methods, :intercept_email if column_exists?(:mail_methods, :intercept_email)
  end

  def down
    add_column :mail_methods, :enable_mail_delivery, :boolean, :default => true unless column_exists?(:mail_methods, :enable_mail_delivery)
    add_column :mail_methods, :mail_host, :string unless column_exists?(:mail_methods, :mail_host)
    add_column :mail_methods, :mail_domain, :string unless column_exists?(:mail_methods, :mail_domain)
    add_column :mail_methods, :mail_port, :string, :default => 25 unless column_exists?(:mail_methods, :mail_port)
    add_column :mail_methods, :mail_auth_type, :string unless column_exists?(:mail_methods, :mail_auth_type)
    add_column :mail_methods, :smtp_username, :string unless column_exists?(:mail_methods, :smtp_username)
    add_column :mail_methods, :smtp_password, :string unless column_exists?(:mail_methods, :smtp_password)
    add_column :mail_methods, :secure_connection_type, :string unless column_exists?(:mail_methods, :secure_connection_type)
    add_column :mail_methods, :mails_from, :string unless column_exists?(:mail_methods, :mails_from)
    add_column :mail_methods, :mail_bcc, :string unless column_exists?(:mail_methods, :mail_bcc)
    add_column :mail_methods, :intercept_email, :string unless column_exists?(:mail_methods, :intercept_email)
  end
end