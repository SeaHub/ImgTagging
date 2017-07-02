<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/15 0015
 * Time: 23:42
 */

namespace App\Listeners;


use App\Events\ExportModelEvent;
use App\Models\Result;

class ExportListener
{

    //python输出模型具体命令
    const COMMAND = 'python /home/wwwroot/cifar/public/cifar/shell_server.py';

    //图片文件路径(Train 文件夹)
    const FILE_PATH = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/data/train/';

    const RESULT_PATH = '/home/wwwroot/cifar/public/cifar/ans.txt';

    /**
     *  处理输出模型
     * @param ExportModelEvent $event
     */
    public function handle(ExportModelEvent $event)
    {
        $filename = self::FILE_PATH . $event->getPictureName();
        $i_id = $event->getIId();
        $create = [];
        $command = self::COMMAND . ' ' . $filename . ' 2>/home/wwwroot/cifar/public/cifar/log.txt';
        exec($command);
        $result = $this->getResult();
        if(empty($result)) return ;             //获取脚本结果失败
        foreach ($result as $key => $item) {
            $create['tag' . ($key+1)] = $item;
        }
        $data = Result::find($i_id);
        if ($data) {
            if ($event->isIsUpdated()) {
                $create['Alternation'] = ($data->Alternation) + 1;
            }
            $data->update($create);
        } else {
            $create['i_id'] = $i_id;
            if ($event->isIsUpdated()) {
                $create['Alternation'] = 1;
            } else {
                $create['Alternation'] = 0;
            }
            Result::create($create);
        }
    }

    private function getResult()
    {
        if(!file_exists(self::RESULT_PATH)) return [];
        $data = [];
        $file_Arr = file(self::RESULT_PATH);
        file_put_contents(self::RESULT_PATH, '');
        if(!empty($file_Arr)) {
            foreach ($file_Arr as $key => $item) {
                $tag = explode(" ", $item);
                $tag = $tag[1];
                $data[$key] = str_replace("\n", "", $tag);
            }
            return $data;
        } else {
            return [];
        }
    }
}