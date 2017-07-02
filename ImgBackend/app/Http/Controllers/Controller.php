<?php

namespace App\Http\Controllers;


use App\Events\ExportModelEvent;
use App\Events\StatisticsTagEvent;
use App\Http\Controllers\System\TagController;
use App\Jobs\ExampleJob;
use App\Models\Hobby;
use App\Models\HobbyHistory;
use App\Models\Image;
use App\Models\Result;
use App\Models\StatisticsTag;
use App\Models\Tag;
use App\Models\UserTag;
use App\User;
use Dingo\Api\Exception\ValidationHttpException;
use Dingo\Api\Http\Response;
use Dingo\Api\Routing\Helpers;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Event;
use Laravel\Lumen\Routing\Controller as BaseController;
use Mockery\CountValidator\Exception;


define('image_bucket', 'cifa');

set_time_limit(0);

class Controller extends BaseController
{
    use Helpers;

    /**
     *  参数验证失败返回错误信息处理
     *  返回http状态码 422
     * @param $validator
     */
    protected function errorBadRequest($validator)
    {
        $msg = $validator->errors()->toArray();
        $result = [];
        if ($msg) {
            foreach ($msg as $param => $errors) {
                foreach ($errors as $error) {
                    $result[] = [
                        'param' => $param,
                        'result' => $error
                    ];
                }
            }
        }

        throw new ValidationHttpException($result);
    }

    /**
     * @SWG\Swagger(
     *     schemes={"http"},
     *     host="114.115.152.250:8080",
     *     basePath="/api/v1",
     *     @SWG\Info(
     *         title="图片标注API",
     *         version="1.0.0"
     *     )
     * )
     * @param $filename
     * @return  string
     */
    public function getSwagger($filename = 'apidoc')
    {
        $Controllers_dir = __DIR__ . '/';
        $OutPut_dir = __DIR__ . '/../../../public/swagger-ui/json/';
        $swagger = \Swagger\scan($Controllers_dir);
        $file = fopen($OutPut_dir . $filename . '.json', "w");
        fwrite($file, urldecode(json_encode($swagger)));
        fclose($file);
        return "文档已生成!" . $OutPut_dir . $filename;
    }

    public function test()
    {
    }

}
