<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/6/25 0025
 * Time: 21:14
 */

namespace App\Jobs;

use App\Events\ExportModelEvent;
use App\Models\UpdateRecord;
use Illuminate\Support\Facades\Event;

// 不限制脚本执行时间
set_time_limit(0);

class UpdateModelJob extends Job
{
    //检查更新状态文件
    const CHECK_UPDATE_PATH = '/home/wwwroot/cifar/public/cifar/check_update.txt';

    const COMMAND_CHANGE_NUM='python /home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/change_label_of_prototxt.py';

    //命令1
    const COMMAND1 = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/create_imagenet.sh';

    //命令2
    const COMMAND2 = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/make_imagenet_mean.sh';

    //命令3
    const COMMAND3 = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/train_caffenet.sh';

    //更新训练文本
    const TRAIN_PATH = '/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/data/train.txt';

    //达到更新的最低要求记录数
    const MIN_UPDATE_NUM = '20';


    public function handle()
    {
        //读取锁标记
        $file = fopen(self::CHECK_UPDATE_PATH, 'r');
        $rs = fgets($file, 2);
        fclose($file);
        if ($rs == '0') {
            file_put_contents(self::CHECK_UPDATE_PATH, '1');        //锁操作
            //更新训练文件
            $record = UpdateRecord::where('is_exec', 0)->get();
            if (($record->count()) < self::MIN_UPDATE_NUM) return;        //达不到最低要求记录数则不运行更新脚本
            else {
                $file = fopen(self::TRAIN_PATH, 'a+');
                $record->each(function ($item, $key) use ($file) {
                    $filename = $item->filename;
                    $t_id = $item->t_id;
                    $content = $filename . ' ' . $t_id . "\n";
                    fwrite($file, $content);
                    $item->is_exec = 1;       //更改执行状态 设置为准备执行
                    $item->save();
                });
                fclose($file);
            }
            //正式执行更新脚本
            exec(self::COMMAND_CHANGE_NUM);
            exec(self::COMMAND1);
            exec(self::COMMAND2);
            exec(self::COMMAND3);
            //执行完毕更新输出模型
            $data = UpdateRecord::where('is_exec', 1)->groupBy('i_id')->get();
            $data->each(function ($item, $key) {
                $i_id = $item->i_id;
                $filename = $item->filename;
                Event::fire(new ExportModelEvent($filename, $i_id, true));
            });
            UpdateRecord::where('is_exec', 1)->delete();
            file_put_contents(self::CHECK_UPDATE_PATH, '0');
            return;
        } else if ($rs == '1') {   //更新脚本已执行
            return;
        }
    }
}