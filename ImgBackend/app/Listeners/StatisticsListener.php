<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/16 0016
 * Time: 16:47
 */

namespace App\Listeners;


use App\Events\StatisticsTagEvent;
use App\Models\StatisticsTag;
use App\Models\UserTag;

class StatisticsListener
{
    /**
     *  处理统计事件
     * @param StatisticsTagEvent $event
     */
    public function handle(StatisticsTagEvent $event)
    {
        $i_id=$event->getIId();
        $t_id=$event->getTId();
        //对于一张图片的一个标签被选次数
        $num=UserTag::where('i_id',$i_id)->where('t_id',$t_id)->count();
        $data=StatisticsTag::where('i_id',$i_id)->where('t_id',$t_id)->first();
        if($data){
            $data->num=$num;
            $data->save();
        } else {
            StatisticsTag::create([
                'i_id'  => $i_id,
                't_id'  => $t_id,
                'num'   => $num
            ]);
        }
    }
}