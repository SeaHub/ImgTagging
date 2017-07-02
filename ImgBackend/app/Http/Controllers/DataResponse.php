<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/10 0010
 * Time: 21:39
 */

/**
 *  通用成功信息体
 * @SWG\Definition(
 *     definition="ret_msg",
 *     type="object",
 *     required={"ret_msg"},
 *     @SWG\Property(property="ret_msg",type="string",description="成功信息",example="success")
 * )
 */


/**
 * 通用成功的返回
 * @SWG\Definition(
 *     definition="success_ret",
 *     type="object",
 *     allOf={
 *      @SWG\Schema(ref="#/definitions/ret_msg")
 *     }
 * )
 */



/**
 * 失败的返回
 * @SWG\Definition(
 *     definition="fail_ret",
 *     type="object",
 *     allOf={
 *      @SWG\Schema(
 *          required={"message","status_code"},
 *          @SWG\Property(property="message",type="string",description="返回的错误信息"),
 *          @SWG\Property(property="status_code",type="integer",format="int32",description="错误状态码(HTTP状态码)"),
 *          @SWG\Property(property="errors",type="array",description="具体错误(可选值)")
 *      )
 *     }
 * )
 */


/**
 *  登陆信息体
 * @SWG\Definition(
 *     definition="login_info",
 *     type="object",
 *     @SWG\Property(property="userId",type="integer",description="用户id"),
 *     @SWG\Property(property="username",type="string",description="用户名(唯一)"),
 *     @SWG\Property(property="email",type="string",description="用户邮箱"),
 *     @SWG\Property(property="identity",type="integer",description="身份(0普通用户 1管理员)"),
 *     @SWG\Property(property="token",type="string",description="验证令牌,内部接口调用需要放到头部"),
 *     @SWG\Property(property="expired_at",type="date",description="验证令牌过期时间"),
 *     @SWG\Property(property="refresh_expired_at",type="date",description="更换令牌过期时间"),
 *     @SWG\Property(property="last_logined_time",type="date",description="最后登陆时间"),
 * )
 */

/**
 *   用户信息体
 * @SWG\Definition(
 *     definition="user_info",
 *     type="object",
 *     @SWG\Property(property="userId",type="int",description="用户id"),
 *     @SWG\Property(property="name",type="string",description="用户昵称,默认为null"),
 *     @SWG\Property(property="avatar",type="string",description="用户头像url"),
 *     @SWG\Property(property="finish_num",type="int",description="完成图片标签数"),
 *     @SWG\Property(property="score",type="int",description="用户积分"),
 * )
 */

/**
 *  兴趣信息体
 * @SWG\Definition(
 *     definition="hobbies",
 *     type="array",
 *     required={"hobby_name"},
 *     @SWG\Items(
 *          @SWG\Property(property="hobby_name",type="string",description="兴趣名(必选)"),
 *          @SWG\Property(property="weight",type="integer",description="兴趣比重(可选)"),
 *     )
 * )
 */

/**
 *   兴趣返回信息体
 * @SWG\Definition(
 *     definition="hobbies_return",
 *     type="object",
 *     @SWG\Property(property="h_id",type="integer",description="兴趣id"),
 *     @SWG\Property(property="userId",type="integer",description="用户id"),
 *     @SWG\Property(property="hobby_name",type="string",description="兴趣名"),
 *     @SWG\Property(property="weight",type="int",description="兴趣权值比重(可选 0最高 1,2,3依次递减)"),
 * )
 */

/**
 *  图片列表返回信息体
 * @SWG\Definition(
 *     definition="Image_list",
 *     type="object",
 *     @SWG\Property(property="i_id",type="integer",description="图片索引id"),
 *     @SWG\Property(property="url",type="string",description="图片存储的url"),
 *     @SWG\Property(property="filename",type="string",description="图片存在服务器的文件名(非七牛文件名)"),
 *     @SWG\Property(property="created_at",type="string",description="创建时间"),
 *     @SWG\Property(property="update_at",type="string",description="修改时间"),
 * )
 */


/**
 *  图片结果集
 * @SWG\Definition(
 *     definition="Image_set",
 *     type="object",
 *     @SWG\Property(property="i_id",type="integer",description="图片索引id"),
 *     @SWG\Property(property="tag1",type="string",description="标签1"),
 *     @SWG\Property(property="tag2",type="string",description="标签2"),
 *     @SWG\Property(property="tag3",type="string",description="标签3"),
 *     @SWG\Property(property="tag4",type="string",description="标签4"),
 *     @SWG\Property(property="tag5",type="string",description="标签5"),
 *     @SWG\Property(property="Alternation",type="integer",description="迭代次数,即调用更新模型的次数"),
 * )
 */

/**
 *  标签统计结果
 * @SWG\Definition(
 *     definition="Image_statisticsResult",
 *     type="object",
 *     @SWG\Property(property="st_id",type="integer",description="数据库中的统计id,可以忽略"),
 *     @SWG\Property(property="i_id",type="integer",description="图片id"),
 *     @SWG\Property(property="t_id",type="integer",description="标签id"),
 *     @SWG\Property(property="num",type="integer",description="该图片被打此标签的次数"),
 *     @SWG\Property(property="t_name",type="string",description="标签名"),
 *     @SWG\Property(property="sum",type="integer",description="该图片被打标签的总数"),
 * )
 */

/**
 *  图片打标签参数
 * @SWG\Definition(
 *     definition="Image_tag",
 *     title="Tags",
 *     type="object",
 *     @SWG\Property(
 *     property="Tags",
 *     type="array",
 *     description="数组",
 *     @SWG\Items(
 *           @SWG\Property(property="i_id",type="integer",description="图片id"),
 *           @SWG\Property(property="t_name",type="string",description="标签名"),
 *      )
 *      ),
 * )
 */

/**
 *  图片评分参数
 * @SWG\Definition(
 *     definition="Image_mark",
 *     title="Scores",
 *     type="object",
 *     @SWG\Property(
 *     property="Scores",
 *     type="array",
 *     description="数组",
 *     @SWG\Items(
 *           @SWG\Property(property="i_id",type="integer",description="图片id"),
 *           @SWG\Property(property="score",type="integer",description="评分(0-10)"),
 *      )
 *      ),
 * )
 */

/**
 *  返回打标签出错的i_id数组
 * @SWG\Definition(
 *     definition="Image_tagArr",
 *     type="object",
 *     @SWG\Property(property="i_id",type="integer",description="data中存储着不能成功打上标签的i_id")
 * )
 */

/**
 *  顺序推送信息体
 * @SWG\Definition(
 *     definition="Push_getSequence",
 *     type="object",
 *     @SWG\Property(property="i_id",type="integer",description="图片id"),
 *     @SWG\Property(property="url",type="string",description="图片url"),
 *     @SWG\Property(property="filename",type="string",description="图片在服务器保存的文件名"),
 *     @SWG\Property(property="created_at",type="string",description="创建时间"),
 *     @SWG\Property(property="update_at",type="string",description="修改时间"),
 *     @SWG\Property(property="finalTag",type="object",description="其图片的结果集"),
 * )
 */