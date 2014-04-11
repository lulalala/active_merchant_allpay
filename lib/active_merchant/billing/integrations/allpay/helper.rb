#encoding: utf-8

require 'cgi'
require 'digest/md5'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module Allpay
        class Helper < ActiveMerchant::Billing::Integrations::Helper

          # 廠商編號
          mapping :account, 'MerchantID'
          # 廠商交易編號
          mapping :order, 'MerchantTradeNo'
          # 交易金額
          mapping :amount, 'TotalAmount'
          # 付款完成通知回傳網址
          mapping :notify_url, 'ReturnURL'
          # Client 端返回廠商網址
          mapping :return_url, 'ClientBackURL'
          # 交易描述
          mapping :description, 'TradeDesc'

          ### Custom Fields
          # 交易類型
          mapping :payment_type, 'PaymentType'

          # 選擇預設付款方式
          #   Credit:信用卡
          #   WebATM:網路 ATM
          #   ATM:自動櫃員機
          #   CVS:超商代碼
          #   BARCODE:超商條碼
          #   Alipay:支付寶
          #   Tenpay:財付通
          #   TopUpUsed:儲值消費
          #   ALL:不指定付款方式, 由歐付寶顯示付款方式 選擇頁面
          mapping :choose_payment, 'ChoosePayment'

          def initialize(order, account, options = {})
            super
            add_field 'MerchantID', ActiveMerchant::Billing::Integrations::Allpay.merchant_id
            add_field 'PaymentType', ActiveMerchant::Billing::Integrations::Allpay::PAYMENT_TYPE
          end

          def merchant_trade_no(trade_number)
            add_field 'MerchantTradeNo', trade_number
          end

          def merchant_trade_date(date)
            add_field 'MerchantTradeDate', date.strftime('%Y/%m/%d %H:%M:%S')
          end

          def total_amount(amount)
            add_field 'TotalAmount', amount
          end

          def trade_desc(description)
            add_field 'TradeDesc', description
          end

          def item_name(item)
            add_field 'ItemName', item
          end

          def choose_payment(payment)
            add_field 'ChoosePayment', payment
          end

          def return_url(url)
            add_field 'ReturnURL', url
          end

          def client_back_url(url)
            add_field 'ClientBackURL', url
          end

          def encrypted_data

            raw_data = @fields.sort.map{|field, value|
              "#{field}=#{value}"
            }.join('&')

            hash_raw_data = "HashKey=#{ActiveMerchant::Billing::Integrations::Allpay.hash_key}&#{raw_data}&HashIV=#{ActiveMerchant::Billing::Integrations::Allpay.hash_iv}"

            url_endcode_data = (CGI::escape(hash_raw_data)).downcase

            add_field 'CheckMacValue', Digest::MD5.hexdigest(url_endcode_data)
          end

        end
      end
    end
  end
end
