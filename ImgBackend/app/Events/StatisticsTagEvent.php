<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/16 0016
 * Time: 16:46
 */

namespace App\Events;


use Illuminate\Support\Facades\Event;

class StatisticsTagEvent extends Event
{
    //图片id
    private $i_id;

    //标签id
    private $t_id;

    /**
     * StatisticsTagEvent constructor.
     * @param $i_id
     * @param $t_id
     */
    public function __construct($i_id, $t_id)
    {
        $this->i_id = $i_id;
        $this->t_id = $t_id;
    }

    /**
     * @return mixed
     */
    public function getIId()
    {
        return $this->i_id;
    }

    /**
     * @return mixed
     */
    public function getTId()
    {
        return $this->t_id;
    }


}