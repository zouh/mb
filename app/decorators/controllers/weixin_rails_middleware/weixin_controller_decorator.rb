# encoding: utf-8
# 1, @weixin_message: 获取微信所有参数.
# 2, @weixin_public_account: 如果配置了public_account_class选项,则会返回当前实例,否则返回nil.
# 3, @keyword: 目前微信只有这三种情况存在关键字: 文本消息, 事件推送, 接收语音识别结果
WeixinRailsMiddleware::WeixinController.class_eval do

  def reply
    render xml: send("response_#{@weixin_message.MsgType}_message", {})
  end

  private

    def response_text_message(options={})
      reply_text_message("Your Message: #{@keyword}")
    end

    # <Location_X>23.134521</Location_X>
    # <Location_Y>113.358803</Location_Y>
    # <Scale>20</Scale>
    # <Label><![CDATA[位置信息]]></Label>
    def response_location_message(options={})
      @lx    = @weixin_message.Location_X
      @ly    = @weixin_message.Location_Y
      @scale = @weixin_message.Scale
      @label = @weixin_message.Label
      reply_text_message("Your Location: #{@lx}, #{@ly}, #{@scale}, #{@label}")
    end

    # <PicUrl><![CDATA[this is a url]]></PicUrl>
    # <MediaId><![CDATA[media_id]]></MediaId>
    def response_image_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @pic_url  = @weixin_message.PicUrl  # 也可以直接通过此链接下载图片, 建议使用carrierwave.
      reply_image_message(generate_image(@media_id))
    end

    # <Title><![CDATA[公众平台官网链接]]></Title>
    # <Description><![CDATA[公众平台官网链接]]></Description>
    # <Url><![CDATA[url]]></Url>
    def response_link_message(options={})
      @title = @weixin_message.Title
      @desc  = @weixin_message.Description
      @url   = @weixin_message.Url
      reply_text_message("回复链接信息")
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <Format><![CDATA[Format]]></Format>
    def response_voice_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      @format   = @weixin_message.Format
      # 如果开启了语音翻译功能，@keyword则为翻译的结果
      # reply_text_message("回复语音信息: #{@keyword}")
      reply_voice_message(generate_voice(@media_id))
    end

    # <MediaId><![CDATA[media_id]]></MediaId>
    # <ThumbMediaId><![CDATA[thumb_media_id]]></ThumbMediaId>
    def response_video_message(options={})
      @media_id = @weixin_message.MediaId # 可以调用多媒体文件下载接口拉取数据。
      # 视频消息缩略图的媒体id，可以调用多媒体文件下载接口拉取数据。
      @thumb_media_id = @weixin_message.ThumbMediaId
      reply_text_message("回复视频信息")
    end

    def response_event_message(options={})
      event_type = @weixin_message.Event
      send("handle_#{event_type.downcase}_event")
    end

    # 关注公众账号
    def handle_subscribe_event
      user = get_user

      if @keyword.present?
        # 扫描带参数二维码事件: 1. 用户未关注时，进行关注后的事件推送
        return reply_text_message("扫描带参数二维码事件: 1. 用户(#{user.subscribe}, #{user.openid},#{user.nickname},#{user.sex},
                                  #{user.language},#{user.city},#{user.province},#{user.country},
                                  #{user.headimgurl},#{user.subscribe_time},#{user.unionid},#{user.qrcode_url},
                                  #{user.parent_id},#{user.organization_id})
                                  未关注#{@weixin_message.ToUserName}时，进行关注后的事件推送, keyword: #{@keyword}")
      end
      reply_text_message("关注公众账号")

    end

    # 取消关注
    def handle_unsubscribe_event
      Rails.logger.info("取消关注")
    end

    # 扫描带参数二维码事件: 2. 用户已关注时的事件推送
    def handle_scan_event
      user = get_user

      if @keyword.present?
        # 扫描带参数二维码事件: 1. 用户未关注时，进行关注后的事件推送
        return reply_text_message("扫描带参数二维码事件: 1. 用户(#{user.subscribe}, #{user.openid},#{user.nickname},#{user.sex},
                                  #{user.language},#{user.city},#{user.province},#{user.country},
                                  #{user.headimgurl},#{user.subscribe_time},#{user.unionid},#{user.qrcode_url},
                                  #{user.parent_id},#{user.organization_id})
                                  未关注#{@weixin_message.ToUserName}时，进行关注后的事件推送, keyword: #{@keyword}")
      end
      reply_text_message("扫描带参数二维码事件: 2. 用户已关注时的事件推送1, keyword: #{@keyword}")
    end

    def handle_location_event # 上报地理位置事件
      @lat = @weixin_message.Latitude
      @lgt = @weixin_message.Longitude
      @precision = @weixin_message.Precision
      reply_text_message("Your Location: #{@lat}, #{@lgt}, #{@precision}")
    end

    # 点击菜单拉取消息时的事件推送
    def handle_click_event
      reply_text_message("你点击了: #{@keyword}, #{request.host}, #{url} ")
    end

    # 点击菜单跳转链接时的事件推送
    def handle_view_event
      @user = User.find_by openid: @weixin_message.FromUserName
      # Rails.logger.info("你点击了: #{@keyword}")
    end

    # 帮助文档: https://github.com/lanrion/weixin_authorize/issues/22

    # 由于群发任务提交后，群发任务可能在一定时间后才完成，因此，群发接口调用时，仅会给出群发任务是否提交成功的提示，若群发任务提交成功，则在群发任务结束时，会向开发者在公众平台填写的开发者URL（callback URL）推送事件。

    # 推送的XML结构如下（发送成功时）：

    # <xml>
    # <ToUserName><![CDATA[gh_3e8adccde292]]></ToUserName>
    # <FromUserName><![CDATA[oR5Gjjl_eiZoUpGozMo7dbBJ362A]]></FromUserName>
    # <CreateTime>1394524295</CreateTime>
    # <MsgType><![CDATA[event]]></MsgType>
    # <Event><![CDATA[MASSSENDJOBFINISH]]></Event>
    # <MsgID>1988</MsgID>
    # <Status><![CDATA[sendsuccess]]></Status>
    # <TotalCount>100</TotalCount>
    # <FilterCount>80</FilterCount>
    # <SentCount>75</SentCount>
    # <ErrorCount>5</ErrorCount>
    # </xml>
    def handle_masssendjobfinish_event
      Rails.logger.info("回调事件处理")
    end

    def get_user
      user = User.find_by openid: @weixin_message.FromUserName
      if user.nil?
        org = Organization.find_by! initial_id: @weixin_message.ToUserName
        weixin_client = WeixinAuthorize::Client.new(org.app_id, org.weixin_secret_key)
        if weixin_client.is_valid?  
          user_info_handler = weixin_client.user @weixin_message.FromUserName
          if user_info_handler.is_ok? # 或者 ok?
            user_info = user_info_handler.result # 这个方法直接返回微信的的json结果
          else
            # 输出错误信息, 具体格式: "#{code}: #{en_msg}(#{cn_msg})."
            puts user_info_handler.full_error_messages # 或者 errors 
          end
        end
        user = User.create!(
                            subscribe: user_info[:subscribe],
                            openid: user_info[:openid],
                            nickname: user_info[:nickname],
                            sex: user_info[:sex],
                            language: user_info[:language],
                            city: user_info[:city],
                            province: user_info[:province],
                            country: user_info[:country],
                            headimgurl: user_info[:headimgurl],
                            subscribe_time: user_info[:subscribe_time],
                            unionid: user_info[:unionid],
                            name: user_info[:nickname],
                            parent_id: @keyword.to_i,
                            organization_id: org.id
                          )
      end
      return user
    end

end
