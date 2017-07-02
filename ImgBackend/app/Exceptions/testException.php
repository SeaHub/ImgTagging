<?php
/**
 * Created by PhpStorm.
 * User: Dawnki Chow
 * Date: 2017/5/8 0008
 * Time: 17:05
 */

namespace App\Exceptions;


class testException extends \Symfony\Component\HttpKernel\Exception\HttpException
{

    public function __construct($statusCode, $message = null)
    {
        $message = $message ?: 'custom!';
        parent::__construct($statusCode, $message);
    }
}