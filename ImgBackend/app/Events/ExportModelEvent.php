<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/15 0015
 * Time: 23:42
 */

namespace App\Events;


class ExportModelEvent extends Event
{
    //图片本地文件名
    private $pictureName;

    //图片id
    private $i_id;

    //调用此次模型前是否刚更新模型
    private $isUpdated;

    /**
     * ExportModelEvent constructor.
     * @param $pictureName
     * @param $i_id
     * @param bool $isUpdated
     */
    public function __construct($pictureName, $i_id, $isUpdated = false)
    {
        $this->pictureName = $pictureName;
        $this->i_id = $i_id;
        $this->isUpdated = $isUpdated;
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
    public function getPictureName()
    {
        return $this->pictureName;
    }

    /**
     * @return boolean
     */
    public function isIsUpdated()
    {
        return $this->isUpdated;
    }
}